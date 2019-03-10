<?php
/*
 * video.php - play a video
 * 
 * This file is part of TiCijev.
 *
 * TiCijev is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * TiCijev is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with TiCijev.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Determine video file name and type
 */
$vtype = 'mp4';
$video = glob('*.mp4');
if (count($video) == 0) {
    $video = glob('*.webm');
    if (count($video) == 0) {
        header('Location: /');
        die();
    }
    $vtype = 'webm';
}
/*
 * Get the filename of the first (and hopefully only) video
 */
$video = $video[0];
/*
 * If a file named 'title' exists, a video title
 * is read from it and displayed on the page.
 */
if (file_exists('title'))
    $title = trim(file_get_contents('title'));
else
    $title = '';
/*
 * If a file named 'about' exists, a video description
 * is read from it and displayed below the title.
 */
if (file_exists('about'))
    $about = file_get_contents('about');
else
    $about = '';
/*
 * Auto playlist emulation - find next video to play
 */
$urls = file('../videos.list',
             FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$self = basename(trim($_SERVER['REQUEST_URI'], '/'));
foreach ($urls as $index => $url) {
    if ($url == $self) {
        $index = ($index + 1) % count($urls);
        $next = '../' . $urls[$index] . '/';
    }
}
?>
<!DOCTYPE html>
<html>
<head>
<?php
if ($title != '')
    echo "<title>TiCijev - $title</title>\n";
else
    echo "<title>TiCijev - $video</title>\n";
?>
<style>
@font-face { font-family: "opensans"; src: url(/opensans.ttf) format("truetype"); }
         * { margin: 0; padding: 0; }
*, *:focus { outline: 0; }
      html { overflow-y: scroll; }
      body { width: 858px; margin: auto; font-family: "opensans",sans-serif; font-size: 16pt; }
        h1 { font-weight: normal; font-size: 1.5em; padding: 0.5em 0; border-bottom: 1px solid #ccc; margin-bottom: 0.5em; }
    header { padding: 1em 0; }
      main { padding-bottom: 1em; }
    footer { padding: 0.5em 0; font-size: 0.75em; color: #888; border-top: 1px solid #ccc; text-align: center; }
</style>
<script>
function videodone(e) {
    document.location = '<?php echo $next; ?>';
}
function focusvideo() {
    document.getElementById('video').focus();
    document.getElementById('video').addEventListener('ended', videodone, false);
}
</script>
</head>
<body onload="focusvideo()">
<header>
<a href=".."><img src="/ticijev.png"></a>
</header>
<main>
<video id="video" width="858" height="480" controls autoplay>
<source src="<?php echo $video; ?>" type="video/<?php echo $vtype; ?>">
</video>
<?php
if ($title != '')
    echo "<h1>$title</h1>\n";
if ($about != '')
    echo "<div>$about</div>\n";
?>
</main>
<footer>
Copyleft 2019+ TiCijev
</footer>
</body>
</html>
