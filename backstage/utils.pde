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
//OPENGL
//*
import com.jogamp.newt.opengl.GLWindow;
import com.jogamp.newt.Screen;
import com.jogamp.newt.MonitorDevice;

int getPrimaryWidth() {
  return Screen.getAllScreens().iterator().next().getPrimaryMonitor().getCurrentMode().getSurfaceSize().getResolution().getWidth();
}

int getPrimaryHeight() {
  return Screen.getAllScreens().iterator().next().getPrimaryMonitor().getCurrentMode().getSurfaceSize().getResolution().getHeight();
}

MonitorDevice secondaryDevice() {
  try {
    if(Screen.getAllScreens().iterator().next().getMonitorDevices().size() > 1)
      for(MonitorDevice m: Screen.getAllScreens().iterator().next().getMonitorDevices()) if(!m.isPrimary()) return m;
    return Screen.getAllScreens().iterator().next().getPrimaryMonitor();
  } catch (Exception e) {
      System.err.println("Get monitor devices error");
      return null;
  }
}

void switchFullScreen() {
  if(((GLWindow) surface.getNative()).isFullscreen()) {
    ((GLWindow) surface.getNative()).setFullscreen(false);
    surface.setSize(640, 480);
    surface.setLocation(screenWidth - 640, screenHeight - 480);
    buttonShow.setIcon("eye.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
  else  {
    MonitorDevice d = secondaryDevice();
    ArrayList<MonitorDevice> list = new ArrayList<MonitorDevice>();
    list.add(d);
    ((GLWindow) surface.getNative()).setFullscreen(list);
    ((GLWindow) surface.getNative()).setFullscreen(true);
    buttonShow.setIcon("eye_slash.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
}
//*/

//JAVA2D
/*
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;

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

void switchFullScreen() {
  if(((SmoothCanvas) (surface).getNative()).getFrame().getState() == 0) {
    ((SmoothCanvas) (surface).getNative()).getFrame().setState(1);
    buttonShow.setIcon("eye.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
  else {
    ((SmoothCanvas) (surface).getNative()).getFrame().setState(0);
    buttonShow.setIcon("eye_slash.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
  cp.getSurface().setAlwaysOnTop(((SmoothCanvas) (surface).getNative()).getFrame().getState() == 0 && screens().length == 1);
}
//*/

boolean isDim(String s) {
  return !(Float.isNaN(float(s)));
}

String dimToString(float n) {
  return str(int(n));
}

float stringToDim(String s) {
  return float(s);
}

boolean isTime(String s) {
  if(Float.isNaN(float(s))) return false;
  if(float(s) < 0) return false;
  return true;
}

String timeToString(float n) {
  return str(int(n * 100) / 100.0);
}

float stringToTime(String s) {
  return float(s);
}

boolean overButton(GButton b, int x, int y) {
  return x > b.getX() && x < b.getX() + b.getWidth() && y > b.getY() && y < b.getY() + b.getHeight();
}

void changeScheme(int c) {
  if(c > 12) c = 8;
  if(c < 8) c = 12;
  colorScheme = c;
  G4P.setGlobalColorScheme(colorScheme);
  backgroundColor = 0;
  //if(colorScheme < 10) backgroundColor = 0;
  //else backgroundColor = 255;
  switch(colorScheme) {
    case 8:
      borderColor = #ef3939;
      normalColor = #ef6b6b;
      overColor = #f7abab;
      selectedColor = #ff0000;
      break;
    case 9:
      borderColor = #ffce40;
      normalColor = #ffdb73;
      overColor = #ffe7a7;
      selectedColor = #ffbe00;
      break;
    case 10:
      borderColor = #399cc6;
      normalColor = #5aa5c6;
      overColor = #dbebf3;
      selectedColor = #13bfff;
      break;
    case 11:
      borderColor = #39d639;
      normalColor = #63d663;
      overColor = #d5f5d5;
      selectedColor = #00ff00;
      break;
    case 12:
      borderColor = #ef9439;
      normalColor = #efad6b;
      overColor = #fae1c8;
      selectedColor = #ff780b;
      break;
  }
  cp.redraw();
}

void tracksChange(int n) {
  if(playing) return;
  int oldTracks = tracks;
  tracks = min(max(n, 4), 8);
  int dif = tracks - oldTracks;;
  stage = new Node[tracks];
  for(Node no: nodes) {
    no.y += dif * trackHeight;
    no.track = max(0, min(tracks - 1, tracks - round(float(no.y) / trackHeight)));
  }
  cp.frame.setSize(cp.width, trackHeight * (tracks + 2) + 8);
  buttonNodePlay.moveTo(buttonNodePlay.getX(), cp.height - buttonNodePlay.getHeight());
  buttonNodeStop.moveTo(buttonNodeStop.getX(), cp.height - buttonNodeStop.getHeight());
  buttonNodeNext.moveTo(buttonNodeNext.getX(), cp.height - buttonNodeNext.getHeight());
  buttonNodeSlider.moveTo(buttonNodeSlider.getX(), cp.height - buttonNodeSlider.getHeight());
}

void resizeCp() {
  buttonResize.moveTo(cp.width - buttonResize.getWidth(), 0);
  buttonTracksPlus.moveTo(cp.width - buttonResize.getWidth() * 2, 0);
  buttonTracksMinus.moveTo(cp.width - buttonResize.getWidth() * 3, 0);
}

String normalizePath(String path) {
  File file = new File(path);
  if(!file.isAbsolute()) {
    file = new File(projectPath.getParent().resolve(Paths.get(path)).normalize().toString());
    if(file.isFile()) path = projectPath.getParent().resolve(Paths.get(path)).normalize().toString();
    else path = prevProjectPath.getParent().resolve(Paths.get(path)).normalize().toString();
  }
  path = projectPath.getParent().relativize(Paths.get(path)).normalize().toString();
  return path;
}

public class VRunnable implements Runnable {
  public Video parent;
  public VRunnable(Video parent) {
    this.parent = parent;
  }

  @Override
  public void run() {    
  }
}

public class ARunnable implements Runnable {
  public Audio parent;
  public ARunnable(Audio parent) {
    this.parent = parent;
  }

  @Override
  public void run() {    
  }
}
