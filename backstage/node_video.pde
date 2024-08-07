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
  String path, target;
  boolean centered, aspectRatio, perX, perY, perW, perH, clickable;
  float nX, nY, nW, nH, volume, beginAt, endAt;
  int beginTransitionType, endTransitionType;
  boolean equalizer;
  int preset;
  
  float pX, pY, pW, pH, pVolume, pPreamp;
  boolean loading, turnStarted;
  float[] pAmps;
  VLCJVideo video;

  Video(Video no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, no.targetable, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.path, no.loop, no.beginTransition, no.endTransition, no.centered, no.aspectRatio,
    no.nX, no.nY, no.nW, no.nH, no.perX, no.perY, no.perW, no.perH, no.beginTransitionDuration, no.endTransitionDuration, no.volume, no.beginAt, no.endAt,
    no.beginTransitionType, no.endTransitionType,
    no.equalizer, no.preset, no.video.preamp(), no.video.amps(),
    no.clickable, no.target);
  }

  Video(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, boolean targetable, int index, int x, int y, int highlight, int[] next,
  String path,
  boolean loop, boolean beginTransition, boolean endTransition, boolean centered, boolean aspectRatio,
  float nX, float nY, float nW, float nH, boolean perX, boolean perY, boolean perW, boolean perH, float beginTransitionDuration, float endTransitionDuration, float volume, float beginAt, float endAt,
  int beginTransitionType, int endTransitionType,
  boolean equalizer, int preset, float preamp, float[] amps,
  boolean clickable, String target) {
    super("Video", label, notes, duration, beginPaused, endPaused, independent, targetable, index, x, y, highlight, next, iconVideo);
    this.path = normalizePath(path);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition; this.centered = centered; this.aspectRatio = aspectRatio;
    this.nX = nX; this.nY = nY; this.nW = nW; this.nH = nH; this.perX = perX; this.perY = perY; this.perW = perW; this.perH = perH;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration;
    this.volume = volume; this.beginAt = beginAt; this.endAt = endAt;
    this.beginTransitionType = beginTransitionType; this.endTransitionType = endTransitionType;
    this.equalizer = equalizer; this.preset = preset;
    this.clickable = clickable; this.target = target;

    video = new VLCJVideo(main);

    video.bind(VLCJVideo.MediaPlayerEventType.LENGTH_CHANGED, new VRunnable(this) { public void run() {
      if(parent.loading) {
        parent.video.setVolume(0);
        parent.duration = video.duration() / 1000.0;
        if(parent.duration <= 0) throw new IllegalArgumentException("This is not a Video!");
        if(parent.beginAt < 0 || parent.beginAt >= parent.duration) parent.beginAt = 0;
        if(parent.endAt <= 0 || parent.endAt > parent.duration || parent.endAt <= parent.beginAt) parent.endAt = parent.duration;
        parent.loading = false;
      }
    }});

    loading = true;
    video.openAndPlay(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
    while(loading || video.width == 0) delay(10);
    video.stop();
    if(equalizer) {
      if(preset >= 0) video.setEqualizer(preset);
      else {
        video.setEqualizer();
        video.setPreamp(preamp);
        video.setAmps(amps);
      }
    }
  }

  void turn() {
    if(!playing) {
      initializeTurn();
      turnStarted = true;
      if(perX) pX = width * nX / 100.0; else pX = nX;
      if(perY) pY = height * nY / 100.0; else pY = nY;
      if(perW) pW = width * nW / 100.0; else pW = nW;
      if(perH) pH = height * nH / 100.0; else pH = nH;
      if(centered) {
        pX = (width - pW) / 2;
        pY = (height - pH) / 2;
      }
      endTime = int((endAt - beginAt) * 1000);
      video.play();

      if(beginTransition) video.setVolume(0);
      else video.setVolume(int(volume * 100));
      video.setTime(int(beginAt * 1000));
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

    if(isBeginTransition()) {
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
      video.setVolume(int(volume * presentTime / beginTransitionDuration / 10));
    }
    else if(isEndTransition()) {
      switch(endTransitionType) {
        case 0: tint(255, 255 * (endTime - presentTime) / endTransitionDuration / 1000); break;
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
      video.setVolume(int(volume * (endTime - presentTime) / endTransitionDuration / 10));
    }
    else video.setVolume(int(volume * 100));

    if(paused && video.isPlaying()) video.pause();
    
    if(!turnStarted || presentTime > 200) {
      try {
        image(video, x, y, w, h);
      }
      catch(Exception e) {
        println(e.toString());
        println(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
        presentTime = endTime;
      }
      turnStarted = false;
    }

    finalizePlay();
    if(loop && presentTime == 0 && !paused) {
      if(!video.isPlaying()) video.play();
      video.setTime(int(beginAt * 1000));
    }
  }

  void finalizeEnd(boolean fullStop) {
    video.stop();
    super.finalizeEnd(fullStop);
  }

  void load() {
    super.load();
    pVolume = volume;
    pPreamp = video.preamp();
    pAmps = video.amps();
    labelPath.setText("Path");
    textPath.setText(path);
    cboxCentered.setSelected(centered);
    cboxAspectRatio.setSelected(aspectRatio);
    cboxEqualizer.setSelected(equalizer);
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
    sliderVolume.setValue(volume);
    textBegin.setText(timeToString(beginAt));
    textEnd.setText(timeToString(endAt));
    String[] t = {"Dissolve", "Zoom", "Slide Left", "Slide Right", "Slide Up", "Slide Down"};
    dListBeginTransition.setItems(t, 0);
    dListEndTransition.setItems(t, 0);
    dListBeginTransition.setSelected(beginTransitionType);
    dListEndTransition.setSelected(endTransitionType);
    cboxClickable.setSelected(clickable);

    StringList targets;
    targets = new StringList();
    targets.append(" ");
    for(Node no: nodes) if(no.targetable) targets.append(no.label);
    targets.sort();
    dListTarget.setItems(targets.toArray(), 0);
    for(int n = 0; n < targets.size(); n++) if(targets.get(n).equals(target)) dListTarget.setSelected(n);

    labelPath.setVisible(true);
    textPath.setVisible(true);
    labelLabel.moveTo(8, 48);
    textLabel.moveTo(48, 48);
    labelX.setVisible(true);
    labelX.moveTo(8, 72);
    textX.setVisible(true);
    textX.moveTo(48, 72);
    cboxX.setVisible(true);
    cboxX.moveTo(88, 72);
    labelY.setVisible(true);
    labelY.moveTo(8, 96);
    textY.setVisible(true);
    textY.moveTo(48, 96);
    cboxY.setVisible(true);
    cboxY.moveTo(88, 96);
    labelW.setVisible(true);
    labelW.moveTo(128, 72);
    textW.setVisible(true);
    textW.moveTo(168, 72);
    cboxW.setVisible(true);
    cboxW.moveTo(208, 72);
    labelH.setVisible(true);
    labelH.moveTo(128, 96);
    textH.setVisible(true);
    textH.moveTo(168, 96);
    cboxH.setVisible(true);
    cboxH.moveTo(208, 96);
    cboxCentered.setVisible(true);
    cboxCentered.moveTo(8, 120);
    cboxAspectRatio.setVisible(true);
    cboxAspectRatio.moveTo(128, 120);
    buttonBegin.setVisible(true);
    buttonBegin.moveTo(8, 144);
    textBegin.setVisible(true);
    textBegin.moveTo(72, 144);
    buttonEnd.setVisible(true);
    buttonEnd.moveTo(128, 144);
    textEnd.setVisible(true);
    textEnd.moveTo(192, 144);
    labelDuration.moveTo(8, 168);
    textDuration.setEnabled(false);
    textDuration.moveTo(72, 168);
    cboxLoop.setVisible(true);
    cboxLoop.moveTo(128, 168);
    labelVolume.setVisible(true);
    labelVolume.moveTo(8, 192);
    sliderVolume.setVisible(true);
    sliderVolume.moveTo(72, 192);
    buttonColor.setVisible(false);
    viewColor.setVisible(false);
    cboxBeginPaused.moveTo(248, 48);
    cboxEndPaused.moveTo(368, 48);
    cboxBeginTransition.setVisible(true);
    cboxBeginTransition.moveTo(248, 72);
    cboxEndTransition.setVisible(true);
    cboxEndTransition.moveTo(368, 72);
    labelBeginTransition.setVisible(true);
    labelBeginTransition.moveTo(248, 96);
    textBeginTransition.setVisible(true);
    textBeginTransition.moveTo(312, 96);
    labelEndTransition.setVisible(true);
    labelEndTransition.moveTo(368, 96);
    textEndTransition.setVisible(true);
    textEndTransition.moveTo(432, 96);
    dListBeginTransition.setVisible(true);
    dListBeginTransition.moveTo(248, 120);
    dListEndTransition.setVisible(true);
    dListEndTransition.moveTo(368, 120);
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
    cboxEqualizer.moveTo(8, 216);
    cboxEqualizer.setVisible(true);
    String[] presets = {"None"};
    presets = concat(presets, video.presets());
    dListPresets.setItems(presets, 0);
    dListPresets.setSelected(preset + 1);
    sliderEq0.setValue(-video.amp(0));
    sliderEq1.setValue(-video.amp(1));
    sliderEq2.setValue(-video.amp(2));
    sliderEq3.setValue(-video.amp(3));
    sliderEq4.setValue(-video.amp(4));
    sliderEq5.setValue(-video.amp(5));
    sliderEq6.setValue(-video.amp(6));
    sliderEq7.setValue(-video.amp(7));
    sliderEq8.setValue(-video.amp(8));
    sliderEq9.setValue(-video.amp(9));
    sliderPreamp.setValue(video.preamp());
    equalizerPanel.moveTo(controlPanel.getX() + controlPanel.getWidth(), controlPanel.getY());
    if(equalizer) equalizerPanel.setVisible(true);
    cboxClickable.setVisible(true);
    dListTarget.setVisible(true);
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
    if(nW < 0) nW = 0;
    if(nH < 0) nH = 0;
    perX = cboxX.isSelected();
    perY = cboxY.isSelected();
    perW = cboxW.isSelected();
    perH = cboxH.isSelected();
    if(isTime(textBegin.getText())) beginAt = stringToTime(textBegin.getText());
    if(isTime(textEnd.getText())) endAt = stringToTime(textEnd.getText());
    beginTransitionType = dListBeginTransition.getSelectedIndex();
    endTransitionType = dListEndTransition.getSelectedIndex();
    if(beginAt < 0 || beginAt >= duration) beginAt = 0;
    if(endAt <= 0 || endAt > duration || endAt <= beginAt) endAt = duration;
    equalizer = cboxEqualizer.isSelected();
    preset = dListPresets.getSelectedIndex() - 1;
    clickable = cboxClickable.isSelected();
    if(clickable) target = dListTarget.getSelectedText(); else target = "";
  }

  void cancel() {
    volume = pVolume;
    video.setPreamp(pPreamp);
    video.setAmps(pAmps);
  }

  void clear() {
    super.clear();
    video.stop();
    //video.dispose(); //Crashes App
    video = null;
  }

  boolean isOver() {
    return clickable & mouseX > pX & mouseX < pX + pW & mouseY > pY & mouseY < pY + pH;
  }

  void jump() {
    end(true);
    for(Node no: nodes) if(no.targetable & no.label.equals(target)) {
      if(no.playing) no.end(true);
      no.turn();
    }
  }

  boolean isClickable() {
    return clickable;
  }

  int getTarget() {
    for(Node no: nodes) if(no.targetable & no.label.equals(target)) return no.index;
    return -1;
  }
}
