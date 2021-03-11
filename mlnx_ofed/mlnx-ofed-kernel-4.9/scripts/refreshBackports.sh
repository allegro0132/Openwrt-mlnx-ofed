#!/bin/bash
#
# Copyright (c) 2017 Mellanox Technologies. All rights reserved.
#
# This Software is licensed under one of the following licenses:
#
# 1) under the terms of the "Common Public License 1.0" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/cpl.php.
#
# 2) under the terms of the "The BSD License" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/bsd-license.php.
#
# 3) under the terms of the "GNU General Public License (GPL) Version 2" a
#    copy of which is available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/gpl-license.php.
#
# Licensee has the right to choose one of the above licenses.
#
# Redistributions of source code must retain the above copyright
# notice and one of the license notices.
#
# Redistributions in binary form must reproduce both the above copyright
# notice, one of the license notices in the documentation
# and/or other materials provided with the distribution.
#

# Pretty colors
GREEN="\033[01;32m"
YELLOW="\033[01;33m"
NORMAL="\033[00m"
BLUE="\033[34m"
RED="\033[31m"
PURPLE="\033[35m"
CYAN="\033[36m"
UNDERLINE="\033[02m"

# Refresh patches using quilt
patchRefresh() {
	export QUILT_PATCHES=$1

	rm -rf $1-patches.orig
	mkdir $1-patches.orig
	mv -u $1/*.patch $1-patches.orig/

	for i in $1-patches.orig/*.patch; do
		if [ ! -f "$i" ]; then
			echo -e "${RED}No patches found in $1${NORMAL}"
			break;
		fi
		echo -e "${GREEN}Refresh backport patch${NORMAL}: ${BLUE}$i${NORMAL}"
		quilt import $i
		quilt push -f
		RET=$?
		if [[ $RET -ne 0 ]]; then
			echo -e "${RED}Refreshing $i failed${NORMAL}, update it"
			echo -e "use ${CYAN}quilt edit [filename]${NORMAL} to apply the failed part manually"
			echo -e "use ${CYAN}quilt refresh${NORMAL} after the files are corrected and rerun this script"
			exit $RET
		fi
		QUILT_DIFF_OPTS="-p" quilt refresh -p ab --no-index --no-timestamp
	done
}

# ###################################################
# main
#

# we need quilt
if ! which quilt >/dev/null 2>&1; then
	echo "-E- quilt is not installed, please install quilt and rerun the script"
	exit 1
fi

rm -rf .pc*
for bdir in backports backports-2.6.16
do
	if [ -d $bdir ]; then
		rm -f $bdir/series
		patchRefresh $bdir
		mv .pc .pc-$bdir
	fi
done

echo
echo ------------------------------------------------------------
echo

for bdir in backports-2.6.16 backports
do
	if [ ! -d $bdir ]; then
		continue
	fi
	echo -e "${GREEN}Reversing patches from${NORMAL}: ${BLUE}$bdir${NORMAL}"
	rm -rf .pc
	mv .pc-$bdir .pc
	quilt pop -a -f
	RET=$?
	if [[ $RET -ne 0 ]]; then
		echo -e "${RED}Restoring $bdir failed${NORMAL}"
		exit $RET
	fi
	rm -rf .pc
	rm -rf $bdir/series $bdir-patches.orig $bdir/*.patch~
done
