AC_PREREQ([2.57])
AC_INIT([compat_mlnx], 2.3, [http://support.mellanox.com/SupportWeb/service_center/SelfService], [compat_mlnx])

AC_CONFIG_AUX_DIR([config])
AC_CONFIG_MACRO_DIR([config])

AC_CANONICAL_SYSTEM

AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_FILES([Makefile])

AC_PROG_CC

AM_PROG_AS

AC_CHECK_TOOLS(AR, ar)

LB_PROG_CC

AC_ARG_WITH(njobs,
	AS_HELP_STRING([--with-njobs=N],[Allow N jobs at once; jobs as number of CPUs with no arg.]),
	[
		NJOBS="$withval"
		case "X${NJOBS}" in
			X | X[A-Za-z]*)
			NJOBS=$(MLXNUMC=$(grep ^processor /proc/cpuinfo | wc -l) && echo $(($MLXNUMC<16?$MLXNUMC:16)))
			;;
		esac
	],
	NJOBS=1
)

MLNX_PROG_LINUX
LB_CONDITIONALS

#
#       cleanup auto-generated defines
#
sed -i '/\<PACKAGE\>/d' $PWD/config.h
sed -i '/\<PACKAGE_BUGREPORT\>/d' $PWD/config.h
sed -i '/\<PACKAGE_NAME\>/d' $PWD/config.h
sed -i '/\<PACKAGE_STRING\>/d' $PWD/config.h
sed -i '/\<PACKAGE_TARNAME\>/d' $PWD/config.h
sed -i '/\<PACKAGE_URL\>/d' $PWD/config.h
sed -i '/\<PACKAGE_VERSION\>/d' $PWD/config.h
sed -i '/\<VERSION\>/d' $PWD/config.h

#
echo '' >> $PWD/config.h
echo '/* Make sure LINUX_BACKPORT macro is defined for all external users */' >> $PWD/config.h
echo '#ifndef LINUX_BACKPORT' >> $PWD/config.h
echo '#define LINUX_BACKPORT(__sym) backport_ ##__sym' >> $PWD/config.h
echo '#endif' >> $PWD/config.h
echo '' >> $PWD/config.h
