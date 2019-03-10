#!/bin/sh
#
# mklists.sh - make lists (caches) of available videos
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
LIST='videos.list'

if [ ! -d "$VDIR" ]; then
  echo "ERROR: Directory '$VDIR' does not exist" >&2
  exit 1
fi

#
# Default option values
#
verbose='no'

#
# Handle options
#
while echo "$1" | grep '^-' >/dev/null; do
  #
  # Verbose output (warnings etc.)?
  #
  if [ "$1" = '-v' -o "$1" = '--verbose' ]; then
    verbose='yes'
  fi
  shift
done

#
# Generate the global all-videos list
#
if [ "$verbose" = 'yes' ]; then
  echo "Generating video list '$VDIR/$LIST'" >&2
fi
find "$VDIR" \
  \( -name '*.mp4' -o -name '*.webm' \) -exec dirname {} \; \
     | sort -u \
         | sed "s:^$VDIR/::" >"$VDIR/$LIST"

#
# Now generate all sub-lists
#
find "$VDIR" -type d \
  | grep -v -f "$VDIR/$LIST" \
      | grep -v "^$VDIR$" \
          | while read dir; do
              if [ "$verbose" = 'yes' ]; then
                echo "Generating video list '$dir/$LIST'" >&2
              fi
              path="$(echo "$dir" | sed "s:^$VDIR/::")"
              sed -n "s|^$path/||p" "$VDIR/$LIST" >"$dir/$LIST"
            done
