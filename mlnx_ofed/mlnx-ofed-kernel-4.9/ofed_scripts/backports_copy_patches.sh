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
# Author: Alaa Hleihel <alaa@mellanox.com>
#

SCRIPTPATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

SDIR="backports_new"
TDIR="backports"

usage()
{
	cat <<EOF

Usage:
	${0}

Note: No flags are required.

Description:
This tool compares backport patches under '${TDIR}' and '${SDIR}' directories,
and copies new/modified patches from '${SDIR}' to '${TDIR}'.

EOF
}

ex()
{
	if ! eval "$@"; then
		echo "-E- Failed command: $@\n" >&2
		exit 1
	fi
}

IGNORE_FILES=
STASHED_FILES=
while [ ! -z "$1" ]
do
	case "$1" in
		-h | *help | *usage)
		usage
		exit 0
		;;
		*)
	esac
	shift
done

if [ ! -e "${SDIR}" ]; then
	echo "-E- '${SDIR}' directory does not exist!" >&2
	exit 1
fi

if [ ! -e "${TDIR}" ]; then
	ex "mkdir -p ${TDIR}"
fi

changes=0
new_files=0
echo "Scanning ${SDIR} for new/modified backports..."
for bp in $(/bin/ls ${SDIR}/*patch)
do
	fname=$(basename ${bp})

	patched_file=$(cat ${bp} | diffstat -l -p1 | head -1)
	nfname=$(grep -lw "${patched_file}" ${TDIR}/*.patch)
	if [ "X${nfname}" != "X" ]; then
		fname=$(basename ${nfname})
	fi

	if [ ! -e "${TDIR}/${fname}" ]; then
		echo "Copying new backport '${fname}'"
		ex "/bin/cp -f ${bp} ${TDIR}/${fname}"
		let changes++
		new_files=1
		continue
	fi

	# Already exists, check if there is a real diff
	if (diff -u ${bp} ${TDIR}/${fname} 2>/dev/null | grep -vE -- "^(\-\-\-|\+\+\+) backports|insertions|\+\+$|\-\-$" | grep -E -- "^(\-|\+)" | grep -qvE -- "^(\-|\+)@@|files changed"); then
		echo "Updating existing backport '${TDIR}/${fname}'"
		ex "/bin/cp -f ${bp} ${TDIR}/${fname}"
		let changes++
		continue
	fi
done

echo
if [ $changes -eq 0 ]; then
	echo "No new changes."
else
	echo "Updated ${changes} backport(s) patches under '${TDIR}' directory."
	if [ $new_files -eq 1 ]; then
		echo "Remember to run 'git add <files>' on newly created backport patch files, or simply 'git add ${TDIR}'"
	fi
fi
echo
