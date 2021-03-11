#!/bin/bash
# Copyright 2013        Mellanox Technologies. All rights reserved.
# Copyright 2012        Luis R. Rodriguez <mcgrof@frijolero.org>
# Copyright 2012        Hauke Mehrtens <hauke@hauke-m.de>
#
# This generates a bunch of CONFIG_COMPAT_KERNEL_2_6_22
# CONFIG_COMPAT_KERNEL_3_0 .. etc for each kernel release you need an object
# for.
#
# Note: this is part of the compat.git project, not compat-drivers,
# send patches against compat.git.

if [[ ! -f ${KLIB_BUILD}/Makefile ]]; then
	exit
fi

KERNEL_VERSION=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')

# 5.0/4.0/3.0 kernel stuff
COMPAT_LATEST_3_VERSION="19"
COMPAT_LATEST_4_VERSION="1"
KERNEL_SUBLEVEL3="-1"
KERNEL_SUBLEVEL4="-1"

function set_config {
	VAR=$1
	VALUE=$2

	eval "export $VAR=$VALUE"
	echo "export $VAR=$VALUE"
}
function unset_config {
	VAR=$1

	eval "unset $VAR"
	echo "unexport $VAR"
}

function check_autofconf {
	VAR=$1
	VALUE=$(tac ${KLIB_BUILD}/include/*/autoconf.h | grep -m1 ${VAR} | sed -ne 's/.*\([01]\)$/\1/gp')

	eval "export $VAR=$VALUE"
}

function is_kernel_symbol_exported {
	SYMBOL=$1
	grep -wq ${SYMBOL} ${KLIB_BUILD}/*symvers* >/dev/null 2>&1
}

# Note that this script will export all variables explicitly,
# trying to export all with a blanket "export" statement at
# the top of the generated file causes the build to slow down
# by an order of magnitude.

if [[ ${KERNEL_VERSION} -eq "3" ]]; then
	KERNEL_SUBLEVEL3=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^3\.\([0-9]\+\).*/\1/p')
elif [[ ${KERNEL_VERSION} -eq "4" ]]; then
	KERNEL_SUBLEVEL4=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^4\.\([0-9]\+\).*/\1/p')
elif [[ ${KERNEL_VERSION} -eq "2" ]]; then
	COMPAT_26LATEST_VERSION="39"
	KERNEL_26SUBLEVEL=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
	let KERNEL_26SUBLEVEL=${KERNEL_26SUBLEVEL}+1

	for i in $(seq ${KERNEL_26SUBLEVEL} ${COMPAT_26LATEST_VERSION}); do
		set_config CONFIG_COMPAT_KERNEL_2_6_${i} y
	done
fi

let KERNEL_SUBLEVEL3=${KERNEL_SUBLEVEL3}+1
let KERNEL_SUBLEVEL4=${KERNEL_SUBLEVEL4}+1

if [[ ${KERNEL_VERSION} -le "4" ]]; then
	for i in $(seq ${KERNEL_SUBLEVEL4} ${COMPAT_LATEST_4_VERSION}); do
		set_config CONFIG_COMPAT_KERNEL_4_${i} y
	done
	if [[ ${KERNEL_VERSION} -le "3" ]]; then
		for i in $(seq ${KERNEL_SUBLEVEL3} ${COMPAT_LATEST_3_VERSION}); do
			set_config CONFIG_COMPAT_KERNEL_3_${i} y
		done
	fi
fi


# The purpose of these seem to be the inverse of the above other varibales.
# The RHEL checks seem to annotate the existance of RHEL minor versions.
RHEL_MAJOR=$(grep ^RHEL_MAJOR ${KLIB_BUILD}/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
if [[ ! -z ${RHEL_MAJOR} ]]; then
	RHEL_MINOR=$(grep ^RHEL_MINOR ${KLIB_BUILD}/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
	for i in $(seq 0 ${RHEL_MINOR}); do
		set_config CONFIG_COMPAT_RHEL_${RHEL_MAJOR}_${i} y
	done
fi

if [[ ${CONFIG_COMPAT_KERNEL_2_6_36} = "y" ]]; then
	if [[ ! ${CONFIG_COMPAT_RHEL_6_1} = "y" ]]; then
		set_config CONFIG_COMPAT_KFIFO y
	fi
fi

case ${KVERSION} in
	3.0.7[6-9]-[0-9].[0-9]* | 3.0.[8-9][0-9]-[0-9].[0-9]* | 3.0.[1-9][0-9][0-9]-[0-9].[0-9]*)
	SLES_11_3_KERNEL=${KVERSION}
	SLES_MAJOR="11"
	SLES_MINOR="3"
	set_config CONFIG_COMPAT_SLES_11_3 y
	;;
esac

SLES_11_2_KERNEL=$(echo ${KVERSION} | sed -n 's/^\(3\.0\.[0-9]\+\)\-\(.*\)\-\(.*\)/\1-\2-\3/p')
if [[ ! -z ${SLES_11_2_KERNEL} ]]; then
	SLES_MAJOR="11"
	SLES_MINOR="2"
	set_config CONFIG_COMPAT_SLES_11_2 y
fi

SLES_11_1_KERNEL=$(echo ${KVERSION} | sed -n 's/^\(2\.6\.32\.[0-9]\+\)\-\(.*\)\-\(.*\)/\1-\2-\3/p')
if [[ ! -z ${SLES_11_1_KERNEL} ]]; then
	SLES_MAJOR="11"
	SLES_MINOR="1"
	set_config CONFIG_COMPAT_SLES_11_1 y
fi

SLES_12_0_KERNEL=$(echo ${KVERSION} | sed -n 's/^\(3\.12\.28\)\-\([0-9]\)\-\(.*\)/\1-\2-\3/p')
if [[ ! -z ${SLES_12_0_KERNEL} ]]; then
	SLES_MAJOR="12"
	SLES_MINOR="0"
	set_config CONFIG_COMPAT_SLES_12 y
	set_config CONFIG_COMPAT_SLES_12_0 y
fi

SLES_12_1_KERNEL=$(echo ${KVERSION} | sed -n 's/^\(3\.12\.4[8-9]\)\-\([0-9]*\)\-\(.*\)/\1-\2-\3/p')
if [[ ! -z ${SLES_12_1_KERNEL} ]]; then
	SLES_MAJOR="12"
	SLES_MINOR="1"
	set_config CONFIG_COMPAT_SLES_12 y
	set_config CONFIG_COMPAT_SLES_12_1 y
fi

SLES_12_2_KERNEL=$(echo ${KVERSION} | sed -n 's/^\(4\.4\.21\)\-\([0-9]*\)\-\(.*\)/\1-\2-\3/p')
if [[ ! -z ${SLES_12_2_KERNEL} ]]; then
	SLES_MAJOR="12"
	SLES_MINOR="2"
	set_config CONFIG_COMPAT_SLES_12 y
	set_config CONFIG_COMPAT_SLES_12_2 y
fi

SLES_12_3_KERNEL=$(echo ${KVERSION} | sed -n 's/^\(4\.4\.73\)\-\([0-9]*\)\-\(.*\)/\1-\2-\3/p')
if [[ ! -z ${SLES_12_3_KERNEL} ]]; then
	SLES_MAJOR="12"
	SLES_MINOR="3"
	set_config CONFIG_COMPAT_SLES_12 y
	set_config CONFIG_COMPAT_SLES_12_3 y
fi

FC14_KERNEL=$(echo ${KVERSION} | grep fc14)
if [[ ! -z ${FC14_KERNEL} ]]; then
 # CONFIG_COMPAT_DISABLE_DCB should be set to 'y' as it used in drivers/net/ethernet/mellanox/mlx4/Makefile
	set_config CONFIG_COMPAT_DISABLE_DCB y
fi

FC16_KERNEL=$(echo ${KVERSION} | grep fc16)
if [[ ! -z ${FC16_KERNEL} ]]; then
	set_config CONFIG_COMPAT_EN_SYSFS y
fi

FBK16_KERNEL=$(echo ${KVERSION} | grep 3.10.53)
if [[ ! -z ${FBK16_KERNEL} ]]; then
   set_config CONFIG_COMPAT_FBK_16 y
fi

UBUNTU12_3_2=$(uname -v | grep -qs Ubuntu && echo ${KVERSION} | grep ^3\.2)
if [[ ! -z ${UBUNTU12_3_2} ]]; then
	set_config CONFIG_COMPAT_EN_SYSFS y
fi

UBUNTU14_4_1=$(uname -v | grep -qs Ubuntu && echo ${KVERSION} | grep ^3\.13)
if [[ ! -z ${UBUNTU14_4_1} ]]; then
	set_config CONFIG_COMPAT_UBUNTU_14_4 y
fi

RHEL7_1=$(echo ${KVERSION} | grep 3.10.0-229 )
if [[ ! -z ${RHEL7_1} ]]; then
   set_config CONFIG_COMPAT_RHEL_7_1 y
fi

RHEL7_2=$(echo ${KVERSION} | grep 3.10.0-327)
if [[ ! -z ${RHEL7_2} ]]; then
   set_config CONFIG_COMPAT_RHEL_7_1 y
   set_config CONFIG_COMPAT_RHEL_7_2 y
fi

if [[ ! -z ${RHEL7_2} ]]; then
	set_config CONFIG_COMPAT_IP_TUNNELS y
	set_config CONFIG_COMPAT_TCF_GACT y
	set_config CONFIG_COMPAT_FLOW_DISSECTOR y
	set_config CONFIG_COMPAT_CLS_FLOWER_MOD m
	set_config CONFIG_COMPAT_TCF_TUNNEL_KEY_MOD m
	set_config CONFIG_COMPAT_TCF_VLAN_MOD m
fi

RHEL7_4_JD=$(echo ${KVERSION} | grep 3.10.0-693.21.3)

if [[ ! -z ${RHEL7_4_JD} ]]; then
	set_config CONFIG_COMPAT_RHEL_JD y
	set_config CONFIG_COMPAT_NFT_GEN_FLOW_OFFLOAD y
fi

if [[ ${RHEL_MAJOR} -eq "7" && ${RHEL_MINOR} -le "4" && ! $RHEL7_4_JD ]]; then
	set_config CONFIG_COMPAT_TCF_PEDIT_MOD m
fi

RHEL7_4ALT_AARCH64=$(echo ${KVERSION} | grep 4.11.0-.*el7a.aarch64)
if [[ ! -z ${RHEL7_4ALT_AARCH64} ]]; then
	set_config CONFIG_COMPAT_KERNEL_4_11_ARM y
fi

KERNEL4_14=$(echo ${KVERSION} | grep ^4\.14)
if [[ ! -z ${KERNEL4_14} ]]; then
	set_config CONFIG_COMPAT_KERNEL_4_14 y
fi

KERNEL3_10_0_327=$(echo ${KVERSION} | grep ^3\.10\.0\-327)
if [[ ! -z ${KERNEL3_10_0_327} ]]; then
	set_config CONFIG_COMPAT_KERNEL3_10_0_327 y
fi

if [[ ${CONFIG_COMPAT_KERNEL_4_14} = "y" ]]; then
	set_config CONFIG_COMPAT_CLS_FLOWER_MOD m
fi

KERNEL4_9=$(echo ${KVERSION} | grep ^4\.9)
if [[ ! -z ${KERNEL4_9} ]]; then
	set_config CONFIG_COMPAT_KERNEL_4_9 y
fi

if [[ ${CONFIG_COMPAT_KERNEL_4_9} = "y" || ${CONFIG_COMPAT_KERNEL_4_11_ARM} = "y" ]]; then
	set_config CONFIG_NET_SCHED_NEW y
	set_config CONFIG_COMPAT_FLOW_DISSECTOR y
	set_config CONFIG_COMPAT_CLS_FLOWER_MOD m
	set_config CONFIG_COMPAT_TCF_TUNNEL_KEY_MOD m
fi

if [[ ${CONFIG_COMPAT_KERNEL_4_9} = "y" ]]; then
	set_config CONFIG_COMPAT_TCF_PEDIT_MOD m
fi

if [ -e /etc/debian_version ]; then
	DEBIAN6=$(cat /etc/debian_version | grep 6\.0)
	if [[ ! -z ${DEBIAN6} ]]; then
		set_config CONFIG_COMPAT_DISABLE_DCB y
	fi
fi

if [[ ${CONFIG_COMPAT_KERNEL_2_6_38} = "y" ]]; then
	if [[ ! ${CONFIG_COMPAT_RHEL_6_3} = "y" ]]; then
		set_config CONFIG_COMPAT_NO_PRINTK_NEEDED y
	fi
fi

if [[ ${CONFIG_COMPAT_SLES_11_1} = "y" ]]; then
	set_config CONFIG_COMPAT_DISABLE_DCB y
	set_config CONFIG_COMPAT_UNDO_I6_PRINT_GIDS y
	set_config CONFIG_COMPAT_DISABLE_REAL_NUM_TXQ y
fi

if [[ ${CONFIG_COMPAT_SLES_11_2} = "y" ]]; then
	set_config CONFIG_COMPAT_MIN_DUMP_ALLOC_ARG y
	set_config CONFIG_COMPAT_IS_NUM_TX_QUEUES y
	set_config CONFIG_COMPAT_NEW_TX_RING_SCHEME y
	set_config CONFIG_COMPAT_EN_SYSFS y
fi


FC21=$(echo ${KVERSION} | grep .fc21.)
if [[ ! -z ${FC21} ]]; then
	set_config CONFIG_COMPAT_FC_21 y
fi

EL7=$(echo ${KVERSION} | grep .el7.)
if [[ ! -z ${EL7} ]]; then
	set_config CONFIG_COMPAT_EL_7 y
fi

if (grep -qw SRP_RPORT_LOST ${KLIB_BUILD}/include/scsi/scsi_transport_srp.h > /dev/null 2>&1 || grep -qw SRP_RPORT_LOST ${KSRC}/include/scsi/scsi_transport_srp.h > /dev/null 2>&1); then
	set_config SRP_NO_FAST_IO_FAIL y
fi

if (grep -qw param_mask ${KLIB_BUILD}/include/scsi/scsi_transport_iscsi.h > /dev/null 2>&1 || grep -qw param_mask ${KSRC}/include/scsi/scsi_transport_iscsi.h > /dev/null 2>&1) && \
	(grep -qw ISCSI_TGT_RESET_TMO ${KLIB_BUILD}/include/scsi/iscsi_if.h > /dev/null 2>&1 || grep -qw ISCSI_TGT_RESET_TMO ${KSRC}/include/scsi/iscsi_if.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_ISCSI_TRANSPORT_PARAM_MASK y
fi

if (grep -qw __skb_tx_hash ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw __skb_tx_hash ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS___SKB_TX_HASH y
fi

if (grep -Eq "mode_t.*attr_is_visible" ${KLIB_BUILD}/include/scsi/scsi_transport_iscsi.h > /dev/null 2>&1 || grep -Eq "mode_t.*attr_is_visible" ${KSRC}/include/scsi/scsi_transport_iscsi.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_ISER_ATTR_IS_VISIBLE y
fi

if (grep -qw iscsi_scsi_req ${KLIB_BUILD}/include/scsi/iscsi_proto.h > /dev/null 2>&1 || grep -qw iscsi_scsi_req ${KSRC}/include/scsi/iscsi_proto.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IF_ISCSI_SCSI_REQ y
fi

if (grep -q 'scsi_target_unblock(struct device \*, enum scsi_device_state)' ${KLIB_BUILD}/include/scsi/scsi_device.h  > /dev/null 2>&1 ||
    grep -q 'scsi_target_unblock(struct device \*, enum scsi_device_state)' ${KSRC}/include/scsi/scsi_device.h  > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_SCSI_TARGET_UNBLOCK y
fi

if [[ "${KVERSION}" == "2.6.32.43-0.4.1.xs1.6.10.784.170772xen" || ${KVERSION} == "2.6.32.43-0.4.1.xs1.6.10.796.170785xen" ]]; then
	set_config CONFIG_COMPAT_MIN_DUMP_ALLOC_ARG y
fi

case $KVERSION in
	2\.6\.32\.*xs.*xen)
	set_config CONFIG_COMPAT_ALLOC_PAGES_ORDER_0 y
	;;
esac

if (grep -q dst_set_neighbour ${KLIB_BUILD}/include/net/dst.h > /dev/null 2>&1 || grep -q dst_set_neighbour ${KSRC}/include/net/dst.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_DST_NEIGHBOUR y
fi

if (grep -q eth_hw_addr_random ${KLIB_BUILD}/include/linux/etherdevice.h > /dev/null 2>&1 || grep -q eth_hw_addr_random ${KSRC}/include/linux/etherdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_ETH_HW_ADDR_RANDOM y
fi

if (grep -q lro_receive_frags ${KLIB_BUILD}/include/linux/inet_lro.h > /dev/null 2>&1 || grep -q lro_receive_frags ${KSRC}/include/linux/inet_lro.h > /dev/null 2>&1); then
    check_autofconf CONFIG_INET_LRO
    if [[ X${CONFIG_INET_LRO} == "X1" ]]; then
        set_config CONFIG_COMPAT_LRO_ENABLED y
    fi
fi

if (grep -q lro_receive_skb ${KLIB_BUILD}/include/linux/inet_lro.h > /dev/null 2>&1 || grep -q lro_receive_skb ${KSRC}/include/linux/inet_lro.h > /dev/null 2>&1); then
    check_autofconf CONFIG_INET_LRO
    if [[ X${CONFIG_INET_LRO} == "X1" ]]; then
        set_config CONFIG_COMPAT_LRO_ENABLED_IPOIB y
    fi
fi

if (grep -q dev_hw_addr_random ${KLIB_BUILD}/include/linux/etherdevice.h > /dev/null 2>&1 || grep -q dev_hw_addr_random ${KSRC}/include/linux/etherdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_DEV_HW_ADDR_RANDOM y
fi

if (grep -qw "netdev_features_t" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "netdev_features_t" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NETDEV_FEATURES y
fi

if (grep -qw "WORK_BUSY_PENDING" ${KLIB_BUILD}/include/linux/workqueue.h > /dev/null 2>&1 || grep -qw "WORK_BUSY_PENDING" ${KSRC}/include/linux/workqueue.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_WORK_BUSY y
fi

if (grep -qw ieee_getmaxrate ${KLIB_BUILD}/include/net/dcbnl.h > /dev/null 2>&1 || grep -qw ieee_getmaxrate ${KSRC}/include/net/dcbnl.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_MAXRATE y
fi

if (grep -qw ieee_getqcn ${KLIB_BUILD}/include/net/dcbnl.h > /dev/null 2>&1 || grep -qw ieee_getqcn ${KSRC}/include/net/dcbnl.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_QCN y
fi

if (grep -qw reinit_completion ${KLIB_BUILD}/include/linux/completion.h > /dev/null 2>&1 || grep -qw reinit_completion ${KSRC}/include/linux/completion.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_REINIT_COMPLETION y
fi

if (grep -qw "netdev_extended" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "netdev_extended" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_NETDEV_EXTENDED y
fi

if (grep -qw "net_device_ops_ext" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "net_device_ops_ext" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_NETDEV_OPS_EXTENDED y
fi

if !(grep -qw "struct va_format" ${KLIB_BUILD}/include/linux/printk.h > /dev/null 2>&1 || grep -qw "struct va_format" ${KSRC}/include/linux/printk.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_DISABLE_VA_FORMAT_PRINT y
fi
if (grep -qw "netif_is_bond_master" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "netif_is_bond_master" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NETIF_IS_BOND_MASTER y
fi
if (grep -qw "struct xps_map" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "struct xps_map" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NETIF_IS_XPS y
fi
if (grep -qw "__netdev_pick_tx" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "__netdev_pick_tx" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NETIF_HAS_PICK_TX y
fi
if (grep -qw "netif_set_xps_queue" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "netif_set_xps_queue" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NETIF_HAS_SET_XPS_QUEUE y
fi
if (grep -qw "sk_tx_queue_get" ${KLIB_BUILD}/include/net/sock.h > /dev/null 2>&1 || grep -qw "sk_tx_queue_get" ${KSRC}/include/net/sock.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_SOCK_HAS_QUEUE y
fi
if (grep -qw "skb_has_frag_list" ${KLIB_BUILD}/include/linux/skbuff.h > /dev/null 2>&1 || grep -qw "skb_has_frag_list" ${KSRC}/include/linux/skbuff.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_SKB_HAS_FRAG_LIST y
fi
if (grep -qw "irq_set_affinity_notifier" ${KLIB_BUILD}/include/linux/interrupt.h > /dev/null 2>&1 || grep -qw "irq_set_affinity_notifier" ${KSRC}/include/linux/interrupt.h > /dev/null 2>&1); then
        set_config CONFIG_COMPAT_HAS_IRQ_AFFINITY_NOTIFIER y
fi
if (grep -qw "NETIF_F_RXHASH" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "NETIF_F_RXHASH" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NETIF_F_RXHASH y
fi
if (grep -qw "NETIF_F_RXHASH" ${KLIB_BUILD}/include/linux/netdev_features.h > /dev/null 2>&1 || grep -qw "NETIF_F_RXHASH" ${KSRC}/include/linux/netdev_features.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NETIF_F_RXHASH y
fi
if (grep -q "struct cpu_rmap {" ${KLIB_BUILD}/include/linux/cpu_rmap.h > /dev/null 2>&1 || grep -q "struct cpu_rmap {" ${KSRC}/include/linux/cpu_rmap.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_LINUX_CPU_RMAP y
fi

if [[ ${CONFIG_COMPAT_RHEL_6_4} = "y" ]]; then
	set_config CONFIG_COMPAT_NETLINK_3_7 y
	set_config CONFIG_COMPAT_HAS_NUM_CHANNELS y
	set_config CONFIG_COMPAT_ETHTOOL_OPS_EXT y
fi

if [[ ${RHEL_MAJOR} -eq "6" ]]; then
	set_config CONFIG_COMPAT_DEFINE_NUM_LRO y
	set_config CONFIG_COMPAT_EN_SYSFS y
	set_config CONFIG_COMPAT_LOOPBACK y

	if [[ ${RHEL_MINOR} -ne "1" ]]; then
		set_config CONFIG_COMPAT_IS_NUM_TX_QUEUES y
		set_config CONFIG_COMPAT_NEW_TX_RING_SCHEME y
	fi

	if [[ ${RHEL_MINOR} -eq "1" ]]; then
		set_config CONFIG_COMPAT_DISABLE_DCB y
	fi
fi

if (grep -qw kfree_rcu ${KLIB_BUILD}/include/linux/rcupdate.h > /dev/null 2>&1 || grep -qw kfree_rcu ${KSRC}/include/linux/rcupdate.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_RCU y
fi

if (grep -q kstrto ${KLIB_BUILD}/include/linux/kernel.h > /dev/null 2>&1 || grep -q kstrto ${KSRC}/include/linux/kernel.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_KSTRTOX y
fi

if (is_kernel_symbol_exported ip_tos2prio); then
	set_config CONFIG_COMPAT_IS_IP_TOS2PRIO y
fi

if (grep -qw test_bit_le ${KLIB_BUILD}/include/asm-generic/bitops/le.h > /dev/null 2>&1 || grep -qw test_bit_le ${KSRC}/include/asm-generic/bitops/le.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_BITOP y
fi

if (grep -qw "dev_uc_add(struct net_device \*dev, const unsigned char \*addr)" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "dev_uc_add(struct net_device \*dev, const unsigned char \*addr)" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_DEV_UC_MC_ADD_CONST y
fi

if (grep -qw ndo_set_vf_mac ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw ndo_set_vf_mac ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NDO_VF_MAC_VLAN y
fi

if (grep -qw ndo_set_vf_spoofchk ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw ndo_set_vf_spoofchk ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_VF_INFO_SPOOFCHK y
fi

if (grep -qw ndo_set_vf_link_state ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw ndo_set_vf_link_state ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_VF_INFO_LINKSTATE y
fi

if (grep -qw pci_physfn ${KLIB_BUILD}/include/linux/pci.h > /dev/null 2>&1 || grep -qw pci_physfn ${KSRC}/include/linux/pci.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_PCI_PHYSFN y
fi

if (grep -q "xprt_reserve_xprt_cong.*rpc_xprt" ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -q "xprt_reserve_xprt_cong.*rpc_xprt" ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_XPRT_RESERVE_XPRT_CONG_2PARAMS y
fi

if (grep -q "reserve_xprt.*rpc_xprt" ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -q "reserve_xprt.*rpc_xprt" ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_RESERVE_XPRT_2PARAMS y
fi

if (grep -qw num_prealloc ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -qw num_prealloc ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_XPRT_ALLOC_4PARAMS y
fi

if (grep -qw tk_bytes_sent ${KLIB_BUILD}/include/linux/sunrpc/sched.h > /dev/null 2>&1 || grep -qw tk_bytes_sent ${KSRC}/include/linux/sunrpc/sched.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_XPRT_TK_BYTES_SENT y
fi

if (grep -qw rpc_xprt ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -qw rpc_xprt ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1) && \
	(grep -qw rq_xmit_bytes_sent ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -qw rq_xmit_bytes_sent ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1) && \
	(grep -qw xprt_alloc ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -qw xprt_alloc ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_XPRTRDMA_NEEDED y
fi

if (grep -q virtqueue_get_buf ${KLIB_BUILD}/include/linux/virtio.h > /dev/null 2>&1 || grep -q virtqueue_get_buf ${KSRC}/include/linux/virtio.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_VIRTQUEUE_GET_BUF y
fi

if (grep -q virtqueue_add_buf ${KLIB_BUILD}/include/linux/virtio.h > /dev/null 2>&1 || grep -q virtqueue_add_buf ${KSRC}/include/linux/virtio.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_VIRTQUEUE_ADD_BUF y
fi

if (grep -q virtqueue_kick ${KLIB_BUILD}/include/linux/virtio.h > /dev/null 2>&1 || grep -q virtqueue_kick ${KSRC}/include/linux/virtio.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_VIRTQUEUE_KICK y
fi

if (grep -q zc_request ${KLIB_BUILD}/include/net/9p/transport.h > /dev/null 2>&1 || grep -q zc_request ${KSRC}/include/net/9p/transport.h > /dev/null 2>&1); then
        set_config CONFIG_COMPAT_ZC_REQUEST y
fi

if (grep -q gfp_t ${KLIB_BUILD}/tools/include/virtio/linux/virtio.h > /dev/null 2>&1 || grep -q gfp_t ${KSRC}/include/linux/virtio.h > /dev/null 2>&1); then
        set_config CONFIG_COMPAT_GFP_T y
fi

if (grep -q virtqueue_add_buf_gfp ${KLIB_BUILD}/tools/include/virtio/linux/virtio.h > /dev/null 2>&1 || grep -q virtqueue_add_buf_gfp ${KSRC}/include/linux/virtio.h > /dev/null 2>&1); then
        set_config CONFIG_COMPAT_VIRTQUEUE_ADD_BUF_GFP y
fi

if (grep -q TCA_CODEL_UNSPEC ${KLIB_BUILD}/include/linux/pkt_sched.h > /dev/null 2>&1 || grep -q TCA_CODEL_UNSPEC ${KSRC}/include/linux/pkt_sched.h > /dev/null 2>&1); then
        set_config CONFIG_TCA_CODEL_UNSPEC y
fi

if (grep -q TCA_FQ_CODEL_UNSPEC ${KLIB_BUILD}/include/linux/pkt_sched.h > /dev/null 2>&1 || grep -q TCA_FQ_CODEL_UNSPEC ${KSRC}/include/linux/pkt_sched.h > /dev/null 2>&1); then
        set_config CONFIG_TCA_FQ_CODEL_UNSPEC y
fi

if (grep -q "struct tc_codel_xstats {" ${KLIB_BUILD}/include/linux/pkt_sched.h > /dev/null 2>&1 || grep -q "struct tc_codel_xstats {" ${KSRC}/include/linux/pkt_sched.h > /dev/null 2>&1); then
        set_config CONFIG_TC_CODEL_XSTATS y
fi

if (grep -q TCA_FQ_CODEL_XSTATS_QDISC ${KLIB_BUILD}/include/linux/pkt_sched.h > /dev/null 2>&1 || grep -q TCA_FQ_CODEL_XSTATS_QDISC ${KSRC}/include/linux/pkt_sched.h > /dev/null 2>&1); then
        set_config CONFIG_TCA_FQ_CODEL_XSTATS_QDISC y
fi

if (grep -q "struct tc_fq_codel_xstats {" ${KLIB_BUILD}/include/linux/pkt_sched.h > /dev/null 2>&1 || grep -q "struct tc_fq_codel_xstats {" ${KSRC}/include/linux/pkt_sched.h > /dev/null 2>&1); then
        set_config CONFIG_TC_FQ_CODEL_XSTATS y
fi

if (grep -q "struct tc_fq_codel_cl_stats {" ${KLIB_BUILD}/include/linux/pkt_sched.h > /dev/null 2>&1 || grep -q "struct tc_fq_codel_cl_stats {" ${KSRC}/include/linux/pkt_sched.h > /dev/null 2>&1); then
        set_config CONFIG_TC_FQ_CODEL_CL_STATS y
fi

if (grep -q "struct tc_fq_codel_qd_stats {" ${KLIB_BUILD}/include/linux/pkt_sched.h > /dev/null 2>&1 || grep -q "struct tc_fq_codel_qd_stats {" ${KSRC}/include/linux/pkt_sched.h > /dev/null 2>&1); then
        set_config CONFIG_TC_FQ_CODEL_QD_STATS y
fi

if (grep -q iscsi_eh_target_reset ${KLIB_BUILD}/include/scsi/libiscsi.h > /dev/null 2>&1 || grep -q iscsi_eh_target_reset ${KSRC}/include/scsi/libiscsi.h > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_ISCSI_EH_TARGET_RESET y
fi

if (grep -q bitmap_set ${KLIB_BUILD}/include/linux/bitmap.h > /dev/null 2>&1 || grep -q bitmap_set ${KSRC}/include/linux/bitmap.h > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_IS_BITMAP y
fi

if (grep -A2 __blkdev_issue_zeroout ${KLIB_BUILD}/include/linux/blkdev.h | grep -q "unsigned flags" > /dev/null 2>&1 ||
    grep -A2 __blkdev_issue_zeroout ${KSRC}/include/linux/blkdev.h | grep -q "unsigned flags" > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_IS_BLKDEV_ISSUE_ZEROOUT_HAS_FLAGS y
fi

if (grep -Eq "struct in_device.*idev" ${KLIB_BUILD}/include/net/route.h > /dev/null 2>&1 || grep -Eq "struct in_device.*idev" ${KSRC}/include/net/route.h > /dev/null 2>&1); then
		set_config CONFIG_IS_RTABLE_IDEV y
fi

if (grep -q netdev_get_prio_tc_map ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || egrep -q netdev_get_prio_tc_map ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_IS_PRIO_TC_MAP y
fi

if (grep -q rx_handler_result ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || egrep -q rx_handler_result ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
		set_config CONFIG_IS_RX_HANDLER_RESULT y
fi

if (grep -q ndo_add_slave ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || egrep -q ndo_add_slave ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
		set_config CONFIG_IS_NDO_ADD_SLAVE y
fi

if (grep -q get_module_eeprom ${KLIB_BUILD}/include/linux/ethtool.h > /dev/null 2>&1 || grep -q get_module_eeprom ${KSRC}/include/linux/ethtool.h > /dev/null 2>&1); then
         set_config CONFIG_MODULE_EEPROM_ETHTOOL y
fi

if (grep -q get_ts_info ${KLIB_BUILD}/include/linux/ethtool.h > /dev/null 2>&1 || grep -q get_ts_info ${KSRC}/include/linux/ethtool.h > /dev/null 2>&1); then
        set_config CONFIG_TIMESTAMP_ETHTOOL y
fi

if (grep -q get_rxfh_indir ${KLIB_BUILD}/include/linux/ethtool.h > /dev/null 2>&1 || grep -q get_rxfh_indir ${KSRC}/include/linux/ethtool.h > /dev/null 2>&1); then
        set_config CONFIG_COMPAT_INDIR_SETTING y
fi

if ! (grep -q get_channels ${KLIB_BUILD}/include/linux/ethtool.h > /dev/null 2>&1 || grep -q get_channels ${KSRC}/include/linux/ethtool.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_NUM_CHANNELS y
fi

if ! (grep -q dcbnl_rtnl_ops ${KLIB_BUILD}/include/net/dcbnl.h > /dev/null 2>&1 || grep -q dcbnl_rtnl_ops ${KSRC}/include/net/dcbnl.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_DISABLE_DCB y
fi

check_autofconf CONFIG_NET_SCH_MQPRIO_MODULE
if [[ X${CONFIG_NET_SCH_MQPRIO_MODULE} != "X1" ]]; then
	if  (grep -q netdev_get_prio_tc_map ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -q netdev_get_prio_tc_map ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
		if [[ ! ${CONFIG_COMPAT_RHEL_6_1} = "y" ]]; then
			set_config CONFIG_COMPAT_MQPRIO y
		fi
	else
		set_config CONFIG_COMPAT_DISABLE_DCB y
	fi
fi

if [ X${CONFIG_COMPAT_IS_MAXRATE} != "Xy" -o X${CONFIG_COMPAT_MQPRIO} = "Xy" -o X${CONFIG_COMPAT_INDIR_SETTING} = "Xy" -o X${CONFIG_COMPAT_NUM_CHANNELS} = "Xy" -o X${CONFIG_COMPAT_LOOPBACK} = "Xy" -o X${CONFIG_COMPAT_IS_QCN} != "Xy" ]; then
	set_config CONFIG_COMPAT_EN_SYSFS y
fi

if (grep -q skb_inner_transport_header ${KLIB_BUILD}/include/linux/skbuff.h > /dev/null 2>&1 || grep -q skb_inner_transport_header ${KSRC}/include/linux/skbuff.h > /dev/null 2>&1); then
	check_autofconf CONFIG_VXLAN
	if [[ X${CONFIG_VXLAN} == "X1" ]]; then
		set_config CONFIG_COMPAT_VXLAN_ENABLED y
		if (grep ndo_add_vxlan_port ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep ndo_add_vxlan_port ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
			set_config CONFIG_COMPAT_VXLAN_DYNAMIC_PORT y
		fi
	fi
fi

if (grep -qw __IFLA_VF_LINK_STATE_MAX ${KLIB_BUILD}/include/uapi/linux/if_link.h > /dev/null 2>&1 || grep -qw __IFLA_VF_LINK_STATE_MAX ${KSRC}/include/uapi/linux/if_link.h > /dev/null 2>&1 ||
    grep -qw __IFLA_VF_LINK_STATE_MAX ${KLIB_BUILD}/include/linux/if_link.h > /dev/null 2>&1 || grep -qw __IFLA_VF_LINK_STATE_MAX ${KSRC}/include/linux/if_link.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IFLA_VF_LINK_STATE_MAX y
fi

if (grep -qw vlan_dev_get_egress_qos_mask ${KLIB_BUILD}/include/linux/if_vlan.h > /dev/null 2>&1 || grep -qw vlan_dev_get_egress_qos_mask ${KSRC}/include/linux/if_vlan.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_VLAN_EGRESS_VISIBLE y
fi

if ! (grep -qw "genl_register_family_with_ops_groups" ${KLIB_BUILD}/include/net/genetlink.h > /dev/null 2>&1 || grep -qw "genl_register_family_with_ops_groups" ${KSRC}/include/net/genetlink.h > /dev/null 2>&1); then
	set_config CONFIG_GENETLINK_IS_LIST_HEAD y
fi

if (grep -q "unsigned lockless" ${KLIB_BUILD}/include/scsi/scsi_host.h > /dev/null 2>&1 || grep -q "unsigned lockless" ${KSRC}/include/scsi/scsi_host.h > /dev/null 2>&1); then
	set_config CONFIG_IS_SCSI_LOCKLESS y
fi

if (grep -q "int  (\*setnumtcs)(struct net_device \*, int, u8)" ${KLIB_BUILD}/include/net/dcbnl.h > /dev/null 2>&1 || grep -q "int  (\*setnumtcs)(struct net_device \*, int, u8)" ${KSRC}/include/net/dcbnl.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_SETNUMTCS_INT y
fi

if ((grep -q ndo_fdb_add ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -q ndo_fdb_add ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1) &&
    !(grep -q net_device_extended ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -q net_device_extended ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1)); then
	set_config CONFIG_COMPAT_FDB_API_EXISTS y

	if (grep ndo_fdb_add -A 4 ${KLIB_BUILD}/include/linux/netdevice.h 2>/dev/null | grep -q "struct nlattr \*tb" > /dev/null 2>&1 || grep ndo_fdb_add -A 4 ${KSRC}/include/linux/netdevice.h 2>/dev/null | grep -q "struct nlattr \*tb" > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_FDB_ADD_NLATTR y
	fi

	if (grep ndo_fdb_del -A 3 ${KLIB_BUILD}/include/linux/netdevice.h 2>/dev/null | grep -q "struct nlattr \*tb" > /dev/null 2>&1 || grep ndo_fdb_del -A 3 ${KSRC}/include/linux/netdevice.h 2>/dev/null | grep -q "struct nlattr \*tb" > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_FDB_DEL_NLATTR y
	fi

	if (grep ndo_fdb_add -A 4 ${KLIB_BUILD}/include/linux/netdevice.h 2>/dev/null | grep -q "const unsigned char \*addr" > /dev/null 2>&1 || grep ndo_fdb_add -A 4 ${KSRC}/include/linux/netdevice.h 2>/dev/null | grep -q "const unsigned char \*addr" > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_FDB_CONST_ADDR y
	fi

	if (grep ndo_fdb_add -A 5 ${KLIB_BUILD}/include/linux/netdevice.h 2>/dev/null | grep -q "u16 vid" > /dev/null 2>&1 || grep ndo_fdb_add -A 5 ${KSRC}/include/linux/netdevice.h 2>/dev/null | grep -q "u16 vid" > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_FDB_U16_VID y
	fi
fi

if (grep -q "const struct sysfs_ops \n*sysfs_ops" ${KLIB_BUILD}/include/linux/kobject.h > /dev/null 2>&1 || grep -q "const struct sysfs_ops \*sysfs_ops" ${KSRC}/include/linux/kobjetc.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_SYSFS_OPS_CONST y
fi

if (grep -q "void \*accel_priv" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -q "void \*accel_priv" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_SELECT_QUEUE_ACCEL y
fi

if (grep -q "select_queue_fallback_t" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -q "select_queue_fallback_t" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_SELECT_QUEUE_FALLBACK y
fi

if (grep -q ptp_clock_info ${KLIB_BUILD}/include/linux/ptp_clock_kernel.h > /dev/null 2>&1 || grep -q ptp_clock_info ${KSRC}/include/linux/ptp_clock_kernel.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_PTP_CLOCK y
	if (grep -q n_pins ${KLIB_BUILD}/include/linux/ptp_clock_kernel.h > /dev/null 2>&1 || grep -q n_pins ${KSRC}/include/linux/ptp_clock_kernel.h > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_PTP_N_PINS y
	fi

	if (grep ptp_clock_register -A 1 ${KLIB_BUILD}/include/linux/ptp_clock_kernel.h 2>/dev/null | grep -q "struct device \*parent"> /dev/null 2>&1 || grep ptp_clock_register -A 1 ${KSRC}/include/linux/ptp_clock_kernel.h 2>/dev/null | grep -q "struct device \*parent" > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_PTP_CLOCK_REGISTER y
	fi
fi

if (grep -q THIS_MODULE ${KLIB_BUILD}/include/linux/export.h > /dev/null 2>&1 || grep -q THIS_MODULE ${KSRC}/include/linux/export.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_THIS_MODULE y
fi

if (grep -q "struct timecompare" ${KLIB_BUILD}/include/linux/timecompare.h > /dev/null 2>&1 || grep -q "struct timecompare" ${KSRC}/include/linux/timecompare.h > /dev/null 2>&1); then
	if !(grep -q ptp_clock_info ${KLIB_BUILD}/include/linux/ptp_clock_kernel.h > /dev/null 2>&1 || grep -q ptp_clock_info ${KSRC}/include/linux/ptp_clock_kernel.h > /dev/null 2>&1); then
		set_config CONFIG_COMPAT_TIMECOMPARE y
	fi
fi

if ! is_kernel_symbol_exported __put_task_struct || ! is_kernel_symbol_exported get_pid_task || ! is_kernel_symbol_exported get_task_pid; then
	set_config CONFIG_COMPAT_MISS_TASK_FUNCS y
fi

if (grep -q 'const void \*(\*namespace)(struct class \*class' ${KLIB_BUILD}/include/linux/device.h > /dev/null 2>&1 || grep -q 'const void \*(\*namespace)(struct class \*class' ${KSRC}/include/linux/device.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_CLASS_ATTR_NAMESPACE y
fi

if (grep -q "spinlock_t\s*frwd_lock;" ${KLIB_BUILD}/include/scsi/libiscsi.h > /dev/null 2>&1 || grep -q "spinlock_t\s*frwd_lock;" ${KSRC}/include/scsi/libiscsi.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_ISCSI_SESSION_FRWD_LOCK y
fi

if (grep -qw "compound_trans_head" ${KLIB_BUILD}/include/linux/huge_mm.h > /dev/null 2>&1 || grep -qw "compound_trans_head" ${KSRC}/include/linux/huge_mm.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_USE_COMPOUND_TRANS_HEAD y
fi

if (grep -qw "max_tx_rate" ${KLIB_BUILD}/include/linux/if_link.h > /dev/null 2>&1 || grep -qw "max_tx_rate" ${KSRC}/include/linux/if_link.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_VF_INFO_MAX_TX_RATE y
fi

#‘struct net_device’ has no member named ‘num_tc’
if (grep -qw 'dev->num_tc' ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw 'dev->num_tc' ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_NET_DEVICE_IS_NUM_TC y
fi

if (grep -Ewq "sysfs_dirent.*sysfs_get_dirent" ${KLIB_BUILD}/include/linux/sysfs.h > /dev/null 2>&1 || grep -Ewq "sysfs_dirent.*sysfs_get_dirent" ${KSRC}/include/linux/sysfs.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_SYSFS_DIRENT_SYSFS_GET_DIRENTY y
fi

if (grep -qw "filter_dev" ${KLIB_BUILD}/include/linux/rtnetlink.h > /dev/null 2>&1 || grep -qw "filter_dev" ${KSRC}/include/linux/rtnetlink.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_FILTER_DEV y
fi

if (grep -q "int.*\*setapp" ${KLIB_BUILD}/include/net/dcbnl.h > /dev/null 2>&1 || grep -q "int.*\*setapp" ${KSRC}/include/net/dcbnl.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_INT_SETAPP y
fi

if (grep -wq "ETH_FLAG_TXVLAN" ${KLIB_BUILD}/include/linux/ethtool.h > /dev/null 2>&1 || grep -wq "ETH_FLAG_TXVLAN" ${KSRC}/include/linux/ethtool.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_ETH_FLAG_TXVLAN y
fi

if (grep -wq "enum pcie_link_width" ${KLIB_BUILD}/include/linux/pci.h > /dev/null 2>&1 || grep -wq "enum pcie_link_width" ${KSRC}/include/linux/pci.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_ENUM_PCIE_LINK_WIDTH y
fi

if (grep -wq "xpo_secure_port" ${KLIB_BUILD}/include/linux/sunrpc/svc_xprt.h > /dev/null 2>&1 || grep -wq "xpo_secure_port" ${KSRC}/include/linux/sunrpc/svc_xprt.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_SVC_XPRT_OPS_XPO_SECURE_PORT y
fi

if (grep -wq "irq_desc_get_irq_data" ${KLIB_BUILD}/include/linux/irqdesc.h > /dev/null 2>&1 || grep -wq "irq_desc_get_irq_data" ${KSRC}/include/linux/irqdesc.h > /dev/null 2>&1) \
	&& is_kernel_symbol_exported irq_to_desc ; then
    set_config CONFIG_COMPAT_IS_IRQ_DESC_GET_IRQ_DATA y
fi

if (grep -wq "xcl_ident" ${KLIB_BUILD}/include/linux/sunrpc/svc_xprt.h > /dev/null 2>&1 || grep -wq "xcl_ident" ${KSRC}/include/linux/sunrpc/svc_xprt.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_SVC_XPRT_CLASS_XCL_IDENT y
fi

if (grep -wq "xprt_alloc(struct net \*net" ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -wq "xprt_alloc(struct net \*net" ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_XPRT_CREATE_NET y
fi

if (grep -wq "rq_xmit_bytes_sent" ${KLIB_BUILD}/include/linux/sunrpc/xprt.h > /dev/null 2>&1 || grep -wq "rq_xmit_bytes_sent" ${KSRC}/include/linux/sunrpc/xprt.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_RPC_RQST_RQ_XMIT_BYTES_SENT y
fi

if [[ -e  ${KLIB_BUILD}/include/linux/sunrpc/addr.h || -e ${KSRC}/include/linux/sunrpc/addr.h ]]; then
    set_config CONFIG_COMPAT_IS_SUNRPC_ADDR_H y
fi

if (grep -q "inet_num" ${KLIB_BUILD}/include/net/inet_sock.h > /dev/null 2>&1 || grep -q "inet_num" ${KSRC}/include/net/inet_sock.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_INET_SOCK_INET_NUM y
fi

if (grep -q "sk->sk_wq" ${KLIB_BUILD}/include/net/sock.h > /dev/null 2>&1 || grep -q "sk->sk_wq" ${KSRC}/include/net/sock.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_SOCK_SK_WQ y
fi

check_autofconf CONFIG_BQL
if [[ X${CONFIG_BQL} == "X1" ]]; then
    if (grep -wq "struct dql" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -wq "struct dql" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
        set_config CONFIG_COMPAT_IS_NETDEV_DQL y
    fi
fi

if (grep -wq "xmit_more" ${KLIB_BUILD}/include/linux/skbuff.h > /dev/null 2>&1 || grep -wq "xmit_more" ${KSRC}/include/linux/skbuff.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_XMIT_MORE y
fi

if (grep -wq "get_tunable" ${KLIB_BUILD}/include/linux/ethtool.h > /dev/null 2>&1 || grep -wq "get_tunable" ${KSRC}/include/linux/ethtool.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_GET_TUNABLE y
fi

if (grep -q "scsi_transfer_length" ${KLIB_BUILD}/include/scsi/scsi_cmnd.h > /dev/null 2>&1 || grep -q "scsi_transfer_length" ${KSRC}/include/scsi/scsi_cmnd.h  > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_SCSI_TRANSFER_LENGTH y
fi

if (grep -wq "smp_mb__after_atomic" ${KLIB_BUILD}/include/asm-generic/barrier.h > /dev/null 2>&1 || grep -wq "smp_mb__after_atomic" ${KSRC}/include/asm-generic/barrier.h > /dev/null 2>&1); then
    set_config CONFIG_COMPAT_IS_SMP_MB__AFTER_ATOMIC y
fi

if (grep -qw iscsit_wait_conn ${KLIB_BUILD}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1 || grep -qw iscsit_wait_conn ${KSRC}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_ISCSIT_WAIT_CONN y
fi

if (grep -qw iscsit_aborted_task ${KLIB_BUILD}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1 || grep -qw iscsit_aborted_task ${KSRC}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_ISCSIT_ABORTED_TASK y
fi

if (grep -qw iscsit_get_sup_prot_ops ${KLIB_BUILD}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1 || grep -qw iscsit_get_sup_prot_ops ${KSRC}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_ISCSIT_GET_SUP_PROT_OPS y
fi

if (grep -qw iscsit_priv_cmd ${KLIB_BUILD}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1 || grep -qw iscsit_aborted_task ${KSRC}/include/target/iscsi/iscsi_transport.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_ISCSIT_PRIV_CMD y
fi

if (grep -qw iscsi_change_queue_depth ${KLIB_BUILD}/include/scsi/libiscsi.h > /dev/null 2>&1 || grep -qw iscsi_change_queue_depth ${KSRC}/include/scsi/libiscsi.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_ISCSI_CHANGE_QUEUE_DEPTH y
fi

if (grep -qw file_inode ${KLIB_BUILD}/include/linux/fs.h > /dev/null 2>&1 || grep -qw file_inode ${KSRC}/include/linux/fs.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_FILE_INODE y
fi

if (grep -A5 "struct msghdr" ${KLIB_BUILD}/include/linux/socket.h 2>&1 | grep -qw msg_iov || grep -A5 "struct msghdr" ${KSRC}/include/linux/socket.h 2>&1 | grep -qw msg_iov); then
	set_config CONFIG_COMPAT_IS_MSG_IOV y
fi

if (grep -qw get_unused_fd ${KLIB_BUILD}/include/linux/file.h > /dev/null 2>&1 || grep -qw get_unused_fd ${KSRC}/include/linux/file.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_GET_UNUSED_FD y
fi

if (grep -qw this_cpu_ptr ${KLIB_BUILD}/include/linux/percpu-defs.h > /dev/null 2>&1 || grep -qw this_cpu_ptr ${KSRC}/include/linux/percpu-defs.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_THIS_CPU_PTR y
fi

if (grep -qw "int nlmsg_validate(struct nlmsghdr" ${KLIB_BUILD}/include/net/netlink.h > /dev/null 2>&1 || grep -qw "int nlmsg_validate(struct nlmsghdr" ${KSRC}/include/net/netlink.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_NLMSG_VALIDATE_NOT_CONST_NLMSGHDR y
fi

if (grep -qw "const struct pci_error_handlers" ${KLIB_BUILD}/include/linux/pci.h > /dev/null 2>&1 || grep -qw "const struct pci_error_handlers" ${KSRC}/include/linux/pci.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_CONST_PCI_ERROR_HANDLERS y
fi

if (grep -qw "const struct sysfs_ops *sysfs_ops" ${KLIB_BUILD}/include/linux/kobject.h > /dev/null 2>&1 || grep -qw "const struct sysfs_ops *sysfs_ops" ${KSRC}/include/linux/kobject.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_CONST_KOBJECT_SYSFS_OPS y
fi

if (grep -qw "int netif_set_xps_queue(struct net_device \*dev, struct cpumask \*mask" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "int netif_set_xps_queue(struct net_device \*dev, struct cpumask \*mask" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_NETIF_SET_XPS_QUEUE_NOT_CONST_CPUMASK y
fi

if (grep -qw "const struct dcbnl_rtnl_ops \*dcbnl_ops" ${KLIB_BUILD}/include/linux/netdevice.h > /dev/null 2>&1 || grep -qw "const struct dcbnl_rtnl_ops \*dcbnl_ops" ${KSRC}/include/linux/netdevice.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_DCBNL_OPS_CONST y
fi

if (grep -qw "static.* fib_lookup" ${KLIB_BUILD}/include/net/ip_fib.h > /dev/null 2>&1 || grep -qw "static.* fib_lookup" ${KSRC}/include/net/ip_fib.h > /dev/null 2>&1) &&
   (grep -qw "extern.* fib_lookup" ${KLIB_BUILD}/include/net/ip_fib.h > /dev/null 2>&1 || grep -qw "extern.* fib_lookup" ${KSRC}/include/net/ip_fib.h > /dev/null 2>&1); then
	set_config CONFIG_COMPAT_IS_FIB_LOOKUP_STATIC_AND_EXTERN y
fi

HASH_TYPES=${KLIB_BUILD}/include/linux/rhashtable-types.h
HASH_TYPES2=${KSRC}/include/linux/rhashtable-types.h

if (test ! -f "$HASH_TYPES" -a ! -f "$HASH_TYPES2"); then
	if (grep -E -A10 "struct rhashtable \{" ${KLIB_BUILD}/include/linux/rhashtable.h 2>&1 | grep -qw rhlist || grep -A5 "struct rhashtable \{" ${KSRC}/include/linux/rhashtable 2>&1 | grep -qw rhlist); then
		if (grep -E -A5 "if \(\!key \|\|" ${KLIB_BUILD}/include/linux/rhashtable.h 2>&1 | grep -qw pprev || grep -A5 "if \(\!key \|\|" ${KSRC}/include/linux/rhashtable 2>&1 | grep -qw pprev); then
			set_config CONFIG_COMPAT_RHASHTABLE_FIXED y
		fi
		if (grep -E -A5 "struct rhashtable \{" ${KLIB_BUILD}/include/linux/rhashtable.h 2>&1 | grep -qw nelems || grep -A5 "struct rhashtable \{" ${KSRC}/include/linux/rhashtable 2>&1 | grep -qw nelems); then
			set_config CONFIG_COMPAT_RHASHTABLE_NOT_REORG y
		fi
		if (grep -E -A2 "struct rhashtable_params \{" ${KLIB_BUILD}/include/linux/rhashtable.h 2>&1 | grep -qw u16 || grep -A2 "struct rhashtable_params \{" ${KSRC}/include/linux/rhashtable 2>&1 | grep -qw u16); then
			set_config CONFIG_COMPAT_RHASHTABLE_PARAM_COMPACT y
		fi
	fi
fi

