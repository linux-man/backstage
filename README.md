# Backstage

![Screenshot](screenshot.jpg)

#### License [GPL-3+](LICENSE)

if you find bugs, go to [github](https://github.com/linux-man/backstage/issues).

if you have questions, try [forums.softlab.pt](http://forums.softlab.pt).

Binaries at [Releases](https://github.com/linux-man/backstage/releases).

This program was born from the tiredness of using Powerpoint/Media player/Quicktime/VLC/Image viewer/whatever... to manage music, image and video projection.

You use a Control Panel on the primary display and do the projection at the secondary.

The Control Panel IS NOT a timeline. It's a media manager where you organize and connect the different media - the Nodes.

There are 6 types:

Link ![Arrow](backstage/data/link.png), Text ![T](backstage/data/text.png) and Rect ![Square](backstage/data/rect.png) are created using the menu.

To add Image ![Image](backstage/data/picture.png), Audio ![Audio](backstage/data/audio.png) and Video ![Video](backstage/data/media.png) you can also drag and drop the wanted files.

Initially you have 4 tracks. It's important to understand that at each time only one node can be active (playing) on each track.

This can be annoying but is also usefull. One example:

You want to do a slideshow with music. Drop a audio file on the first (bottom) track, then drop your 100 images on another track (leave the audio track free). The hard part is to connect all images, one after another.

To start the music at the first image, create a Link node, put it before the audio. It's the start node. Connect it to the audio and to the first image.

Open the audio properties. Choose loop.

How to stop the audio after the last image? Just connect the last image to another link node and put it on the first track. When the link "starts" the audio is stopped. If nothing is playing the show ends. If you want to stop at the end of the music, do the opposite. If you want a never ending slideshow, connect the last image to the first.

Select the first Link node. Press play.

### Interface

Move nodes: Left click + drag

Move around: Left click + drag on empty space

Select several nodes: Control + Left click

Connect nodes: Right click + drag & drop (maximum of 4 connections from node)

Delete connection: Right click over the connection semi-circle

Delete node: Right click

Duplicate node: Control + Right click

Open node properties window: Double click.

Resize window: drag resize button at top-right

Change tracks number: plus/minus buttons

There are 2 sets of play/pause/step buttons. The upper is the global player. It starts all the SELECTED nodes. It pauses all the PLAYING nodes. Same goes for the "Step" button.

The bottom buttons only affect the last selected node. This way you can start or stop playing something during the show. The "Step" button allow to end and jump to the next connected nodes.

"Step" respects End Paused and End Transition.

At the "Gear" submenu you can compress your project to export to other computer, change the default duration of new Text, Rect and Image nodes (default is 5 seconds) and change theme.

The "Eye" turn fullscreen on/off. You can't do that while playing.

Accepted formats: jpg, png, gif, bmp, avi, mp4, mov, ogg, mkv, wav, mp3, au, aiff.

Nodes with "Loop": it's expected to use "Step" to move forward.

An "Independent" node is not controlled by the global buttons. You must start/stop selecting it and using the bottom buttons.

There are more to tell (I really should write a wiki), but for now, play with it. It's easy! Really!!

### Requirements

Java Version 8 (preferably the latest update)

Gstreamer 1.0

Codecs

### Issues

Main window can be maximized on Windows. It shouldn't be. The GLWindow is misbehaving.

If you install Backstage you can open a project by double clicking the file. On Windows, a console window is opened. You can close it. That happens because Processing apps must be run on their working directories. I couldn't find a registry key to force that, so I had to open a command line and run Backstage after a "change dir". If someone knows how to avoid this please tell me.

On Linux, Java has a tendency to crash when a monitor is connected/disconnected. Looks like a long time [bug](https://www.google.pt/search?q=sun.awt.image.BufImgSurfaceData+cannot+be+cast+to+sun.java2d.xr.XRSurfaceData).

Certain mp4 files mute after 10-15 seconds of playing without any warning. It's a random glitch probably related to gstreamer-java. Better use avi or test the media several times.

Ogg audio files are loaded by the Video library. You might have to play the "video" outside the window (choosing big or negative left/top values and small width/height).

Sometimes at start the theme is not correctly applied.

During the limited tests I did on Mac, I found that the original Opengl version crash, so I added an alternative JAVA2D version.
There are 3 labeled code blocks on backstage.pde and utils.pde that must be commented/uncommented to change the renderer.
The main difference between versions is that the presentation window start fullscreen minimized and can't be windowed.

### Acknowledgements:

[Processing](https://processing.org/)

[G4P](http://www.lagers.org.uk/g4p/)

[Minim](http://code.compartmental.net/tools/minim/)

[Drop](http://transfluxus.github.io/drop/)

Image buttons from [Fontawesome](http://fontawesome.io/)

Stage icon from [Findicons](http://findicons.com)

Control panel icon from [Iconarchive](http://www.iconarchive.com)
