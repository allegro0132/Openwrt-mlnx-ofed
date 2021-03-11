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
#
# Execute command w/ echo and exit if it fail
ex()
{
        makedist_log=$1
        shift
        if [ ! -z $makedist_log ]; then
            echo "$@ >> $makedist_log"
            eval "$@" >> $makedist_log 2>&1
        else
            echo "$@"
            eval "$@"
        fi
        status=$?
        if [ $status -ne 0 ]; then
                if [ ! -z $makedist_log ]; then
                    echo "Failed executing $@ >> $makedist_log" >&2
                    tail $makedist_log >&2
                else
                    echo "Failed executing $@" >&2
                fi
        		echo Build failed in $tmpdir >&2
                if [ ! -z $makedist_log ]; then
                    echo See log file $makedist_log >&2
                fi
                exit $status
        fi
}

CWD=`pwd`
project=${project:-"ofed_kernel"}
tmpdir=`mktemp -d /tmp/build-$project-XXXXXX`
giturl=${giturl:-${CWD}}
head=${head:-`git show-ref -s -h -- HEAD`}
backports=${backports:-`(cd kernel_patches/backport/ 2> /dev/null; ls)`}
destdir=${destdir:-${CWD}}

# Add reference to local git directory on git.openfabrics.org
git_reference_dir=${git_reference_dir:-"/home/vlad/scm/ofed_kernel.git"}

git_extra_flags=
if [ -d ${git_reference_dir} ]; then
	git_extra_flags="--reference ${git_reference_dir}"
fi

for backport in $backports
do
	if [ ! -d kernel_patches/backport/$backport ] && [ ! -d kernel_addons/backport/$backport ]
	then
		continue
	fi
	ex "" git clone -q -s -n $git_extra_flags $giturl $tmpdir/$project-$backport
	ex "" pushd $tmpdir/$project-$backport
	ex $tmpdir/$project-$backport.log \
        $CWD/ofed_scripts/ofed_checkout.sh $head
	ex $tmpdir/$project-$backport.log \
        $CWD/ofed_scripts/ofed_patch.sh --with-backport=$backport
	#Some QUILT versions create files with 0 permissions
	#work around this
	if [ -d .pc ]
	then
		ex "" chmod -R u+rw .pc
		ex "" chmod -R o+r .pc
	fi
	ex "" cd $tmpdir
	ex "" tar czf $tmpdir/$project-$backport.tgz $project-$backport
	ex "" popd
done

# create a tree with only the 'fixes' patches applied
if [ -d kernel_patches/fixes ]; then
	ex "" git clone -q -s -n $git_extra_flags $giturl $tmpdir/$project-fixes
	ex "" pushd $tmpdir/$project-fixes
	ex $tmpdir/$project-fixes.log \
		$CWD/ofed_scripts/ofed_checkout.sh $head
	ex $tmpdir/$project-fixes.log BACKPORT_DIR='NONE' \
		$CWD/ofed_scripts/ofed_patch.sh --with-kernel-fixes \
			--without-backport-patches
	#Some QUILT versions create files with 0 permissions
	#work around this
	if [ -d .pc ]
	then
		ex "" chmod -R u+rw .pc
		ex "" chmod -R o+r .pc
	fi
	ex "" cd $tmpdir
	ex "" tar czf $tmpdir/$project-fixes.tgz $project-fixes
	ex "" popd
fi

# create a tree with no patches applied
ex "" git clone -q -s -n $git_extra_flags $giturl $tmpdir/$project
ex "" pushd $tmpdir/$project
ex $tmpdir/$project.log $CWD/ofed_scripts/ofed_checkout.sh $head
ex "" cd ..
ex "" tar czf $tmpdir/$project.tgz $project
ex "" popd

results=`(cd $tmpdir; ls *tgz)`
ex "" mv $tmpdir/*tgz $destdir
ex "" rm -fr $tmpdir
echo $results
