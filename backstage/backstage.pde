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
import VLCJVideo.*;
import g4p_controls.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.prefs.Preferences;
import java.util.Arrays;
import processing.awt.PSurfaceAWT.SmoothCanvas;

boolean GL = false;
boolean dragging, draggingWindow, draggingSlider, playing, paused;
int screenWidth, screenHeight, colorScheme, trackHeight, translation, tracks, version;
color backgroundColor, normalColor, overColor, selectedColor, borderColor;
float defaultDuration;
boolean hideCursor = false;
ArrayList<Node> nodes;
Node[] stage;
PImage iconImage, iconVideo, iconAudio, iconText, iconRect, iconLink, iconRandom, iconGallery, iconExec;
Path projectPath, prevProjectPath;
Preferences prefs;
GTabManager tm;
PApplet main = this;

color schemes[][] = {{#ef3939, #ef6b6b, #f7abab, #ff0000},
                     {#ffce40, #ffdb73, #ffe7a7, #ffbe00},
                     {#399cc6, #5aa5c6, #dbebf3, #13bfff},
                     {#39d639, #63d663, #d5f5d5, #00ff00},
                     {#ef9439, #efad6b, #fae1c8, #ff780b}};

void settings() {
  initSettings();
}

void setup() {
  prefs = Preferences.userRoot().node(this.getClass().getName());
  frameRate(60);
  version = 4;
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
  iconRandom = loadImage("random_w.png");
  iconGallery = loadImage("gallery_w.png");
  iconExec = loadImage("exec_w.png");
  nodes = new ArrayList<Node>();
  stage = new Node[tracks];
  createGUI();
  initializeCp();
  initializeDrop();

  if (args != null) {
    ((JFrame) ((SmoothCanvas) cp.getSurface().getNative()).getFrame()).toBack();
    surface.setAlwaysOnTop(true);
    thread("loadArgs");    
  }
}

void loadArgs() {
  loadProject(new File(args[0]));
  hideCursor();
  end(true);
  turn();  
}

void draw() {
  background(0);
  if(playing) for(Node no: stage) if(no != null) no.play();
}

void mouseClicked() {
  if(playing) for(Node no: stage) if(no != null) {
    if(no.isOver()) no.jump();
  }
}

void turn() {
  if(!playing) {for(Node no: nodes) if(no.selected && !no.independent) no.turn();}
  else {for(Node no: stage) if(no != null && !no.independent && !(paused  ^ no.paused)) no.turn();}
}

void end(boolean fullStop) {
  for(Node no: stage) if(no != null) no.end(fullStop);
  for(Node no: nodes) if(no != null) no.end(fullStop);//To stop nodes that play on load
}

void next() {
  for(Node no: stage) if(no != null && !no.independent) no.next();
}

void keyPressed() {
  key = keyCode == ESC ? 0 : key;
}

void hideCursor() {
  if(hideCursor) {
    noCursor();
    buttonCursor.setIcon("cursor.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
  else {
    cursor(ARROW);
    buttonCursor.setIcon("nocursor.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  }
}
