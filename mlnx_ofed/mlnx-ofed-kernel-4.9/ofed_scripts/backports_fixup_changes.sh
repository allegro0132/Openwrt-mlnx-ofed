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

current_branch=`git rev-parse --abbrev-ref HEAD`
orig_branch=`echo $current_branch | sed -e 's/backport-//'`


usage()
{
	cat <<EOF

Usage:
	${0} [Whitespace separated list of files to ignore]

Description:
This tool takes staged new/modified files and either create a new
backport commit (that will be converted to patch file later), or
fixup (squash) the changes to an existing backport commit for the
respective modified file.
In case that the script needs to fixup to an existing backport commit,
it will automatically rebase with --autosquash option.

If you have files that should not be modified by backports (like compat),
then simply provide their paths to the script so that they will be ignored,
e.g:
    $ ${0} compat/config/rdma.m4 include/linux/netdevice.h
The script will leave these files alone.

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
		if [ ! -e "$1" ]; then
			echo "-E- Path '$1' does not exist!" >&2
			exit 1
		fi
		if [ "X$IGNORE_FILES" == "X" ]; then
			IGNORE_FILES="$1"
		else
			IGNORE_FILES="$IGNORE_FILES|$1"
		fi
		;;
	esac
	shift
done

if ! [[ "$current_branch" =~ ^backport-.* ]]; then
	echo "-E- You are not on backports branch!" >&2
	exit 1
fi

echo "Scanning working directory for modified files..."

err=0
while read -r ff
do
	fpath=$(echo ${ff} | sed -e 's/^.*\s//g')
	if [ "X${IGNORE_FILES}" != "X" ]; then
		if (echo "${IGNORE_FILES}" | grep -q -- "${fpath}"); then
			continue
		fi
	fi
	echo "There are unstaged changes in '${fpath}'" >&2
	err=1
done < <(git status --porcelain | grep -E -- '^[[:space:]](A|M)[[:space:]]+')
if [ $err -eq 1 ]; then
	echo "" >&2
	echo "Please stage them (run 'git add <files>') or provide them to the script to be ignored." >&2
	echo "Cannot continue!" >&2
	exit 1
fi

changes=0
fixup=0
while read -r ff
do
	fpath=$(echo ${ff} | sed -e 's/^.*\s//g')
	if [ "X${IGNORE_FILES}" != "X" ]; then
		if (echo "${IGNORE_FILES}" | grep -q -- "${fpath}"); then
			echo "-I- Ignoring ${fpath} ..."
			STASHED_FILES="${fpath}\n${STASHED_FILES}"
			continue
		fi
	fi

	last_commit_id=$(git log -1 --format="%h" ${fpath})
	last_commit_subject=$(git log -1 --format="%s" ${fpath})

	let changes++
	if (echo "${last_commit_subject}" | grep -Eq -- "(fixup.*BACKPORT:[[:space:]]${fpath}|BACKPORT:[[:space:]]${fpath})"); then
		echo "Fixup ${fpath} changes to prev backport commit --> ${last_commit_subject}"
		ex "git commit ${fpath} --fixup ${last_commit_id} --no-edit >/dev/null"
		fixup=1
	else
		echo "Creating new commit for backporting: ${fpath}"
		message="BACKPORT: ${fpath}"
		ex "git commit ${fpath} -m '${message}' --no-edit >/dev/null"
	fi

done < <(git status --porcelain | grep -E -- '^([[:space:]])*(A|M)[[:space:]]+')

if [ $fixup -ne 0 ]; then
	if [ "X${STASHED_FILES}" != "X" ]; then
		echo
		echo "Running 'git stash' to save these files:"
		echo -e "$STASHED_FILES"
		echo "-------------------------------------------------------------------------------"
		ex "git stash"
		echo "-------------------------------------------------------------------------------"
	fi

	echo
	echo "Going to rebase and autosquash changes..."
	echo "-------------------------------------------------------------------------------"
	ex "env EDITOR=: GIT_EDITOR=: git rebase -i --autosquash ${orig_branch}"
	echo "-------------------------------------------------------------------------------"

	if [ "X${STASHED_FILES}" != "X" ]; then
		echo
		echo "Running 'git stash pop' to restore these files:"
		echo -e "$STASHED_FILES"
		echo "-------------------------------------------------------------------------------"
		ex "git stash pop"
		echo "-------------------------------------------------------------------------------"
	fi
fi

echo
if [ $changes -eq 0 ]; then
	echo "No new changes."
else
	echo "Updated ${changes} backport commit(s)."
	echo "Now, you can run './ofed_scripts/ofed_get_patches.sh' to generate the updated backport patch files."
	echo
	echo "Note: When you switch to the original branch, run './ofed_scripts/backports_copy_patches.sh' to copy new/modified backports."
fi
echo
