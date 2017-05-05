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
class Video extends Node {
  String path;
  boolean centered, aspectRatio;
  float nX, nY, nW, nH, beginTransitionDuration, endTransitionDuration, volume, beginAt, endAt;
  int beginTransitionType, endTransitionType;
  
  float pX, pY, pW, pH;
  Movie video;
  
  Video(String label, String notes, float duration, boolean beginPaused, boolean endPaused, int index, int x, int y, int[] next,
  String path,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered, boolean aspectRatio,
  float nX, float nY, float nW, float nH, float beginTransitionDuration, float endTransitionDuration, float volume, float beginAt, float endAt,
  int beginTransitionType, int endTransitionType) {
    super("Video", label, notes, duration, beginPaused, endPaused, index, x, y, next, iconVideo);
    this.path = normalizePath(path);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered; this.aspectRatio = aspectRatio;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.volume = volume; this.beginAt = beginAt; this.endAt = endAt;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType;

    video = new Movie(main, projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
    video.play();
    video.volume(0);
    this.duration = int(video.duration() * 100) / 100.0;
    video.jump(video.duration() - 1);
    if(this.duration <= 0) throw new IllegalArgumentException("This is not a Video!");
    if(this.beginAt < 0 || this.beginAt >= this.duration) this.beginAt = 0;
    if(this.endAt <= 0 || this.endAt > this.duration || this.endAt <= this.beginAt) this.endAt = this.duration;
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
      endTime = int((endAt - beginAt) * 1000);
      video.play();
      duration = int(video.duration() * 100) / 100.0;
      if(beginAt < 0 || beginAt >= duration) beginAt = 0;
      if(endAt <= 0 || endAt > duration || endAt <= beginAt) endAt = duration;

      if(beginTransition) video.volume(0);
      else video.volume(volume);
      video.jump(beginAt);
      if(aspectRatio) {
        float ratio = float(video.width) / video.height;
        pW = min(pW, pH * ratio);
        pH = min(pH, pW / ratio);
      }
      if(centered) {
        pX = (width - pW) / 2;
        pY = (height - pH) / 2;
      }
      finalizeTurn();
    }
    else paused = !paused;
    if(paused) video.pause();
    else video.play();
  }
  
  void play() {
    if(!playing) return;
    float x = pX; float y = pY; float w = pW; float h = pH;
    tint(255, 255);

    if(beginTransition && beginTransitionDuration > 0 && presentTime < beginTransitionDuration * 1000) {
      switch(beginTransitionType) {
        case 0: tint(255, 255 * presentTime / beginTransitionDuration / 1000); break;
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
      video.volume(volume * presentTime / beginTransitionDuration / 1000);
    }
    else if(endTransition && endTransitionDuration > 0 && presentTime > endTime - endTransitionDuration * 1000) {
      switch(endTransitionType) {
        case 0: tint(255, 255 * (endTime - presentTime) / endTransitionDuration / 1000); break;
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
      video.volume(volume * (endTime - presentTime) / endTransitionDuration / 1000);
    }
    else video.volume(volume);

    image(video, x, y, w, h);

    finalizePlay();
    if(presentTime == 0 && loop) video.jump(beginAt);
  }

  void end(boolean fullStop) {
    if(endPaused && !onEndPause) gotoEndPause();
    else {
      video.jump(beginAt);
      video.stop();
      finalizeEnd(fullStop);
    }
  }

  void load() {
    super.load();
    textPath.setText(path);
    cboxCentered.setSelected(centered);
    cboxAspectRatio.setSelected(aspectRatio);
    textX.setText(dimToString(nX));
    textY.setText(dimToString(nY));
    textW.setText(dimToString(nW));
    textH.setText(dimToString(nH));
    textBeginTransition.setText(timeToString(beginTransitionDuration));
    textEndTransition.setText(timeToString(endTransitionDuration));
    sliderVolume.setValue(volume);
    textBegin.setText(timeToString(beginAt));
    textEnd.setText(timeToString(endAt));
    String[] t = {"Dissolve", "Zoom", "Slide Left", "Slide Right", "Slide Up", "Slide Down"};
    dListBeginTransition.setItems(t, 0);
    dListEndTransition.setItems(t, 0);
    dListBeginTransition.setSelected(beginTransitionType);
    dListEndTransition.setSelected(endTransitionType);

    labelPath.setVisible(true);
    textPath.setVisible(true);
    labelLabel.moveTo(8, 48);
    textLabel.moveTo(64, 48);
    labelX.setVisible(true);
    labelX.moveTo(8, 72);
    textX.setVisible(true);
    textX.moveTo(64, 72);
    labelY.setVisible(true);
    labelY.moveTo(8, 96);
    textY.setVisible(true);
    textY.moveTo(64, 96);
    labelW.setVisible(true);
    labelW.moveTo(120, 72);
    textW.setVisible(true);
    textW.moveTo(176, 72);
    labelH.setVisible(true);
    labelH.moveTo(120, 96);
    textH.setVisible(true);
    textH.moveTo(176, 96);
    cboxCentered.setVisible(true);
    cboxCentered.moveTo(8, 120);
    cboxAspectRatio.setVisible(true);
    cboxAspectRatio.moveTo(120, 120);
    buttonBegin.setVisible(true);
    buttonBegin.moveTo(8, 144);
    textBegin.setVisible(true);
    textBegin.moveTo(64, 144);
    buttonEnd.setVisible(true);
    buttonEnd.moveTo(120, 144);
    textEnd.setVisible(true);
    textEnd.moveTo(176, 144);
    labelDuration.moveTo(8, 168);
    textDuration.setEnabled(false);
    textDuration.moveTo(64, 168);
    cboxLoop.setVisible(true);
    cboxLoop.moveTo(120, 168);
    labelVolume.setVisible(true);
    labelVolume.moveTo(8, 192);
    sliderVolume.setVisible(true);
    sliderVolume.moveTo(64, 192);
    buttonColor.setVisible(false);
    sketchColor.setVisible(false);
    cboxBeginPaused.moveTo(232, 48);
    cboxEndPaused.moveTo(344, 48);
    cboxBeginTransition.setVisible(true);
    cboxBeginTransition.moveTo(232, 72);
    cboxEndTransition.setVisible(true);
    cboxEndTransition.moveTo(344, 72);
    labelBeginTransition.setVisible(true);
    labelBeginTransition.moveTo(232, 96);
    textBeginTransition.setVisible(true);
    textBeginTransition.moveTo(288, 96);
    labelEndTransition.setVisible(true);
    labelEndTransition.moveTo(344, 96);
    textEndTransition.setVisible(true);
    textEndTransition.moveTo(400, 96);
    dListBeginTransition.setVisible(true);
    dListBeginTransition.moveTo(232, 120);
    dListEndTransition.setVisible(true);
    dListEndTransition.moveTo(344, 120);
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
    tm.addControls(textPath, textLabel, textX, textY, textW, textH, textBegin, textEnd, textBeginTransition, textEndTransition, notesArea);
  }
  
  void save() {
    super.save();
    path = trim(textPath.getText());
    centered = cboxCentered.isSelected();
    aspectRatio = cboxAspectRatio.isSelected();
    if(isDim(textX.getText())) nX = stringToDim(textX.getText());
    if(isDim(textY.getText())) nY = stringToDim(textY.getText());
    if(isDim(textW.getText())) nW = stringToDim(textW.getText());
    if(isDim(textH.getText())) nH = stringToDim(textH.getText());
    if(nW <= 0) nW = 1;
    if(nH <= 0) nH = 1;
    if(isTime(textBeginTransition.getText())) beginTransitionDuration = stringToTime(textBeginTransition.getText());
    if(isTime(textEndTransition.getText())) endTransitionDuration = stringToTime(textEndTransition.getText());
    volume = sliderVolume.getValueF();
    if(isTime(textBegin.getText())) beginAt = stringToTime(textBegin.getText());
    if(isTime(textEnd.getText())) endAt = stringToTime(textEnd.getText());
    beginTransitionType = dListBeginTransition.getSelectedIndex();
    endTransitionType = dListEndTransition.getSelectedIndex();
    if(beginAt < 0 || beginAt >= duration) beginAt = 0;
    if(endAt <= 0 || endAt > duration || endAt <= beginAt) endAt = duration;
  }
}