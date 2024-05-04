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
class Exec extends Node {
  String command;
  //boolean wasFullScreen = false;
  Process process;

  Exec(Exec no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, nodes.size(), no.x + 1, no.y, no.highlight, new int[0],
    no.command);
  }

  Exec() {
    this("", "", defaultDuration, false, false, false, nodes.size(), -translation, trackHeight, 0, new int[0], "");
  }

  Exec(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, int index, int x, int y, int highlight, int[] next,
  String command) {
    super("Exec", label, notes, duration, beginPaused, endPaused, independent, index, x, y, highlight, next, iconExec);
    this.command = command;
  }

  void initializeTurn() {
    super.initializeTurn();
    String[] params = command.split("\\s+(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);
    for(int n = 0; n < params.length; n++) params[n] = params[n].replaceAll("^\"|\"$", "");

    //wasFullScreen = isFullScreen();
    //surface.setVisible(false);//More testing
    //if(wasFullScreen) switchFullScreen(false);

    try {
      execute(params);
    }
    catch(IOException e) {
      println(e.toString());
    }
  }

  void finalizeEnd(boolean fullStop) {
    super.finalizeEnd(fullStop);
    try {
      process.destroy();
    }
    catch(Exception e) {
      println(e.toString());
    }
    //if(wasFullScreen) switchFullScreen(true);//More testing
    //surface.setVisible(true);
  }

  void load() {
    super.load();
    labelPath.setText("Exec");
    textPath.setText(command);
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
    buttonBegin.setVisible(false);
    textBegin.setVisible(false);
    buttonEnd.setVisible(false);
    textEnd.setVisible(false);
    labelDuration.moveTo(8, 72);
    textDuration.setEnabled(true);
    textDuration.moveTo(72, 72);
    cboxLoop.setVisible(false);
    labelVolume.setVisible(false);
    sliderVolume.setVisible(false);
    buttonColor.setVisible(false);
    viewColor.setVisible(false);
    cboxBeginPaused.moveTo(248, 48);
    cboxEndPaused.moveTo(368, 48);
    cboxBeginTransition.setVisible(false);
    cboxEndTransition.setVisible(false);
    labelBeginTransition.setVisible(false);
    textBeginTransition.setVisible(false);
    labelEndTransition.setVisible(false);
    textEndTransition.setVisible(false);
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
    cboxEqualizer.setVisible(false);
    tm.addControls(textLabel, textDuration, notesArea);
  }

  void save() {
    super.save();
    command = trim(textPath.getText());
  }

  void execute(String[] params) throws IOException {
    ProcessBuilder builder = new ProcessBuilder(params);
    process = builder.start();
  }
}
