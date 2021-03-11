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

kernelver=${1:-$(uname -r)}

is_installed()
{
    if [ "X$(dpkg-query -l $1 2> /dev/null | awk '/^[rhi][iU]/{print $2}')" != "X" ]; then
        return 0
    else
        return 1
    fi
}

echo
echo ------------------------------------------
echo ----- mlnx-ofed-kernel post-install ------
for mod in srp iser isert mlnx-nfsrdma mlnx-nvme mlnx-rdma-rxe
do
    echo
    if ! is_installed ${mod}-dkms ; then
        echo "Package '${mod}-dkms' is not installed, skipping module '$mod'."
        continue
    fi

    version=`dpkg-query -W -f='${Version}' "${mod}-dkms" | sed -e 's/[+-].*//'`
    isadded=`dkms status -m "$name" -v "$version" -k $kernelver`

    if (dkms status "$mod" -v "$version" -k $kernelver 2>/dev/null | grep -qwi installed); then
        echo "Module '$mod' is already installed for kernel $kernelver."
        continue
    fi

    echo "Going to build and install module '$mod' for kernel $kernelver."
    if [ "x${isadded}" = "x" ] ; then
        dkms add -m "$mod" -v "$version"
    fi
    # build it
    if ! (dkms build -m "$mod" -v "$version" -k $kernelver); then
        echo "Error! Module build failed for '$mod' $version !" >&2
        continue
    fi
    # install it
    if ! (dkms install -m "$mod" -v "$version" -k $kernelver --force); then
        echo "Error! Module install failed for '$mod' $version !" >&2
        continue
    fi
done
echo ------------------------------------------
echo
