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
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.util.zip.*;

void loadProject(File file) {
  if (file != null && file.exists()) {
    JSONObject json = loadJSONObject(file);
    clearNodes();
    projectPath = Paths.get(file.getPath());
    prevProjectPath = Paths.get(json.getString("projectPath", projectPath.toString()));
    cp.setTitle("Control Panel - " + projectPath.toString());
    tracksChange(json.getInt("tracks", 4));
    JSONArray jsonNodes = json.getJSONArray("nodes");
    for(int n = 0; n < jsonNodes.size(); n++) {
      JSONObject node = jsonNodes.getJSONObject(n);
      switch(node.getString("type")) {
        case "Link":
          nodes.add(new Link(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
          node.getBoolean("independent"), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getJSONArray("next").getIntArray()));
          break;
        case "Rect":
          nodes.add(new Rect(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
          node.getBoolean("independent"), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getJSONArray("next").getIntArray(),
          node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"),
          node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
          node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
          node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
          node.getInt("beginTransitionType"), node.getInt("endTransitionType"),
          node.getInt("bColor")));
          break;
        case "Text":
          nodes.add(new Text(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
          node.getBoolean("independent"), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getJSONArray("next").getIntArray(),
          node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"),
          node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
          node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
          node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
          node.getInt("beginTransitionType"), node.getInt("endTransitionType"), node.getInt("textAlignHor"), node.getInt("textAlignVer"), node.getInt("textSize"),
          node.getString("text"), node.getString("textFont"),
          node.getInt("bColor")));
          break;
        case "Image":
          nodes.add(new Image(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
          node.getBoolean("independent"), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getJSONArray("next").getIntArray(),
          node.getString("path"),
          node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"), node.getBoolean("aspectRatio"),
          node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
          node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
          node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
          node.getInt("beginTransitionType"), node.getInt("endTransitionType")));
          break;
        case "Audio":
          nodes.add(new Audio(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
          node.getBoolean("independent"), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getJSONArray("next").getIntArray(),
          node.getString("path"),
          node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"),
          node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"), node.getFloat("volume"), node.getFloat("beginAt"), node.getFloat("endAt")));
          break;
        case "Video":
          nodes.add(new Video(node.getString("label"), node.getString("notes"), node.getFloat("duration"), node.getBoolean("beginPaused"), node.getBoolean("endPaused"),
          node.getBoolean("independent"), node.getInt("index"), node.getInt("x"), node.getInt("y"), node.getJSONArray("next").getIntArray(),
          node.getString("path"),
          node.getBoolean("loop"), node.getBoolean("beginTransition"), node.getBoolean("endTransition"), node.getBoolean("centered"), node.getBoolean("aspectRatio"),
          node.getFloat("nX"), node.getFloat("nY"), node.getFloat("nW"), node.getFloat("nH"),
          node.getBoolean("perX"), node.getBoolean("perY"), node.getBoolean("perW"), node.getBoolean("perH"),
          node.getFloat("beginTransitionDuration"), node.getFloat("endTransitionDuration"),
          node.getFloat("volume"), node.getFloat("beginAt"), node.getFloat("endAt"),
          node.getInt("beginTransitionType"), node.getInt("endTransitionType")));
          break;
      }
    }
  }
}

void saveProject(File file) {
  if(nodes.size() == 0) return;
  int minX = nodes.get(0).x;
  if (file != null) {
    prevProjectPath = projectPath;
    String path = file.getPath();
    if(!path.endsWith(".stage")) path = path + ".stage";
    projectPath = Paths.get(path);
    cp.setTitle("Control Panel - " + projectPath.toString());
    for(Node no: nodes) minX = min(minX, no.x);
    for(Node no: nodes) no.x -= minX - 20;
    JSONObject json = new JSONObject();
    json.setInt("version", version);
    json.setInt("tracks", tracks);
    json.setString("projectPath", projectPath.toString());
    JSONArray jsonNodes = new JSONArray();
    for(Node no: nodes) {
      JSONObject jsonNode = new JSONObject();
      jsonNode.setString("type", no.type);jsonNode.setString("label", no.label); jsonNode.setString("notes", no.notes);
      jsonNode.setFloat("duration", no.duration); jsonNode.setBoolean("beginPaused", no.beginPaused); jsonNode.setBoolean("endPaused", no.endPaused); 
      jsonNode.setBoolean("independent", no.independent); jsonNode.setInt("index", no.index); jsonNode.setInt("x", no.x); jsonNode.setInt("y", no.y);
      JSONArray values = new JSONArray(); for(int n = 0; n < no.next.length; n++) values.setInt(n, no.next[n]); jsonNode.setJSONArray("next", values);
      jsonNode.setBoolean("loop", no.loop); jsonNode.setBoolean("beginTransition", no.beginTransition); jsonNode.setBoolean("endTransition", no.endTransition);
      switch(no.type) {
        case "Rect":
          jsonNode.setBoolean("centered", ((Rect)no).centered);
          jsonNode.setFloat("nX", ((Rect)no).nX); jsonNode.setFloat("nY", ((Rect)no).nY); jsonNode.setFloat("nW", ((Rect)no).nW); jsonNode.setFloat("nH", ((Rect)no).nH);
          jsonNode.setBoolean("perX", ((Rect)no).perX); jsonNode.setBoolean("perY", ((Rect)no).perY); jsonNode.setBoolean("perW", ((Rect)no).perW); jsonNode.setBoolean("perH", ((Rect)no).perH);
          jsonNode.setFloat("beginTransitionDuration", ((Rect)no).beginTransitionDuration); jsonNode.setFloat("endTransitionDuration", ((Rect)no).endTransitionDuration);
          jsonNode.setInt("beginTransitionType", ((Rect)no).beginTransitionType); jsonNode.setInt("endTransitionType", ((Rect)no).endTransitionType);
          jsonNode.setInt("bColor", ((Rect)no).bColor);
          break;
        case "Text":
          jsonNode.setBoolean("centered", ((Text)no).centered);
          jsonNode.setFloat("nX", ((Text)no).nX); jsonNode.setFloat("nY", ((Text)no).nY); jsonNode.setFloat("nW", ((Text)no).nW); jsonNode.setFloat("nH", ((Text)no).nH);
          jsonNode.setBoolean("perX", ((Text)no).perX); jsonNode.setBoolean("perY", ((Text)no).perY); jsonNode.setBoolean("perW", ((Text)no).perW); jsonNode.setBoolean("perH", ((Text)no).perH);
          jsonNode.setFloat("beginTransitionDuration", ((Text)no).beginTransitionDuration); jsonNode.setFloat("endTransitionDuration", ((Text)no).endTransitionDuration);
          jsonNode.setInt("beginTransitionType", ((Text)no).beginTransitionType); jsonNode.setInt("endTransitionType", ((Text)no).endTransitionType);
          jsonNode.setInt("textAlignHor", ((Text)no).textAlignHor); jsonNode.setInt("textAlignVer", ((Text)no).textAlignVer); jsonNode.setInt("textSize", ((Text)no).textSize);
          jsonNode.setString("text", ((Text)no).text); jsonNode.setString("textFont", ((Text)no).textFont);
          jsonNode.setInt("bColor", ((Text)no).bColor);
          break;
        case "Image":
          ((Image)no).path = projectPath.getParent().relativize(prevProjectPath.getParent().resolve(Paths.get(((Image)no).path)).normalize()).normalize().toString();
          jsonNode.setString("path", ((Image)no).path);
          jsonNode.setBoolean("centered", ((Image)no).centered); jsonNode.setBoolean("aspectRatio", ((Image)no).aspectRatio);
          jsonNode.setFloat("nX", ((Image)no).nX); jsonNode.setFloat("nY", ((Image)no).nY); jsonNode.setFloat("nW", ((Image)no).nW); jsonNode.setFloat("nH", ((Image)no).nH);
          jsonNode.setBoolean("perX", ((Image)no).perX); jsonNode.setBoolean("perY", ((Image)no).perY); jsonNode.setBoolean("perW", ((Image)no).perW); jsonNode.setBoolean("perH", ((Image)no).perH);
          jsonNode.setFloat("beginTransitionDuration", ((Image)no).beginTransitionDuration); jsonNode.setFloat("endTransitionDuration", ((Image)no).endTransitionDuration);
          jsonNode.setInt("beginTransitionType", ((Image)no).beginTransitionType); jsonNode.setInt("endTransitionType", ((Image)no).endTransitionType);
          break;
        case "Audio":
          ((Audio)no).path = projectPath.getParent().relativize(prevProjectPath.getParent().resolve(Paths.get(((Audio)no).path)).normalize()).normalize().toString();
          jsonNode.setString("path", ((Audio)no).path);
          jsonNode.setFloat("beginTransitionDuration", ((Audio)no).beginTransitionDuration); jsonNode.setFloat("endTransitionDuration", ((Audio)no).endTransitionDuration);
          jsonNode.setFloat("volume", ((Audio)no).volume); jsonNode.setFloat("beginAt", ((Audio)no).beginAt); jsonNode.setFloat("endAt", ((Audio)no).endAt);
          break;
        case "Video":
          ((Video)no).path = projectPath.getParent().relativize(prevProjectPath.getParent().resolve(Paths.get(((Video)no).path)).normalize()).normalize().toString();
          jsonNode.setString("path", ((Video)no).path);
          jsonNode.setBoolean("centered", ((Video)no).centered); jsonNode.setBoolean("aspectRatio", ((Video)no).aspectRatio);
          jsonNode.setFloat("nX", ((Video)no).nX); jsonNode.setFloat("nY", ((Video)no).nY); jsonNode.setFloat("nW", ((Video)no).nW); jsonNode.setFloat("nH", ((Video)no).nH);
          jsonNode.setBoolean("perX", ((Video)no).perX); jsonNode.setBoolean("perY", ((Video)no).perY); jsonNode.setBoolean("perW", ((Video)no).perW); jsonNode.setBoolean("perH", ((Video)no).perH);
          jsonNode.setFloat("beginTransitionDuration", ((Video)no).beginTransitionDuration); jsonNode.setFloat("endTransitionDuration", ((Video)no).endTransitionDuration);
          jsonNode.setFloat("volume", ((Video)no).volume); jsonNode.setFloat("beginAt", ((Video)no).beginAt); jsonNode.setFloat("endAt", ((Video)no).endAt);
          jsonNode.setInt("beginTransitionType", ((Video)no).beginTransitionType); jsonNode.setInt("endTransitionType", ((Video)no).endTransitionType);
          break;
      }
      jsonNodes.setJSONObject(no.index, jsonNode);
    }
    json.setJSONArray("nodes", jsonNodes);
    saveJSONObject(json, path);
    prevProjectPath = projectPath;
  }
}

void saveZip(File file) {
  if (file != null) {
    String path = file.getPath();
    if(!path.endsWith(".zip")) path = path + ".zip";
    try{
      File zip = new File(path);
      ZipOutputStream zipStream = new ZipOutputStream(new FileOutputStream(zip));
      ZipEntry ze;
      FileInputStream inputStream;
      ArrayList<String> files = new ArrayList<String>();
      JSONObject json = loadJSONObject(projectPath.toString());
      JSONArray jsonNodes = json.getJSONArray("nodes");
      files.clear();
      for(int n = 0; n < jsonNodes.size(); n++) {
        JSONObject node = jsonNodes.getJSONObject(n);
        switch(node.getString("type")) {
          case "Image": case "Audio": case "Video":
            Path nodePath = Paths.get(node.getString("path"));
            Path newPath = Paths.get("media").resolve(nodePath.getFileName());
            node.setString("path", newPath.toString());
            if(!files.contains(newPath.toString())) {
              files.add(newPath.toString());
              ze = new ZipEntry(newPath.toString());
              zipStream.putNextEntry(ze);
              inputStream = new FileInputStream(projectPath.getParent().resolve(nodePath).normalize().toString());
              byte[] readBuffer = new byte[2048];
              int amountRead;
              while ((amountRead = inputStream.read(readBuffer)) > 0) {
                zipStream.write(readBuffer, 0, amountRead);
              }
              inputStream.close();
              zipStream.closeEntry();
            }
            break;
        }
      }
      File tmpFile = File.createTempFile("presentation", null, null);
      saveJSONObject(json, tmpFile.getPath());
      ze= new ZipEntry(projectPath.getFileName().toString());
      zipStream.putNextEntry(ze);
      inputStream = new FileInputStream(tmpFile.getPath());
      byte[] readBuffer = new byte[2048];
      int amountRead;
      while ((amountRead = inputStream.read(readBuffer)) > 0) {
        zipStream.write(readBuffer, 0, amountRead);
      }
      inputStream.close();
      zipStream.closeEntry();
      zipStream.close();
    }
    catch (Exception e){
      println(e.getMessage());
    }
  }
}

void insertMedia(File file) {
  if (file != null) insertMedia(-translation, trackHeight, file);
}

void insertMedia(int x, int y, File file) {
  if (file == null) return;
  if(controlPanel.isVisible() || durationPanel.isVisible()) return;
  String path = file.getPath();
  String label = file.getName();
  String[] qname = splitTokens(label, ".");
  String type;
  if(qname.length == 1) type = "Unknown";
  else switch(qname[qname.length - 1].toLowerCase()) {
    case "jpg": case "jpeg": case "png": case "gif": case "bmp": type = "Image"; break;
    case "avi": case "mp4": case "m4v": case "mov": case "ogv": case "mkv": case "3gp": case "wmv": case "flv": case "ts": case "mpg": case "mpeg": case "rm": case "rmbv": case "dv": case "vid": type = "Video"; break;
    case "wav": case "mp3": case "au": case "aiff": case "ogg": case "wma": case "asf": case "mka": case "tta": case "dts": case "mp2": case "a52": case "aac": case "flac":  case "ra": type = "Audio"; break;
    default: type = "Unknown";
  }
  int index = nodes.size();
  String notes = ""; int[] next = new int[0];
  boolean loop = false; boolean beginPaused = false; boolean endPaused = false; boolean independent = false; boolean beginTransition = false; boolean endTransition = false;
  float duration = defaultDuration; float beginTransitionDuration = 1; float endTransitionDuration = 1;
  int beginTransitionType = 0; int endTransitionType = 0; float nX = 0; float nY = 0; float nW = 100; float nH = 100;
  boolean perX = false; boolean perY = false; boolean perW = true; boolean perH = true;
  boolean aspectRatio = true; boolean centered = true;
  float volume = 0.5; float beginAt = 0; float endAt = 0;

  switch(type) {
    case "Image":
      nodes.add(new Image(label, notes, duration, beginPaused, endPaused, independent, index, x, y, next,
      path,
      loop, beginTransition, endTransition, centered, aspectRatio,
      nX, nY, nW, nH, perX, perY, perW, perH, beginTransitionDuration, endTransitionDuration,
      beginTransitionType, endTransitionType));
      break;
    case "Audio": 
      nodes.add(new Audio(label, notes, duration, beginPaused, endPaused, independent, index, x, y, next,
      path,
      loop, beginTransition, endTransition,
      beginTransitionDuration, endTransitionDuration, volume, beginAt, endAt));
      break;
    case "Video": 
      nodes.add(new Video(label, notes, duration, beginPaused, endPaused, independent, index, x, y, next,
      path,
      loop, beginTransition, endTransition, centered, aspectRatio,
      nX, nY, nW, nH, perX, perY, perW, perH, beginTransitionDuration, endTransitionDuration, volume, beginAt, endAt,
      beginTransitionType, endTransitionType));
      break;
  }
}

void clearNodes() {
  translation = 0;
  for(int n = 0; n < stage.length; n++) stage[n] = null;
  for(Node no: nodes) {
    no.clear();
    no = null;
  }
  nodes.clear();
  System.gc();
}
