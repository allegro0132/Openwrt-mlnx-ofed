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
# Usage: ofed_checkout.sh [branch]
#        must be launched from top of git repo

# get ref to "real" stdout
exec 3>&1

# Execute command w/ echo and exit if it fails
ex()
{
        echo "$@" >&3
        eval "$@"
        if [ $? -ne 0 ]; then
                printf "\nFailed executing $@\n" >&3
                exit 1
        fi
}

# Like ex above, but command is self echoing on stderr
xex()
{
        eval "$@" 2>&3
        if [ $? -ne 0 ]; then
                printf "\nFailed executing $@\n" >&3
                exit 1
        fi
}

# branch defaults to ofed_kernel
branch=${1:-ofed_kernel}

git checkout -f ${branch}

ex git update-ref HEAD ${branch}

ln -snf ofed_scripts/configure
ln -snf ofed_scripts/Makefile
ln -snf ofed_scripts/makefile
