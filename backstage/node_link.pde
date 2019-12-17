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
class Link extends Node {

  Link(Link no) {
    this(no.label, no.notes, no.duration, no.beginPaused, no.endPaused, no.independent, nodes.size(), no.x + 1, no.y, new int[0]);
  }

  Link() {
    this("", "", 0, false, false, false, nodes.size(), -translation, trackHeight, new int[0]);
  }

  Link(String label, String notes, float duration, boolean beginPaused, boolean endPaused, boolean independent, int index, int x, int y, int[] next) {
    super("Link", label, notes, duration, beginPaused, endPaused, independent, index, x, y, next, iconLink);
  }
  
  void load() {
    super.load();
    labelPath.setVisible(false);
    textPath.setVisible(false);
    labelLabel.moveTo(8, 24);
    textLabel.moveTo(48, 24);
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
    labelDuration.moveTo(8, 48);
    textDuration.setEnabled(true);
    textDuration.moveTo(72, 48);
    cboxLoop.setVisible(false);
    labelVolume.setVisible(false);
    sliderVolume.setVisible(false);
    buttonColor.setVisible(false);
    viewColor.setVisible(false);
    cboxBeginPaused.moveTo(248, 24);
    cboxEndPaused.moveTo(368, 24);
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
    tm.addControls(textLabel, textDuration, notesArea);
  }
}
