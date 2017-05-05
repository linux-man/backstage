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
class Rect extends Node {
  boolean centered;
  float nX, nY, nW, nH, beginTransitionDuration, endTransitionDuration;
  int beginTransitionType, endTransitionType;
  color bColor;

  float pX, pY, pW, pH;

  Rect() {
    this("", "", defaultDuration, false, false, nodes.size(), -translation, trackHeight, new int[0], false, false, false, false, 0, 0, 1, 1, 1, 1, 0, 0, color(128));
  }

  Rect(String label, String notes, float duration, boolean beginPaused, boolean endPaused, int index, int x, int y, int[] next,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered,
  float nX, float nY, float nW, float nH, float beginTransitionDuration, float endTransitionDuration,
  int beginTransitionType, int endTransitionType,
  color bColor) {
    super("Rect", label, notes, duration, beginPaused, endPaused, index, x, y, next, iconRect);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType;
    this.bColor = bColor;
  }
  
  void turn() {
    if(!playing) {
      initializeTurn();
      if(nX > 0 && nX <= 1) pX = width * nX; else pX = nX;
      if(nY > 0 && nY <= 1) pY = height * nY; else pY = nY;
      if(nW <= 1) pW = width * nW; else pW = nW;
      if(nH <= 1) pH = height * nH; else pH = nH;
      if(centered) {
        pX = (width - pW) / 2;
        pY = (height - pH) / 2;
      }
      endTime = int(duration * 1000);
      finalizeTurn();
    }
    else paused = !paused;
  }
  
  void play() {
    if(!playing) return;
    float x = pX; float y = pY; float w = pW; float h = pH;
    color c = bColor;

    if(beginTransition && beginTransitionDuration > 0 && presentTime < beginTransitionDuration * 1000) {
      switch(beginTransitionType) {
        case 0: c = color(red(bColor), green(bColor), blue(bColor), alpha(bColor) * presentTime / beginTransitionDuration / 1000); break;
        case 1:
          w = pW * presentTime / beginTransitionDuration / 1000;
          h = pH * presentTime / beginTransitionDuration / 1000;
          x = pX + (pW - w) / 2;
          y = pY + (pH - h) / 2;
          break;
        case 2: x = width +  (pX - width) * presentTime / beginTransitionDuration / 1000; break;
        case 3: x = -pW + (pX + pW) * presentTime / beginTransitionDuration / 1000; break;
        case 4: y = height +  (pY - height) * presentTime / beginTransitionDuration / 1000; break;
        case 5: y = -pH + (pY + pH) * presentTime / beginTransitionDuration / 1000; break;
      }
    }
    else if(endTransition && endTransitionDuration > 0 && presentTime > endTime - endTransitionDuration * 1000) {
      switch(endTransitionType) {
        case 0: c = color(red(bColor), green(bColor), blue(bColor), alpha(bColor) * (endTime - presentTime) / endTransitionDuration / 1000); break;
        case 1:
          w = pW * (endTime - presentTime) / beginTransitionDuration / 1000;
          h = pH * (endTime - presentTime) / beginTransitionDuration / 1000;
          x = pX + (pW - w) / 2;
          y = pY + (pH - h) / 2;
          break;
        case 2: x = -pW +  (pX + pW) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
        case 3: x = width +  (pX  - width) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
        case 4: y = -pH +  (pY + pH) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
        case 5: y = height +  (pY  - height) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
      }
    }

    noStroke();
    fill(c);
    rect(x, y, w, h);

    finalizePlay();
  }

  void load() {
    super.load();
    cboxCentered.setSelected(centered);
    textX.setText(dimToString(nX));
    textY.setText(dimToString(nY));
    textW.setText(dimToString(nW));
    textH.setText(dimToString(nH));
    textBeginTransition.setText(timeToString(beginTransitionDuration));
    textEndTransition.setText(timeToString(endTransitionDuration));
    String[] t = {"Dissolve", "Zoom", "Slide Left", "Slide Right", "Slide Up", "Slide Down"};
    dListBeginTransition.setItems(t, 0);
    dListEndTransition.setItems(t, 0);
    dListBeginTransition.setSelected(beginTransitionType);
    dListEndTransition.setSelected(endTransitionType);
    sketchPg.beginDraw();
    sketchPg.background(bColor);
    sketchPg.endDraw();

    labelPath.setVisible(false);
    textPath.setVisible(false);
    labelLabel.moveTo(8, 24);
    textLabel.moveTo(64, 24);
    labelX.setVisible(true);
    labelX.moveTo(8, 48);
    textX.setVisible(true);
    textX.moveTo(64, 48);
    labelY.setVisible(true);
    labelY.moveTo(8, 72);
    textY.setVisible(true);
    textY.moveTo(64, 72);
    labelW.setVisible(true);
    labelW.moveTo(120, 48);
    textW.setVisible(true);
    textW.moveTo(176, 48);
    labelH.setVisible(true);
    labelH.moveTo(120, 72);
    textH.setVisible(true);
    textH.moveTo(176, 72);
    cboxCentered.setVisible(true);
    cboxCentered.moveTo(8, 96);
    cboxAspectRatio.setVisible(false);
    buttonBegin.setVisible(false);
    textBegin.setVisible(false);
    buttonEnd.setVisible(false);
    textEnd.setVisible(false);
    labelDuration.moveTo(120, 96);
    textDuration.setEnabled(true);
    textDuration.moveTo(176, 96);
    cboxLoop.setVisible(true);
    cboxLoop.moveTo(120, 168 - 48);
    labelVolume.setVisible(false);
    sliderVolume.setVisible(false);
    buttonColor.setVisible(true);
    buttonColor.moveTo(8, 120);
    sketchColor.setVisible(true);
    sketchColor.moveTo(64, 120);
    cboxBeginPaused.moveTo(232, 24);
    cboxEndPaused.moveTo(344, 24);
    cboxBeginTransition.setVisible(true);
    cboxBeginTransition.moveTo(232, 48);
    cboxEndTransition.setVisible(true);
    cboxEndTransition.moveTo(344, 48);
    labelBeginTransition.setVisible(true);
    labelBeginTransition.moveTo(232, 72);
    textBeginTransition.setVisible(true);
    textBeginTransition.moveTo(288, 72);
    labelEndTransition.setVisible(true);
    labelEndTransition.moveTo(344, 72);
    textEndTransition.setVisible(true);
    textEndTransition.moveTo(400, 72);
    dListBeginTransition.setVisible(true);
    dListBeginTransition.moveTo(232, 96);
    dListEndTransition.setVisible(true);
    dListEndTransition.moveTo(344, 96);
    labelText.setVisible(false);
    textArea.setVisible(false);
    labelTextAlign.setVisible(false);
    dListTextAlignHor.setVisible(false);
    dListTextAlignVer.setVisible(false);
    labelTextSize.setVisible(false);
    textTextSize.setVisible(false);
    labelTextFont.setVisible(false);
    dListTextFont.setVisible(false);
    labelNotes.moveTo(232, 144);
    notesArea.moveTo(232, 160);
    tm.addControls(textLabel, textX, textY, textW, textH, textDuration, textBeginTransition, textEndTransition, notesArea);
  }
  
  void save() {
    super.save();
    centered = cboxCentered.isSelected();
    if(isDim(textX.getText())) nX = stringToDim(textX.getText());
    if(isDim(textY.getText())) nY = stringToDim(textY.getText());
    if(isDim(textW.getText())) nW = stringToDim(textW.getText());
    if(isDim(textH.getText())) nH = stringToDim(textH.getText());
    if(nW <= 0) nW = 1;
    if(nH <= 0) nH = 1;
    if(isTime(textBeginTransition.getText())) beginTransitionDuration = stringToTime(textBeginTransition.getText());
    if(isTime(textEndTransition.getText())) endTransitionDuration = stringToTime(textEndTransition.getText());
    beginTransitionType = dListBeginTransition.getSelectedIndex();
    endTransitionType = dListEndTransition.getSelectedIndex();
    bColor = sketchPg.backgroundColor;
  }
}