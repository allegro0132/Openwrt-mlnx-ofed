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

usage()
{
	cat <<EOF

Usage:
	${0} [OPTIONS]

	--backports-dir <dir>      Backports directory to scan (option can be repeated)
	--path <path>              Get backport patches matching this patch (option can be repeated).

Description:
Get list of patches that touches given path(s).

EOF
}

ex()
{
	if ! eval "$@"; then
		echo "-E- Failed command: $@\n" >&2
		exit 1
	fi
}

patches_dir=
paths_regex=
while [ ! -z "$1" ]
do
	case "$1" in
		--backports-dir)
		patches_dir="${patches_dir} ${2}"
		shift
		;;
		--path)
		if [ "X${paths_regex}" == "X" ]; then
			paths_regex="${2}"
		else
			paths_regex="${paths_regex}|${2}"
		fi
		shift
		;;
		-h | *help | *usage)
		usage
		exit 0
		;;
		*)
		echo "-E- unsupported option '$1' !" >&2
		exit 1
		;;
	esac
	shift
done

if [ "X${patches_dir}" == "X" ]; then
	echo "-E- --backports-dir not provided!" >&2
	exit 1
fi
if [ "X${paths_regex}" == "X" ]; then
	echo "-E- --path not provided!" >&2
	exit 1
fi

relevant_patches=
for curr_patches_dir in "${patches_dir}"
do
	echo "-I- Scanning backport patches under ${curr_patches_dir} ..."
	for backport in ${curr_patches_dir}/*.patch;
	do
		for patched_file in $(cat ${backport} | diffstat -l -p1)
		do
			if (echo ${patched_file} | grep -qE -- "${paths_regex}"); then
				if ! (echo -e "${relevant_patches}" | grep -wq -- "${backport}"); then
					relevant_patches="${backport}\n${relevant_patches}"
				fi
			fi
		done
	done
done

if [ "X${relevant_patches}" == "X" ]; then
	echo "-I- No relevant backport patches"
else
	echo -e "${relevant_patches}"
fi
