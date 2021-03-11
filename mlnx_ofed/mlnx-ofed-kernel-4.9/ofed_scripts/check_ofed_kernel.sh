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
# This script check ofed_kernel compilation with kernel from kernel.org

usage()
{
cat << EOF

	Usage: `basename $0` -g|--git <ofed kernel git url> 
			     -k|--kernel <kernel version>
			     [-b|--branch <git branch>]

EOF
}

if [ -z "$1" ]; then
	usage
	exit 1
fi

while [ ! -z "$1" ]
do
	case "$1" in
	-g | --git)
		giturl=$2
		shift 2
	;;
	-k | --kernel)
		kernel=$2
		shift 2
	;;
	-b | --branch)
		head=$2
		shift 2
	;;
	-h | --help)
		usage
		exit 0
	;;
	*)
		echo
		echo Wrong parameter $1
		echo
		usage
		exit 1
	;;
	esac
done

if [ -z "$giturl" ] || [ -z "$kernel" ]; then
	usage
	exit 1
fi

tmpdir=${tmpdir:-${HOME}/tmp}
arch=${arch:-$(uname -m)}
kernels=${kernels:-${HOME}/kernel.org/$arch}
korgurl="ftp://ftp.eu.kernel.org/pub/linux/kernel/v2.6"
project=ofed_kernel
log=${tmpdir}/${project}-${kernel}.log

core_options="--with-core-mod --with-user_mad-mod --with-user_access-mod \
		--with-addr_trans-mod"

if [ -z "$configure_options" ]; then
	configure_options=" \
		--with-mthca-mod --with-mthca_debug-mod \
		--with-mlx4-mod --with-mlx4_debug-mod --with-ipoib-mod \
		--with-ipoib_debug-mod --with-sdp-mod --with-sdp_debug-mod \
		--with-rds-mod --with-cxgb3-mod --with-nes-mod \
		${custom_options} \
		"
fi

rm -f $log
mkdir -p $tmpdir
mkdir -p $kernels

ex()
{
	echo "$@" | tee -a $log
	eval "$@" >> $log 2>&1
	status=$?
        if [ $status -ne 0 ]; then
		echo Failed executing:
		echo "$@"
		echo
		echo "See $log"
		exit $status
	fi
}

echo LOG: $log

# Prepare kernel sources
pushd $kernels
if [ ! -d linux-$kernel ]; then
	if [ ! -f linux-${kernel}.tar.bz2 ]; then
		ex wget $korgurl/linux-${kernel}.tar.bz2
	fi
	ex tar xjf linux-${kernel}.tar.bz2
	pushd linux-${kernel}
	ex make defconfig prepare scripts
	popd
	popd
fi

# Check ofed_kernel compilation
cd $tmpdir
rm -rf $tmpdir/$project-$kernel

ex git clone -q -s -n $giturl $tmpdir/$project-$kernel
pushd $tmpdir/$project-$kernel
head=${head:-`git show-ref -s -h -- HEAD | head -1`}

ex git checkout $head `git ls-tree -r --name-only $head \
                ofed_scripts/ofed_checkout.sh
                `
ex ofed_scripts/ofed_checkout.sh $head

ex ./configure ${core_options} ${configure_options} \
		--kernel-version=$kernel \
		--kernel-sources=$kernels/linux-${kernel}
ex make

cat << EOF

Passed $kernel

EOF
