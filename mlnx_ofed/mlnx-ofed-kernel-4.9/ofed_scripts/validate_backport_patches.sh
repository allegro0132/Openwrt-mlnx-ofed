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

patches_dir=${1}; shift

if [ ! -e "${patches_dir}" ]; then
	echo "-E- patches_dir not provided!" >&2
	exit 1
fi

echo "Validating backport patches under ${patches_dir} ..."

rc=0
for backport in ${patches_dir}/*.patch;
do
	for patched_file in $(cat ${backport} | diffstat -l -p1)
	do
		if (grep -lw a/${patched_file} ${patches_dir}/*.patch | grep -qv $(basename ${backport}) ); then
			echo "--------------------------------------------------------------"
			echo "-E- '$patched_file' was modified by more than one backport patch!!!"
			grep -l ${patched_file} ${patches_dir}/*.patch
			echo "--------------------------------------------------------------"
			echo
			rc=1
		fi
	done
done

if [ $rc -eq 0 ]; then
	echo "PASS: backports are OK."
else
	echo "FAIL: backports are invalid, please fix the above issues!"
fi
exit $rc
