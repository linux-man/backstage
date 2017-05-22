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
void initializeCp() {
  cp.getSurface().setIcon(loadImage("control-panel.png"));
  cp.setLocation(0, 0);
  tm = new GTabManager();
  controlPanel.setAlpha(232);
  tracksChange(tracks);
  controlPanel.setVisible(false);
  durationPanel.setVisible(false);
  aboutPanel.setVisible(false);
  buttonNew.setVisible(false);
  buttonNew.moveTo(buttonFiles.getX() + buttonFiles.getWidth() * 1, 0);
  buttonLoad.setVisible(false);
  buttonLoad.moveTo(buttonFiles.getX() + buttonFiles.getWidth() * 2, 0);
  buttonSave.setVisible(false);
  buttonSave.moveTo(buttonFiles.getX() + buttonFiles.getWidth() * 3, 0);
  buttonZip.setVisible(false);
  buttonZip.moveTo(buttonConfig.getX() + buttonConfig.getWidth() * 1, 0);
  buttonDefaultDuration.setVisible(false);
  buttonDefaultDuration.moveTo(buttonConfig.getX() + buttonConfig.getWidth() * 2, 0);
  buttonScheme.setVisible(false);
  buttonScheme.moveTo(buttonConfig.getX() + buttonConfig.getWidth() * 3, 0);
  buttonAddLink.setVisible(false);
  buttonAddLink.moveTo(buttonAdd.getX() + buttonAdd.getWidth() * 1, 0);
  buttonAddText.setVisible(false);
  buttonAddText.moveTo(buttonAdd.getX() + buttonAdd.getWidth() * 2, 0);
  buttonAddRect.setVisible(false);
  buttonAddRect.moveTo(buttonAdd.getX() + buttonAdd.getWidth() * 3, 0);
  buttonAddMedia.setVisible(false);
  buttonAddMedia.moveTo(buttonAdd.getX() + buttonAdd.getWidth() * 4, 0);
  textBegin.addEventHandler(this, "textTime_change");
  textEnd.addEventHandler(this, "textTime_change");
  textDuration.addEventHandler(this, "textTime_change");
  textBeginTransition.addEventHandler(this, "textTime_change");
  textEndTransition.addEventHandler(this, "textTime_change");
  textTextSize.addEventHandler(this, "textTime_change");
  textX.addEventHandler(this, "textDim_change");
  textY.addEventHandler(this, "textDim_change");
  textW.addEventHandler(this, "textDim_change");
  textH.addEventHandler(this, "textDim_change");
  textDp.addEventHandler(this,"textTime_change");
  sketchPg = createGraphics(56, 15);
  sketchPg.beginDraw();
  sketchPg.background(255, 0, 0);
  sketchPg.endDraw();
  sketchColor.setGraphic(sketchPg);
  cp.frame.setSize(max(min(prefs.getInt("Width", 600), screenWidth), 600), cp.height);
  resizeCp();
  cp.addMouseHandler(this, "cp_mouse");  
  cp.addDrawHandler(this, "cp_draw");
  cp.textFont(loadFont("Ubuntu-12.vlw"), 12);
  changeScheme(prefs.getInt("Scheme", 8));
}

synchronized public void cp_draw(PApplet appc, GWinData data) {
  cp.background(backgroundColor);
  cp.stroke(selectedColor);
  for(int n = 1; n < tracks + 2; n++) cp.line(0, trackHeight * n - 4, cp.width, trackHeight * n - 4); 

  playing = false;
  paused = true;
  for(Node no: stage) if(no != null) {
    playing = true;
    if(!no.paused) paused = false;
  }
  if(!playing) paused = false;

  if(!playing || paused) buttonPlay.setIcon("play.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  else buttonPlay.setIcon("pause.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);

  if(nodes.size() > 0) {
    Node last = nodes.get(nodes.size() - 1);
    if(last.selected) {
      cp.fill(selectedColor);
      cp.stroke(selectedColor);
      cp.rect(buttonNodeNext.getX() + buttonNodeNext.getWidth(), cp.height - 24, cp.width - (buttonNodeNext.getX() + buttonNodeNext.getWidth()), 24);
      buttonNodePlay.setVisible(true);
      buttonNodeStop.setVisible(true);
      buttonNodeNext.setVisible(true);
      buttonNodeSlider.setVisible(true);
      if(last.playing) {
        if(last.paused) buttonNodePlay.setIcon("play.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
        else buttonNodePlay.setIcon("pause.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
        if(!draggingSlider) {
          float xi = buttonNodeNext.getX() + buttonNodeNext.getWidth();
          float xf = cp.width - buttonNodeSlider.getWidth();
          if(last.endTime != 0) buttonNodeSlider.moveTo(xi + float(last.presentTime) / last.endTime * (xf - xi), buttonNodeSlider.getY());
        }
      }
      else {
        buttonNodePlay.setIcon("play.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
        buttonNodeSlider.moveTo(buttonNodeNext.getX() + buttonNodeNext.getWidth(), buttonNodeSlider.getY());
      }
      cp.fill(selectedColor);
      cp.textAlign(CENTER);
      float xi = buttonNodeNext.getX() + buttonNodeNext.getWidth();
      float xf = cp.width - buttonNodeSlider.getWidth();
      int t = int((buttonNodeSlider.getX() - xi) / (xf - xi) * last.endTime / 1000);
      cp.text(t, buttonNodeSlider.getX() + buttonNodeSlider.getWidth() / 2, buttonNodeSlider.getY() - 12);
    }
    else {
      buttonNodePlay.setVisible(false);
      buttonNodeStop.setVisible(false);
      buttonNodeNext.setVisible(false);
      buttonNodeSlider.setVisible(false);
    }
    if(dragging) {
      if(cp.mouseX > cp.width - 12) {translation--; last.x++;}
      if(cp.mouseX < 12) {translation++; last.x--;}
      translation = min(translation, 0);
      last.x = max(last.x, 0);
    }
    if(cp.mousePressed && cp.mouseButton == RIGHT) {
      if(last.connecting) {
        if(cp.mouseX > cp.width - 12) translation--;
        if(cp.mouseX < 12) translation++;
        translation = min(translation, 0);
      }
    }
  }
  else {
    buttonNodePlay.setVisible(false);
    buttonNodeStop.setVisible(false);
    buttonNodeNext.setVisible(false);
    buttonNodeSlider.setVisible(false);
  }
  cp.translate(translation, 0);
  for(Node no: nodes) no.draw();
}

synchronized public void cp_mouse(PApplet appc, GWinData data, MouseEvent mevent) {
  int action = mevent.getAction();
  int button = mevent.getButton();
  int x = mevent.getX();
  int y = mevent.getY();
  boolean ctrl = (mevent.getModifiers() & mevent.CTRL) != 0;
  switch(action) {
    case 1://mevent.PRESS
      if(buttonResize.isOver(x, y)) draggingWindow = true;
      if(buttonNodeSlider.isVisible() && buttonNodeSlider.isOver(x, y)) draggingSlider = true;
      if(y < buttonFiles.getHeight() || y > cp.height - buttonNodePlay.getHeight() || controlPanel.isVisible() || durationPanel.isVisible()) return;
      dragging = false;
      for(Node no: nodes) {
        if(no.mouseOver(x, y)) {
          Node temp = no;
          int a = no.index;
          int b = nodes.size() - 1;
          nodes.set(a, nodes.get(b));
          nodes.set(b, temp);
          nodes.get(a).index = a;
          nodes.get(b).index = b;
          for(Node c: nodes) c.switchConnectors(a, b);
          if(button == LEFT) {
            dragging = true;
            no.dragged = true;
            if(no.selected) for(Node s: nodes) s.dragged = s.selected;
          }
          else if(button == RIGHT) no.connecting = true;
          break;
        }
      }
      break;
    case 2://mevent.RELEASE
      cp.cursor(ARROW);
      if(draggingWindow) {
        draggingWindow = false;
        cp.redraw();
      }
      if(draggingSlider) {
        draggingSlider = false;
        Node last = nodes.get(nodes.size() -1);
        if(!last.playing) return;
        updateTime(last);
        switch(last.type) {
          case "Video": ((Video)last).video.jump(((Video)last).beginAt + ((Video)last).presentTime/ 1000.0); break;
          case "Audio": ((Audio)last).audio.cue(int(((Video)last).beginAt * 1000 + ((Video)last).presentTime)); break;
        } 
      }
      if(dragging) {
        dragging = false;
        for(Node no: nodes) {
          if(no.dragged) {
            no.dragged = false;
            int t = max(0, min(tracks - 1, tracks - round(float(no.y) / trackHeight)));
            if(playing && no.playing && no.track != t) {
              stage[no.track] = null;
              if(stage[t] != null) stage[t].end(true);
              stage[t] = no;
            }
            no.track = t;
          }
        }
      }
      else if(button == RIGHT) {
        Node last = nodes.get(nodes.size() -1);
        if(last.connecting) {
          for(Node no: nodes) {
            if(no.mouseOver(x, y)) {
              last.addConnector(no.index);
              break;
            }
          }
          last.connecting = false;
        }
      }
      break;
    case 3://mevent.CLICK
      if(buttonNodeSlider.isVisible() && y > cp.height - buttonNodeNext.getHeight() && x > buttonNodeNext.getX() + buttonNodeNext.getWidth()) {
        Node last = nodes.get(nodes.size()-1);
        if(!last.playing) return;
        moveSlider(x);
        updateTime(last);
        switch(last.type) {
          case "Video": ((Video)last).video.jump(((Video)last).beginAt + last.presentTime/ 1000.0); break;
          case "Audio": ((Audio)last).audio.cue(int(((Audio)last).beginAt * 1000 + last.presentTime)); break;
        }
      }
      if(y < buttonFiles.getHeight() || y > cp.height - buttonFiles.getHeight() || controlPanel.isVisible() || durationPanel.isVisible()) return;
      if(button == LEFT) for(Node no: nodes) no.click(x, y, mevent.getCount(), ctrl);
      else if(button == RIGHT) {
        Node last = nodes.get(nodes.size()-1);
        if(last.mouseOver(x, y)) {
          if(last.mouseOverConnector(x, y) >= 0) last.removeConnector(last.mouseOverConnector(x, y));
          else {
            if(G4P.selectOption(cp, "Are you sure?", "Delete node " + last.label, G4P.QUERY, G4P.YES_NO) == G4P.OK){
              for(Node no: stage) if(no == last) no.end(true);
              for(Node no: nodes) no.removeConnector(nodes.size()-1);
              nodes.remove(nodes.size()-1);
            }
          }
          break;
        }
      }
      break;
    case 4://mevent.DRAG
      if(button == RIGHT) return;
      else if(draggingSlider) {
        cp.cursor(MOVE);
        moveSlider(x);
      }
      else if(draggingWindow) {
        cp.cursor(MOVE);
        cp.frame.setSize(max(min(x + 8, screenWidth), 600), cp.height);
        resizeCp();
      }
      else if(dragging) {
        cp.cursor(MOVE);
        for(Node no: nodes) no.drag(x - cp.pmouseX, y - cp.pmouseY);
      }
      else if(!(y < buttonFiles.getHeight() || y > cp.height - buttonFiles.getHeight() || controlPanel.isVisible() || durationPanel.isVisible())) {
        cp.cursor(MOVE);
        int maxTrans = 0;
        if(nodes.size() > 0) for(Node no: nodes) maxTrans = max(maxTrans, no.x + no.w + 84 - cp.width);
        translation = min(max(translation + x - cp.pmouseX, -maxTrans), 0);
      }
      break;
  }
}

public void textTime_change(GTextField source, GEvent event) {
  if(isTime(source.getText())) source.setLocalColor(7, color(255));
  else source.setLocalColor(7, color(255,0,0));
}

public void textDim_change(GTextField source, GEvent event) {
  if(isDim(source.getText())) source.setLocalColor(7, color(255));
  else source.setLocalColor(7, color(255,0,0));
}

void buttonsEnabled(boolean e) {
  buttonFiles.setEnabled(e);
  buttonNew.setEnabled(e);
  buttonLoad.setEnabled(e);
  buttonSave.setEnabled(e);
  buttonConfig.setEnabled(e);
  buttonZip.setEnabled(e);
  buttonDefaultDuration.setEnabled(e);
  buttonScheme.setEnabled(e);
  buttonAdd.setEnabled(e);
  buttonAddLink.setEnabled(e);
  buttonAddText.setEnabled(e);
  buttonAddRect.setEnabled(e);
  buttonAddMedia.setEnabled(e);
  buttonShow.setEnabled(e);
  buttonPlay.setEnabled(e);
  buttonStop.setEnabled(e);
  buttonAbout.setEnabled(e);
  buttonTracksMinus.setEnabled(e);
  buttonTracksPlus.setEnabled(e);
}

void moveSlider(int x) {
  float xi = buttonNodeNext.getX() + buttonNodeNext.getWidth();
  float xf = cp.width - buttonNodeSlider.getWidth();
  buttonNodeSlider.moveTo(min(max(x - buttonNodeSlider.getWidth() / 2, xi), xf), buttonNodeSlider.getY());
}

void updateTime(Node last) {
  float xi = buttonNodeNext.getX() + buttonNodeNext.getWidth();
  float xf = cp.width - buttonNodeSlider.getWidth();
  last.presentTime = int((buttonNodeSlider.getX() - xi) / (xf - xi) * last.endTime);
  if(last.presentTime > last.endTime - 100) last.presentTime -= 100;//Prevent strange behaviour when dragging/clicking slider at the end
}