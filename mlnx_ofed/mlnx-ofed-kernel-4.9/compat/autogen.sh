#!/bin/sh

run_cmd()
{
	cmd="$@"
	echo -n "Running $cmd"
	eval $cmd
	res=$?
	if [ $res -ne 0 ]; then
		echo " failed: $res"
		echo "Aborting"
		exit 1
	fi
	echo
}

run_cmd "aclocal -I $PWD/config $ACLOCAL_FLAGS"
run_cmd "autoheader"
run_cmd "automake -a -c --force-missing"
run_cmd autoconf
