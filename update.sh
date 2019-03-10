#!/bin/sh
#
# update.sh - update the contents of the videos directory
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
# You can specify the force ('-f' or '--force') and
# verbose ('-v' or '--verbose') flags here and they
# will be passed on to all the executed scripts.
#
./cpfiles.sh  "$@"
./mkthumbs.sh "$@"
./mklists.sh  "$@"
