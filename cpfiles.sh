#!/bin/sh
#
# cpfiles.sh - copy support files to the videos directory
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

if [ ! -d "$VDIR" ]; then
  echo "ERROR: Directory '$VDIR' does not exist" >&2
  exit 1
fi

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
# Copy top-level files
#
for file in index.php ticijev.png opensans.ttf; do
  if [ -f "$VDIR/$file" -a "$force" = 'no' ]; then
    if [ "$verbose" = 'yes' ]; then
      echo "WARNING: Not overwriting '$VDIR/$file'" >&2
    fi
    continue
  fi
  #
  # Even if forcing the copy, we first check if
  # the SHA1 hashes of the files are the same
  # to skip copying if it is not necessary.
  #
  nhashes=$(
    sha1sum "$file" "$VDIR/$file" 2>/dev/null \
     | awk '{ print $1 }' \
        | uniq \
           | wc -l
  )
  #
  # New file or two different hashes, so do copy
  #
  if [ ! -f "$VDIR/$file" -o $nhashes -eq 2 ]; then
    if [ "$verbose" = 'yes' ]; then
      cp -v -f "$file" "$VDIR/$file"
    else
      cp -f "$file" "$VDIR/$file"
    fi
  fi
done

#
# Copy per-video files
#
find "$VDIR" \( -name '*.mp4' -o -name '*.webm' \) \
 | while read video; do
     index="$(dirname "$video")/index.php"
     if [ -f "$index" -a "$force" = 'no' ]; then
       if [ "$verbose" = 'yes' ]; then
         echo "WARNING: Not overwriting '$index'" >&2
       fi
       continue
     fi
     if [ "$verbose" = 'yes' ]; then
       cp -v -f video.php "$index"
     else
       cp -f video.php "$index"
     fi
   done

#
# Copy per-collection files
#
find "$VDIR" -type d -exec dirname {} \; \
 | grep '/' \
    | sort -u \
       | while read dir; do
           index="$dir/index.php"
           if [ -f "$index" -a "$force" = 'no' ]; then
             if [ "$verbose" = 'yes' ]; then
               echo "WARNING: Not overwriting '$index'" >&2
             fi
             continue
           fi
           if [ "$verbose" = 'yes' ]; then
             cp -v -f index.php "$index"
           else
             cp -f index.php "$index"
           fi
         done
