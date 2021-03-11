#
# This file defines macros used to manage and support running
# build tests in parallel.
#

#
# Prepare stuff for parralel build jobs process
#
AC_DEFUN([MLNX_PARALLEL_INIT_ONCE],
[
if [[ "X${RAN_MLNX_PARALLEL_INIT_ONCE}" != "X1" ]]; then
	MAX_JOBS=${NJOBS:-1}
	RAN_MLNX_PARALLEL_INIT_ONCE=1
	/bin/rm -rf CONFDEFS_H_DIR
	/bin/mkdir -p CONFDEFS_H_DIR
	declare -i CONFDEFS_H_INDEX=0
	declare -i RUNNING_JOBS=0
fi
])

#
# MLNX_AC_DEFINE(VARIABLE, [VALUE], [DESCRIPTION])
# -------------------------------------------
# Set VARIABLE to VALUE, verbatim, or 1.  Remember the value
# and if VARIABLE is affected the same VALUE, do nothing, else
# die.  The third argument is used by autoheader.
m4_define([MLNX_AC_DEFINE], [_MLNX_AC_DEFINE_Q([\], $@)])


# _MLNX_AC_DEFINE_Q(QUOTE, VARIABLE, [VALUE], [DESCRIPTION])
# -----------------------------------------------------
# Internal function that performs common elements of AC_DEFINE{,_UNQUOTED}.
#
# m4_index is roughly 5 to 8 times faster than m4_bpatsubst, so only
# use the regex when necessary.  AC_name is defined with over-quotation,
# so that we can avoid m4_defn.
m4_define([_MLNX_AC_DEFINE_Q],
[m4_pushdef([AC_name], m4_if(m4_index([$2], [(]), [-1], [[[$2]]],
			     [m4_bpatsubst([[[$2]]], [(.*)])]))dnl
AC_DEFINE_TRACE(AC_name)dnl
m4_cond([m4_index([$3], [
])], [-1], [],
	[AS_LITERAL_IF([$3], [m4_bregexp([[$3]], [[^\\]
], [-])])], [], [],
	[m4_warn([syntax], [AC_DEFINE]m4_ifval([$1], [], [[_UNQUOTED]])dnl
[: `$3' is not a valid preprocessor define value])])dnl
m4_ifval([$4], [AH_TEMPLATE(AC_name, [$4])])dnl
cat >>CONFDEFS_H_DIR/confdefs.h.${CONFDEFS_H_INDEX} <<$1_ACEOF
[@%:@define] $2 m4_if([$#], 2, 1, [$3], [], [/**/], [$3])
_ACEOF
])

# MLNX_AC_LANG_SOURCE(C)(BODY)
# -----------------------
# We can't use '#line $LINENO "configure"' here, since
# Sun c89 (Sun WorkShop 6 update 2 C 5.3 Patch 111679-08 2002/05/09)
# rejects $LINENO greater than 32767, and some configure scripts
# are longer than 32767 lines.
m4_define([MLNX_AC_LANG_SOURCE(C)],
[/* confdefs.h.  */
_ACEOF
cat confdefs.h >>$tmpbuild/conftest.$ac_ext
cat >>$tmpbuild/conftest.$ac_ext <<_ACEOF
/* end confdefs.h.  */
$1])

# MLNX_AC_LANG_SOURCE(BODY)
# --------------------
# Produce a valid source for the current language, which includes the
# BODY, and as much as possible `confdefs.h'.
AC_DEFUN([MLNX_AC_LANG_SOURCE],
[_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])


# MLNX_AC_LANG_CONFTEST(BODY)
# ----------------------
# Save the BODY in `conftest.$ac_ext'.  Add a trailing new line.
AC_DEFUN([MLNX_AC_LANG_CONFTEST],
[cat >$tmpbuild/conftest.$ac_ext <<_ACEOF
$1
_ACEOF])

# _MLNX_AC_MSG_LOG_CONFTEST
# --------------------
m4_define([_MLNX_AC_MSG_LOG_CONFTEST],
[AS_ECHO(["$as_me: failed program was:"]) >&AS_MESSAGE_LOG_FD
sed 's/^/| /' $tmpbuild/conftest.$ac_ext >&AS_MESSAGE_LOG_FD
])


#
# MLNX_LB_LINUX_COMPILE_IFELSE
#
# like AC_COMPILE_IFELSE.
# runs in a temp dir
#
AC_DEFUN([MLNX_LB_LINUX_COMPILE_IFELSE],
[
{
MAKE=${MAKE:-make}
tmpbuild=$(/bin/mktemp -d $PWD/build/build_XXXXX)
/bin/cp build/Makefile $tmpbuild/
m4_ifvaln([$1], [MLNX_AC_LANG_CONFTEST([$1])])dnl
AS_IF([AC_TRY_COMMAND(env $CROSS_VARS $MAKE -d [$2] ${LD:+"LD=$CROSS_COMPILE$LD"} CC="$CROSS_COMPILE$CC" -f $tmpbuild/Makefile MLNX_LINUX_CONFIG=$LINUX_CONFIG LINUXINCLUDE="-include $AUTOCONF_HDIR/autoconf.h $XEN_INCLUDES $EXTRA_MLNX_INCLUDE -I$LINUX/arch/$SRCARCH/include -Iarch/$SRCARCH/include/generated -Iinclude -I$LINUX/arch/$SRCARCH/include/uapi -Iarch/$SRCARCH/include/generated/uapi -I$LINUX/include -I$LINUX/include/uapi -Iinclude/generated/uapi  -I$LINUX/arch/$SRCARCH/include -Iarch/$SRCARCH/include/generated -I$LINUX/arch/$SRCARCH/include -I$LINUX/arch/$SRCARCH/include/generated -I$LINUX_OBJ/include -I$LINUX/include -I$LINUX_OBJ/include2 $CONFIG_INCLUDE_FLAG" -o tmp_include_depends -o scripts -o include/config/MARKER -C $LINUX_OBJ EXTRA_CFLAGS="-Werror-implicit-function-declaration -Wno-unused-variable -Wno-uninitialized $EXTRA_KCFLAGS" $CROSS_VARS $MODULE_TARGET=$tmpbuild >/dev/null 2>$tmpbuild/output.log; [[[ $? -ne 0 ]]] && cat $tmpbuild/output.log 1>&2 && false || config/warning_filter.sh $tmpbuild/output.log) >/dev/null && AC_TRY_COMMAND([$3])],
	[$4],
	[_MLNX_AC_MSG_LOG_CONFTEST
m4_ifvaln([$5],[$5])dnl])
/bin/rm -rf $tmpbuild
}
])

#
# MLNX_LB_LINUX_TRY_COMPILE
#
# like AC_TRY_COMPILE
#
AC_DEFUN([MLNX_LB_LINUX_TRY_COMPILE],
[MLNX_LB_LINUX_COMPILE_IFELSE(
	[MLNX_AC_LANG_SOURCE([LB_LANG_PROGRAM([[$1]], [[$2]])])],
	[modules],
	[test -s $tmpbuild/conftest.o],
	[$3], [$4])])

# MLNX_BG_LB_LINUX_COMPILE_IFELSE
#
# Do fork and call LB_LINUX_COMPILE_IFELSE
# to run the build test in background
#
AC_DEFUN([MLNX_BG_LB_LINUX_TRY_COMPILE],
[
# init stuff
MLNX_PARALLEL_INIT_ONCE

# wait if there are MAX_JOBS tests running
if [[ $RUNNING_JOBS -eq $MAX_JOBS ]]; then
	wait
	RUNNING_JOBS=0
else
	let RUNNING_JOBS++
fi

# inc header index
let CONFDEFS_H_INDEX++

# run test in background if MAX_JOBS > 1
if [[ $MAX_JOBS -eq 1 ]]; then
MLNX_LB_LINUX_TRY_COMPILE([$1], [$2], [$3], [$4])
else
{
MLNX_LB_LINUX_TRY_COMPILE([$1], [$2], [$3], [$4])
}&
fi
])

#####################################
