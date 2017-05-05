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
class Audio extends Node {
  String path;
  float beginTransitionDuration, endTransitionDuration, volume, beginAt, endAt;
  AudioPlayer audio;
  
  Audio(String label, String notes, float duration, boolean beginPaused, boolean endPaused, int index, int x, int y, int[] next,
  String path,
  boolean loop, boolean beginTransition, boolean endTransition,
  float beginTransitionDuration, float endTransitionDuration, float volume, float beginAt, float endAt) {
    super("Audio", label, notes, duration, beginPaused, endPaused, index, x, y, next, iconAudio);
    this.path = normalizePath(path);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration; this.volume = volume; this.beginAt = beginAt; this.endAt = endAt;

    audio = minim.loadFile(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString(), 1024);
    this.duration = audio.length() / 10 / 100.0;
    if(this.beginAt < 0 || this.beginAt >= this.duration) this.beginAt = 0;
    if(this.endAt <= 0 || this.endAt > this.duration || this.endAt <= this.beginAt) this.endAt = this.duration;
  }
  
  void turn() {
    if(!playing) {
      initializeTurn();
      endTime = int((endAt - beginAt) * 1000);
      duration = audio.length() / 10 / 100.0;
      if(beginAt < 0 || beginAt >= duration) beginAt = 0;
      if(endAt <= 0 || endAt > duration || endAt <= beginAt) endAt = duration;
      if(beginTransition) audio.setGain(-144);
      else audio.setGain(volumeToDecibel(volume));
      audio.cue(int(beginAt * 1000));
      finalizeTurn();
    }
    else paused = !paused;

    if(paused) audio.pause();
    else audio.play();
  }
  
  void play() {
    if(!playing) return;

    if(beginTransition && beginTransitionDuration > 0 && presentTime < beginTransitionDuration * 1000) audio.setGain(volumeToDecibel(volume * presentTime / beginTransitionDuration / 1000));
    else if(endTransition && endTransitionDuration > 0 && presentTime > endTime - endTransitionDuration * 1000) audio.setGain(volumeToDecibel(volume * (endTime - presentTime) / endTransitionDuration / 1000));
    else audio.setGain(volumeToDecibel(volume));

    finalizePlay();
    if(presentTime == 0 && loop) audio.cue(int(beginAt * 1000));
  }

  void end(boolean fullStop) {
    if(endPaused && !onEndPause) gotoEndPause();
    else {
      audio.setGain(-144);//Sometimes audio just keep playing! (when you drag slider/click at the end)
      audio.cue(int(beginAt * 1000));
      audio.pause();
      finalizeEnd(fullStop);
    }
  }
  
  void load() {
    super.load();
    textPath.setText(path);
    textBeginTransition.setText(timeToString(beginTransitionDuration));
    textEndTransition.setText(timeToString(endTransitionDuration));
    sliderVolume.setValue(volume);
    textBegin.setText(timeToString(beginAt));
    textEnd.setText(timeToString(endAt));

    labelPath.setVisible(true);
    textPath.setVisible(true);
    labelLabel.moveTo(8, 48);
    textLabel.moveTo(64, 48);
    labelX.setVisible(false);
    textX.setVisible(false);
    labelY.setVisible(false);
    textY.setVisible(false);
    labelW.setVisible(false);
    textW.setVisible(false);
    labelH.setVisible(false);
    textH.setVisible(false);
    cboxCentered.setVisible(false);
    cboxAspectRatio.setVisible(false);
    buttonBegin.setVisible(true);
    buttonBegin.moveTo(8, 72);
    textBegin.setVisible(true);
    textBegin.moveTo(64, 72);
    buttonEnd.setVisible(true);
    buttonEnd.moveTo(120, 72);
    textEnd.setVisible(true);
    textEnd.moveTo(176, 72);
    labelDuration.moveTo(8, 96);
    textDuration.setEnabled(false);
    textDuration.moveTo(64, 96);
    cboxLoop.setVisible(true);
    cboxLoop.moveTo(120, 96);
    labelVolume.setVisible(true);
    labelVolume.moveTo(8, 120);
    sliderVolume.setVisible(true);
    sliderVolume.moveTo(64, 120);
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
    dListBeginTransition.setVisible(false);
    dListEndTransition.setVisible(false);
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
    tm.addControls(textPath, textLabel, textBegin, textEnd, textBeginTransition, textEndTransition, notesArea);
  }
  
  void save() {
    super.save();
    path = trim(textPath.getText());
    if(isTime(textBeginTransition.getText())) beginTransitionDuration = stringToTime(textBeginTransition.getText());
    if(isTime(textEndTransition.getText())) endTransitionDuration = stringToTime(textEndTransition.getText());
    volume = sliderVolume.getValueF();
    if(isTime(textBegin.getText())) beginAt = stringToTime(textBegin.getText());
    if(isTime(textEnd.getText())) endAt = stringToTime(textEnd.getText());
    if(beginAt < 0 || beginAt >= duration) beginAt = 0;
    if(endAt <= 0 || endAt > duration || endAt <= beginAt) endAt = duration;
  }
}