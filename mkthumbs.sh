#!/bin/sh
#
# mkthumbs.sh - make thumbnails for available videos
# 
# This file is part of TiCijev.
#
# TiCijev is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# TiCijev is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with TiCijev.  If not, see <http://www.gnu.org/licenses/>.
#

VDIR='videos'

#
# Default option values
#
force='no'
verbose='no'

#
# Handle options
#
while echo "$1" | grep '^-' >/dev/null; do
  #
  # Force overwriting of existing files?
  #
  if [ "$1" = '-f' -o "$1" = '--force' ]; then
    force='yes'
  fi
  #
  # Verbose output (warnings etc.)?
  #
  if [ "$1" = '-v' -o "$1" = '--verbose' ]; then
    verbose='yes'
  fi
  shift
done

#
# Find all video files and make thumbnails for them
#
find "$VDIR" \( -name '*.mp4' -o -name '*.webm' \) \
  | while read video; do
      #
      # Determine the length of the video
      #
      len=$(
        ffprobe \
          -v error \
          -select_streams v:0 \
          -show_entries format=duration \
          -of default=noprint_wrappers=1:nokey=1 \
          "$video"
      )
      #
      # Note the middle position of the video
      #
      pos=$(awk 'BEGIN { print ARGV[1] / 2.0 }' "$len")
      #
      # Generate the thumbnail from the middle of the video
      #
      thumb="$(dirname "$video")/thumb.jpg"
      if [ -f "$thumb" -a "$force" = 'no' ]; then
        if [ "$verbose" = 'yes' ]; then
          echo "WARNING: Not overwriting '$thumb'" >&2
        fi
        continue
      fi
      #
      # Generate thumbnail
      #
      if [ "$verbose" = 'yes' ]; then
        echo "Generating thumbnail '$thumb'" >&2
      fi
      #
      # Need to close stdin so ffmpeg doesn't
      # interfere with our while-read loop!!!
      #
      ffmpeg -y -v quiet -ss "$pos" -i "$video" \
        -vframes 1 -s 280x156 -f image2 "$thumb" </dev/null
    done
