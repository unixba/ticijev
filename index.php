<?php
/*
 * index.php - display video thumbnails
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
?>
<!DOCTYPE html>
<html>
<head>
<?php
if ($title != '')
    echo "<title>TiCijev - $title</title>\n";
else
    echo "<title>TiCijev - YouTube for humans</title>\n";
?>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<style>
   @font-face { font-family: "opensans"; src: url(/opensans.ttf) format("truetype"); }
            * { margin: 0; padding: 0; }
   *, *:focus { outline: 0; }
         html { overflow-y: scroll; }
         body { width: 858px; margin: auto; font-family: "opensans",sans-serif; font-size: 16pt; }
           h1 { font-weight: normal; font-size: 1.75em; padding-bottom: 0.5em; }
 a, a:visited { text-decoration: none; color: inherit; }
table, td, tr { border-collapse: collapse; line-height: 1.2em; }
           td { padding: 0 5px 15px 0; font-size: 0.75em; vertical-align: top; text-align: center; }
       header { padding: 1em 0; }
         main { padding-bottom: 1em; }
       footer { padding: 0.5em 0; font-size: 0.75em; color: #888; border-top: 1px solid #ccc; text-align: center; }
</style>
</head>
<body>
<header>
<a href=".."><img src="/ticijev.png"></a>
</header>
<main>
<?php
if ($title != '')
    echo '<a href="' . $_SERVER['REQUEST_URI'] . '"><h1>' . $title . '</h1></a>' . "\n";
if ($about != '')
    echo '<div style="padding-bottom:1em">' .
         "\n$about" .
         '</div>' . "\n";
$urls = file('videos.list',
             FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
shuffle($urls);
$nvideos = 30;
$current = 0;
echo '<table><tr>';
foreach ($urls as $url) {
    if (file_exists("$url/title"))
        $title = trim(file_get_contents("$url/title"));
    else
        $title = basename($url);
    echo '<td><a href="'  . $url . '/">' .
         '<img src="' . $url . '/thumb.jpg" />' .
         '<p>' . $title . '</p>' .
         '</a></td>';
    if (++$current == $nvideos)
        break;
    if ($current % 3 == 0)
        echo '</tr><tr>';
}
echo '</tr></table>';
?>
</main>
<footer>
Copyleft 2019+ TiCijev
</footer>
</body>
</html>
