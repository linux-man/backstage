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
import javax.swing.*;
import javax.swing.filechooser.*;

import javax.swing.JColorChooser;
import javax.swing.colorchooser.AbstractColorChooserPanel;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Color;


File openDialog(String title) {
  FileNameExtensionFilter f;
  JFileChooser chooser = new JFileChooser();
  if(title == "Load project") {
    f = new FileNameExtensionFilter("Backstage files", "stage");
    chooser.addChoosableFileFilter(f);
  }
  else {
    f = new FileNameExtensionFilter("Media files", "jpg", "jpeg", "png", "gif", "bmp", "avi", "mp4", "m4v", "mov", "ogg", "ogv", "mkv", "wav", "mp3", "au", "aiff");
    chooser.addChoosableFileFilter(f);
    chooser.addChoosableFileFilter(new FileNameExtensionFilter("Image Files", "jpg", "jpeg", "png", "gif", "bmp"));
    chooser.addChoosableFileFilter(new FileNameExtensionFilter("Video Files", "avi", "mp4", "m4v", "mov", "ogg", "ogv", "mkv"));
    chooser.addChoosableFileFilter(new FileNameExtensionFilter("Audio Files","wav", "mp3", "au", "aiff"));
  }
  chooser.setFileFilter(f);
  chooser.setDialogTitle(title);
  int returnVal = chooser.showOpenDialog((SmoothCanvas) cp.getSurface().getNative());
  if (returnVal == JFileChooser.APPROVE_OPTION) return chooser.getSelectedFile();
  return null;
}

File saveDialog(String type) {
  JFileChooser chooser = new JFileChooser();
  FileNameExtensionFilter f;
  if(type == "zip") {
    f = new FileNameExtensionFilter("Zip files", "zip");
    chooser.setDialogTitle("Compress Project");
  }
  else {
    f = new FileNameExtensionFilter("Backstage files", "stage");
    chooser.setDialogTitle("Save project");
    chooser.setSelectedFile(new File(projectPath.toString()));
  }
  chooser.addChoosableFileFilter(f);
  chooser.setFileFilter(f);
  int returnVal = chooser.showSaveDialog((SmoothCanvas) cp.getSurface().getNative());
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    return chooser.getSelectedFile();
  }
  return null;
}

Color result;

color colorChooser(color c) {
  result = new Color(int(red(c)), int(green(c)), int(blue(c)), int(alpha(c)));
  final JColorChooser CC = new JColorChooser();
  CC.setColor(result);
  CC.setPreviewPanel(new JPanel());
  AbstractColorChooserPanel[] panels = CC.getChooserPanels();
  for (AbstractColorChooserPanel accp : panels) {
    if(!(accp.getDisplayName().equals("RGB") || accp.getDisplayName().equals("Swatches") || accp.getDisplayName().equals("HSL"))) {
      CC.removeChooserPanel(accp);
    }
  }
  JDialog dialog = JColorChooser.createDialog((SmoothCanvas) cp.getSurface().getNative(), "Select color", true, CC,
  new ActionListener() {
    public void actionPerformed(ActionEvent e) {
      result = CC.getColor();
    }
  },
  null);
  dialog.setVisible(true);
  return color(result.getRed(), result.getGreen(), result.getBlue(), result.getAlpha());
}
