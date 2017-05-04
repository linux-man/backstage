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
import processing.awt.PSurfaceAWT.SmoothCanvas;

SDrop drop;

void initializeDrop() {
  drop = new SDrop(this);
  drop.addComponent((SmoothCanvas) cp.getSurface().getNative());
}

void dropEvent(DropEvent dropEvt) {
  if(dropEvt.isFile()) {
    File file = dropEvt.file();
    if (file != null) {
      if(file.isFile()) insertMedia(dropEvt.x(), dropEvt.y(), file);
      else if(file.isDirectory()) for(File f : dropEvt.listFiles(file, true)) insertMedia(dropEvt.x(), dropEvt.y(), f);
    }
  }
}