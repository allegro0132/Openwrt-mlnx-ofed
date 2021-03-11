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

usage()
{
cat << EOF
	Usage: `basename $0` <OPTIONS>

	OPTIONS:
		get-distro
		get-distro-major
EOF
}

get_distro()
{
	case "$(rpm -qf /etc/issue)" in
	redhat-release-5Server-5.2*|centos-release-5-2.el5.centos*)
	distro=rhel5.2
	;;
	redhat-release-5Server-5.3*|redhat-release-5Client-5.3*|centos-release-5-3*)
	distro=rhel5.3
	;;
	redhat-release-5Server-5.4*|redhat-release-5Client-5.4*|entos-release-5-4*)
	distro=rhel5.4
	;;
	redhat-release-5Server-5.5*|redhat-release-5Client-5.5*|centos-release-5-5*|enterprise-release-5*)
	if (grep -q XenServer /etc/issue 2> /dev/null); then
		distro=xenserver6
	else
		distro=rhel5.5
	fi
	;;
	redhat-release-5Server-5.6*|redhat-release-5Client-5.6*|centos-release-5-6*)
	distro=rhel5.6
	;;
	redhat-release-5Server-5.7*|redhat-release-5Client-5.7*|centos-release-5-7*)
	if (grep -q XenServer /etc/issue 2> /dev/null); then
		distro=xenserver6.1
	else
		distro=rhel5.7
	fi
	;;
	redhat-release-5Server-5.8*|redhat-release-5Client-5.8*|centos-release-5-8*)
	distro=rhel5.8
	;;
	redhat-release-5Server-5.9*|redhat-release-5Client-5.9*|centos-release-5-9*)
	distro=rhel5.9
	;;
	redhat-release-server-*6.0*|redhat-release-client-*6.0*|centos-release-6-0*|centos-*6Server-*6.0*|enterprise-release-*6.0*)
	distro=rhel6.0
	;;
	redhat-release-server-*6.1*|redhat-release-client-*6.1*|centos-*6?1*|enterprise-release-*6.1*)
	distro=rhel6.1
	;;
	redhat-release-server-*6.2*|redhat-release-client-*6.2*|centos-*6?2*|enterprise-release-*6.2*)
	distro=rhel6.2
	;;
	redhat-release-server-*6.3*|redhat-release-client-*6.3*|centos-*6?3*|enterprise-release-*6.3*)
	distro=rhel6.3
	;;
	redhat-release-server-*6.4*|redhat-release-client-*6.4*|centos-*6?4*|enterprise-release-*6.4*)
	distro=rhel6.4
	;;
	redhat-release-server-*6.5*|redhat-release-client-*6.5*|centos-*6?5*|enterprise-release-*6.5*)
	distro=rhel6.5
	;;
	redhat-release-server-*6.6*|redhat-release-client-*6.6*|centos-*6?6*|enterprise-release-*6.6*)
	distro=rhel6.6
	;;
	redhat-release*-7.0*|centos-release-7-0*|sl-release-7.0*)
	distro=rhel7.0
	;;
	redhat-release*-7.1*|centos-release-7-1*|sl-release-7.1*)
	distro=rhel7.1
	;;
	oraclelinux-release-7-1*)
	distro=oel7.1
	;;
	oraclelinux-release-7-0*)
	distro=oel7.0
	;;
	oraclelinux-release-6Server-7*)
	distro=oel6.7
	;;
	oraclelinux-release-6Server-6*)
	distro=oel6.6
	;;
	oraclelinux-release-6Server-5*)
	distro=oel6.5
	;;
	oraclelinux-release-6Server-4*)
	distro=oel6.4
	;;
	oraclelinux-release-6Server-3*)
	distro=oel6.3
	;;
	oraclelinux-release-6Server-2*)
	distro=oel6.2
	;;
	oraclelinux-release-6Server-1*)
	distro=oel6.1
	;;
	sles-release-10-15.35)
	distro=sles10sp2
	;;
	sles-release-10-15.45.8)
	distro=sles10sp3
	;;
	sles-release-10-15.57.1)
	distro=sles10sp4
	;;
	sles-release-11-72.13)
	distro=sles11
	;;
	sles-release-11.1-1.152)
	distro=sles11sp1
	;;
	sles-release-11.2*)
	distro=sles11sp2
	;;
	sles-release-11.3*)
	distro=sles11sp3
	;;
	sles-release-12-1*)
	distro=sles12sp0
	;;
	fedora-release-14*)
	distro=fc14
	;;
	fedora-release-15*)
	distro=fc15
	;;
	fedora-release-16*)
	distro=fc16
	;;
	fedora-release-17*)
	distro=fc17
	;;
	fedora-release-18*)
	distro=fc18
	;;
	fedora-release-19*)
	distro=fc19
	;;
	fedora-release-20*)
	distro=fc20
	;;
	openSUSE-release-11.1*)
	distro=openSUSE11sp1
	;;
	openSUSE-release-12.1*)
	distro=openSUSE12sp1
	;;
	openSUSE-release-13.1*)
	distro=openSUSE13sp1
	;;
	*)
	distro=unsupported
	;;
	esac

	echo $distro
}

get_distro_major()
{
	case "$1" in
	sles11*|openSUSE12*)
	distro_major=sles11
	;;
	sles10*|openSUSE11*)
	distro_major=sles10
	;;
	rhel7*)
	distro_major=rhel7
	;;
	rhel6*)
	distro_major=rhel6
	;;
	rhel5*)
	distro_major=rhel5
	;;
	xenserver6*)
	distro_major=xenserver6
	;;
	*)
	distro_major="unsupported"
	;;
	esac

	echo $distro_major
}


main()
{
	case "$1" in
	get-distro)
	get_distro
	exit 0
	;;
	get-distro-major)
	get_distro_major `get_distro`
	exit 0
	;;
	-h | --help)
	usage
	exit 0
	;;
	*)
	usage
	exit 1
	;;
	esac
}

main $@
