/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void buttonAddMedia_click(GButton source, GEvent event) { //_CODE_:buttonAddMedia:213148:
  buttonAdd_click(source, event);
  insertMedia(openDialog("Insert media"));
} //_CODE_:buttonAddMedia:213148:

public void buttonShow_click(GButton source, GEvent event) { //_CODE_:buttonShow:277424:
  if(playing) return;
  switchFullScreen();
} //_CODE_:buttonShow:277424:

public void controlPanel_Event(GPanel source, GEvent event) { //_CODE_:controlPanel:541621:
  if(event == GEvent.DRAGGED) {
    controlPanel.setDragArea();
    equalizerPanel.moveTo(controlPanel.getX() + controlPanel.getWidth(), controlPanel.getY());
  }
} //_CODE_:controlPanel:541621:

public void buttonOK_click(GButton source, GEvent event) { //_CODE_:buttonOK:584874:
  Node last = nodes.get(nodes.size() - 1);
  last.save();
  controlPanel.setVisible(false);
  equalizerPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonOK:584874:

public void buttonCancel_click(GButton source, GEvent event) { //_CODE_:buttonCancel:892661:
  Node last = nodes.get(nodes.size() - 1);
  last.cancel();
  controlPanel.setVisible(false);
  equalizerPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonCancel:892661:

public void buttonColor_click(GButton source, GEvent event) { //_CODE_:buttonColor:830083:
  //color c = colorChooser(sketchPg.backgroundColor);
  PGraphics v = viewColor.getGraphics();
  color c = colorChooser(v.backgroundColor);
  v.beginDraw();
  v.background(c);
  v.endDraw();
} //_CODE_:buttonColor:830083:

public void buttonBegin_click(GButton source, GEvent event) { //_CODE_:buttonBegin:398055:
  Node last = nodes.get(nodes.size() - 1);
  if(last.playing) {
    if(last.type == "Video") textBegin.setText(timeToString(((Video)last).beginAt + ((Video)last).presentTime  / 1000.0));
    else textBegin.setText(timeToString(((Audio)last).beginAt + ((Audio)last).presentTime  / 1000.0));
  }
} //_CODE_:buttonBegin:398055:

public void buttonEnd_click(GButton source, GEvent event) { //_CODE_:buttonEnd:207091:
  Node last = nodes.get(nodes.size() - 1);
  if(last.playing) {
    if(last.type == "Video") textEnd.setText(timeToString(((Video)last).beginAt + ((Video)last).presentTime  / 1000.0));
    else textEnd.setText(timeToString(((Audio)last).beginAt + ((Audio)last).presentTime  / 1000.0));
  }
} //_CODE_:buttonEnd:207091:

public void cboxEqualizer_click(GCheckbox source, GEvent event) { //_CODE_:cboxEqualizer:211408:
  Node last = nodes.get(nodes.size() - 1);
  if(event == GEvent.SELECTED) {
    dListPresets.setSelected(0);
    if(last.type == "Video") ((Video)last).video.setEqualizer();
    else ((Audio)last).audio.setEqualizer();
  }
  else {
    if(last.type == "Video") ((Video)last).video.noEqualizer();
    else ((Audio)last).audio.noEqualizer();
  }
  equalizerPanel.setVisible(event == GEvent.SELECTED);
} //_CODE_:cboxEqualizer:211408:

public void buttonLoad_click(GButton source, GEvent event) { //_CODE_:buttonLoad:446188:
  buttonFiles_click(source, event);
  end(true);
  loadProject(openDialog("Load project"));
} //_CODE_:buttonLoad:446188:

public void buttonSave_click(GButton source, GEvent event) { //_CODE_:buttonSave:574204:
  buttonFiles_click(source, event);
  saveProject(saveDialog("project"));
} //_CODE_:buttonSave:574204:

public void buttonZip_click(GButton source, GEvent event) { //_CODE_:buttonZip:836748:
  buttonConfig_click(source, event);
  if(!(new File(projectPath.toString()).isFile())) return;
  if(cp.getTitle() == "Control Panel") saveProject(saveDialog("project"));
  saveZip(saveDialog("zip"));
} //_CODE_:buttonZip:836748:

public void buttonFiles_click(GButton source, GEvent event) { //_CODE_:buttonFiles:743300:
  buttonConfig.setVisible(!buttonConfig.isVisible());
  buttonAdd.setVisible(!buttonAdd.isVisible());
  buttonShow.setVisible(!buttonShow.isVisible());
  buttonPlay.setVisible(!buttonPlay.isVisible());
  buttonStop.setVisible(!buttonStop.isVisible());
  buttonNext.setVisible(!buttonNext.isVisible());
  buttonAbout.setVisible(!buttonAbout.isVisible());
  buttonNew.setVisible(!buttonNew.isVisible());
  buttonLoad.setVisible(!buttonLoad.isVisible());
  buttonSave.setVisible(!buttonSave.isVisible());
} //_CODE_:buttonFiles:743300:

public void buttonNew_click(GButton source, GEvent event) { //_CODE_:buttonNew:484621:
  if(G4P.selectOption(cp, "Are you sure?", "New Backstage", G4P.QUERY_MESSAGE, G4P.YES_NO) == G4P.OK) {
    buttonFiles_click(source, event);
    end(true);
    clearNodes();
    projectPath = Paths.get(System.getProperty("user.home")).resolve("presentation.stage");
    prevProjectPath = projectPath;
    cp.setTitle("Control Panel");
  }
} //_CODE_:buttonNew:484621:

public void buttonConfig_click(GButton source, GEvent event) { //_CODE_:buttonConfig:337398:
  buttonFiles.setVisible(!buttonFiles.isVisible());
  buttonAdd.setVisible(!buttonAdd.isVisible());
  buttonShow.setVisible(!buttonShow.isVisible());
  buttonPlay.setVisible(!buttonPlay.isVisible());
  buttonStop.setVisible(!buttonStop.isVisible());
  buttonNext.setVisible(!buttonNext.isVisible());
  buttonAbout.setVisible(!buttonAbout.isVisible());
  buttonZip.setVisible(!buttonZip.isVisible());
  buttonDefaultDuration.setVisible(!buttonDefaultDuration.isVisible());
  buttonScheme.setVisible(!buttonScheme.isVisible());
} //_CODE_:buttonConfig:337398:

public void buttonNodeNext_click(GButton source, GEvent event) { //_CODE_:buttonNodeNext:603192:
  Node last = nodes.get(nodes.size() - 1);
  if(last.selected && last.playing) last.next();
} //_CODE_:buttonNodeNext:603192:

public void buttonStop_click(GButton source, GEvent event) { //_CODE_:buttonStop:792593:
  end(true);
} //_CODE_:buttonStop:792593:

public void buttonPlay_click(GButton source, GEvent event) { //_CODE_:buttonPlay:614685:
  turn();
} //_CODE_:buttonPlay:614685:

public void buttonNodePlay_click(GButton source, GEvent event) { //_CODE_:buttonNodePlay:329279:
  Node last = nodes.get(nodes.size() - 1);
  last.turn();
} //_CODE_:buttonNodePlay:329279:

public void buttonNodeStop_click(GButton source, GEvent event) { //_CODE_:buttonNodeStop:468519:
  Node last = nodes.get(nodes.size() - 1);
  if(last.selected && last.playing) last.end(true);
} //_CODE_:buttonNodeStop:468519:

public void buttonTracksPlus_click(GButton source, GEvent event) { //_CODE_:buttonTracksPlus:572295:
  tracksChange(tracks + 1);
} //_CODE_:buttonTracksPlus:572295:

public void buttonTracksMinus_click(GButton source, GEvent event) { //_CODE_:buttonTracksMinus:874604:
  tracksChange(tracks - 1);
} //_CODE_:buttonTracksMinus:874604:

public void buttonAdd_click(GButton source, GEvent event) { //_CODE_:buttonAdd:542567:
  buttonFiles.setVisible(!buttonFiles.isVisible());
  buttonConfig.setVisible(!buttonConfig.isVisible());
  buttonShow.setVisible(!buttonShow.isVisible());
  buttonPlay.setVisible(!buttonPlay.isVisible());
  buttonStop.setVisible(!buttonStop.isVisible());
  buttonNext.setVisible(!buttonNext.isVisible());
  buttonAbout.setVisible(!buttonAbout.isVisible());
  buttonAddLink.setVisible(!buttonAddLink.isVisible());
  buttonAddText.setVisible(!buttonAddText.isVisible());
  buttonAddRect.setVisible(!buttonAddRect.isVisible());
  buttonAddMedia.setVisible(!buttonAddMedia.isVisible());
  buttonAddGallery.setVisible(!buttonAddGallery.isVisible());
  buttonAddRandom.setVisible(!buttonAddRandom.isVisible());
  buttonAddExec.setVisible(!buttonAddExec.isVisible());
} //_CODE_:buttonAdd:542567:

public void buttonAddLink_click(GButton source, GEvent event) { //_CODE_:buttonAddLink:458440:
  buttonAdd_click(source, event);
  nodes.add(new Link());  
} //_CODE_:buttonAddLink:458440:

public void buttonAddText_click(GButton source, GEvent event) { //_CODE_:buttonAddText:519134:
  buttonAdd_click(source, event);
  nodes.add(new Text());  
} //_CODE_:buttonAddText:519134:

public void buttonAddRect_click(GButton source, GEvent event) { //_CODE_:buttonAddRect:304017:
  buttonAdd_click(source, event);
  nodes.add(new Rect());
} //_CODE_:buttonAddRect:304017:

public void buttonDpCancel_click(GButton source, GEvent event) { //_CODE_:buttonDpCancel:983302:
  durationPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonDpCancel:983302:

public void buttonDpOk_click(GButton source, GEvent event) { //_CODE_:buttonDpOk:455034:
  if(isTime(textDp.getText())) defaultDuration = stringToTime(textDp.getText());
  durationPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonDpOk:455034:

public void buttonDefaultDuration_click(GButton source, GEvent event) { //_CODE_:buttonDefaultDuration:325528:
  buttonConfig_click(source, event);
  textDp.setText(timeToString(defaultDuration));
  buttonsEnabled(false);
  durationPanel.moveTo(144, 32);
  durationPanel.setVisible(true);
} //_CODE_:buttonDefaultDuration:325528:

public void buttonScheme_click(GButton source, GEvent event) { //_CODE_:buttonScheme:974075:
  buttonConfig_click(source, event);
  changeScheme(colorScheme + 1);
} //_CODE_:buttonScheme:974075:

public void buttonAbout_click(GButton source, GEvent event) { //_CODE_:buttonAbout:437878:
  aboutPanel.moveTo(cp.width / 2 - aboutPanel.getWidth() / 2, 48);
  aboutPanel.setVisible(true);
} //_CODE_:buttonAbout:437878:

public void buttonNext_click(GButton source, GEvent event) { //_CODE_:buttonNext:869176:
  next();
} //_CODE_:buttonNext:869176:

public void buttonGithub_click(GButton source, GEvent event) { //_CODE_:buttonGithub:262236:
  aboutPanel.setVisible(false);
  link("https://github.com/linux-man/backstage");
} //_CODE_:buttonGithub:262236:

public void buttonAboutOk_click(GButton source, GEvent event) { //_CODE_:buttonAboutOk:768487:
  aboutPanel.setVisible(false);
} //_CODE_:buttonAboutOk:768487:

public void dListPresets_click(GDropList source, GEvent event) { //_CODE_:dListPresets:841162:
  Node last = nodes.get(nodes.size() - 1);
  int newPreset = dListPresets.getSelectedIndex() - 1;
  if(newPreset >= 0) {
    if(last.type == "Video") {
      ((Video)last).video.setEqualizer(newPreset);
      sliderPreamp.setValue(((Video)last).video.preamp());
      sliderEq0.setValue(-((Video)last).video.amp(0));
      sliderEq1.setValue(-((Video)last).video.amp(1));
      sliderEq2.setValue(-((Video)last).video.amp(2));
      sliderEq3.setValue(-((Video)last).video.amp(3));
      sliderEq4.setValue(-((Video)last).video.amp(4));
      sliderEq5.setValue(-((Video)last).video.amp(5));
      sliderEq6.setValue(-((Video)last).video.amp(6));
      sliderEq7.setValue(-((Video)last).video.amp(7));
      sliderEq8.setValue(-((Video)last).video.amp(8));
      sliderEq9.setValue(-((Video)last).video.amp(9));
    }
    else {
      ((Audio)last).audio.setEqualizer(newPreset);
      sliderPreamp.setValue(((Audio)last).audio.preamp());
      sliderEq0.setValue(-((Audio)last).audio.amp(0));
      sliderEq1.setValue(-((Audio)last).audio.amp(1));
      sliderEq2.setValue(-((Audio)last).audio.amp(2));
      sliderEq3.setValue(-((Audio)last).audio.amp(3));
      sliderEq4.setValue(-((Audio)last).audio.amp(4));
      sliderEq5.setValue(-((Audio)last).audio.amp(5));
      sliderEq6.setValue(-((Audio)last).audio.amp(6));
      sliderEq7.setValue(-((Audio)last).audio.amp(7));
      sliderEq8.setValue(-((Audio)last).audio.amp(8));
      sliderEq9.setValue(-((Audio)last).audio.amp(9));
    }
  }
} //_CODE_:dListPresets:841162:

public void buttonAddGallery_click(GButton source, GEvent event) { //_CODE_:buttonAddGallery:643646:
  buttonAdd_click(source, event);
  insertGallery(openGallery("Select folder"));
} //_CODE_:buttonAddGallery:643646:

public void buttonAddRandom_click(GButton source, GEvent event) { //_CODE_:buttonAddRandom:353894:
  buttonAdd_click(source, event);
  nodes.add(new Random());  
} //_CODE_:buttonAddRandom:353894:

public void buttonAddExec_click(GButton source, GEvent event) { //_CODE_:buttonAddExec:716116:
  buttonAdd_click(source, event);
  nodes.add(new Exec());  
} //_CODE_:buttonAddExec:716116:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.RED_SCHEME);
  G4P.setMouseOverEnabled(false);
  GButton.useRoundCorners(false);
  G4P.setDisplayFont("Arial", G4P.PLAIN, 10);
  G4P.setInputFont("Arial", G4P.PLAIN, 10);
  surface.setTitle("Backstage");
  cp = GWindow.getWindow(this, "Control Panel", 0, 0, 896, 296, JAVA2D);
  cp.noLoop();
  cp.setActionOnClose(G4P.CLOSE_WINDOW);
  buttonAddMedia = new GButton(cp, 96, 96, 48, 24);
  buttonAddMedia.setIcon("media.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddMedia.addEventHandler(this, "buttonAddMedia_click");
  buttonShow = new GButton(cp, 144, 0, 48, 24);
  buttonShow.setIcon("eye.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonShow.addEventHandler(this, "buttonShow_click");
  controlPanel = new GPanel(cp, 144, 24, 488, 240, "Control Panel");
  controlPanel.setCollapsible(false);
  controlPanel.setText("Control Panel");
  controlPanel.setOpaque(true);
  controlPanel.addEventHandler(this, "controlPanel_Event");
  buttonOK = new GButton(cp, 432, 208, 48, 24);
  buttonOK.setIcon("ok.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonOK.addEventHandler(this, "buttonOK_click");
  labelLabel = new GLabel(cp, 8, 48, 40, 16);
  labelLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelLabel.setText("Label");
  labelLabel.setOpaque(false);
  labelPath = new GLabel(cp, 8, 24, 40, 16);
  labelPath.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelPath.setText("Path");
  labelPath.setOpaque(false);
  textLabel = new GTextField(cp, 48, 48, 192, 16, G4P.SCROLLBARS_NONE);
  textLabel.setOpaque(true);
  textPath = new GTextField(cp, 48, 24, 432, 16, G4P.SCROLLBARS_NONE);
  textPath.setOpaque(true);
  textBegin = new GTextField(cp, 72, 144, 48, 16, G4P.SCROLLBARS_NONE);
  textBegin.setOpaque(true);
  textEnd = new GTextField(cp, 192, 144, 48, 16, G4P.SCROLLBARS_NONE);
  textEnd.setOpaque(true);
  buttonCancel = new GButton(cp, 368, 208, 48, 24);
  buttonCancel.setIcon("cancel.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonCancel.addEventHandler(this, "buttonCancel_click");
  labelX = new GLabel(cp, 8, 72, 40, 16);
  labelX.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelX.setText("Left");
  labelX.setOpaque(false);
  labelY = new GLabel(cp, 8, 96, 40, 16);
  labelY.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelY.setText("Top");
  labelY.setOpaque(false);
  labelW = new GLabel(cp, 128, 72, 40, 16);
  labelW.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelW.setText("Width");
  labelW.setOpaque(false);
  labelH = new GLabel(cp, 128, 96, 40, 16);
  labelH.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelH.setText("Height");
  labelH.setOpaque(false);
  textX = new GTextField(cp, 48, 72, 40, 16, G4P.SCROLLBARS_NONE);
  textX.setOpaque(true);
  textY = new GTextField(cp, 48, 96, 40, 16, G4P.SCROLLBARS_NONE);
  textY.setOpaque(true);
  textW = new GTextField(cp, 168, 72, 40, 16, G4P.SCROLLBARS_NONE);
  textW.setOpaque(true);
  textH = new GTextField(cp, 168, 96, 40, 16, G4P.SCROLLBARS_NONE);
  textH.setOpaque(true);
  textDuration = new GTextField(cp, 72, 168, 48, 16, G4P.SCROLLBARS_NONE);
  textDuration.setOpaque(true);
  labelDuration = new GLabel(cp, 8, 168, 64, 16);
  labelDuration.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelDuration.setText("Duration");
  labelDuration.setOpaque(false);
  labelText = new GLabel(cp, 248, 144, 64, 16);
  labelText.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelText.setText("Text");
  labelText.setOpaque(false);
  textArea = new GTextArea(cp, 248, 160, 112, 72, G4P.SCROLLBARS_NONE);
  textArea.setOpaque(true);
  labelNotes = new GLabel(cp, 488, 144, 64, 16);
  labelNotes.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelNotes.setText("Notes");
  labelNotes.setOpaque(false);
  notesArea = new GTextArea(cp, 488, 160, 112, 72, G4P.SCROLLBARS_NONE);
  notesArea.setOpaque(true);
  viewColor = new GView(cp, 72, 216, 48, 16, JAVA2D);
  buttonColor = new GButton(cp, 8, 216, 64, 16);
  buttonColor.setText("Color");
  buttonColor.addEventHandler(this, "buttonColor_click");
  buttonBegin = new GButton(cp, 8, 144, 64, 16);
  buttonBegin.setText("Begin at");
  buttonBegin.addEventHandler(this, "buttonBegin_click");
  cboxCentered = new GCheckbox(cp, 8, 120, 112, 16);
  cboxCentered.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxCentered.setText("Centered");
  cboxCentered.setOpaque(false);
  cboxAspectRatio = new GCheckbox(cp, 128, 120, 112, 16);
  cboxAspectRatio.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxAspectRatio.setText("Aspect Ratio");
  cboxAspectRatio.setOpaque(false);
  cboxBeginPaused = new GCheckbox(cp, 248, 48, 112, 16);
  cboxBeginPaused.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxBeginPaused.setText("Begin Paused");
  cboxBeginPaused.setOpaque(false);
  cboxEndPaused = new GCheckbox(cp, 368, 48, 112, 16);
  cboxEndPaused.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxEndPaused.setText("End Paused");
  cboxEndPaused.setOpaque(false);
  cboxBeginTransition = new GCheckbox(cp, 248, 72, 112, 16);
  cboxBeginTransition.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxBeginTransition.setText("Begin Transition");
  cboxBeginTransition.setOpaque(false);
  cboxEndTransition = new GCheckbox(cp, 368, 72, 112, 16);
  cboxEndTransition.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxEndTransition.setText("End Transition");
  cboxEndTransition.setOpaque(false);
  labelBeginTransition = new GLabel(cp, 248, 96, 64, 16);
  labelBeginTransition.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelBeginTransition.setText("Duration");
  labelBeginTransition.setOpaque(false);
  labelEndTransition = new GLabel(cp, 368, 96, 64, 16);
  labelEndTransition.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelEndTransition.setText("Duration");
  labelEndTransition.setOpaque(false);
  textBeginTransition = new GTextField(cp, 312, 96, 48, 16, G4P.SCROLLBARS_NONE);
  textBeginTransition.setOpaque(true);
  textEndTransition = new GTextField(cp, 432, 96, 48, 16, G4P.SCROLLBARS_NONE);
  textEndTransition.setOpaque(true);
  dListBeginTransition = new GDropList(cp, 248, 120, 112, 112, 6, 10);
  dListBeginTransition.setItems(loadStrings("list_968539"), 0);
  dListEndTransition = new GDropList(cp, 368, 120, 112, 112, 6, 10);
  dListEndTransition.setItems(loadStrings("list_460436"), 0);
  labelVolume = new GLabel(cp, 8, 192, 64, 16);
  labelVolume.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelVolume.setText("Volume");
  labelVolume.setOpaque(false);
  sliderVolume = new GSlider(cp, 72, 192, 168, 16, 10.0);
  sliderVolume.setShowValue(true);
  sliderVolume.setLimits(1.0, 0.0, 2.0);
  sliderVolume.setNbrTicks(21);
  sliderVolume.setShowTicks(true);
  sliderVolume.setNumberFormat(G4P.DECIMAL, 2);
  sliderVolume.setOpaque(false);
  buttonEnd = new GButton(cp, 128, 144, 64, 16);
  buttonEnd.setText("End at");
  buttonEnd.addEventHandler(this, "buttonEnd_click");
  cboxLoop = new GCheckbox(cp, 128, 168, 64, 16);
  cboxLoop.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxLoop.setText("Loop");
  cboxLoop.setOpaque(false);
  labelTextSize = new GLabel(cp, 488, 112, 64, 16);
  labelTextSize.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelTextSize.setText("Size");
  labelTextSize.setOpaque(false);
  textTextSize = new GTextField(cp, 552, 112, 48, 16, G4P.SCROLLBARS_NONE);
  textTextSize.setOpaque(true);
  dListTextAlignHor = new GDropList(cp, 488, 24, 112, 64, 3, 10);
  dListTextAlignHor.setItems(loadStrings("list_283308"), 0);
  dListTextAlignVer = new GDropList(cp, 488, 48, 112, 80, 4, 10);
  dListTextAlignVer.setItems(loadStrings("list_449715"), 0);
  dListTextFont = new GDropList(cp, 552, 72, 144, 176, 10, 10);
  dListTextFont.setItems(loadStrings("list_611259"), 0);
  labelTextFont = new GLabel(cp, 488, 72, 64, 16);
  labelTextFont.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelTextFont.setText("Font");
  labelTextFont.setOpaque(false);
  labelTextAlign = new GLabel(cp, 488, 0, 64, 16);
  labelTextAlign.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelTextAlign.setText("Text Align");
  labelTextAlign.setOpaque(false);
  cboxX = new GCheckbox(cp, 88, 72, 32, 16);
  cboxX.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxX.setText("%");
  cboxX.setOpaque(false);
  cboxH = new GCheckbox(cp, 208, 96, 32, 16);
  cboxH.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxH.setText("%");
  cboxH.setOpaque(false);
  cboxY = new GCheckbox(cp, 88, 96, 32, 16);
  cboxY.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxY.setText("%");
  cboxY.setOpaque(false);
  cboxW = new GCheckbox(cp, 208, 72, 32, 16);
  cboxW.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxW.setText("%");
  cboxW.setOpaque(false);
  cboxIndependent = new GCheckbox(cp, 368, 184, 112, 16);
  cboxIndependent.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxIndependent.setText("Independent");
  cboxIndependent.setOpaque(false);
  cboxEqualizer = new GCheckbox(cp, 128, 216, 112, 16);
  cboxEqualizer.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  cboxEqualizer.setText("Equalizer");
  cboxEqualizer.setOpaque(false);
  cboxEqualizer.addEventHandler(this, "cboxEqualizer_click");
  dListHighlight = new GDropList(cp, 368, 160, 112, 96, 5, 10);
  dListHighlight.setItems(loadStrings("list_871695"), 0);
  controlPanel.addControl(buttonOK);
  controlPanel.addControl(labelLabel);
  controlPanel.addControl(labelPath);
  controlPanel.addControl(textLabel);
  controlPanel.addControl(textPath);
  controlPanel.addControl(textBegin);
  controlPanel.addControl(textEnd);
  controlPanel.addControl(buttonCancel);
  controlPanel.addControl(labelX);
  controlPanel.addControl(labelY);
  controlPanel.addControl(labelW);
  controlPanel.addControl(labelH);
  controlPanel.addControl(textX);
  controlPanel.addControl(textY);
  controlPanel.addControl(textW);
  controlPanel.addControl(textH);
  controlPanel.addControl(textDuration);
  controlPanel.addControl(labelDuration);
  controlPanel.addControl(labelText);
  controlPanel.addControl(textArea);
  controlPanel.addControl(labelNotes);
  controlPanel.addControl(notesArea);
  controlPanel.addControl(viewColor);
  controlPanel.addControl(buttonColor);
  controlPanel.addControl(buttonBegin);
  controlPanel.addControl(cboxCentered);
  controlPanel.addControl(cboxAspectRatio);
  controlPanel.addControl(cboxBeginPaused);
  controlPanel.addControl(cboxEndPaused);
  controlPanel.addControl(cboxBeginTransition);
  controlPanel.addControl(cboxEndTransition);
  controlPanel.addControl(labelBeginTransition);
  controlPanel.addControl(labelEndTransition);
  controlPanel.addControl(textBeginTransition);
  controlPanel.addControl(textEndTransition);
  controlPanel.addControl(dListBeginTransition);
  controlPanel.addControl(dListEndTransition);
  controlPanel.addControl(labelVolume);
  controlPanel.addControl(sliderVolume);
  controlPanel.addControl(buttonEnd);
  controlPanel.addControl(cboxLoop);
  controlPanel.addControl(labelTextSize);
  controlPanel.addControl(textTextSize);
  controlPanel.addControl(dListTextAlignHor);
  controlPanel.addControl(dListTextAlignVer);
  controlPanel.addControl(dListTextFont);
  controlPanel.addControl(labelTextFont);
  controlPanel.addControl(labelTextAlign);
  controlPanel.addControl(cboxX);
  controlPanel.addControl(cboxH);
  controlPanel.addControl(cboxY);
  controlPanel.addControl(cboxW);
  controlPanel.addControl(cboxIndependent);
  controlPanel.addControl(cboxEqualizer);
  controlPanel.addControl(dListHighlight);
  buttonResize = new GButton(cp, 872, 0, 24, 24);
  buttonResize.setIcon("resize.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonLoad = new GButton(cp, 0, 48, 48, 24);
  buttonLoad.setIcon("folder_upload.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonLoad.addEventHandler(this, "buttonLoad_click");
  buttonSave = new GButton(cp, 0, 72, 48, 24);
  buttonSave.setIcon("folder_download.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonSave.addEventHandler(this, "buttonSave_click");
  buttonZip = new GButton(cp, 48, 24, 48, 24);
  buttonZip.setIcon("zip.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonZip.addEventHandler(this, "buttonZip_click");
  buttonFiles = new GButton(cp, 0, 0, 48, 24);
  buttonFiles.setIcon("folder.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonFiles.addEventHandler(this, "buttonFiles_click");
  buttonNew = new GButton(cp, 0, 24, 48, 24);
  buttonNew.setIcon("folder_new.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonNew.addEventHandler(this, "buttonNew_click");
  buttonConfig = new GButton(cp, 48, 0, 48, 24);
  buttonConfig.setIcon("gear.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonConfig.addEventHandler(this, "buttonConfig_click");
  buttonNodeNext = new GButton(cp, 96, 272, 48, 24);
  buttonNodeNext.setIcon("step_forward.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonNodeNext.addEventHandler(this, "buttonNodeNext_click");
  buttonStop = new GButton(cp, 240, 0, 48, 24);
  buttonStop.setIcon("stop.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonStop.addEventHandler(this, "buttonStop_click");
  buttonPlay = new GButton(cp, 192, 0, 48, 24);
  buttonPlay.setIcon("play.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonPlay.addEventHandler(this, "buttonPlay_click");
  buttonNodePlay = new GButton(cp, 0, 272, 48, 24);
  buttonNodePlay.setIcon("play.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonNodePlay.addEventHandler(this, "buttonNodePlay_click");
  buttonNodeStop = new GButton(cp, 48, 272, 48, 24);
  buttonNodeStop.setIcon("stop.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonNodeStop.addEventHandler(this, "buttonNodeStop_click");
  buttonNodeSlider = new GButton(cp, 144, 272, 24, 24);
  buttonNodeSlider.setIcon("marker.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonTracksPlus = new GButton(cp, 848, 0, 24, 24);
  buttonTracksPlus.setIcon("plus.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonTracksPlus.addEventHandler(this, "buttonTracksPlus_click");
  buttonTracksMinus = new GButton(cp, 824, 0, 24, 24);
  buttonTracksMinus.setIcon("minus.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonTracksMinus.addEventHandler(this, "buttonTracksMinus_click");
  buttonAdd = new GButton(cp, 96, 0, 48, 24);
  buttonAdd.setIcon("add.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAdd.addEventHandler(this, "buttonAdd_click");
  buttonAddLink = new GButton(cp, 96, 24, 48, 24);
  buttonAddLink.setIcon("link.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddLink.addEventHandler(this, "buttonAddLink_click");
  buttonAddText = new GButton(cp, 96, 48, 48, 24);
  buttonAddText.setIcon("text.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddText.addEventHandler(this, "buttonAddText_click");
  buttonAddRect = new GButton(cp, 96, 72, 48, 24);
  buttonAddRect.setIcon("rect.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddRect.addEventHandler(this, "buttonAddRect_click");
  durationPanel = new GPanel(cp, 144, 24, 104, 80, "Default Duration");
  durationPanel.setCollapsible(false);
  durationPanel.setText("Default Duration");
  durationPanel.setOpaque(true);
  textDp = new GTextField(cp, 8, 24, 88, 16, G4P.SCROLLBARS_NONE);
  textDp.setOpaque(true);
  buttonDpCancel = new GButton(cp, 8, 48, 32, 24);
  buttonDpCancel.setIcon("cancel.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonDpCancel.addEventHandler(this, "buttonDpCancel_click");
  buttonDpOk = new GButton(cp, 64, 48, 32, 24);
  buttonDpOk.setIcon("ok.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonDpOk.addEventHandler(this, "buttonDpOk_click");
  durationPanel.addControl(textDp);
  durationPanel.addControl(buttonDpCancel);
  durationPanel.addControl(buttonDpOk);
  buttonDefaultDuration = new GButton(cp, 48, 48, 48, 24);
  buttonDefaultDuration.setIcon("clock.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonDefaultDuration.addEventHandler(this, "buttonDefaultDuration_click");
  buttonScheme = new GButton(cp, 48, 72, 48, 24);
  buttonScheme.setIcon("palete.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonScheme.addEventHandler(this, "buttonScheme_click");
  buttonAbout = new GButton(cp, 336, 0, 48, 24);
  buttonAbout.setIcon("help.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAbout.addEventHandler(this, "buttonAbout_click");
  buttonNext = new GButton(cp, 288, 0, 48, 24);
  buttonNext.setIcon("step_forward.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonNext.addEventHandler(this, "buttonNext_click");
  aboutPanel = new GPanel(cp, 224, 144, 200, 152, "About");
  aboutPanel.setCollapsible(false);
  aboutPanel.setText("About");
  aboutPanel.setOpaque(true);
  labelTitle = new GLabel(cp, 8, 24, 184, 24);
  labelTitle.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelTitle.setText("Backstage v.3.0");
  labelTitle.setOpaque(false);
  labelCopyright = new GLabel(cp, 8, 48, 184, 24);
  labelCopyright.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelCopyright.setText("© 2024 Caldas Lopes");
  labelCopyright.setOpaque(false);
  labelGPL = new GLabel(cp, 8, 72, 184, 48);
  labelGPL.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelGPL.setText("Backstage is free software and is licensed under the GNU General Public License");
  labelGPL.setOpaque(false);
  buttonGithub = new GButton(cp, 8, 120, 72, 24);
  buttonGithub.setIcon("github.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonGithub.addEventHandler(this, "buttonGithub_click");
  buttonAboutOk = new GButton(cp, 144, 120, 48, 24);
  buttonAboutOk.setIcon("ok.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAboutOk.addEventHandler(this, "buttonAboutOk_click");
  aboutPanel.addControl(labelTitle);
  aboutPanel.addControl(labelCopyright);
  aboutPanel.addControl(labelGPL);
  aboutPanel.addControl(buttonGithub);
  aboutPanel.addControl(buttonAboutOk);
  equalizerPanel = new GPanel(cp, 624, 32, 248, 240, "Equalizer");
  equalizerPanel.setCollapsible(false);
  equalizerPanel.setText("Equalizer");
  equalizerPanel.setOpaque(true);
  sliderEq0 = new GSlider(cp, 24, 48, 160, 16, 10.0);
  sliderEq0.setShowValue(true);
  sliderEq0.setRotation(PI/2, GControlMode.CORNER);
  sliderEq0.setLimits(0.0, -20.0, 20.0);
  sliderEq0.setNbrTicks(21);
  sliderEq0.setShowTicks(true);
  sliderEq0.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq0.setOpaque(false);
  sliderEq1 = new GSlider(cp, 48, 48, 160, 16, 10.0);
  sliderEq1.setShowValue(true);
  sliderEq1.setRotation(PI/2, GControlMode.CORNER);
  sliderEq1.setLimits(0.0, -20.0, 20.0);
  sliderEq1.setNbrTicks(21);
  sliderEq1.setShowTicks(true);
  sliderEq1.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq1.setOpaque(false);
  sliderEq2 = new GSlider(cp, 72, 48, 160, 16, 10.0);
  sliderEq2.setShowValue(true);
  sliderEq2.setRotation(PI/2, GControlMode.CORNER);
  sliderEq2.setLimits(0.0, -20.0, 20.0);
  sliderEq2.setNbrTicks(21);
  sliderEq2.setShowTicks(true);
  sliderEq2.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq2.setOpaque(false);
  sliderEq3 = new GSlider(cp, 96, 48, 160, 16, 10.0);
  sliderEq3.setShowValue(true);
  sliderEq3.setRotation(PI/2, GControlMode.CORNER);
  sliderEq3.setLimits(0.0, -20.0, 20.0);
  sliderEq3.setNbrTicks(21);
  sliderEq3.setShowTicks(true);
  sliderEq3.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq3.setOpaque(false);
  sliderEq4 = new GSlider(cp, 120, 48, 160, 16, 10.0);
  sliderEq4.setShowValue(true);
  sliderEq4.setRotation(PI/2, GControlMode.CORNER);
  sliderEq4.setLimits(0.0, -20.0, 20.0);
  sliderEq4.setNbrTicks(21);
  sliderEq4.setShowTicks(true);
  sliderEq4.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq4.setOpaque(false);
  sliderEq5 = new GSlider(cp, 144, 48, 160, 16, 10.0);
  sliderEq5.setShowValue(true);
  sliderEq5.setRotation(PI/2, GControlMode.CORNER);
  sliderEq5.setLimits(0.0, -20.0, 20.0);
  sliderEq5.setNbrTicks(21);
  sliderEq5.setShowTicks(true);
  sliderEq5.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq5.setOpaque(false);
  sliderEq6 = new GSlider(cp, 168, 48, 160, 16, 10.0);
  sliderEq6.setShowValue(true);
  sliderEq6.setRotation(PI/2, GControlMode.CORNER);
  sliderEq6.setLimits(0.0, -20.0, 20.0);
  sliderEq6.setNbrTicks(21);
  sliderEq6.setShowTicks(true);
  sliderEq6.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq6.setOpaque(false);
  sliderEq7 = new GSlider(cp, 192, 48, 160, 16, 10.0);
  sliderEq7.setShowValue(true);
  sliderEq7.setRotation(PI/2, GControlMode.CORNER);
  sliderEq7.setLimits(0.0, -20.0, 20.0);
  sliderEq7.setNbrTicks(21);
  sliderEq7.setShowTicks(true);
  sliderEq7.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq7.setOpaque(false);
  sliderEq8 = new GSlider(cp, 216, 48, 160, 16, 10.0);
  sliderEq8.setShowValue(true);
  sliderEq8.setRotation(PI/2, GControlMode.CORNER);
  sliderEq8.setLimits(0.0, -20.0, 20.0);
  sliderEq8.setNbrTicks(21);
  sliderEq8.setShowTicks(true);
  sliderEq8.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq8.setOpaque(false);
  sliderEq9 = new GSlider(cp, 240, 48, 160, 16, 10.0);
  sliderEq9.setShowValue(true);
  sliderEq9.setRotation(PI/2, GControlMode.CORNER);
  sliderEq9.setLimits(0.0, -20.0, 20.0);
  sliderEq9.setNbrTicks(21);
  sliderEq9.setShowTicks(true);
  sliderEq9.setNumberFormat(G4P.DECIMAL, 2);
  sliderEq9.setOpaque(false);
  sliderPreamp = new GSlider(cp, 72, 216, 168, 16, 10.0);
  sliderPreamp.setShowValue(true);
  sliderPreamp.setLimits(0.0, -20.0, 20.0);
  sliderPreamp.setNbrTicks(21);
  sliderPreamp.setShowTicks(true);
  sliderPreamp.setNumberFormat(G4P.DECIMAL, 2);
  sliderPreamp.setOpaque(false);
  labelPreamp = new GLabel(cp, 8, 216, 64, 16);
  labelPreamp.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelPreamp.setText("Preamp");
  labelPreamp.setOpaque(false);
  labelPresets = new GLabel(cp, 8, 24, 64, 16);
  labelPresets.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelPresets.setText("Presets");
  labelPresets.setOpaque(false);
  dListPresets = new GDropList(cp, 72, 24, 168, 176, 10, 10);
  dListPresets.setItems(loadStrings("list_841162"), 0);
  dListPresets.addEventHandler(this, "dListPresets_click");
  equalizerPanel.addControl(sliderEq0);
  equalizerPanel.addControl(sliderEq1);
  equalizerPanel.addControl(sliderEq2);
  equalizerPanel.addControl(sliderEq3);
  equalizerPanel.addControl(sliderEq4);
  equalizerPanel.addControl(sliderEq5);
  equalizerPanel.addControl(sliderEq6);
  equalizerPanel.addControl(sliderEq7);
  equalizerPanel.addControl(sliderEq8);
  equalizerPanel.addControl(sliderEq9);
  equalizerPanel.addControl(sliderPreamp);
  equalizerPanel.addControl(labelPreamp);
  equalizerPanel.addControl(labelPresets);
  equalizerPanel.addControl(dListPresets);
  buttonAddGallery = new GButton(cp, 96, 120, 48, 24);
  buttonAddGallery.setIcon("gallery.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddGallery.addEventHandler(this, "buttonAddGallery_click");
  buttonAddRandom = new GButton(cp, 96, 144, 48, 24);
  buttonAddRandom.setIcon("random.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddRandom.addEventHandler(this, "buttonAddRandom_click");
  buttonAddExec = new GButton(cp, 96, 168, 48, 24);
  buttonAddExec.setIcon("exec.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddExec.addEventHandler(this, "buttonAddExec_click");
  cp.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow cp;
GButton buttonAddMedia; 
GButton buttonShow; 
GPanel controlPanel; 
GButton buttonOK; 
GLabel labelLabel; 
GLabel labelPath; 
GTextField textLabel; 
GTextField textPath; 
GTextField textBegin; 
GTextField textEnd; 
GButton buttonCancel; 
GLabel labelX; 
GLabel labelY; 
GLabel labelW; 
GLabel labelH; 
GTextField textX; 
GTextField textY; 
GTextField textW; 
GTextField textH; 
GTextField textDuration; 
GLabel labelDuration; 
GLabel labelText; 
GTextArea textArea; 
GLabel labelNotes; 
GTextArea notesArea; 
GView viewColor; 
GButton buttonColor; 
GButton buttonBegin; 
GCheckbox cboxCentered; 
GCheckbox cboxAspectRatio; 
GCheckbox cboxBeginPaused; 
GCheckbox cboxEndPaused; 
GCheckbox cboxBeginTransition; 
GCheckbox cboxEndTransition; 
GLabel labelBeginTransition; 
GLabel labelEndTransition; 
GTextField textBeginTransition; 
GTextField textEndTransition; 
GDropList dListBeginTransition; 
GDropList dListEndTransition; 
GLabel labelVolume; 
GSlider sliderVolume; 
GButton buttonEnd; 
GCheckbox cboxLoop; 
GLabel labelTextSize; 
GTextField textTextSize; 
GDropList dListTextAlignHor; 
GDropList dListTextAlignVer; 
GDropList dListTextFont; 
GLabel labelTextFont; 
GLabel labelTextAlign; 
GCheckbox cboxX; 
GCheckbox cboxH; 
GCheckbox cboxY; 
GCheckbox cboxW; 
GCheckbox cboxIndependent; 
GCheckbox cboxEqualizer; 
GDropList dListHighlight; 
GButton buttonResize; 
GButton buttonLoad; 
GButton buttonSave; 
GButton buttonZip; 
GButton buttonFiles; 
GButton buttonNew; 
GButton buttonConfig; 
GButton buttonNodeNext; 
GButton buttonStop; 
GButton buttonPlay; 
GButton buttonNodePlay; 
GButton buttonNodeStop; 
GButton buttonNodeSlider; 
GButton buttonTracksPlus; 
GButton buttonTracksMinus; 
GButton buttonAdd; 
GButton buttonAddLink; 
GButton buttonAddText; 
GButton buttonAddRect; 
GPanel durationPanel; 
GTextField textDp; 
GButton buttonDpCancel; 
GButton buttonDpOk; 
GButton buttonDefaultDuration; 
GButton buttonScheme; 
GButton buttonAbout; 
GButton buttonNext; 
GPanel aboutPanel; 
GLabel labelTitle; 
GLabel labelCopyright; 
GLabel labelGPL; 
GButton buttonGithub; 
GButton buttonAboutOk; 
GPanel equalizerPanel; 
GSlider sliderEq0; 
GSlider sliderEq1; 
GSlider sliderEq2; 
GSlider sliderEq3; 
GSlider sliderEq4; 
GSlider sliderEq5; 
GSlider sliderEq6; 
GSlider sliderEq7; 
GSlider sliderEq8; 
GSlider sliderEq9; 
GSlider sliderPreamp; 
GLabel labelPreamp; 
GLabel labelPresets; 
GDropList dListPresets; 
GButton buttonAddGallery; 
GButton buttonAddRandom; 
GButton buttonAddExec; 
