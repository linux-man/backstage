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
  float volume, beginAt, endAt;
  
  boolean loading;
  VLCJVideo audio;

  Audio(Audio no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, nodes.size(), no.x + 1, no.y, new int[0],
    no.path, no.loop, no.beginTransition, no.endTransition,
    no.beginTransitionDuration, no.endTransitionDuration, no.volume, no.beginAt, no.endAt);
  }

  Audio(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, int index, int x, int y, int[] next,
  String path,
  boolean loop, boolean beginTransition, boolean endTransition,
  float beginTransitionDuration, float endTransitionDuration, float volume, float beginAt, float endAt) {
    super("Audio", label, notes, duration, beginPaused, endPaused, independent, index, x, y, next, iconAudio);
    this.path = normalizePath(path);
    this.loop = loop; this.beginTransition = beginTransition; this.endTransition = endTransition;
    this.beginTransitionDuration = beginTransitionDuration; this.endTransitionDuration = endTransitionDuration; this.volume = volume; this.beginAt = beginAt; this.endAt = endAt;

    audio = new VLCJVideo(main);

    audio.bind(VLCJVideo.MediaPlayerEventType.LENGTH_CHANGED, new ARunnable(this) { public void run() {
      if(parent.loading) {
        parent.audio.setVolume(0);
        parent.loading = false;
        parent.duration = audio.duration() / 1000.0;
        if(parent.duration <= 0) throw new IllegalArgumentException("This is not an Audio!");
        if(parent.beginAt < 0 || parent.beginAt >= parent.duration) parent.beginAt = 0;
        if(parent.endAt <= 0 || parent.endAt > parent.duration || parent.endAt <= parent.beginAt) parent.endAt = parent.duration;
        parent.audio.stop();
      }
    }});

    loading = true;
    audio.openAndPlay(projectPath.getParent().resolve(Paths.get(this.path)).normalize().toString());
  }

  void turn() {
    if(!playing) {
      initializeTurn();
      endTime = int((endAt - beginAt) * 1000);
      audio.play();

      if(beginTransition) audio.setVolume(0);
      else audio.setVolume(int(volume * 100));
      audio.setTime(int(beginAt * 1000));
      finalizeTurn();
    }
    else paused = !paused;

    if(paused) audio.pause();
    else audio.play();
  }

  void play() {
    if(!playing) return;

    if(isBeginTransition()) audio.setVolume(int(volume * presentTime / beginTransitionDuration / 10));
    else if(isEndTransition()) audio.setVolume(int(volume * (endTime - presentTime) / endTransitionDuration / 10));
    else audio.setVolume(int(volume * 100));

    if(paused && audio.isPlaying()) audio.pause();
    
    finalizePlay();
    if(loop && presentTime == 0 && !paused) {
      if(!audio.isPlaying()) audio.play();
      audio.setTime(int(beginAt * 1000));
    }
  }

  void finalizeEnd(boolean fullStop) {
    audio.stop();
    super.finalizeEnd(fullStop);
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
    textLabel.moveTo(48, 48);
    labelX.setVisible(false);
    textX.setVisible(false);
    cboxX.setVisible(false);
    labelY.setVisible(false);
    textY.setVisible(false);
    cboxY.setVisible(false);
    labelW.setVisible(false);
    textW.setVisible(false);
    cboxW.setVisible(false);
    labelH.setVisible(false);
    textH.setVisible(false);
    cboxH.setVisible(false);
    cboxCentered.setVisible(false);
    cboxAspectRatio.setVisible(false);
    buttonBegin.setVisible(true);
    buttonBegin.moveTo(8, 72);
    textBegin.setVisible(true);
    textBegin.moveTo(72, 72);
    buttonEnd.setVisible(true);
    buttonEnd.moveTo(128, 72);
    textEnd.setVisible(true);
    textEnd.moveTo(192, 72);
    labelDuration.moveTo(8, 96);
    textDuration.setEnabled(false);
    textDuration.moveTo(72, 96);
    cboxLoop.setVisible(true);
    cboxLoop.moveTo(128, 96);
    labelVolume.setVisible(true);
    labelVolume.moveTo(8, 120);
    sliderVolume.setVisible(true);
    sliderVolume.moveTo(72, 120);
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
    labelNotes.moveTo(248, 144);
    notesArea.moveTo(248, 160);
    tm.addControls(textPath, textLabel, textBegin, textEnd, textBeginTransition, textEndTransition, notesArea);
  }
  
  void save() {
    super.save();
    path = trim(textPath.getText());
    volume = sliderVolume.getValueF();
    if(isTime(textBegin.getText())) beginAt = stringToTime(textBegin.getText());
    if(isTime(textEnd.getText())) endAt = stringToTime(textEnd.getText());
    if(beginAt < 0 || beginAt >= duration) beginAt = 0;
    if(endAt <= 0 || endAt > duration || endAt <= beginAt) endAt = duration;
  }

  void clear() {
    super.clear();
    audio.stop();
    //audio.dispose(); //Crashes App
    audio = null;
  }
}
