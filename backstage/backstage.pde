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
import processing.video.*;
import ddf.minim.*;
import g4p_controls.*;
import drop.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.prefs.Preferences;

Minim minim;
boolean dragging, draggingWindow, draggingSlider, playing, paused;
int screenWidth, screenHeight, colorScheme, trackHeight, translation, tracks, version;
color backgroundColor, normalColor, overColor, selectedColor, borderColor;
float defaultDuration;
ArrayList<Node> nodes;
Node[] stage;
PGraphics sketchPg;
PImage iconImage, iconVideo, iconAudio, iconText, iconRect, iconLink;
Path projectPath, prevProjectPath;
Preferences prefs;
GTabManager tm;
PApplet main = this;

void settings() {
//OPENGL
//*
  size(640, 480, P2D);
  //PJOGL.setIcon("stage.png");
//*/
//JAVA2D
/*
  fullScreen(2);
//*/
}

void setup() {
  prefs = Preferences.userRoot().node(this.getClass().getName());
  frameRate(30);
  version = 1;
  defaultDuration = 5;
  tracks = 4;
  trackHeight = 48;
  translation = 0;
  screenWidth = getPrimaryWidth();
  screenHeight = getPrimaryHeight();
  projectPath = Paths.get(System.getProperty("user.home")).resolve("presentation.stage");
  prevProjectPath = projectPath;
  iconImage = loadImage("picture_w.png");
  iconVideo = loadImage("media_w.png");
  iconAudio = loadImage("audio_w.png");
  iconLink = loadImage("link_w.png");
  iconText = loadImage("text_w.png");
  iconRect = loadImage("rect_w.png");
  minim = new Minim(this);
  nodes = new ArrayList<Node>();
  stage = new Node[tracks];
  createGUI();
  initializeCp();
  initializeDrop();
  if(args != null) loadProject(new File(args[0]));
//OPENGL
//*
  surface.setLocation(screenWidth - 640, screenHeight - 480);
//*/
//JAVA2D
/*
  switchFullScreen();
//*/
}

void draw() {
  background(0);
  if(playing) for(Node no: stage) if(no != null) no.play();
}

void turn() {
  if(!playing) {for(Node no: nodes) if(no.selected && !no.independent) no.turn();}
  else {for(Node no: stage) if(no != null && !no.independent && !(paused  ^ no.paused)) no.turn();}
}

void end(boolean fullStop) {
  for(Node no: stage) if(no != null && !no.independent) no.end(fullStop);
}

void next() {
  for(Node no: stage) if(no != null && !no.independent) no.next();
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed(){
  key = keyCode == ESC ? 0 : key;
}