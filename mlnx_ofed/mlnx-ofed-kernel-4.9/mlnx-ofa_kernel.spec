#
# Copyright (c) 2012 Mellanox Technologies. All rights reserved.
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

# KMP is disabled by default
%{!?KMP: %global KMP 0}

%global WITH_SYSTEMD %(if ( test -d "%{_unitdir}" > /dev/null); then echo -n '1'; else echo -n '0'; fi)

%{!?configure_options: %global configure_options --with-core-mod --with-user_mad-mod --with-user_access-mod --with-addr_trans-mod --with-mlx4-mod --with-mlx4_en-mod --with-mlx5-mod --with-mlxfw-mod --with-ipoib-mod}

%global MEMTRACK %(if ( echo %{configure_options} | grep "with-memtrack" > /dev/null ); then echo -n '1'; else echo -n '0'; fi)
%global MADEYE %(if ( echo %{configure_options} | grep "with-madeye-mod" > /dev/null ); then echo -n '1'; else echo -n '0'; fi)

%global WINDRIVER %(if (grep -qiE "Wind River" /etc/issue /etc/*release* 2>/dev/null); then echo -n '1'; else echo -n '0'; fi)
%global POWERKVM %(if (grep -qiE "powerkvm" /etc/issue /etc/*release* 2>/dev/null); then echo -n '1'; else echo -n '0'; fi)
%global BLUENIX %(if (grep -qiE "Bluenix" /etc/issue /etc/*release* 2>/dev/null); then echo -n '1'; else echo -n '0'; fi)
%global XENSERVER65 %(if (grep -qiE "XenServer.*6\.5" /etc/issue /etc/*release* 2>/dev/null); then echo -n '1'; else echo -n '0'; fi)
# Force python3 on RHEL8, fedora3x and similar:
%global RHEL8 %(if test `grep -E '^(ID="(rhel|ol|centos)"|VERSION="8)' /etc/os-release 2>/dev/null | wc -l` -eq 2; then echo -n '1'; else echo -n '0'; fi)
%global FEDORA3X %{!?fedora:0}%{?fedora:%(if [ %{fedora} -ge 30 ]; then echo 1; else echo 0; fi)}
%global PYTHON3 %{RHEL8} || %{FEDORA3X}

# Workaround: To be removed when mlnx_tune has python3 support:
# mlnx_tune is a python2 script. Avoid generating dependencies
# from it in some distributions to avoid dragging in a python2
# dependency
%if (!%{KMP}) && %{RHEL8}
%global __requires_exclude_from mlnx_tune
%endif

%global IS_RHEL_VENDOR "%{_vendor}" == "redhat" || ("%{_vendor}" == "bclinux")

%{!?KVERSION: %global KVERSION %(uname -r)}
%global kernel_version %{KVERSION}
%global krelver %(echo -n %{KVERSION} | sed -e 's/-/_/g')
# take path to kernel sources if provided, otherwise look in default location (for non KMP rpms).
%{!?K_SRC: %global K_SRC /lib/modules/%{KVERSION}/build}

# Select packages to build

# Kernel module packages to be included into kernel-ib
%global build_ipoib %(if ( echo %{configure_options} | grep "with-ipoib-mod" > /dev/null ); then echo -n '1'; else echo -n '0'; fi)
%global build_oiscsi %(if ( echo %{configure_options} | grep "with-iscsi-mod" > /dev/null ); then echo -n '1'; else echo -n '0'; fi)
%global build_mlx4 %(if ( echo %{configure_options} | grep "with-mlx4-mod" > /dev/null ); then echo -n '1'; else echo -n '0'; fi)
%global build_mlx5 %(if ( echo %{configure_options} | grep "with-mlx5-mod" > /dev/null ); then echo -n '1'; else echo -n '0'; fi)
%global build_mlx4_en %(if ( echo %{configure_options} | grep "with-mlx4_en-mod" > /dev/null ); then echo -n '1'; else echo -n '0'; fi)

%{!?LIB_MOD_DIR: %global LIB_MOD_DIR /lib/modules/%{KVERSION}/updates}

%{!?IB_CONF_DIR: %global IB_CONF_DIR /etc/infiniband}

%{!?KERNEL_SOURCES: %global KERNEL_SOURCES /lib/modules/%{KVERSION}/source}

%{!?_name: %global _name mlnx-ofa_kernel}
%{!?_version: %global _version 4.9}
%{!?_release: %global _release OFED.4.9.2.2.4.1}
%global _kmp_rel %{_release}%{?_kmp_build_num}%{?_dist}

%global utils_pname %{_name}
%global devel_pname %{_name}-devel
%global non_kmp_pname %{_name}-modules

%if %{PYTHON3}
%global mlnx_python_env    export MLNX_PYTHON_EXECUTABLE=python3
%else
%global mlnx_python_env    :
%endif

Summary: Infiniband HCA Driver
Name: %{_name}
Version: %{_version}
Release: %{_release}%{?_dist}
License: GPLv2
Url: http://www.mellanox.com/
Group: System Environment/Base
Source: %{_name}-%{_version}.tgz
BuildRoot: %{?build_root:%{build_root}}%{!?build_root:/var/tmp/OFED}
Vendor: Mellanox Technologies
Obsoletes: kernel-ib
Obsoletes: compat-rdma
Obsoletes: rdma
Provides: rdma
Obsoletes: rdma-core < 41mlnx1-1
Provides: rdma-core = 41mlnx1-1
Obsoletes: rdma-core-devel < 41mlnx1-1
Provides: rdma-core-devel = 41mlnx1-1
Provides: rdma-core-devel%{?_isa} = 41mlnx1-1
Obsoletes: mlnx-en
Obsoletes: mlnx_en
Obsoletes: mlnx-en-utils
Obsoletes: kmod-mlnx-en
Obsoletes: mlnx-en-kmp-default
Obsoletes: mlnx-en-kmp-xen
Obsoletes: mlnx-en-kmp-trace
Obsoletes: mlnx-en-doc
Obsoletes: mlnx-en-debuginfo
Obsoletes: mlnx-en-sources
Requires: coreutils
Requires: pciutils
Requires: grep
Requires: procps
Requires: module-init-tools
Requires: lsof
%if "%{KMP}" == "1"
BuildRequires: %kernel_module_package_buildreqs
BuildRequires: /usr/bin/perl
%endif
%description 
InfiniBand "verbs", Access Layer  and ULPs.
Utilities rpm.
The driver sources are located at: http://www.mellanox.com/downloads/ofed/mlnx-ofa_kernel-4.9-2.2.4.tgz


# build KMP rpms?
%if "%{KMP}" == "1"
%global kernel_release() $(make -C %{1} kernelrelease | grep -v make | tail -1)
# prep file list for kmp rpm
%(cat > %{_builddir}/kmp.files << EOF
%defattr(644,root,root,755)
/lib/modules/%2-%1
%if %{IS_RHEL_VENDOR}
%config(noreplace) %{_sysconfdir}/depmod.d/zz01-%{_name}-*.conf
%endif
EOF)
%(echo "Requires: %{utils_pname}" > %{_builddir}/preamble)
%kernel_module_package -f %{_builddir}/kmp.files -p %{_builddir}/preamble -r %{_kmp_rel}
%else # not KMP
%global kernel_source() %{K_SRC}
%global kernel_release() %{KVERSION}
%global flavors_to_build default
%package -n %{non_kmp_pname}
Requires: %{utils_pname}
Requires: coreutils
Requires: pciutils
Requires: grep
Requires: procps
Requires: module-init-tools
Requires: lsof
Obsoletes: kernel-ib
Obsoletes: compat-rdma
Obsoletes: rdma
Provides: rdma
Obsoletes: rdma-core < 41mlnx1-1
Provides: rdma-core = 41mlnx1-1
Obsoletes: rdma-core-devel < 41mlnx1-1
Provides: rdma-core-devel = 41mlnx1-1
Provides: rdma-core-devel%{?_isa} = 41mlnx1-1
Obsoletes: mlnx-en
Obsoletes: mlnx_en
Obsoletes: mlnx-en-utils
Obsoletes: kmod-mlnx-en
Obsoletes: mlnx-en-kmp-default
Obsoletes: mlnx-en-kmp-xen
Obsoletes: mlnx-en-kmp-trace
Obsoletes: mlnx-en-doc
Obsoletes: mlnx-en-debuginfo
Obsoletes: mlnx-en-sources
Version: %{_version}
Release: %{_release}.kver.%{krelver}
Summary: Infiniband Driver and ULPs kernel modules
Group: System Environment/Libraries
%description -n %{non_kmp_pname}
Core, HW and ULPs kernel modules
Non-KMP format kernel modules rpm.
The driver sources are located at: http://www.mellanox.com/downloads/ofed/mlnx-ofa_kernel-4.9-2.2.4.tgz
%endif #end if "%{KMP}" == "1"

%package -n %{devel_pname}
Version: %{_version}
# build KMP rpms?
Release: %{_release}%{?_dist}
Obsoletes: kernel-ib-devel
Obsoletes: compat-rdma-devel
Obsoletes: kernel-ib
Obsoletes: compat-rdma
Obsoletes: rdma
Provides: rdma
Obsoletes: rdma-core-devel < 41mlnx1-1
Provides: rdma-core-devel = 41mlnx1-1
Provides: rdma-core-devel%{?_isa} = 41mlnx1-1
Obsoletes: mlnx-en
Obsoletes: mlnx_en
Obsoletes: mlnx-en-utils
Obsoletes: kmod-mlnx-en
Obsoletes: mlnx-en-kmp-default
Obsoletes: mlnx-en-kmp-xen
Obsoletes: mlnx-en-kmp-trace
Obsoletes: mlnx-en-doc
Obsoletes: mlnx-en-debuginfo
Obsoletes: mlnx-en-sources
Requires: coreutils
Requires: %{utils_pname}
Requires: pciutils
Summary: Infiniband Driver and ULPs kernel modules sources
Group: System Environment/Libraries
%description -n %{devel_pname}
Core, HW and ULPs kernel modules sources
The driver sources are located at: http://www.mellanox.com/downloads/ofed/mlnx-ofa_kernel-4.9-2.2.4.tgz

#
# setup module sign scripts if paths to the keys are given
#
%global WITH_MOD_SIGN %(if ( test -f "$MODULE_SIGN_PRIV_KEY" && test -f "$MODULE_SIGN_PUB_KEY" ); \
	then \
		echo -n '1'; \
	else \
		echo -n '0'; fi)

%if "%{WITH_MOD_SIGN}" == "1"
# call module sign script
%global __modsign_install_post \
    %{_builddir}/$NAME-$VERSION/source/ofed_scripts/tools/sign-modules %{buildroot}/lib/modules/ %{kernel_source default} || exit 1 \
%{nil}

%global __debug_package 1
%global buildsubdir %{_name}-%{version}
# Disgusting hack alert! We need to ensure we sign modules *after* all
# invocations of strip occur, which is in __debug_install_post if
# find-debuginfo.sh runs, and __os_install_post if not.
#
%global __spec_install_post \
  %{?__debug_package:%{__debug_install_post}} \
  %{__arch_install_post} \
  %{__os_install_post} \
  %{__modsign_install_post} \
%{nil}

%endif # end of setup module sign scripts
#
%if "%{_vendor}" == "suse"
%debug_package
%endif

%if %{IS_RHEL_VENDOR}
%global __find_requires %{nil}
%endif

%if "%{_vendor}" == "wrs" || "%{_vendor}" == "bluenix"
%global __python_provides %{nil}
%global __python_requires %{nil}
%endif

# set modules dir
%if %{IS_RHEL_VENDOR}
%if 0%{?fedora}
%global install_mod_dir updates
%else
%global install_mod_dir extra/%{_name}
%endif
%endif

%if "%{_vendor}" == "suse"
%global install_mod_dir updates
%endif

%{!?install_mod_dir: %global install_mod_dir updates}

%prep
%setup -n %{_name}-%{_version}
set -- *
mkdir source
mv "$@" source/
%if %{PYTHON3}
sed -s -i -e '1s|python\>|python3|' `grep -rl '^#!.*python' source/ofed_scripts`
%endif
mkdir obj

%build
export EXTRA_CFLAGS='-DVERSION=\"%version\"'
export INSTALL_MOD_DIR=%{install_mod_dir}
export CONF_OPTIONS="%{configure_options}"
%{mlnx_python_env}
for flavor in %flavors_to_build; do
	export KSRC=%{kernel_source $flavor}
	export KVERSION=%{kernel_release $KSRC}
	export LIB_MOD_DIR=/lib/modules/$KVERSION/$INSTALL_MOD_DIR
	rm -rf obj/$flavor
	cp -a source obj/$flavor
	cd $PWD/obj/$flavor
	find compat -type f -exec touch -t 200012201010 '{}' \; || true
	./configure --build-dummy-mods --prefix=%{_prefix} --kernel-version $KVERSION --kernel-sources $KSRC --modules-dir $LIB_MOD_DIR $CONF_OPTIONS %{?_smp_mflags}
	make %{?_smp_mflags} kernel
	make build_py_scripts
	cd -
done

%install
touch ofed-files
export RECORD_PY_FILES=1
export INSTALL_MOD_PATH=%{buildroot}
export INSTALL_MOD_DIR=%{install_mod_dir}
export NAME=%{name}
export VERSION=%{version}
export PREFIX=%{_prefix}
%{mlnx_python_env}
for flavor in %flavors_to_build; do 
	export KSRC=%{kernel_source $flavor}
	export KVERSION=%{kernel_release $KSRC}
	cd $PWD/obj/$flavor
	make install_modules KERNELRELEASE=$KVERSION
	# install script and configuration files
	make install_scripts
	mkdir -p %{buildroot}/$PREFIX/src/$NAME/$flavor
	mkdir -p %{_builddir}/src/$NAME/$flavor
	cp -ar include/ %{_builddir}/src/$NAME/$flavor
	cp -ar config* %{_builddir}/src/$NAME/$flavor
	cp -ar compat*  %{_builddir}/src/$NAME/$flavor
	cp -ar ofed_scripts %{_builddir}/src/$NAME/$flavor

	modsyms=`find . -name Module.symvers -o -name Modules.symvers`
	if [ -n "$modsyms" ]; then
		for modsym in $modsyms
		do
			cat $modsym >> %{_builddir}/src/$NAME/$flavor/Module.symvers
		done
	else
		./ofed_scripts/create_Module.symvers.sh
		cp ./Module.symvers %{_builddir}/src/$NAME/$flavor/Module.symvers
	fi
	# Cleanup unnecessary kernel-generated module dependency files.
	find $INSTALL_MOD_PATH/lib/modules -iname 'modules.*' -exec rm {} \;
	cd -
done

if [[ "$(ls %{buildroot}/%{_bindir}/tc_wrap.py* 2>/dev/null)" != "" ]]; then
	echo '%{_bindir}/tc_wrap.py*' >> ofed-files
fi

# Set the module(s) to be executable, so that they will be stripped when packaged.
find %{buildroot} \( -type f -name '*.ko' -o -name '*ko.gz' \) -exec %{__chmod} u+x \{\} \;

%if %{IS_RHEL_VENDOR}
%if ! 0%{?fedora}
%{__install} -d %{buildroot}%{_sysconfdir}/depmod.d/
for module in `find %{buildroot}/ -name '*.ko' -o -name '*.ko.gz' | sort`
do
ko_name=${module##*/}
mod_name=${ko_name/.ko*/}
mod_path=${module/*%{_name}}
mod_path=${mod_path/\/${ko_name}}
echo "override ${mod_name} * weak-updates/%{_name}${mod_path}" >> %{buildroot}%{_sysconfdir}/depmod.d/zz01-%{_name}-${mod_name}.conf
echo "override ${mod_name} * extra/%{_name}${mod_path}" >> %{buildroot}%{_sysconfdir}/depmod.d/zz01-%{_name}-${mod_name}.conf
done
%endif
%endif

# copy sources
mkdir -p %{buildroot}/%{_prefix}/src
cp -ar %{_builddir}/$NAME-$VERSION/source %{buildroot}/%{_prefix}/src/ofa_kernel-$VERSION
cd %{buildroot}/%{_prefix}/src/
ln -snf ofa_kernel-$VERSION mlnx-ofa_kernel-$VERSION
cd -
cp -ar %{_builddir}/src/$NAME %{buildroot}/%{_prefix}/src/ofa_kernel
# Fix path of BACKPORT_INCLUDES
sed -i -e "s@=-I.*backport_includes@=-I/usr/src/ofa_kernel-$VERSION/backport_includes@" %{buildroot}/%{_prefix}/src/ofa_kernel/*/configure.mk.kernel || true
rm -rf %{_builddir}/src
%ifarch ppc64
if [ ! -d "%{buildroot}/%{_prefix}/src/ofa_kernel/default" ]; then
    ln -snf /%{_prefix}/src/ofa_kernel/ppc64 %{buildroot}/%{_prefix}/src/ofa_kernel/default
fi
%endif

INFO=${RPM_BUILD_ROOT}/etc/infiniband/info
/bin/rm -f ${INFO}
mkdir -p ${RPM_BUILD_ROOT}/etc/infiniband
touch ${INFO}

cat >> ${INFO} << EOFINFO
#!/bin/bash

echo prefix=%{_prefix}
echo Kernel=%{KVERSION}
echo
echo "Configure options: %{configure_options}"
echo
EOFINFO

chmod +x ${INFO} > /dev/null 2>&1

%if "%{WITH_SYSTEMD}" == "1"
install -d %{buildroot}%{_unitdir}
install -d %{buildroot}/etc/systemd/system
install -m 0644 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/openibd.service %{buildroot}%{_unitdir}
install -m 0644 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/mlnx_interface_mgr\@.service %{buildroot}/etc/systemd/system
echo 'DRIVERS=="*mlx*", SUBSYSTEM=="net", ACTION=="add",RUN+="/usr/bin/systemctl --no-block start mlnx_interface_mgr@$env{INTERFACE}.service"' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
echo 'DRIVERS=="*mlx*", SUBSYSTEM=="net", ACTION=="remove",RUN+="/usr/bin/systemctl stop mlnx_interface_mgr@$env{INTERFACE}.service"' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
echo '# For IPoIB Pkeys' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
echo 'KERNEL=="ib[0-9]*\.*|*nfiniband[0-9]*\.*", DRIVERS=="", SUBSYSTEM=="net", ACTION=="add",RUN+="/usr/bin/systemctl --no-block start mlnx_interface_mgr@$env{INTERFACE}.service"' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
echo 'KERNEL=="ib[0-9]*\.*|*nfiniband[0-9]*\.*", DRIVERS=="", SUBSYSTEM=="net", ACTION=="remove",RUN+="/usr/bin/systemctl stop mlnx_interface_mgr@$env{INTERFACE}.service"' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
%else
# no systemd support
echo 'DRIVERS=="*mlx*", SUBSYSTEM=="net", ACTION=="add", RUN+="/bin/mlnx_interface_mgr.sh $env{INTERFACE} <&- >/dev/null 2>&1 &"' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
echo '# For IPoIB Pkeys' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
echo 'KERNEL=="ib[0-9]*\.*|*nfiniband[0-9]*\.*", DRIVERS=="", SUBSYSTEM=="net", ACTION=="add", RUN+="/bin/mlnx_interface_mgr.sh $env{INTERFACE} <&- >/dev/null 2>&1 &"' >> %{buildroot}/etc/udev/rules.d/90-ib.rules
%endif

install -d %{buildroot}/bin
install -m 0755 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/mlnx_conf_mgr.sh %{buildroot}/bin/
%if "%{WINDRIVER}" == "0" && "%{BLUENIX}" == "0"
install -m 0755 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/mlnx_interface_mgr.sh %{buildroot}/bin/
%else
# Wind River and Mellanox Bluenix are rpm based, however, interfaces management is done in Debian style
install -d %{buildroot}/usr/sbin
install -m 0755 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/mlnx_interface_mgr_deb.sh %{buildroot}/bin/mlnx_interface_mgr.sh
install -m 0755 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/net-interfaces %{buildroot}/usr/sbin
%endif

# Install ibroute utilities
# TBD: move these utilities into standalone package
install -d %{buildroot}%{_sbindir}
install -d %{buildroot}%{_defaultdocdir}/ib2ib
install -m 0755 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/ib2ib/ib2ib*  %{buildroot}%{_sbindir}
install -m 0644 %{_builddir}/$NAME-$VERSION/source/ofed_scripts/ib2ib/README %{buildroot}%{_defaultdocdir}/ib2ib

# update /etc/init.d/openibd header
if [[ -f /etc/redhat-release || -f /etc/rocks-release ]]; then
perl -i -ne 'if (m@^#!/bin/bash@) {
        print q@#!/bin/bash
#
# Bring up/down openib
#
# chkconfig: 2345 05 95
# description: Activates/Deactivates InfiniBand Driver to \
#              start at boot time.
#
### BEGIN INIT INFO
# Provides:       openibd
### END INIT INFO
@;
                 } else {
                     print;
                 }' %{buildroot}/etc/init.d/openibd
fi

if [ -f /etc/SuSE-release ] || [ -f /etc/SUSE-brand ]; then
    local_fs='$local_fs'
    openiscsi=''
    %if %{build_oiscsi}
        openiscsi='open-iscsi'
    %endif
        perl -i -ne "if (m@^#!/bin/bash@) {
        print q@#!/bin/bash
### BEGIN INIT INFO
# Provides:       openibd
# Required-Start: $local_fs
# Required-Stop: opensmd $openiscsi
# Default-Start:  2 3 5
# Default-Stop: 0 1 2 6
# Description:    Activates/Deactivates InfiniBand Driver to \
#                 start at boot time.
### END INIT INFO
@;
                 } else {
                     print;
                 }" %{buildroot}/etc/init.d/openibd
fi

%if %{build_ipoib}
case $(uname -m) in
	i[3-6]86)
	# Decrease send/receive queue sizes on 32-bit arcitecture
	echo "options ib_ipoib send_queue_size=64 recv_queue_size=128" >> %{buildroot}/etc/modprobe.d/ib_ipoib.conf
	;;
esac
%endif

%if "%{XENSERVER65}" == "1"
	# mlx4_core fails to load on xenserver 6.5 with the following error:
	# mlx4_core 0000:01:00.0: Failed to map MCG context memory, aborting
	# mlx4_core: probe of 0000:01:00.0 failed with error -12
	# This happens only when DMFS is used (module parameter log_num_mgm_entry < 0).
	echo "options mlx4_core log_num_mgm_entry_size=10" >> %{buildroot}/etc/modprobe.d/mlnx.conf
%endif

%clean
rm -rf %{buildroot}


%if "%{KMP}" != "1"
%post -n %{non_kmp_pname}
/sbin/depmod %{KVERSION}
# W/A for OEL6.7/7.x inbox modules get locked in memory
# in dmesg we get: Module mlx4_core locked in memory until next boot
if (grep -qiE "Oracle.*(6.([7-9]|10)| 7)" /etc/issue /etc/*release* 2>/dev/null); then
	/sbin/dracut --force
fi

%postun -n %{non_kmp_pname}
if [ $1 = 0 ]; then  # 1 : Erase, not upgrade
	/sbin/depmod %{KVERSION}
	# W/A for OEL6.7/7.x inbox modules get locked in memory
	# in dmesg we get: Module mlx4_core locked in memory until next boot
	if (grep -qiE "Oracle.*(6.([7-9]|10)| 7)" /etc/issue /etc/*release* 2>/dev/null); then
		/sbin/dracut --force
	fi
fi
%endif # end KMP=1

%post -n %{utils_pname}
if [ $1 -eq 1 ]; then # 1 : This package is being installed
#############################################################################################################
if [[ -f /etc/redhat-release || -f /etc/rocks-release ]]; then
        /sbin/chkconfig openibd off >/dev/null 2>&1 || true
        /usr/bin/systemctl disable openibd >/dev/null  2>&1 || true
        /sbin/chkconfig --del openibd >/dev/null 2>&1 || true

%if "%{WITH_SYSTEMD}" != "1"
        /sbin/chkconfig --add openibd >/dev/null 2>&1 || true
        /sbin/chkconfig openibd on >/dev/null 2>&1 || true
%else
        /usr/bin/systemctl enable openibd >/dev/null  2>&1 || true
%endif
fi

if [ -f /etc/SuSE-release ] || [ -f /etc/SUSE-brand ]; then
        /sbin/chkconfig openibd off >/dev/null  2>&1 || true
        /usr/bin/systemctl disable openibd >/dev/null  2>&1 || true
        /sbin/insserv -r openibd >/dev/null 2>&1 || true

%if "%{WITH_SYSTEMD}" != "1"
        /sbin/insserv openibd >/dev/null 2>&1 || true
        /sbin/chkconfig openibd on >/dev/null 2>&1 || true
%else
        /usr/bin/systemctl enable openibd >/dev/null  2>&1 || true
%endif
fi

%if "%{WINDRIVER}" == "1" || "%{BLUENIX}" == "1"
/usr/sbin/update-rc.d openibd defaults || true
%endif

%if "%{POWERKVM}" == "1"
/usr/bin/systemctl disable openibd >/dev/null  2>&1 || true
/usr/bin/systemctl enable openibd >/dev/null  2>&1 || true
%endif

%if "%{WITH_SYSTEMD}" == "1"
/usr/bin/systemctl daemon-reload >/dev/null 2>&1 || :
cat /proc/sys/kernel/random/boot_id 2>/dev/null | sed -e 's/-//g' > /var/run/openibd.bootid || true
test -s /var/run/openibd.bootid || echo manual > /var/run/openibd.bootid || true
%endif

# Comment core modules loading hack
if [ -e /etc/modprobe.conf.dist ]; then
	sed -i -r -e 's/^(\s*install ib_core.*)/#MLX# \1/' /etc/modprobe.conf.dist
	sed -i -r -e 's/^(\s*alias ib.*)/#MLX# \1/' /etc/modprobe.conf.dist
fi

%if %{build_ipoib}
if [ -e /etc/modprobe.d/ipv6 ]; then
	sed -i -r -e 's/^(\s*install ipv6.*)/#MLX# \1/' /etc/modprobe.d/ipv6
fi
%endif

# Update limits.conf (but not for Containers)
if [ ! -e "/.dockerenv" ] && ! (grep -q docker /proc/self/cgroup 2>/dev/null); then
	if [ -e /etc/security/limits.conf ]; then
		LIMITS_UPDATED=0
		if ! (grep -qE "soft.*memlock" /etc/security/limits.conf 2>/dev/null); then
			echo "* soft memlock unlimited" >> /etc/security/limits.conf
			LIMITS_UPDATED=1
		fi
		if ! (grep -qE "hard.*memlock" /etc/security/limits.conf 2>/dev/null); then
			echo "* hard memlock unlimited" >> /etc/security/limits.conf
			LIMITS_UPDATED=1
		fi
		if [ $LIMITS_UPDATED -eq 1 ]; then
			echo "Configured /etc/security/limits.conf"
		fi
	fi
fi

# Make IPoIB interfaces be unmanaged on XenServer
if (grep -qi xenserver /etc/issue /etc/*-release 2>/dev/null); then
	IPOIB_PNUM=$(lspci -d 15b3: 2>/dev/null | wc -l 2>/dev/null)
	IPOIB_PNUM=$(($IPOIB_PNUM * 2))
	for i in $(seq 1 $IPOIB_PNUM)
	do
		uuid=$(xe pif-list 2>/dev/null | grep -B2 ib${i} | grep uuid | cut -d : -f 2 | sed -e 's/ //g')
		if [ "X${uuid}" != "X" ]; then
			xe pif-forget uuid=${uuid} >/dev/null 2>&1 || true
		fi
	done
fi

fi # 1 : closed
# END of post

%preun -n %{utils_pname}
if [ $1 = 0 ]; then  # 1 : Erase, not upgrade
          if [[ -f /etc/redhat-release || -f /etc/rocks-release ]]; then
                /sbin/chkconfig openibd off >/dev/null 2>&1 || true
                /usr/bin/systemctl disable openibd >/dev/null  2>&1 || true
                /sbin/chkconfig --del openibd  >/dev/null 2>&1 || true
          fi
          if [ -f /etc/SuSE-release ] || [ -f /etc/SUSE-brand ]; then
                /sbin/chkconfig openibd off >/dev/null 2>&1 || true
                /usr/bin/systemctl disable openibd >/dev/null  2>&1 || true
                /sbin/insserv -r openibd >/dev/null 2>&1 || true
          fi
          if [ -f /etc/debian_version ]; then
                if ! ( /usr/sbin/update-rc.d openibd remove > /dev/null 2>&1 ); then
                        true
                fi
          fi
%if "%{WINDRIVER}" == "1" || "%{BLUENIX}" == "1"
/usr/sbin/update-rc.d -f openibd remove || true
%endif

%if "%{POWERKVM}" == "1"
/usr/bin/systemctl disable openibd >/dev/null  2>&1 || true
%endif
fi

%postun -n %{utils_pname}
%if "%{WITH_SYSTEMD}" == "1"
/usr/bin/systemctl daemon-reload >/dev/null 2>&1 || :
%endif

# Uncomment core modules loading hack
if [ -e /etc/modprobe.conf.dist ]; then
	sed -i -r -e 's/^#MLX# (.*)/\1/' /etc/modprobe.conf.dist
fi

%if %{build_ipoib}
if [ -e /etc/modprobe.d/ipv6 ]; then
	sed -i -r -e 's/^#MLX# (.*)/\1/' /etc/modprobe.d/ipv6
fi
%endif

#end of post uninstall

%files -n %{utils_pname} -f ofed-files
%defattr(-,root,root,-)
%if "%{KMP}" == "1"
%if %{IS_RHEL_VENDOR}
%endif # end rh
%endif # end KMP=1
%dir /etc/infiniband
%config(noreplace) /etc/infiniband/openib.conf
%config(noreplace) /etc/infiniband/mlx5.conf
/etc/infiniband/info
/etc/infiniband/vf-net-link-name.sh
/etc/init.d/openibd
%if "%{WITH_SYSTEMD}" == "1"
%{_unitdir}/openibd.service
/etc/systemd/system/mlnx_interface_mgr@.service
%endif
/sbin/sysctl_perf_tuning
/sbin/mlnx_bf_configure
/sbin/mlnx-sf
/usr/sbin/show_gids
/usr/sbin/compat_gid_gen
/usr/sbin/cma_roce_mode
/usr/sbin/cma_roce_tos
/usr/sbin/setup_mr_cache.sh
/usr/sbin/odp_stat.sh
/usr/sbin/show_counters
%dir %{_defaultdocdir}/ib2ib
%{_defaultdocdir}/ib2ib/*
%config(noreplace) /etc/modprobe.d/mlnx.conf
%config(noreplace) /etc/modprobe.d/mlnx-bf.conf
%{_sbindir}/*
%config(noreplace) /etc/udev/rules.d/90-ib.rules
%config(noreplace) /etc/udev/rules.d/82-net-setup-link.rules
/bin/mlnx_interface_mgr.sh
/bin/mlnx_conf_mgr.sh
%if "%{WINDRIVER}" == "1" || "%{BLUENIX}" == "1"
/usr/sbin/net-interfaces
%endif
%if %{build_ipoib}
%config(noreplace) /etc/modprobe.d/ib_ipoib.conf
%endif
%if %{build_mlx4} || %{build_mlx5}
%{_bindir}/ibdev2netdev
%endif
%if %{build_mlx4_en}
/sbin/connectx_port_config
%config(noreplace) /etc/infiniband/connectx.conf
%endif

%if "%{KMP}" != "1"
%files -n %{non_kmp_pname}
/lib/modules/%{KVERSION}/%{install_mod_dir}/
%if %{IS_RHEL_VENDOR}
%if ! 0%{?fedora}
%config(noreplace) %{_sysconfdir}/depmod.d/zz01-%{_name}-*.conf
%endif
%endif
%endif

%files -n %{devel_pname}
%defattr(-,root,root,-)
%{_prefix}/src

%changelog
* Thu Jun 18 2015 Alaa Hleihel <alaa@mellanox.com>
- Renamed kernel-ib package to mlnx-ofa_kernel-modules
* Thu Apr 10 2014 Alaa Hleihel <alaa@mellanox.com>
- Add QoS utils.
* Thu Mar 13 2014 Alaa Hleihel <alaa@mellanox.com>
- Use one spec for KMP and non-KMP OS's.
* Tue Apr 24 2012 Vladimir Sokolovsky <vlad@mellanox.com>
- Remove FC support
* Tue Mar 6 2012 Vladimir Sokolovsky <vlad@mellanox.com>
- Add weak updates support
* Wed Jul 6 2011 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Add KMP support
* Mon Oct 4 2010 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Add mlx4_fc and mlx4_vnic support
* Mon May 10 2010 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Support install macro that removes RPM_BUILD_ROOT
* Thu Feb 4 2010 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Added ibdev2netdev script
* Mon Sep 8 2008 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Added nfsrdma support
* Wed Aug 13 2008 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Added mlx4_en support
* Tue Aug 21 2007 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Added %build macro
* Sun Jan 28 2007 Vladimir Sokolovsky <vlad@mellanox.co.il>
- Created spec file for kernel-ib
