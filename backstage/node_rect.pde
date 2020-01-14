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
  boolean centered, perX, perY, perW, perH;
  float nX, nY, nW, nH;
  int beginTransitionType, endTransitionType;
  color bColor;

  float pX, pY, pW, pH;

  Rect(Rect no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.loop, no.beginTransition, no.endTransition, no.centered,
    no.nX, no.nY, no.nW, no.nH, no.perX, no.perY, no.perW, no.perH, no.beginTransitionDuration, no.endTransitionDuration,
    no.beginTransitionType, no.endTransitionType, no.bColor);
  }

  Rect() {
    this("", "", defaultDuration, false, false, false, nodes.size(), -translation, trackHeight, 0, new int[0], false, false, false, false, 0, 0, 100, 100, false, false, true, true, 1, 1, 0, 0, color(128));
  }

  Rect(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, int index, int x, int y, int highlight, int[] next,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered,
  float nX, float nY, float nW, float nH, boolean perX, boolean perY, boolean perW, boolean perH, float beginTransitionDuration, float endTransitionDuration,
  int beginTransitionType, int endTransitionType,
  color bColor) {
    super("Rect", label, notes, duration, beginPaused, endPaused, independent, index, x, y, highlight, next, iconRect);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.perX = perX; this.perY = perY; this.perW = perW; this.perH = perH;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType;
    this.bColor = bColor;
  }
  
  void turn() {
    if(!playing) {
      initializeTurn();
      if(perX) pX = width * nX / 100.0; else pX = nX;
      if(perY) pY = height * nY / 100.0; else pY = nY;
      if(perW) pW = width * nW / 100.0; else pW = nW;
      if(perH) pH = height * nH / 100.0; else pH = nH;
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

    if(isBeginTransition()) {
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
    else if(isEndTransition()) {
      switch(endTransitionType) {
        case 0: c = color(red(bColor), green(bColor), blue(bColor), alpha(bColor) * (endTime - presentTime) / endTransitionDuration / 1000); break;
        case 1:
          w = pW * (endTime - presentTime) / endTransitionDuration / 1000;
          h = pH * (endTime - presentTime) / endTransitionDuration / 1000;
          x = pX + (pW - w) / 2;
          y = pY + (pH - h) / 2;
          break;
        case 2: x = -pW +  (pX + pW) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 3: x = width +  (pX  - width) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 4: y = -pH +  (pY + pH) * (endTime - presentTime) / endTransitionDuration / 1000; break;
        case 5: y = height +  (pY  - height) * (endTime - presentTime) / endTransitionDuration / 1000; break;
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
    cboxX.setSelected(perX);
    cboxY.setSelected(perY);
    cboxW.setSelected(perW);
    cboxH.setSelected(perH);
    textBeginTransition.setText(timeToString(beginTransitionDuration));
    textEndTransition.setText(timeToString(endTransitionDuration));
    String[] t = {"Dissolve", "Zoom", "Slide Left", "Slide Right", "Slide Up", "Slide Down"};
    dListBeginTransition.setItems(t, 0);
    dListEndTransition.setItems(t, 0);
    dListBeginTransition.setSelected(beginTransitionType);
    dListEndTransition.setSelected(endTransitionType);
    PGraphics v = viewColor.getGraphics();
    v.beginDraw();
    v.background(bColor);
    v.endDraw();

    labelPath.setVisible(false);
    textPath.setVisible(false);
    labelLabel.moveTo(8, 24);
    textLabel.moveTo(48, 24);
    labelX.setVisible(true);
    labelX.moveTo(8, 48);
    textX.setVisible(true);
    textX.moveTo(48, 48);
    cboxX.setVisible(true);
    cboxX.moveTo(88, 48);
    labelY.setVisible(true);
    labelY.moveTo(8, 72);
    textY.setVisible(true);
    textY.moveTo(48, 72);
    cboxY.setVisible(true);
    cboxY.moveTo(88, 72);
    labelW.setVisible(true);
    labelW.moveTo(128, 48);
    textW.setVisible(true);
    textW.moveTo(168, 48);
    cboxW.setVisible(true);
    cboxW.moveTo(208, 48);
    labelH.setVisible(true);
    labelH.moveTo(128, 72);
    textH.setVisible(true);
    textH.moveTo(168, 72);
    cboxH.setVisible(true);
    cboxH.moveTo(208, 72);
    cboxCentered.setVisible(true);
    cboxCentered.moveTo(8, 96);
    cboxAspectRatio.setVisible(false);
    buttonBegin.setVisible(false);
    textBegin.setVisible(false);
    buttonEnd.setVisible(false);
    textEnd.setVisible(false);
    labelDuration.moveTo(128, 96);
    textDuration.setEnabled(true);
    textDuration.moveTo(192, 96);
    cboxLoop.setVisible(true);
    cboxLoop.moveTo(128, 168 - 48);
    labelVolume.setVisible(false);
    sliderVolume.setVisible(false);
    buttonColor.setVisible(true);
    buttonColor.moveTo(8, 120);
    viewColor.setVisible(true);
    viewColor.moveTo(72, 120);
    cboxBeginPaused.moveTo(248, 24);
    cboxEndPaused.moveTo(368, 24);
    cboxBeginTransition.setVisible(true);
    cboxBeginTransition.moveTo(248, 48);
    cboxEndTransition.setVisible(true);
    cboxEndTransition.moveTo(368, 48);
    labelBeginTransition.setVisible(true);
    labelBeginTransition.moveTo(248, 72);
    textBeginTransition.setVisible(true);
    textBeginTransition.moveTo(312, 72);
    labelEndTransition.setVisible(true);
    labelEndTransition.moveTo(368, 72);
    textEndTransition.setVisible(true);
    textEndTransition.moveTo(432, 72);
    dListBeginTransition.setVisible(true);
    dListBeginTransition.moveTo(248, 96);
    dListEndTransition.setVisible(true);
    dListEndTransition.moveTo(368, 96);
    labelText.setVisible(false);
    textArea.setVisible(false);
    labelTextAlign.setVisible(false);
    dListTextAlignHor.setVisible(false);
    dListTextAlignVer.setVisible(false);
    labelTextSize.setVisible(false);
    textTextSize.setVisible(false);
    labelTextFont.setVisible(false);
    dListTextFont.setVisible(false);
    labelNotes.moveTo(248, 144);
    notesArea.moveTo(248, 160);
    cboxEqualizer.setVisible(false);
    tm.addControls(textLabel, textX, textY, textW, textH, textDuration, textBeginTransition, textEndTransition, notesArea);
  }
  
  void save() {
    super.save();
    centered = cboxCentered.isSelected();
    if(isDim(textX.getText())) nX = stringToDim(textX.getText());
    if(isDim(textY.getText())) nY = stringToDim(textY.getText());
    if(isDim(textW.getText())) nW = stringToDim(textW.getText());
    if(isDim(textH.getText())) nH = stringToDim(textH.getText());
    if(nW < 0) nW = 0;
    if(nH < 0) nH = 0;
    perX = cboxX.isSelected();
    perY = cboxY.isSelected();
    perW = cboxW.isSelected();
    perH = cboxH.isSelected();
    beginTransitionType = dListBeginTransition.getSelectedIndex();
    endTransitionType = dListEndTransition.getSelectedIndex();
    bColor = viewColor.getGraphics().backgroundColor;
  }
}
