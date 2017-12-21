/*
This file is part of Backstage.

Backstage is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Backstage is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Backstage.  If not, see <http://www.gnu.org/licenses/>.
*/
class Node {
  String type; String label; String notes; float duration; boolean beginPaused; boolean endPaused;
  int index; int x; int y; int w; int h; int[] next;
  boolean loop; boolean beginTransition; boolean endTransition;
  
  int track, endTime, presentTime, prevMillis;
  boolean selected, connecting, dragged, mouseOver, playing, paused, onEndPause;
  PImage icon;

  Node(String type, String label, String notes, float duration, boolean beginPaused, boolean endPaused, int index, int x, int y, int[] next, PImage icon) {
    this.type = type; this.label = label; this.notes = notes; this.duration = duration; this.beginPaused = beginPaused; this.endPaused = endPaused;   
    this.index = index; this.x = x; this.y = y; this.next = next; this.icon = icon;
    w = max(int(cp.textWidth(label)) + 8, 84);
    h = 40;
    track = tracks - int(round(float(y) / trackHeight));
    
    loop = false; beginTransition = false; endTransition = false;
  }

  void switchConnectors(int a, int b) {
    for(int n = 0; n < next.length; n++) {
      if(next[n] == a) next[n] = b;
      else if(next[n] == b) next[n] = a;
    }
  }

  void addConnector(int c) {
    if(next.length > 3 || c == index) return;
    for(int n: next) if(n == c) return;
    next = append(next, c);
  }
  
  void removeConnector(int c) {
    for(int n = 0; n < next.length; n++) if(next[n] == c) {
      arrayCopy(next, n + 1, next, n, next.length - (n + 1));
      next = shorten(next);
      break;
    }
  }

  int mouseOverConnector(int mX, int mY){
    mX -= translation;
    if(next.length > 0 && mX > x + w && mY > y && mX < x + w + h / 2 && mY < y + h) {
      for(int n = 0; n < next.length; n++) {
        if(dist(mX, mY, x + w, y + (n + 1 / 2.0) * h  / next.length) <= h / next.length / 2.0) return next[n];
      }
    }
    return -1;
  }

  boolean mouseOver(int mX, int mY) {
    mX -= translation;
    float nextRadius = 0;
    if(next.length > 0) nextRadius = h / (next.length + 1.0);
    return mX > x && mY > y && mX < x + w + nextRadius && mY < y + h;
  }

  boolean isColliding() {
      boolean over = false;
      for(Node no: nodes) if(no != this) {
        over |= x > no.x - w && y > no.y - h && x < no.x + no.w + 30 && y < no.y + no.h && x >= no.x;
      }
    return over;
  }

  void click(int mX, int mY, int clicks, boolean ctrl) {
    boolean over = mouseOver(mX, mY);
    //selected = (!ctrl && over) || (ctrl && ((over && !selected) || (!over && selected)));
    selected = !ctrl && over || over && !selected || ctrl && !over && selected;
    if(over && clicks > 1) {
      for(Node no: nodes) no.selected = false;
      selected = true;
      load();
      buttonsEnabled(false);
      controlPanel.setVisible(true);
    }
  }

  void drag(int dmX, int dmY) {
    if(dragged) {
      x += dmX;
      y += dmY;
    }
  }

  void draw() {
    mouseOver = mouseOver(cp.mouseX, cp.mouseY);
    if(!dragging) {
      if(y < trackHeight) y++;
      else if(y > tracks * trackHeight) y--;
      else if(y % trackHeight >= trackHeight / 2) y++;
      else if(y % trackHeight > 0) y--;
      else if(x < 20 || isColliding() || x % 20 != 0) x++;
    }
    
    color strokeColor, fillColor;
    if(selected) fillColor = selectedColor;
    else if(mouseOver) fillColor = overColor;
    else fillColor = normalColor;
    strokeColor = borderColor;

    cp.noFill();
    cp.stroke(strokeColor);
    if(connecting && !mouseOver) {
      int x1 = x + w;
      int y1 = y + h / 2;
      int x2 = cp.mouseX - translation;
      int y2 = cp.mouseY;
      float dif =  min(200, max(20, x1 - x2 + abs(y1 - y2)));
      cp.bezier(x1, y1, x1 + dif, y1, x2 - dif, y2, x2, y2);
    }
    for(int n = next.length - 1; n >= 0; n--) {
      try {
        int x1 = x + w + h / next.length / 2;
        int y1 = round(y + (n + 1 / 2.0) * h  / next.length);
        int x2 = nodes.get(next[n]).x;
        int y2 = nodes.get(next[n]).y + nodes.get(next[n]).h / 2;
        float dif =  min(200, max(20, x1 - x2 + abs(y1 - y2)));
        if(selected) cp.strokeWeight(5);
        else cp.strokeWeight(3);
        cp.bezier(x1, y1, x1 + dif, y1, x2 - dif, y2, x2, y2);
      } catch (Exception e) {
        removeConnector(n);
      }
    }
    cp.strokeWeight(1);
    cp.fill(fillColor);
    cp.rect(x, y, w, h);
    cp.fill(255);
    if(playing) {
      if(paused) {
        cp.rect(x, y + 20, 6, 15);
        cp.rect(x + 8, y + 20, 6, 15);
      }
      else cp.triangle(x, y + 20, x + 14, y + 28, x, y + 35);
      cp.rect(x, y + 36, float(presentTime) / endTime * w, 4);
    }
    cp.noStroke();
    if(beginPaused) {
      cp.rect(x + 34, y + 24, 3, 8);
      cp.rect(x + 39, y + 24, 3, 8);
    }
    if(beginTransition) cp.triangle(x + 44, y + 32, x + 52, y + 32, x + 52, y + 24);
    if(loop) cp.ellipse(x + 58, y + 28, 8, 8);
    if(endTransition) cp.triangle(x + 64, y + 24, x + 64, y + 32, x + 72, y + 32);
    if(endPaused) {
      cp.rect(x + 74, y + 24, 3, 8);
      cp.rect(x + 79, y + 24, 3, 8);
    }
    cp.stroke(strokeColor);
    cp.fill(fillColor);
    for(int n = 0; n < next.length; n++) {
      int x1 = x + w;
      int y1 = round(y + (n + 1 / 2.0) * h  / next.length);
      cp.arc(x1, y1, h / next.length, h / next.length, PI + HALF_PI, TWO_PI + HALF_PI);
    }

    cp.textAlign(CENTER, CENTER);
    cp.fill(0);
    cp.text(label, x + w / 2, y + h / 4);
    cp.image(icon, x + 16, y + h / 2);
    if(!controlPanel.isVisible() && index == nodes.size() - 1 && mouseOver && notes.length() > 0) {
      cp.fill(color(red(overColor), green(overColor), blue(overColor), 232));
      cp.rect(cp.width - 240 - translation, 24, 240, 160);
      cp.fill(0);
      cp.text(notes, cp.width - 240 - translation, 24, 240, 160);
    }
  }

  void turn() {
    if(!playing) {
      initializeTurn();
      endTime = int(duration * 1000);
      finalizeTurn();
    }
    else paused = !paused;
  }

  void initializeTurn() {
    paused = false;
    if(stage[track] != null) stage[track].end(true); 
    stage[track] = this;
  }
  
  void finalizeTurn() {
    presentTime = 0;
    paused = beginPaused;
    onEndPause = false;
    prevMillis = millis();
    playing = true;
  }
  
  void play() {
    if(!playing) return;
    finalizePlay();
  }

  void finalizePlay() {
    int presentMillis = millis();
    if(!paused) {
      presentTime += presentMillis - prevMillis;
      if(presentTime >= endTime) {
        if(loop && !onEndPause) presentTime = 0;
        else end(false);
      }
    }
    prevMillis = presentMillis;
  }

  void end(boolean fullStop) {
    if(!fullStop && endPaused && !onEndPause) gotoEndPause(); //<>//
    else finalizeEnd(fullStop);
  }
  
  void gotoEndPause() {
    onEndPause = true;
    presentTime = endTime;
    turn();
  }

  void finalizeEnd(boolean fullStop) {
    playing = false;
    paused = false;
    onEndPause = false;
    stage[track] = null;
    if(!fullStop) {
      for(int n: next) {
        Node no = nodes.get(n);
        if(no.playing) no.end(true);
        no.turn();
      }
    }
  }

  void load() {
    textLabel.setText(label);
    textDuration.setText(timeToString(duration));
    cboxBeginPaused.setSelected(beginPaused);
    cboxEndPaused.setSelected(endPaused);
    notesArea.setText(notes);
    
    cboxLoop.setSelected(loop);
    cboxBeginTransition.setSelected(beginTransition);
    cboxEndTransition.setSelected(endTransition);

    textBegin.setLocalColor(7, color(255));
    textEnd.setLocalColor(7, color(255));
    textDuration.setLocalColor(7, color(255));
    textBeginTransition.setLocalColor(7, color(255));
    textEndTransition.setLocalColor(7, color(255));
    textTextSize.setLocalColor(7, color(255));
    textX.setLocalColor(7, color(255));
    textY.setLocalColor(7, color(255));
    textW.setLocalColor(7, color(255));
    textH.setLocalColor(7, color(255));
    textLabel.setFocus(true);

    tm.removeControl(textPath);
    tm.removeControl(textLabel);
    tm.removeControl(textX);
    tm.removeControl(textY);
    tm.removeControl(textW);
    tm.removeControl(textH);
    tm.removeControl(textBegin);
    tm.removeControl(textEnd);
    tm.removeControl(textDuration);
    tm.removeControl(textArea);
    tm.removeControl(textBeginTransition);
    tm.removeControl(textEndTransition);
    tm.removeControl(textTextSize);
    tm.removeControl(notesArea);
  }

  void save() {
    label = trim(textLabel.getText());
    if(isTime(textDuration.getText())) duration = stringToTime(textDuration.getText());
    if(duration < 0) duration = 0;
    beginPaused = cboxBeginPaused.isSelected();
    endPaused = cboxEndPaused.isSelected();
    notes = trim(notesArea.getText());
    w = max(int(cp.textWidth(label)) + 8, 84);

    loop = cboxLoop.isSelected();
    beginTransition = cboxBeginTransition.isSelected();
    endTransition = cboxEndTransition.isSelected();
  }
  
  void clear() {
    g.removeCache(icon);
    icon = null;
  }
}