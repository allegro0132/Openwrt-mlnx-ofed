#!/bin/bash
#
# Copyright (c) 2006 Mellanox Technologies. All rights reserved.
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

get_backport_dir()
{
    case $1 in
        2.6.9-42*)
                echo 2.6.9_U4
        ;;
        2.6.9-55*)
                echo 2.6.9_U5
        ;;
        2.6.9-67*)
                echo 2.6.9_U6
        ;;
        2.6.9-78*)
                echo 2.6.9_U7
        ;;
        2.6.9-89*)
                echo 2.6.9_U8
        ;;
        2.6.16.*-*-*)
                minor=$(echo $KVERSION | cut -d"." -f4 | cut -d"-" -f1)
                if [ $minor -lt 37 ]; then
                        echo 2.6.16_sles10
                elif [ $minor -lt 60 ]; then
                        echo 2.6.16_sles10_sp1
                else
                        subminor=$(echo $KVERSION | cut -d "-" -f 2 | cut -d"." -f2)
                        if [ $subminor -lt 49 ]; then
                                echo 2.6.16_sles10_sp2
                        else
                                echo 2.6.16_sles10_sp3
                        fi
                fi
        ;;
        2.6.16-*-*)  # for SLES10 SP1 lustre ( 2.6.16-54-0.2.5_lustre.1.6.4.3-smp )
                minor=$(echo $KVERSION | cut -d"." -f3 | cut -d"-" -f2)
                if [ $minor -lt 60 ]; then
                        echo 2.6.16_sles10_sp1
                else
                        echo 2.6.16_sles10_sp2
                fi
        ;;
        2.6.16*)
                echo 2.6.16
        ;;
        2.6.17*)
                echo 2.6.17
        ;;
        2.6.18.8-xen*)
                echo 2.6.18.8-xen
        ;;
        2.6.18*-*chaos)
                echo 2.6.18-chaos
        ;;
        2.6.18-*.el5*)
                minor=$(echo $KVERSION | cut -d"." -f3 | cut -d"-" -f2)
                if [ $minor -lt 50 ]; then
                        echo 2.6.18_FC6
                elif [ $minor -lt 84 ]; then
                        echo 2.6.18-EL5.1
                elif [ $minor -lt 128 ]; then
                        echo 2.6.18-EL5.2
                elif [ $minor -lt 155 ]; then
                        echo 2.6.18-EL5.3
                elif [ $minor -lt 186 ]; then
                        echo 2.6.18-EL5.4
                elif [ $minor -lt 229 ]; then
                        echo 2.6.18-EL5.5
                elif [ $minor -lt 259 ]; then
                        echo 2.6.18-EL5.6
                else
                        echo 2.6.18-EL5.7
                fi
        ;;
        2.6.18-*fc[56]*)
                echo 2.6.18_FC6
        ;;
        2.6.18.*-*-*)
                middle=$(echo $KVERSION | cut -d"-" -f2)
                if [ $middle -lt 34 ]; then
                        echo 2.6.18
                else
                        echo 2.6.18_suse10_2
                fi
        ;;
        2.6.18*)
                echo 2.6.18
        ;;
        2.6.19*)
                echo 2.6.19
        ;;
        2.6.20*)
                echo 2.6.20
        ;;
        2.6.21*)
                echo 2.6.21
        ;;
        2.6.22.*-*-rt)
                echo 2.6.22_slert10_sp2
        ;;
        2.6.22.*-*-*)
                echo 2.6.22_suse10_3
        ;;
        2.6.22*)
                echo 2.6.22
        ;;
        2.6.23*)
                echo 2.6.23
        ;;
        2.6.24.7-*)
                echo 2.6.24-rt
        ;;
        2.6.24*)
                echo 2.6.24
        ;;
        2.6.25.*-*-*)
                echo 2.6.25_suse11
        ;;
        2.6.25*)
                echo 2.6.25
        ;;
        2.6.26*)
                echo 2.6.26
        ;;
        2.6.27.*-*)
		minor=$(echo $KVERSION | cut -d "." -f 4 | cut -d "-" -f 1)
		if [ $minor -lt 25 ]; then
                	echo 2.6.27_sles11
		else
                	echo 2.6.27_sles11_update
		fi
        ;;
        2.6.27*)
                echo 2.6.27
        ;;
        2.6.28*)
                echo 2.6.28
        ;;
        2.6.29*)
                echo 2.6.29
        ;;
        2.6.30*)
                echo 2.6.30
        ;;
        2.6.31*)
                echo 2.6.31
        ;;
#         2.6.32*xen*)
#                 echo 2.6.32-xen
#         ;;
        2.6.32*el6* | 2.6.32*chaos*)
		minor=$(echo $KVERSION | cut -d "." -f 3 | cut -d "-" -f 2)
                # RHEL6.0 (minor=131) and RHEL6.1 backports are the same
		if [ $minor -lt 202 ]; then
			echo 2.6.32-EL6
		else
			echo 2.6.32-EL6.2
		fi
        ;;
        2.6.32*)
                echo 2.6.32
        ;;
        2.6.33*)
                echo 2.6.33
        ;;
        2.6.34*)
                echo 2.6.34
        ;;
        2.6.35*)
                echo 2.6.35
        ;;
        2.6.36*)
                echo 2.6.36
        ;;
        2.6.37*)
                echo 2.6.37
        ;;
        2.6.38*)
                echo 2.6.38
        ;;
        2.6.39*)
                echo 2.6.39
        ;;
        3.0* | 2.6.40*)
                echo 3.0
        ;;
        3.1* | 2.6.41*)
                echo 3.1
        ;;
        3.2* | 2.6.42*)
                echo 3.2
        ;;
        3.3* | 2.6.43*)
                echo 3.3
        ;;
        3.4* | 2.6.44*)
                echo 3.4
        ;;
        *)
                echo
        ;;
    esac

}

if [ -z "$1" ]; then
	KVERSION=$(uname -r)
else
	KVERSION=$1
fi

get_backport_dir ${KVERSION}
