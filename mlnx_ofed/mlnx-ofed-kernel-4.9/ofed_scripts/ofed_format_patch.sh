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

cwd=`dirname $0`
out=backports_new

if [ -d $out ]; then 
	if [ "$(ls -A $out)" ]; then
		echo "output directory $out is not empty. Should delete all files in it?"
		read -p "Are you sure? " -n 1
		echo
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo "Removing $out"
			rm -fr $out
		else
			echo "Aborting"
			exit
		fi
	fi
fi

echo "Preparing patches"

git format-patch -o $out --subject-prefix="PATCH" --no-numbered --diff-algorithm=myers $1

echo "Stripping id's from patches"
for f in $out/*.patch; do
	$cwd/strip.sh $f;
done

$cwd/validate_backport_patches.sh $out
