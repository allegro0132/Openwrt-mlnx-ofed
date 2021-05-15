#Put this source to 'package/yourfolder' folder of OpenWRT/LEDE SDK
#Build(make menuconfig, make defconfig, make)

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mlnx_ofed
PKG_VERSION:=4.9-2.2.4.0
PKG_RELEASE:=1

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
#PKG_CAT:=bzcat

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/mlnx_ofed
  TITLE:=Mellanox ConnectX(R) mlx5 vpi Network Driver
  SUBMENU:=Network Devices
  VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
  FILES:= `find $(PKG_BUILD_DIR)/ \( -name "*.ko" -o -name "*.ko.gz" \)`
  DEPENDS:=@PCI_SUPPORT +kmod-ptp
  KCONFIG:= CONFIG_MLX5_CORE \
	CONFIG_MLX5_CORE_EN=y \
	CONFIG_MLX5_CORE_EN_DCB=n \
	CONFIG_MLX5_EN_ARFS=n \
	CONFIG_MLX5_EN_IPSEC=n \
	CONFIG_MLX5_EN_RXNFC=y \
	CONFIG_MLX5_EN_TLS=n \
	CONFIG_MLX5_ESWITCH=n \
	CONFIG_MLX5_FPGA=n \
	CONFIG_MLX5_FPGA_IPSEC=n \
	CONFIG_MLX5_FPGA_TLS=n \
	CONFIG_MLX5_MPFS=y \
	CONFIG_MLX5_SW_STEERING=n \
	CONFIG_MLX5_TC_CT=n \
	CONFIG_MLX5_TLS=n \
	CONFIG_INFINIBAND=m \
	CONFIG_INFINIBAND_IPOIB=m \
	CONFIG_INFINIBAND_IPOIB_CM=y \
	CONFIG_INFINIBAND_SRP=m \
	CONFIG_INFINIBAND_USER_MAD=m \
	CONFIG_INFINIBAND_USER_ACCESS=m \
	CONFIG_INFINIBAND_USER_ACCESS_UCM=m \
	CONFIG_INFINIBAND_ADDR_TRANS=y \
	CONFIG_INFINIBAND_USER_MEM=y \
	CONFIG_MLX5_ACCEL=y \
	CONFIG_MLX5_IPSEC=n \
	CONFIG_MLX5_CORE=m \
	CONFIG_MLX5_CLS_ACT=y \
	CONFIG_MLX5_TC_SAMPLE=y \
	CONFIG_MLX5_CORE_IPOIB=y \
	CONFIG_MLX5_EN_SPECIAL_SQ=y \
	CONFIG_MLX5_INFINIBAND=m \
	CONFIG_MLX5_DEBUG=y \
	CONFIG_BACKPORT_LRO=m \
	CONFIG_AUXILIARY_BUS=m \
	CONFIG_INFINIBAND_IPOIB_DEBUG=y \
	CONFIG_SCSI_SRP_ATTRS=m \
	CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
  AUTOLOAD:=$(call AutoLoad,35,mlx5_core mlx4_core ib_ipoib)
  #AUTOLOAD:=$(call AutoProbe,35,scsi_transport_srp.ko mlx4_ib.ko efa.ko mlx5_ib.ko iw_cm.ko ib_core.ko ib_cm.ko rdma_cm.ko rdma_ucm.ko ib_ucm.ko ib_umad.ko ib_uverbs.ko ib_ipoib.ko ib_srp.ko ib_iser.ko mlx4_en.ko mlx4_core.ko mlx5_core.ko mlx_compat.ko)
endef

define Package/mlnx_ofed/description
 This package contains a OFED driver for Mellanox CX3 and above chipsets.
endef

mlnx_MAKEOPTS= PATH="$(TARGET_PATH)" \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		TARGET="$(HAL_TARGET)" \
		TOOLPREFIX="$(KERNEL_CROSS)" \
		TOOLPATH="$(KERNEL_CROSS)" \
		LDOPTS=" " \
		DOMULTI=1

mlnx_CFGOPTS= --kernel-version=$(LINUX_VERSION) \
	--with-linux=$(LINUX_DIR) \
	--kernel-sources=$(LINUX_DIR) \
	-j 8 \
	--with-core-mod --with-user_mad-mod --with-user_access-mod --with-addr_trans-mod --with-mlx5-mod --with-ipoib-mod --with-srp-mod --with-mlx4_en-mod --with-mlx4-mod
#-j[N]|--with-njobs=[N] : Allow N configure jobs at once; jobs as number of CPUs with no arg.
##########################################################################
#Kernel modules configuration:
#
#    --build-dummy-mods    Build dummy modules for ULPs and storage drivers [no]
#
#    --with-core-mod    make CONFIG_INFINIBAND=m [no]
#    --without-core-mod   [yes]
#
#    --with-ipoib-mod    make CONFIG_INFINIBAND_IPOIB=m [no]
#    --without-ipoib-mod   [yes]
#
#    --with-ipoib-cm    make CONFIG_INFINIBAND_IPOIB_CM=y [yes]
#    --without-ipoib-cm   [no]
#
#    --with-ipoib-allmulti    make CONFIG_IPOIB_ALL_MULTI=y [yes]
#    --without-ipoib-allmulti   [no]
#
#    --with-ipoib_debug-mod    make CONFIG_INFINIBAND_IPOIB_DEBUG=y [yes]
#    --without-ipoib_debug-mod    [no]
#
#    --with-ipoib_debug_data-mod    make CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y [no]
#    --without-ipoib_debug_data-mod    [yes]
#
#    --with-sdp_debug_data-mod    make CONFIG_INFINIBAND_SDP_DEBUG_DATA=y [no]
#    --without-sdp_debug_data-mod    [yes]
#
#    --with-srp-mod    make CONFIG_INFINIBAND_SRP=m [no]
#    --without-srp-mod    [yes]
#
#    --with-rxe-mod    make CONFIG_RDMA_RXE=m [no]
#    --without-rxe-mod    [yes]
#
#    --with-user_mad-mod    make CONFIG_INFINIBAND_USER_MAD=m [no]
#    --without-user_mad-mod    [yes]
#
#    --with-user_access-mod    make CONFIG_INFINIBAND_USER_ACCESS=m CONFIG_INFINIBAND_USER_ACCESS_UCM=m [no]
#    --without-user_access-mod    [yes]
#
#    --with-addr_trans-mod    make CONFIG_INFINIBAND_ADDR_TRANS=y [no]
#    --without-addr_trans-mod    [yes]
#
#    --with-mlx4-mod         make CONFIG_MLX4_CORE=y CONFIG_MLX4_INFINIBAND=y [no]
#    --without-mlx4-mod      [yes]
#
#    --with-mlx5-mod         make CONFIG_MLX5_CORE=y CONFIG_MLX5_INFINIBAND=y [no]
#    --without-mlx5-mod      [yes]
#
#    Options for MLX5 development usage:
#        --with-mlx5-core-only-mod         Build MLX5 Core, without EN, without IB, without IPoIB
#        --with-mlx5-core-and-ib-mod       Build MLX5 Core, with EN, with IB, without IPoIB)
#        --with-mlx5-core-and-en-mod       Build MLX5 Core, with EN, without IB, without IPoIB)
#        --with-mlx5-core-and-ib-and-en-mod  Build MLX5 Core, with EN, with IB, without IPoIB)
#        --with-mlx5-core-and-ipoib-mod    Build MLX5 Core, without EN, without IB, with IPoIB)
#
#    --with-mlx4_core-mod         make CONFIG_MLX4_CORE=y [no]
#    --without-mlx4_core-mod      [yes]
#
#    --with-mlx5_core-mod         make CONFIG_MLX5_CORE=y [no]
#    --without-mlx5_core-mod      [yes]
#
#    --with-mdev-mod              make CONFIG_VFIO_MDEV=m [no]
#    --without-mdev-mod           [yes]
#
#    --with-mlx4_en-mod         make CONFIG_MLX4_EN=y [no]
#    --without-mlx4_en-mod      [yes]
#
#    --with-mlx4_en-perf-stat     make CONFIG_MLX4_EN_PERF_STAT=y [no]
#    --without-mlx4_en-perf-stat  [yes]
#
#    --with-mlx4_inf-mod         make CONFIG_MLX4_INFINIBAND=y [no]
#    --without-mlx4_inf-mod      [yes]
#
#    --with-mlx5_inf-mod         make CONFIG_MLX5_INFINIBAND=y [no]
#    --without-mlx5_inf-mod      [yes]
#
#    --with-mlx4_fc-mod         make CONFIG_MLX4_FC=y [no]
#    --without-mlx4_fc-mod      [yes]
#
#    --with-mlx4_debug-mod         make CONFIG_MLX4_DEBUG=y [yes]
#    --without-mlx4_debug-mod      [no]
#
#    --with-mlx5_debug-mod         make CONFIG_MLX5_DEBUG=y [yes]
#    --without-mlx5_debug-mod      [no]
#
#    --with-mlxfw-mod              make CONFIG_MLXFW=m [no]
#    --without-mlxfw-mod           [yes]
#
#    --with-innova-flex            make CONFIG_MLX5_ACCEL=y CONFIG_MLX5_FPGA=y CONFIG_MLX5_FPGA_TOOLS=m CONFIG_MLX5_EN_TLS=y [no]
#    --without-innova-flex         [yes]
#
#    --with-innova-ipsec           make CONFIG_MLX5_ACCEL=y CONFIG_MLX5_FPGA=y CONFIG_MLX5_FPGA_TOOLS=m CONFIG_MLX5_EN_IPSEC=y CONFIG_MLX5_EN_TLS=y [no]
#    --without-innova-ipsec        [yes]
#
#    --with-mlx5-ipsec             make CONFIG_MLX5_ACCEL=y CONFIG_MLX5_EN_ACCEL_FS=y CONFIG_MLX5_IPSEC=y CONFIG_MLX5_EN_IPSEC=y [no]
#    --without-mlx5-ipsec          [yes]
#
#    --with-iser-mod    make CONFIG_INFINIBAND_ISER=m [no]
#    --without-iser-mod    [yes]
#
#    --with-isert-mod    make CONFIG_INFINIBAND_ISERT=m [no]
#    --without-isert-mod    [yes]
#
#    --with-madeye-mod   make CONFIG_INFINIBAND_MADEYE=m [no]
#    --without-madeye-mod    [yes]
#
#    --with-memtrack  enable momory tracking [no]
#    --without-memtrack disable memory tracking [yes]
#
#    --with-debug-info  make CONFIG_DEBUG_INFO=y [yes]
#    --without-debug-info [no]
#
#    --with-nfsrdma-mod    make CONFIG_SUNRPC_XPRT_RDMA=m [no]
#    --without-nfsrdma-mod    [yes]
#
#    --with-scsi_transport_srp-mod    make CONFIG_SCSI_SRP_ATTRS=m [no]
#    --without-scsi_transport_srp-mod    [yes]
#
#    --with-odp             make CONFIG_INFINIBAND_ON_DEMAND_PAGING=y [no]
#    --without-odp             [yes]
#
#    --with-wqe-format             make CONFIG_INFINIBAND_WQE_FORMAT=y [no]
#    --without-wqe-format             [yes]
#
#    --with-pa-mr             make CONFIG_INFINIBAND_PA_MR=y [no]
#    --without-pa-mr             [yes]
#
#    --with-nvmf_host-mod    make CONFIG_NVME_HOST=m [no]
#    --without-nvmf_host-mod    [yes]
#
#    --with-nvmf-host-without-fc        make CONFIG_NVME_HOST_WITHOUT_FC=m [no]
#    --without-nvmf-host-without-fc     [yes]
#
#    --with-nvmf_target-mod    make CONFIG_NVME_TARGET=m [no]
#    --without-nvmf_target-mod    [yes]
#
#    --block-request-module     Prevent drivers from using request_module function [no]
#
#    --with-bf-device-emulation    make CONFIG_BF_DEVICE_EMULATION=y [no]
#    --without-bf-device-emulation    [yes]
#
#    --with-bf-power-failure-event make CONFIG_BF_POWER_FAILURE_EVENT=y [no]
#    --without-bf-power-failure-event [yes]
#
#    --with-mlx5-fs-debugfs    make CONFIG_ENABLE_MLX5_FS_DEBUGFS=y [no]
###############################################################################
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./mlnx-ofed-kernel-4.9 $(PKG_BUILD_DIR)
	#$(TAR) -C $(PKG_BUILD_DIR) -zxvf ./mlnx-ofed-kernel_5*.tar.gz
endef

define Build/Compile
	cd $(PKG_BUILD_DIR)/mlnx-of* ; \
		./configure $(mlnx_CFGOPTS); \
		$(MAKE) $(mlnx_MAKEOPTS) kernel
endef

$(eval $(call KernelPackage,mlnx_ofed))
