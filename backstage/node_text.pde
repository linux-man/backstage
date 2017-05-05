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
class Text extends Node {
  boolean centered;
  float nX, nY, nW, nH, beginTransitionDuration, endTransitionDuration;
  int beginTransitionType, endTransitionType, textAlignHor, textAlignVer, textSize;
  String text, textFont;
  color bColor;

  float pX, pY, pW, pH;
  PFont font;
  
  Text() {
    this("", "", defaultDuration, false, false, nodes.size(), -translation, trackHeight, new int[0], false, false, false, true, 0, 0, 0, 0, 1, 1, 0, 0, 1, 2, 48, "", "", color(255));
  }

  Text(String label, String notes, float duration, boolean beginPaused, boolean endPaused, int index, int x, int y, int[] next,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered,
  float nX, float nY, float nW, float nH, float beginTransitionDuration, float endTransitionDuration,
  int beginTransitionType, int endTransitionType, int textAlignHor, int textAlignVer, int textSize,
  String text, String textFont,
  color bColor) {
    super("Text", label, notes, duration, beginPaused, endPaused, index, x, y, next, iconText);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType; this.textAlignHor = textAlignHor; this.textAlignVer = textAlignVer; this.textSize = textSize;
    this.text = text; this.textFont = textFont;
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
      font = createFont(textFont, textSize);
      textFont(font);
      if(pW == 0) pW = textWidth(text);
      if(pH == 0) pH = textAscent() + textDescent();
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
        case 1: x = width +  (pX - width) * presentTime / beginTransitionDuration / 1000; break;
        case 2: x = -pW + (pX + pW) * presentTime / beginTransitionDuration / 1000; break;
        case 3: y = height +  (pY - height) * presentTime / beginTransitionDuration / 1000; break;
        case 4: y = -pH + (pY + pH) * presentTime / beginTransitionDuration / 1000; break;
      }
    }
    else if(endTransition && endTransitionDuration > 0 && presentTime > endTime - endTransitionDuration * 1000) {
      switch(endTransitionType) {
        case 0: c = color(red(bColor), green(bColor), blue(bColor), alpha(bColor) * (endTime - presentTime) / endTransitionDuration / 1000); break;
        case 1: x = -pW +  (pX + pW) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
        case 2: x = width +  (pX  - width) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
        case 3: y = -pH +  (pY + pH) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
        case 4: y = height +  (pY  - height) * (endTime - presentTime) / beginTransitionDuration / 1000; break;
      }
    }

    textFont(font);
    noStroke();
    fill(c);
    int hor, ver;
    switch(textAlignHor) {
      case 0: hor = LEFT; break;
      case 1: hor = CENTER; break;
      default: hor = RIGHT; break;
    }
    switch(textAlignVer) {
      case 0: ver = BASELINE; break;
      case 1: ver = TOP; break;
      case 2: ver = CENTER; break;
      default: ver = BOTTOM; break;
    }
    textAlign(hor, ver);
    if(nW > 0 && nH > 0) text(text, x, y, w, h);
    else text(text, x, y);

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
    String[] t = {"Dissolve", "Slide Left", "Slide Right", "Slide Up", "Slide Down"};
    dListBeginTransition.setItems(t, 0);
    dListEndTransition.setItems(t, 0);
    dListBeginTransition.setSelected(beginTransitionType);
    dListEndTransition.setSelected(endTransitionType);
    dListTextAlignHor.setSelected(textAlignHor);
    dListTextAlignVer.setSelected(textAlignVer);
    textTextSize.setText(dimToString(textSize));
    String[] fonts = {"Default"};
    fonts = concat(fonts, PFont.list());
    dListTextFont.setItems(fonts, 0);
    for(int n = 0; n < fonts.length; n++) if(fonts[n] == textFont) dListTextFont.setSelected(n);
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
    cboxLoop.moveTo(120, 116);
    labelVolume.setVisible(false);
    sliderVolume.setVisible(false);
    buttonColor.setVisible(true);
    buttonColor.moveTo(8, 216);
    sketchColor.setVisible(true);
    sketchColor.moveTo(64, 216);
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
    labelText.setVisible(true);
    labelText.moveTo(8, 120);
    textArea.setVisible(true);
    textArea.moveTo(8, 136);
    labelTextAlign.setVisible(true);
    labelTextAlign.moveTo(120, 144);
    dListTextAlignHor.setVisible(true);
    dListTextAlignHor.moveTo(120, 168);
    dListTextAlignVer.setVisible(true);
    dListTextAlignVer.moveTo(120, 192);
    labelTextSize.setVisible(true);
    labelTextSize.moveTo(120, 216);
    textTextSize.setVisible(true);
    textTextSize.moveTo(400 - 224, 216);
    labelTextFont.setVisible(true);
    labelTextFont.moveTo(232, 120);
    dListTextFont.setVisible(true);
    dListTextFont.moveTo  (288, 120);
    labelNotes.moveTo(232, 144);
    notesArea.moveTo(232, 160);
    tm.addControls(textLabel, textX, textY, textW, textH, textDuration, textArea, textTextSize, textBeginTransition, textEndTransition, notesArea);
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
    if(isTime(textBeginTransition.getText())) beginTransitionDuration = stringToTime(textBeginTransition.getText());
    if(isTime(textEndTransition.getText())) endTransitionDuration = stringToTime(textEndTransition.getText());
    beginTransitionType = dListBeginTransition.getSelectedIndex();
    endTransitionType = dListEndTransition.getSelectedIndex();
    textAlignHor = dListTextAlignHor.getSelectedIndex();
    textAlignVer = dListTextAlignVer.getSelectedIndex();
    if(isTime(textTextSize.getText())) textSize = int(stringToTime(textTextSize.getText()));
    text = textArea.getText();
    textFont = dListTextFont.getSelectedText();
    bColor = sketchPg.backgroundColor;
  }
}