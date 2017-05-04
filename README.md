# Backstage

#### License [GPL-3+](LICENSE)

if you find bugs, go to [github](https://github.com/linux-man/backstage/issues).

if you have questions, try [forums.softlab.pt](http://forums.softlab.pt).

Binaries will be at [Releases](https://github.com/linux-man/backstage/releases).

This program was born from the tiredness of using Powerpoint/Media player/Quicktime/VLC/Image viewer/whatever... to manage music, image and video projection.

You got a Control Panel at the primary display and do the projection at the secondary.

The Control Panel IS NOT a timeline. It's a media manager where you organize and connect the different media - the Nodes.

There are 6 types.

Link, Text and Rect are created using the menu.

To add Image, Audio and Video you can also drag and drop the wanted files.

Initially you have 4 tracks. It's important to understand that at each time only one node can be active (playing) on each track.

Move nodes: Left click + drag

Select several nodes: Control + Left click

Connect nodes: Right click + drag + drop

Delete connection: Right click over the connection semi-circle

Delete node: Right click

Open node properties window: Double click.

Resize window: drag resize button at top-right

Change tracks number: plus/minus buttons

There are 2 play/pause buttons. The upper is the global play/pause. It starts all the SELECTED nodes.

The bottom buttons only affect the last selected node. This way you can start playing or stop something during the show.

Accepted formats: jpg, png, gif, bmp, avi, mp4, mov, ogg, mkv, wav, mp3, au, aiff.

There could be some more explanations (I should write a wiki), but for now, play with it. It's easy! Really!!

### Requirements

Java Version 8 (preferably the latest update)

Codecs

### Issues

Main window can be maximized on Windows. It shouldn't be. The GLWindow is misbehaving.

Java has a tendency to crash when a monitor is connected/disconnected. Looks like a long time [bug](https://www.google.pt/search?q=sun.awt.image.BufImgSurfaceData+cannot+be+cast+to+sun.java2d.xr.XRSurfaceData).

Processing Video uses Gstreamer 0.10. It will be nice to install [gstreamer0.10-plugins-ugly](https://launchpad.net/ubuntu/xenial/+package/gstreamer0.10-plugins-ugly) and [libx264-146](https://launchpad.net/ubuntu/xenial/+package/libx264-146) on Debian/Ubuntu/Mint.

Installed codecs are really important. On Windows you can try [K-Lite Codec Pack](https://www.codecguide.com/download_kl.htm)

Ogg audio files are loaded by the Video library. You might have to "play" the video outside the window (choosing big or negative left/top values and small width/height).

### Acknowledgements:

[Processing](https://processing.org/)

[G4P](http://www.lagers.org.uk/g4p/)

[Minim](http://code.compartmental.net/tools/minim/)

[Drop](http://transfluxus.github.io/drop/)

Image buttons from [Fontawesome](http://fontawesome.io/)

Stage icon from [Findicons](http://findicons.com)

Control panel icon from [Iconarchive](http://www.iconarchive.com)
