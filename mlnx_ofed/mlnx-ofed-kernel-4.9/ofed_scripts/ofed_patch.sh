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

usage()
{
cat << EOF
\`ofed_patch.sh' applies kernel fixes and backport patches

Usage:  `basename $0` [options]

    --with-backport=VERSION  apply these backports [backports]
    --kernel-version=VERSION  apply backports for this kernel [$(uname -r)]
    --with-git[=TMP_BRANCH]  use git, create a temporary branch [backport-`git rev-parse --abbrev-ref HEAD`]
    --without-git        don't use git
    --with-quilt[=FILE]  path to quilt [$(/usr/bin/which quilt  2> /dev/null)]
    --without-quilt  use patch and not quilt [no]
    --with-patchdir=DIR  path to the patches directory []
    --without-patch  don't apply any patch [no]

    --with-kernel-fixes apply fixes (patches) to kernel sources [yes]
    --without-kernel-fixes don't apply patches to kernel sources

    --with-backport-patches apply backport patches [yes]
    --without-backport-patches don't apply backport patches

    --with-hpage-patch apply huge pages patch [no]
    --without-hpage-patch don't apply huge pages patch [yes]

    --help - print out options

EOF
}

# Execute command w/ echo and exit if it fail
ex()
{
        echo "$@"
        if ! "$@"; then
                printf "\nFailed executing $@\n\n"
                exit 1
        fi
}

# Apply patch
apply_patch()
{
        local patch=$1
        shift

        if [ -e  ${patch} ]; then
            printf "\t${patch}\n"
            if [ "${WITH_GIT}" == "yes" ]; then
                ex $GIT am $REJECT < ${patch}
            elif [ "${WITH_QUILT}" == "yes" ]; then
                ex $QUILT import ${patch}
                ex $QUILT push patches/${patch##*/}
            else
                if ! ($PATCH < ${patch} ); then
                    echo "Failed to apply patch: ${patch}"
                    exit 1
                fi
            fi
        else
                echo File ${patch} does not exist
                return 1
        fi
        return 0
}

apply_kernel_fixes()
{

    if [ ! -d ${CWD}/kernel_patches/fixes ]; then
        echo "${CWD}/kernel_patches/fixes directory does not exist"
        return 0
    fi
    if [ "${WITH_GIT}" == "yes" ]; then
        ex $GIT am $REJECT ${CWD}/kernel_patches/fixes/*.patch
    else
        for patch in ${CWD}/kernel_patches/fixes/*
        do
            apply_patch ${patch}
        done
    fi
}

# Apply patches from the given directory
apply_backport_patches()
{
        local pdir=${CWD}/${BACKPORT_DIR}
        shift
        printf "\nApplying patches for ${BACKPORT_DIR} kernel:\n"
        if [[ "${WITH_GIT}" == "yes" && "$current_branch" != "$branch" ]]; then
            ex $GIT checkout -b $branch
        fi
        if [ -d ${pdir} ]; then
            if [ "${WITH_GIT}" == "yes" ]; then
                ex $GIT am $REJECT ${pdir}/*.patch
            else
                for patch in ${pdir}/*
                do
                    apply_patch ${patch}
                done
            fi
        else
                echo ${pdir} no such directory
        fi
}

# Apply patches
patches_handle()
{
    ex mkdir -p ${CWD}/patches
    quiltrc=${CWD}/patches/quiltrc
    ex touch ${quiltrc}

cat << EOF >> ${quiltrc}
QUILT_DIFF_OPTS='-x .svn -p --ignore-matching-lines=\$Id'
QUILT_PATCH_OPTS='-l'
EOF

    QUILT="${QUILT} --quiltrc ${quiltrc}"

    if [ -n "${PATCH_DIR}" ]; then
            # Apply user's patches
            for patch in ${PATCH_DIR}/*
            do
                    apply_patch ${patch}
            done

    else
            # Apply kernel fixes
            if [ "X${WITH_KERNEL_FIXES}" == "Xyes" ]; then
                apply_kernel_fixes
            fi

            # Apply backport patches
            echo "getting backport dir for kernel version ${KVERSION}"
            BACKPORT_DIR="backports"
            echo "found backport dir ${BACKPORT_DIR}"
            if [ -n "${BACKPORT_DIR}" ]; then
                    if [ "X${WITH_BACKPORT_PATCHES}" == "Xyes" ]; then
                            apply_backport_patches
                    fi
                    BACKPORT_INCLUDES='-I${CWD}/kernel_addons/backport/'${BACKPORT_DIR}/include/
            fi

    fi

    # quilt leaves some files in .pc with no permissions
    if [ -d ${CWD}/.pc ]; then
        ex chmod -R u+rw ${CWD}/.pc
    fi
}

main()
{
        # Parsing parameters
        while [ ! -z "$1" ]
        do
                case $1 in
                        -kernel-version | --kernel-version | --kern-ver | --ker-ver)
                                shift
                                KVERSION=$1
                        ;;
                        -kernel-version=* | --kernel-version=* | --kern-ver=* | --ker-ver=*)
                                KVERSION=`expr "x$1" : 'x[^=]*=\(.*\)'`
                        ;;
                        -with-git | --with-git)
                                WITH_GIT="yes"
                                if [ ! -z "$2" ] && [ "`echo -n $2 | cut -c 1`" != '-' ]; then
                                        shift
                                        GIT_BRANCH=$1
                                fi
                        ;;
                        -with-git=* | --with-git=*)
                                WITH_GIT="yes"
                                GIT_BRANCH=`expr "x$1" : 'x[^=]*=\(.*\)'`
                        ;;
                        --without-git)
                                WITH_GIT="no"
                        ;;
                        -with-quilt | --with-quilt)
                                WITH_QUILT="yes"
                                if [ ! -z "$2" ] && [ "`echo -n $2 | cut -c 1`" != '-' ]; then
                                        shift
                                        QUILT=$1
                                        if [ ! -x ${QUILT} ]; then
                                                echo "${QUILT} does not exist"
                                                exit 1
                                        fi
                                fi
                        ;;
                        -with-quilt=* | --with-quilt=*)
                                WITH_QUILT="yes"
                                QUILT=`expr "x$1" : 'x[^=]*=\(.*\)'`
                                if [ ! -x ${QUILT} ]; then
                                        echo "${QUILT} does not exist"
                                        exit 1
                                fi
                        ;;
                        --without-quilt)
                                WITH_QUILT="no"
                        ;;
                        -with-patchdir | --with-patchdir)
                                shift
                                WITH_PATCH="yes"
                                PATCH_DIR=$1
                        ;;
                        -with-patchdir=* | --with-patchdir=*)
                                PATCH_DIR=`expr "x$1" : 'x[^=]*=\(.*\)'`
                                WITH_PATCH="yes"
                        ;;
                        --without-patch)
                                WITH_PATCH="no"
                                WITH_KERNEL_FIXES="no"
                                WITH_BACKPORT_PATCHES="no"
                        ;;
                        --with-kernel-fixes)
                                WITH_KERNEL_FIXES="yes"
                                WITH_PATCH="yes"
                        ;;
                        --without-kernel-fixes)
                                WITH_KERNEL_FIXES="no"
                        ;;
                        --with-hpage-patch)
                                WITH_HPAGE_PATCH="yes"
                                WITH_PATCH="yes"
                        ;;
                        --without-hpage-patch)
                                WITH_HPAGE_PATCH="no"
                        ;;
                        --with-backport-patches)
                                WITH_BACKPORT_PATCHES="yes"
                                WITH_PATCH="yes"
                        ;;
                        --without-backport-patches)
                                WITH_BACKPORT_PATCHES="no"
                        ;;
                        --with-backport)
                                shift
                                BACKPORT_DIR=$1
                        ;;
                        --with-backport=*)
                                BACKPORT_DIR=`expr "x$1" : 'x[^=]*=\(.*\)'`
                        ;;
                        -h | --help)
                                usage
                                exit 0
                        ;;
                        *)
                                echo
                                echo "Wrong parameter $1"
                                echo
                                usage
                                exit 1
                        ;;
                esac
                shift

        done

#Set default values
KVERSION=${KVERSION:-$(uname -r)}
WITH_GIT=${WITH_GIT:-"yes"}
WITH_QUILT=${WITH_QUILT:-"no"}
WITH_PATCH=${WITH_PATCH:-"yes"}
WITH_KERNEL_FIXES=${WITH_KERNEL_FIXES:-"yes"}
BACKPORT_INCLUDES=""

WITH_BACKPORT_PATCHES=${WITH_BACKPORT_PATCHES:-"yes"}
WITH_HPAGE_PATCH=${WITH_HPAGE_PATCH:-"no"}

QUILT=${QUILT:-$(/usr/bin/which quilt  2> /dev/null)}
GIT=${GIT:-$(/usr/bin/which git 2> /dev/null)}
REJECT="--reject"

if [[ ! -x "$GIT" || ! -d ".git" ]]; then
    WITH_GIT="no"
fi

if [ "$WITH_GIT" == "yes" ]; then
    current_branch=`git rev-parse --abbrev-ref HEAD`
    case $current_branch in
        backport*)
        branch=$current_branch
        ;;
        *)
        branch="backport-${GIT_BRANCH:-$current_branch}"
        ;;
    esac
fi

if (patch --version 2>&1 | grep -iq BusyBox); then
	PATCH="patch -p1"
else
	PATCH="patch -p1 -l"
fi

CWD=$(pwd)
PATCH_DIR=${PATCH_DIR:-""}

        # Check parameters
        if [ "$WITH_PATCH" == "yes" ] && [ "$WITH_QUILT" == "yes" ] && [[ ! -x ${QUILT} || ! -n "${QUILT}" ]]; then
                echo "Quilt ${QUILT} does not exist... Going to use patch."
                WITH_QUILT="no"
        fi

        patches_handle

        touch backports_applied
}

main $@
