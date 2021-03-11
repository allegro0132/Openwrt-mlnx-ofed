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

SCRIPTPATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

current_branch=`git rev-parse --abbrev-ref HEAD`
orig_branch=`echo $current_branch | sed -e 's/backport-//'`

if ! [[ "$current_branch" =~ ^backport-.* ]]; then
	echo "-E- You are not on backports branch!"
	exit 1
fi

rm -rf $SCRIPTPATH/../backports_new
$SCRIPTPATH/ofed_format_patch.sh $orig_branch
RC=$?
rm -f $SCRIPTPATH/../backports_new/*.orig
exit $RC
