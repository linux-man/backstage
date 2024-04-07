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
//JAVAFX
/*<------------------------------------------------------------
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import processing.javafx.*;

void initSettings() {
  fullScreen(FX2D, 2);
}

GraphicsDevice[] screens() {
  GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment();
  return env.getScreenDevices();
}

int getPrimaryWidth() {
  return screens()[0].getDisplayMode().getWidth();
}

int getPrimaryHeight() {
  return screens()[0].getDisplayMode().getHeight();
}
boolean isFullScreen() {
  return (width != 640);  
}

void switchFullScreen(boolean full) {
  if(full && !isFullScreen()) {
    surface.setLocation(0, 0);
    surface.setSize(displayWidth, displayHeight);
    buttonShow.setIcon("eye_slash.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
  else if (!full && isFullScreen()){
    surface.setSize(640, 480);
    surface.setLocation(getPrimaryWidth() - 640, getPrimaryHeight() - 480);
    buttonShow.setIcon("eye.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
}

void switchFullScreen() {
  if(isFullScreen()) switchFullScreen(false);
  else switchFullScreen(true);
}

void initializeDrop() {}
//*/
