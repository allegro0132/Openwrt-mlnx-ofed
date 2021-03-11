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
kernelver=$1
kernel_source_dir=$2
PACKAGE_NAME=$3
PACKAGE_VERSION=$4

config_flag=`/var/lib/dkms/${PACKAGE_NAME}/${PACKAGE_VERSION}/source/ofed_scripts/dkms_ofed $kernelver $kernel_source_dir get-config`

if [ -e ./configure.mk.kernel ]; then
    make distclean
fi

NJOBS=`MLXNUMC=$(grep ^processor /proc/cpuinfo | wc -l) && echo $(($MLXNUMC<16?$MLXNUMC:16))`

find compat -type f -exec touch -t 200012201010 '{}' \; || true
./configure --kernel-version=$kernelver --kernel-sources=$kernel_source_dir ${config_flag} --with-njobs=${NJOBS:-1}

make -j${NJOBS:-1}

./ofed_scripts/install_helper

# copy the ofa-kernel build headers
export ofa_build_src=/usr/src/ofa_kernel/${kernelver}
./ofed_scripts/dkms_ofed_post_build.sh
