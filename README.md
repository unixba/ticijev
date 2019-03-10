# TiCijev - A very poor man's YouTube

**TiCijev** is a set of several simple shell scripts and PHP files which allow you to easily set up and maintain a rudimentary video hosting site. The interface is designed for small children with the single left click as the only supported action. It works on GNU/Linux, though ambitious users could make it work on a modern BSD, MacOS or Windows.

## Dependencies

**TiCijev** shell scripts use commands from the following packages: *GNU coreutils*, *GNU findutils*, *GNU grep*, *GNU sed*, *GAWK* and *FFmpeg*.

## Initial setup

Setting up **TiCijev** is simple. First, clone this repository to the computer that will be hosting the videos (we assume the hostname of your **TiCijev** server is *tcserver*):

```
$ cd /home/user
$ git clone https://github.com/unixba/ticijev.git
Cloning into 'ticijev'...
remote: Counting objects: 14, done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 14 (delta 4), reused 0 (delta 0)
Unpacking objects: 100% (14/14), done.
Checking connectivity... done.
```

Now enter the directory `ticijev` which contains the cloned repository:

```
$ cd ticijev
```

In the rest of this document, we assume that our working directory is the one containing the cloned **TiCijev** repository (i.e. `/home/user/ticijev` in my case).

## Testing the setup

The **TiCijev** repository already contains several sample videos, which you can use for testing before you start adding your own content. Begin by unpacking the file `sample.tar.gz`:

```
$ gunzip -c sample.tar.gz | tar xf -
```

This command will unpack all the videos into a directory named `videos`.

Before moving on, it is advisable to survey the contents of the `videos` directory and see how the files are organized. **TiCijev** uses a few very simple file naming conventions and you can probably figure it all out by simply looking at the contents of the `videos` directory (even if you don't, those conventions are explained later in this document).

Now execute the script named `update.sh` to populate the `videos` directory with files that are needed by **TiCijev**:

```
$ ./update.sh
```

If you wish to see each step performed by `update.sh`, run it with the `-v` or `--verbose` option.

At this point, your **TiCijev** document root is set up inside the `videos` directory and you are ready to start hosting the videos. If you have PHP installed on the system, the simplest way to test the setup is to use PHP's built-in web server:

```
$ ( cd videos && php -S 0:7777 )
PHP 5.6.29 Development Server started at Sun Mar 10 19:15:01 2019
Listening on http://0:7777
Document root is /home/user/ticijev/videos
Press Ctrl-C to quit.
_
```

Alternatively, you can set up Apache listening on port 7777 with document root pointing to your `videos` directory.

Now open your web browser and navigate to `http://tcserver:7777/` to test your **TiCijev** setup.

Notice that the port 7777 here is chosen arbitrarily, only for testing. In a permanent setup, you will probably have an Apache web server listening on port 80 with a virtual host dedicated for your **TiCijev** videos.

## Adding your videos

**TiCijev** shell scripts expect all your videos to reside inside the `videos` directory. If you wish to keep your videos on a different physical device, you first need to mount your device onto the `videos` directory, or make `videos` a symbolic link pointing to a directory on your video storage device.

**TiCijev** only supports MP4 and WEBM videos, which can be played natively by most web browsers. If you have a video in another format, you first need to convert it to either MP4 or WEBM before it can be hosted by **TiCijev**.

Each video must be contained inside its own directory. One directory can only contain a single video file with an extension of `.mp4` or `.webm`. For instance, to add an MP4 file of a butterfly, you first make a subdirectory inside `videos`, then copy the video file into it:

```
$ mkdir videos/my-butterfly-video
$ cp ~/Downloads/butterfly.mp4 videos/my-butterfly-video/
```

Keep adding as many videos as you wish in the same manner, but please do avoid using whitespace in the names of files and directories (e.g. instead of `my first video` use `my-first-video`).

After you have finished adding your videos, execute the script `update.sh` to update the contents of the `videos` directory:

```
$ ./update.sh
```

## Playlists

**TiCijev** allows you to organize your videos into collections, which function in a similar way as playlists. To make a collection, simply group multiple video directories into a single common directory, for example:

```
$ mkdir videos/collection1
$ mkdir videos/collection1/turtle
$ mkdir videos/collection1/horse
$ mkdir videos/collection1/birds
$ cp ~/Downloads/turtle.mp4 videos/collection1/turtle/
$ cp ~/Downloads/whitehorse.webm videos/collection1/horse/
$ cp ~/Downloads/smallbirds.webm videos/collection1/birds/
```

Do not forget to execute `update.sh` each time you make changes to the `videos` directory:

```
$ ./update.sh
```

From this point on, the three videos `turtle.mp4`, `whitehorse.webm` and `smallbirds.webm` will be treated as a single collection and will be automatically played one after another as a playlist (i.e. when you play any one of them, **TiCijev** will play them all in sequence).

The order in which these video files are played is determined by the names of the directories that contain them. In our example, the video directories are named `turtle`, `horse` and `birds`, which means that, due to alphanumeric ordering, the video in the `birds` directory will be played first, followed by the video in the `horse` directory, followed by the video in the `turtle` directory. When the last video in a collection has finished playing, **TiCijev** plays the first video of the same collection again.

To enforce a specific order of playing the videos in a collection, simply name the video directories in a way that will guarantee your desired ordering. In our example, to make the turtle video play first, followed by the horse video, followed by the birds video, we could simply name the corresponding directories `01-turtle`, `02-horse` and `03-birds`, respectively:

```
$ mv videos/collection1/turtle videos/collection1/01-turtle
$ mv videos/collection1/horse videos/collection1/02-horse
$ mv videos/collection1/birds videos/collection1/03-birds
```

Again, execute `update.sh` to have **TiCijev** notice your changes:

```
$ ./update.sh
```

## Titles and descriptions

You can add a custom title to each video by making a one-line file named `title` in the corresponding video directory, for instance:

```
$ echo 'White Horse' >videos/collections1/02-horse/title
```

If the `title` file is missing from a video directory, **TiCijev** will display the name of the video directory in place of the custom title.

In the same manner, you can add a description for a video by making a file named `about` inside the video directory, for example:

```
$ cat <<END >videos/collections1/02-horse/about
This is a footage of a beautiful white flying
horse recorded on a mountain near Nowhereland.
END
```

You can also add the files `title` and/or `about` to a collection directory to describe the entire collection of videos.

Note that all title and about files are optional and do not affect the functioning of **TiCijev** in any way.

## Rebuilding everything

When you execute `update.sh`, it only carries out operations which are required to reflect the latest changes in the `videos` directory. You can run `update.sh` with the `-f` or `--force` option to force updating all of the files. Using this option should normally never be needed, but may help if something breaks (e.g. thumbnails are generated incorrectly).

## The magic **TiCijev** logo

Clicking the **TiCijev** logo is context-sensitive. If you cannot figure out what it does, consider this project a failure.

## License

Licensed under GPLv3+:
[GNU GPL version 3](http://gnu.org/licenses/gpl.html)
or later.
