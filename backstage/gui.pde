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

public void buttonAddMedia_click(GButton source, GEvent event) { //_CODE_:buttonAddMedia:865208:
  buttonAdd_click(source, event);
  insertMedia(openDialog("Insert media"));
} //_CODE_:buttonAddMedia:865208:

public void buttonShow_click(GButton source, GEvent event) { //_CODE_:buttonShow:602257:
  if(playing) return;
  switchFullScreen();
} //_CODE_:buttonShow:602257:

public void controlPanel_Event(GPanel source, GEvent event) { //_CODE_:controlPanel:650884:
  if(event == GEvent.DRAGGED) controlPanel.setDragArea();
} //_CODE_:controlPanel:650884:

public void buttonOK_click(GButton source, GEvent event) { //_CODE_:buttonOK:412325:
  Node last = nodes.get(nodes.size() - 1);
  last.save();
  controlPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonOK:412325:

public void buttonCancel_click(GButton source, GEvent event) { //_CODE_:buttonCancel:309314:
  Node last = nodes.get(nodes.size() - 1);
  last.cancel();
  controlPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonCancel:309314:

public void buttonColor_click(GButton source, GEvent event) { //_CODE_:buttonColor:764260:
  //color c = colorChooser(sketchPg.backgroundColor);
  PGraphics v = viewColor.getGraphics();
  color c = colorChooser(v.backgroundColor);
  v.beginDraw();
  v.background(c);
  v.endDraw();
} //_CODE_:buttonColor:764260:

public void buttonBegin_click(GButton source, GEvent event) { //_CODE_:buttonBegin:740950:
  Node last = nodes.get(nodes.size() - 1);
  if(last.playing) {
    if(last.type == "Video") textBegin.setText(timeToString(((Video)last).beginAt + ((Video)last).presentTime  / 1000.0));
    else textBegin.setText(timeToString(((Audio)last).beginAt + ((Audio)last).presentTime  / 1000.0));
  }
} //_CODE_:buttonBegin:740950:

public void buttonEnd_click(GButton source, GEvent event) { //_CODE_:buttonEnd:376759:
  Node last = nodes.get(nodes.size() - 1);
  if(last.playing) {
    if(last.type == "Video") textEnd.setText(timeToString(((Video)last).beginAt + ((Video)last).presentTime  / 1000.0));
    else textEnd.setText(timeToString(((Audio)last).beginAt + ((Audio)last).presentTime  / 1000.0));
  }
} //_CODE_:buttonEnd:376759:

public void buttonLoad_click(GButton source, GEvent event) { //_CODE_:buttonLoad:520173:
  buttonFiles_click(source, event);
  end(true);
  loadProject(openDialog("Load project"));
} //_CODE_:buttonLoad:520173:

public void buttonSave_click(GButton source, GEvent event) { //_CODE_:buttonSave:396549:
  buttonFiles_click(source, event);
  saveProject(saveDialog("project"));
} //_CODE_:buttonSave:396549:

public void buttonZip_click(GButton source, GEvent event) { //_CODE_:buttonZip:430393:
  buttonConfig_click(source, event);
  if(!(new File(projectPath.toString()).isFile())) return;
  saveZip(saveDialog("zip"));
} //_CODE_:buttonZip:430393:

public void buttonFiles_click(GButton source, GEvent event) { //_CODE_:buttonFiles:591107:
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
} //_CODE_:buttonFiles:591107:

public void buttonNew_click(GButton source, GEvent event) { //_CODE_:buttonNew:668979:
  if(G4P.selectOption(cp, "Are you sure?", "New Backstage", G4P.QUERY, G4P.YES_NO) == G4P.OK) {
    buttonFiles_click(source, event);
    end(true);
    clearNodes();
    projectPath = Paths.get(System.getProperty("user.home")).resolve("presentation.stage");
    prevProjectPath = projectPath;
    cp.setTitle("Control Panel");
  }
} //_CODE_:buttonNew:668979:

public void buttonConfig_click(GButton source, GEvent event) { //_CODE_:buttonConfig:230647:
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
} //_CODE_:buttonConfig:230647:

public void buttonScheme_click(GButton source, GEvent event) { //_CODE_:buttonScheme:472181:
  buttonConfig_click(source, event);
  changeScheme(colorScheme + 1);
} //_CODE_:buttonScheme:472181:

public void buttonNodeNext_click(GButton source, GEvent event) { //_CODE_:buttonNodeNext:334280:
  Node last = nodes.get(nodes.size() - 1);
  if(last.selected && last.playing) last.next();
} //_CODE_:buttonNodeNext:334280:

public void buttonStop_click(GButton source, GEvent event) { //_CODE_:buttonStop:401078:
  end(true);
} //_CODE_:buttonStop:401078:

public void buttonPlay_click(GButton source, GEvent event) { //_CODE_:buttonPlay:467305:
  turn();
} //_CODE_:buttonPlay:467305:

public void buttonNodePlay_click(GButton source, GEvent event) { //_CODE_:buttonNodePlay:285767:
  Node last = nodes.get(nodes.size() - 1);
  last.turn();
} //_CODE_:buttonNodePlay:285767:

public void buttonNodeStop_click(GButton source, GEvent event) { //_CODE_:buttonNodeStop:980932:
  Node last = nodes.get(nodes.size() - 1);
  if(last.selected && last.playing) last.end(true);
} //_CODE_:buttonNodeStop:980932:

public void buttonTracksPlus_click(GButton source, GEvent event) { //_CODE_:buttonTracksPlus:971221:
  tracksChange(tracks + 1);
} //_CODE_:buttonTracksPlus:971221:

public void buttonTracksMinus_click(GButton source, GEvent event) { //_CODE_:buttonTracksMinus:595166:
  tracksChange(tracks - 1);
} //_CODE_:buttonTracksMinus:595166:

public void buttonAdd_click(GButton source, GEvent event) { //_CODE_:buttonAdd:584446:
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
} //_CODE_:buttonAdd:584446:

public void buttonAddLink_click(GButton source, GEvent event) { //_CODE_:buttonAddLink:396763:
  buttonAdd_click(source, event);
  nodes.add(new Link());  
} //_CODE_:buttonAddLink:396763:

public void buttonAddText_click(GButton source, GEvent event) { //_CODE_:buttonAddText:871890:
  buttonAdd_click(source, event);
  nodes.add(new Text());  
} //_CODE_:buttonAddText:871890:

public void buttonAddRect_click(GButton source, GEvent event) { //_CODE_:buttonAddRect:475144:
  buttonAdd_click(source, event);
  nodes.add(new Rect());  
} //_CODE_:buttonAddRect:475144:

public void buttonDpCancel_click(GButton source, GEvent event) { //_CODE_:buttonDpCancel:273107:
  durationPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonDpCancel:273107:

public void buttonDpOk_click(GButton source, GEvent event) { //_CODE_:buttonDpOk:965799:
  if(isTime(textDp.getText())) defaultDuration = stringToTime(textDp.getText());
  durationPanel.setVisible(false);
  buttonsEnabled(true);
} //_CODE_:buttonDpOk:965799:

public void buttonDefaultDuration_click(GButton source, GEvent event) { //_CODE_:buttonDefaultDuration:585100:
  buttonConfig_click(source, event);
  textDp.setText(timeToString(defaultDuration));
  buttonsEnabled(false);
  durationPanel.setVisible(true);
} //_CODE_:buttonDefaultDuration:585100:

public void buttonAbout_click(GButton source, GEvent event) { //_CODE_:buttonAbout:332361:
  aboutPanel.setVisible(true);
} //_CODE_:buttonAbout:332361:

public void buttonGithub_click(GButton source, GEvent event) { //_CODE_:buttonGithub:681756:
  aboutPanel.setVisible(false);
  link("https://github.com/linux-man/backstage");
} //_CODE_:buttonGithub:681756:

public void buttonAboutOk_click(GButton source, GEvent event) { //_CODE_:buttonAboutOk:306674:
  aboutPanel.setVisible(false);
} //_CODE_:buttonAboutOk:306674:

public void buttonNext_click(GButton source, GEvent event) { //_CODE_:buttonNext:977240:
  next();
} //_CODE_:buttonNext:977240:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.RED_SCHEME);
  G4P.setCursor(ARROW);
  GButton.useRoundCorners(false);
  surface.setTitle("Backstage");
  cp = GWindow.getWindow(this, "Control Panel", 0, 0, 600, 296, JAVA2D);
  cp.noLoop();
  cp.setActionOnClose(G4P.CLOSE_WINDOW);
  buttonAddMedia = new GButton(cp, 96, 96, 48, 24);
  buttonAddMedia.setIcon("media.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAddMedia.addEventHandler(this, "buttonAddMedia_click");
  buttonShow = new GButton(cp, 144, 0, 48, 24);
  buttonShow.setIcon("eye.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonShow.addEventHandler(this, "buttonShow_click");
  controlPanel = new GPanel(cp, 56, 24, 488, 240, "Control Panel");
  controlPanel.setCollapsible(false);
  controlPanel.setText("Control Panel");
  controlPanel.setOpaque(true);
  controlPanel.addEventHandler(this, "controlPanel_Event");
  buttonOK = new GButton(cp, 432, 208, 48, 24);
  buttonOK.setIcon("ok.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonOK.addEventHandler(this, "buttonOK_click");
  textLabel = new GTextField(cp, 48, 48, 192, 16, G4P.SCROLLBARS_NONE);
  textLabel.setOpaque(true);
  labelLabel = new GLabel(cp, 8, 48, 40, 16);
  labelLabel.setText("Label");
  labelLabel.setOpaque(false);
  labelPath = new GLabel(cp, 8, 24, 40, 16);
  labelPath.setText("Path");
  labelPath.setOpaque(false);
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
  labelX.setText("Left");
  labelX.setOpaque(false);
  labelY = new GLabel(cp, 8, 96, 40, 16);
  labelY.setText("Top");
  labelY.setOpaque(false);
  labelW = new GLabel(cp, 128, 72, 40, 16);
  labelW.setText("Width");
  labelW.setOpaque(false);
  labelH = new GLabel(cp, 128, 96, 40, 16);
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
  labelDuration.setText("Duration");
  labelDuration.setOpaque(false);
  labelText = new GLabel(cp, 248, 144, 64, 16);
  labelText.setText("Text");
  labelText.setOpaque(false);
  textArea = new GTextArea(cp, 248, 160, 112, 72, G4P.SCROLLBARS_NONE);
  textArea.setOpaque(true);
  labelNotes = new GLabel(cp, 488, 48, 64, 16);
  labelNotes.setText("Notes");
  labelNotes.setOpaque(false);
  notesArea = new GTextArea(cp, 488, 64, 112, 72, G4P.SCROLLBARS_NONE);
  notesArea.setOpaque(true);
  viewColor = new GView(cp, 72, 216, 48, 16, JAVA2D);
  buttonColor = new GButton(cp, 8, 216, 64, 16);
  buttonColor.setText("Color");
  buttonColor.addEventHandler(this, "buttonColor_click");
  buttonBegin = new GButton(cp, 8, 144, 64, 16);
  buttonBegin.setText("Begin at");
  buttonBegin.addEventHandler(this, "buttonBegin_click");
  buttonEnd = new GButton(cp, 128, 144, 64, 16);
  buttonEnd.setText("End at");
  buttonEnd.addEventHandler(this, "buttonEnd_click");
  cboxCentered = new GCheckbox(cp, 8, 120, 112, 16);
  cboxCentered.setText("Centered");
  cboxCentered.setOpaque(false);
  cboxAspectRatio = new GCheckbox(cp, 128, 120, 112, 16);
  cboxAspectRatio.setText("Aspect Ratio");
  cboxAspectRatio.setOpaque(false);
  cboxBeginPaused = new GCheckbox(cp, 248, 48, 120, 16);
  cboxBeginPaused.setText("Begin Paused");
  cboxBeginPaused.setOpaque(false);
  cboxEndPaused = new GCheckbox(cp, 368, 48, 112, 16);
  cboxEndPaused.setText("End Paused");
  cboxEndPaused.setOpaque(false);
  cboxBeginTransition = new GCheckbox(cp, 248, 72, 120, 16);
  cboxBeginTransition.setText("Begin Transition");
  cboxBeginTransition.setOpaque(false);
  cboxEndTransition = new GCheckbox(cp, 368, 72, 112, 16);
  cboxEndTransition.setText("End Transition");
  cboxEndTransition.setOpaque(false);
  labelBeginTransition = new GLabel(cp, 248, 96, 64, 16);
  labelBeginTransition.setText("Duration");
  labelBeginTransition.setOpaque(false);
  labelEndTransition = new GLabel(cp, 368, 96, 64, 16);
  labelEndTransition.setText("Duration");
  labelEndTransition.setOpaque(false);
  textBeginTransition = new GTextField(cp, 312, 96, 48, 16, G4P.SCROLLBARS_NONE);
  textBeginTransition.setOpaque(true);
  textEndTransition = new GTextField(cp, 432, 96, 48, 16, G4P.SCROLLBARS_NONE);
  textEndTransition.setOpaque(true);
  dListBeginTransition = new GDropList(cp, 248, 120, 112, 112, 6, 10);
  dListBeginTransition.setItems(loadStrings("list_399051"), 0);
  dListEndTransition = new GDropList(cp, 368, 120, 112, 112, 6, 10);
  dListEndTransition.setItems(loadStrings("list_281916"), 0);
  labelVolume = new GLabel(cp, 8, 192, 64, 16);
  labelVolume.setText("Volume");
  labelVolume.setOpaque(false);
  sliderVolume = new GSlider(cp, 72, 192, 168, 16, 10.0);
  sliderVolume.setShowValue(true);
  sliderVolume.setLimits(1.0, 0.0, 2.0);
  sliderVolume.setNbrTicks(21);
  sliderVolume.setStickToTicks(true);
  sliderVolume.setShowTicks(true);
  sliderVolume.setNumberFormat(G4P.DECIMAL, 2);
  sliderVolume.setOpaque(false);
  cboxLoop = new GCheckbox(cp, 128, 168, 64, 16);
  cboxLoop.setText("Loop");
  cboxLoop.setOpaque(false);
  labelTextSize = new GLabel(cp, 488, 184, 64, 16);
  labelTextSize.setText("Size");
  labelTextSize.setOpaque(false);
  textTextSize = new GTextField(cp, 488, 200, 48, 16, G4P.SCROLLBARS_NONE);
  textTextSize.setOpaque(true);
  dListTextAlignHor = new GDropList(cp, 368, 168, 112, 64, 3, 10);
  dListTextAlignHor.setItems(loadStrings("list_355854"), 0);
  dListTextAlignVer = new GDropList(cp, 368, 192, 112, 80, 4, 10);
  dListTextAlignVer.setItems(loadStrings("list_625198"), 0);
  dListTextFont = new GDropList(cp, 488, 160, 192, 144, 8, 10);
  dListTextFont.setItems(loadStrings("list_672062"), 0);
  labelTextFont = new GLabel(cp, 488, 144, 64, 16);
  labelTextFont.setText("Font");
  labelTextFont.setOpaque(false);
  labelTextAlign = new GLabel(cp, 368, 144, 80, 16);
  labelTextAlign.setText("Text Align");
  labelTextAlign.setOpaque(false);
  cboxX = new GCheckbox(cp, 88, 72, 32, 16);
  cboxX.setText("%");
  cboxX.setOpaque(false);
  cboxH = new GCheckbox(cp, 208, 96, 32, 16);
  cboxH.setText("%");
  cboxH.setOpaque(false);
  cboxY = new GCheckbox(cp, 88, 96, 32, 16);
  cboxY.setText("%");
  cboxY.setOpaque(false);
  cboxW = new GCheckbox(cp, 208, 72, 32, 16);
  cboxW.setText("%");
  cboxW.setOpaque(false);
  cboxIndependent = new GCheckbox(cp, 368, 176, 112, 16);
  cboxIndependent.setText("Independent");
  cboxIndependent.setOpaque(false);
  controlPanel.addControl(buttonOK);
  controlPanel.addControl(textLabel);
  controlPanel.addControl(labelLabel);
  controlPanel.addControl(labelPath);
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
  controlPanel.addControl(buttonEnd);
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
  buttonResize = new GButton(cp, 576, 0, 24, 24);
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
  buttonScheme = new GButton(cp, 48, 72, 48, 24);
  buttonScheme.setIcon("palete.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonScheme.addEventHandler(this, "buttonScheme_click");
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
  buttonTracksPlus = new GButton(cp, 552, 0, 24, 24);
  buttonTracksPlus.setIcon("plus.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonTracksPlus.addEventHandler(this, "buttonTracksPlus_click");
  buttonTracksMinus = new GButton(cp, 528, 0, 24, 24);
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
  durationPanel = new GPanel(cp, 352, 0, 104, 80, "Default Duration");
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
  buttonAbout = new GButton(cp, 336, 0, 48, 24);
  buttonAbout.setIcon("help.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAbout.addEventHandler(this, "buttonAbout_click");
  aboutPanel = new GPanel(cp, 0, 96, 200, 152, "About");
  aboutPanel.setCollapsible(false);
  aboutPanel.setText("About");
  aboutPanel.setOpaque(true);
  labelTitle = new GLabel(cp, 8, 24, 184, 24);
  labelTitle.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelTitle.setText("Backstage v.2.0.1");
  labelTitle.setTextBold();
  labelTitle.setOpaque(false);
  buttonGithub = new GButton(cp, 8, 120, 72, 24);
  buttonGithub.setIcon("github.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonGithub.addEventHandler(this, "buttonGithub_click");
  labelCopyright = new GLabel(cp, 8, 48, 184, 24);
  labelCopyright.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelCopyright.setText("© 2019 Caldas Lopes");
  labelCopyright.setOpaque(false);
  buttonAboutOk = new GButton(cp, 144, 120, 48, 24);
  buttonAboutOk.setIcon("ok.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonAboutOk.addEventHandler(this, "buttonAboutOk_click");
  labelGPL = new GLabel(cp, 8, 72, 184, 48);
  labelGPL.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelGPL.setText("Backstage is free software and is licensed under the GNU General Public License");
  labelGPL.setOpaque(false);
  aboutPanel.addControl(labelTitle);
  aboutPanel.addControl(buttonGithub);
  aboutPanel.addControl(labelCopyright);
  aboutPanel.addControl(buttonAboutOk);
  aboutPanel.addControl(labelGPL);
  buttonNext = new GButton(cp, 288, 0, 48, 24);
  buttonNext.setIcon("step_forward.png", 1, GAlign.NORTH, GAlign.CENTER, GAlign.MIDDLE);
  buttonNext.addEventHandler(this, "buttonNext_click");
  cp.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow cp;
GButton buttonAddMedia; 
GButton buttonShow; 
GPanel controlPanel; 
GButton buttonOK; 
GTextField textLabel; 
GLabel labelLabel; 
GLabel labelPath; 
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
GButton buttonEnd; 
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
GButton buttonResize; 
GButton buttonLoad; 
GButton buttonSave; 
GButton buttonZip; 
GButton buttonFiles; 
GButton buttonNew; 
GButton buttonConfig; 
GButton buttonScheme; 
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
GButton buttonAbout; 
GPanel aboutPanel; 
GLabel labelTitle; 
GButton buttonGithub; 
GLabel labelCopyright; 
GButton buttonAboutOk; 
GLabel labelGPL; 
GButton buttonNext; 
