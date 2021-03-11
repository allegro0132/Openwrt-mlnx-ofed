#include <linux/version.h>
#include "config.h"

#if LINUX_VERSION_CODE >= KERNEL_VERSION (2, 6, 28)

#if LINUX_VERSION_CODE < KERNEL_VERSION (2, 6, 34) && \
!defined (HAVE_ISCSI_EH_TARGET_RESET)
#error HAVE_ISCSI_EH_TARGET_RESET is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (2, 6, 34)

#ifndef HAVE_PCI_BUS_SPEED
#error HAVE_PCI_BUS_SPEED is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (2, 6, 39)

#ifndef HAVE_ISCSI_GET_EP_PARAM
#error HAVE_ISCSI_GET_EP_PARAM is not defined
#endif

/*#ifndef HAVE_VLAN_HWACCEL_RECEIVE_SKB
#error HAVE_VLAN_HWACCEL_RECEIVE_SKB is not defined
#endif*/

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 1, 0)

#ifndef HAVE_ISCSI_SCSI_REQ
#error HAVE_ISCSI_SCSI_REQ is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 2, 0)

#ifndef HAVE_ISCSI_ATTR_IS_VISIBLE
#error HAVE_ISCSI_ATTR_IS_VISIBLE is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 3, 0)

#if LINUX_VERSION_CODE < KERNEL_VERSION (3, 6, 0) && \
!defined (HAVE_DST_GET_NEIGHBOUR)
#error HAVE_DST_GET_NEIGHBOUR is not defined
#endif

#if LINUX_VERSION_CODE < KERNEL_VERSION (3, 18, 0) && \
!defined (HAVE_ISCSI_CHANGE_QUEUE_DEPTH)
#error HAVE_ISCSI_CHANGE_QUEUE_DEPTH is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 8, 0)

#ifndef HAVE_REQUEST_QUEUE_REQUEST_FN_ACTIVE
#error HAVE_REQUEST_QUEUE_REQUEST_FN_ACTIVE is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 12, 0)

#ifndef HAVE_PTR_ERR_OR_ZERO
#error HAVE_PTR_ERR_OR_ZERO is not defined
#endif

#ifndef HAVE_ISCSI_DISCOVERY_SESS
#error HAVE_ISCSI_DISCOVERY_SESS is not defined
#endif

#ifndef HAVE_ISCSI_PARAM_DISCOVERY_SESS
#error HAVE_ISCSI_PARAM_DISCOVERY_SESS is not defined
#endif

#ifndef HAVE_PCIE_LINK_WIDTH
#error HAVE_PCIE_LINK_WIDTH is not defined
#endif

#ifndef HAVE_NETDEV_PHYS_PORT_ID
#error HAVE_NETDEV_PHYS_PORT_ID is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 13, 0)

#ifndef HAVE_NET_GET_RANDOM_ONCE
#error HAVE_NET_GET_RANDOM_ONCE is not defined
#endif

#ifndef HAVE_INET_EHASHFN
#error HAVE_INET_EHASHFN is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 14, 0)

#ifndef HAVE_PCI_ENABLE_MSIX_RANGE
#error HAVE_PCI_ENABLE_MSIX_RANGE is not defined
#endif

#ifndef HAVE_SELECT_QUEUE_FALLBACK_T
#error HAVE_SELECT_QUEUE_FALLBACK_T is not defined
#endif

#ifndef HAVE_SKB_SET_HASH
#error HAVE_SKB_SET_HASH is not defined
#endif

#ifndef HAVE_SIOCGHWTSTAMP
#error HAVE_SIOCGHWTSTAMP is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 15, 0)

#ifndef HAVE_PCI_ENABLE_MSI_EXACT
#error HAVE_PCI_ENABLE_MSI_EXACT is not defined
#endif

#ifndef HAVE_PTP_CLOCK_INFO_N_PINS
#error HAVE_PTP_CLOCK_INFO_N_PINS is not defined
#endif

#ifndef HAVE_NET_DEVICE_DEV_PORT
#error HAVE_NET_DEVICE_DEV_PORT is not defined
#endif

#ifndef HAVE_ISCSI_CHECK_PROTECTION
#error HAVE_ISCSI_CHECK_PROTECTION is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 16, 0)

#ifndef HAVE_TX_RATE_LIMIT
#error HAVE_TX_RATE_LIMIT is not defined
#endif

#ifndef HAVE_GET_SET_RXFH
#error HAVE_GET_SET_RXFH is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 17, 0)

#ifndef HAVE_KTIME_GET_NS
#error HAVE_KTIME_GET_NS is not defined
#endif

#ifndef HAVE_XCL_IDENT
#error HAVE_XCL_IDENT is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 18, 0)

#ifndef HAVE_GET_SET_TUNABLE
#error HAVE_GET_SET_TUNABLE is not defined
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION (3, 19, 0)

/* TBD - move the checkers below to the corresponding kernel version #if */
#ifndef HAVE_LINKSTATE
#error HAVE_LINKSTATE is not defined
#endif

#ifndef HAVE_SKB_MARK_NAPI_ID
#error HAVE_SKB_MARK_NAPI_ID is not defined
#endif

#ifndef HAVE_NAPI_HASH_ADD
#error HAVE_NAPI_HASH_ADD is not defined
#endif

#ifndef HAVE_NETIF_KEEP_DST
#error HAVE_NETIF_KEEP_DST is not defined
#endif

#ifndef HAVE_DEV_CONSUME_SKB_ANY
#error HAVE_DEV_CONSUME_SKB_ANY is not defined
#endif

#ifndef HAVE_NETDEV_TXQ_BQL_PREFETCHW
#error HAVE_NETDEV_TXQ_BQL_PREFETCHW is not defined
#endif

#ifndef HAVE_SK_BUFF_XMIT_MORE
#error HAVE_SK_BUFF_XMIT_MORE is not defined
#endif

#ifndef HAVE_SK_BUFF_ENCAPSULATION
#error HAVE_SK_BUFF_ENCAPSULATION is not defined
#endif

#ifndef HAVE_ETH_GET_HEADLEN
#error HAVE_ETH_GET_HEADLEN is not defined
#endif

#ifndef HAVE_SK_BUFF_CSUM_LEVEL
#error HAVE_SK_BUFF_CSUM_LEVEL is not defined
#endif

#ifndef HAVE_SKB_INNER_TRANSPORT_HEADER
#error HAVE_SKB_INNER_TRANSPORT_HEADER is not defined
#endif

#ifndef HAVE_SKB_INNER_NETWORK_HEADER
#error HAVE_SKB_INNER_NETWORK_HEADER is not defined
#endif

#ifndef HAVE_VLAN_DEV_GET_EGRESS_QOS_MASK
#error HAVE_VLAN_DEV_GET_EGRESS_QOS_MASK is not defined
#endif

#ifndef HAVE_NETDEV_GET_PRIO_TC_MAP
#error HAVE_NETDEV_GET_PRIO_TC_MAP is not defined
#endif

#ifndef HAVE___VLAN_FIND_DEV_DEEP_RCU
#error HAVE___VLAN_FIND_DEV_DEEP_RCU is not defined
#endif

#ifndef HAVE_BONDING_H
#error HAVE_BONDING_H is not defined
#endif

#ifndef HAVE_U64_STATS_SYNC
#error HAVE_U64_STATS_SYNC is not defined
#endif

#ifndef HAVE_U64_STATS_FETCH_BEGIN_IRQ
#error HAVE_U64_STATS_FETCH_BEGIN_IRQ is not defined
#endif

#ifndef HAVE_ETHER_ADDR_COPY
#error HAVE_ETHER_ADDR_COPY is not defined
#endif

#ifndef HAVE_SET_VF_RATE
#error HAVE_SET_VF_RATE is not defined
#endif

#ifndef HAVE_NETIF_SET_XPS_QUEUE
#error HAVE_NETIF_SET_XPS_QUEUE is not defined
#endif

#ifndef HAVE_NDO_SET_FEATURES
#error HAVE_NDO_SET_FEATURES is not defined
#endif

#ifndef HAVE_NDO_SETUP_TC
#error HAVE_NDO_SETUP_TC is not defined
#endif

#ifndef HAVE_NDO_RX_FLOW_STEER
#error HAVE_NDO_RX_FLOW_STEER is not defined
#endif

#ifndef HAVE_NET_DEVICE_PRIV_FLAGS
#error HAVE_NET_DEVICE_PRIV_FLAGS is not defined
#endif

#ifndef HAVE_NDO_GET_STATS64
#error HAVE_NDO_GET_STATS64 is not defined
#endif

#ifndef HAVE_NDO_BRIDGE_SET_GET_LINK
#error HAVE_NDO_BRIDGE_SET_GET_LINK is not defined
#endif

#ifndef HAVE_NETDEV_NDO_GET_PHYS_PORT_ID
#error HAVE_NETDEV_NDO_GET_PHYS_PORT_ID is not defined
#endif

#ifndef HAVE_NETDEV_OPS_NDO_SET_VF_SPOOFCHK
#error HAVE_NETDEV_OPS_NDO_SET_VF_SPOOFCHK is not defined
#endif

#ifndef HAVE_NETDEV_OPS_NDO_SET_VF_LINK_STATE
#error HAVE_NETDEV_OPS_NDO_SET_VF_LINK_STATE is not defined
#endif

#ifndef HAVE_RETURN_INT_FOR_SET_NUM_TX_QUEUES
#error HAVE_RETURN_INT_FOR_SET_NUM_TX_QUEUES is not defined
#endif

#ifndef HAVE_XPS_MAP
#error HAVE_XPS_MAP is not defined
#endif

#ifndef HAVE_SET_PHYS_ID
#error HAVE_SET_PHYS_ID is not defined
#endif

#ifndef HAVE_GET_SET_CHANNELS
#error HAVE_GET_SET_CHANNELS is not defined
#endif

#ifndef HAVE_GET_TS_INFO
#error HAVE_GET_TS_INFO is not defined
#endif

#ifndef HAVE_NETDEV_HW_ADDR
#error HAVE_NETDEV_HW_ADDR is not defined
#endif

#ifndef HAVE_PCI_VFS_ASSIGNED
#error HAVE_PCI_VFS_ASSIGNED is not defined
#endif

#ifndef HAVE_NETDEV_HW_FEATURES
#error HAVE_NETDEV_HW_FEATURES is not defined
#endif

#ifndef HAVE_NETDEV_HW_ENC_FEATURES
#error HAVE_NETDEV_HW_ENC_FEATURES is not defined
#endif

#ifndef HAVE_NETDEV_RX_CPU_RMAP
#error HAVE_NETDEV_RX_CPU_RMAP is not defined
#endif

#ifndef HAVE_IRQ_DESC_GET_IRQ_DATA
#error HAVE_IRQ_DESC_GET_IRQ_DATA is not defined
#endif

#ifndef HAVE_PCI_DEV_PCIE_MPSS
#error HAVE_PCI_DEV_PCIE_MPSS is not defined
#endif

#ifndef HAVE_UAPI_LINUX_IF_ETHER_H
#error HAVE_UAPI_LINUX_IF_ETHER_H is not defined
#endif

#ifndef HAVE_VF_INFO_SPOOFCHK
#error HAVE_VF_INFO_SPOOFCHK is not defined
#endif

#ifndef HAVE_KTHREAD_WORK
#error HAVE_KTHREAD_WORK is not defined
#endif

#ifndef HAVE_TIMECOUNTER_H
#error HAVE_TIMECOUNTER_H is not defined
#endif

#ifndef HAVE_NAPI_SCHEDULE_IRQOFF
#error HAVE_NAPI_SCHEDULE_IRQOFF is not defined
#endif

#ifndef HAVE_ETH_SS_RSS_HASH_FUNCS
#error HAVE_ETH_SS_RSS_HASH_FUNCS is not defined
#endif

#ifndef HAVE_NAPI_COMPLETE_DONE
#error HAVE_NAPI_COMPLETE_DONE is not defined
#endif

#ifndef HAVE_NETDEV_RSS_KEY_FILL
#error HAVE_NETDEV_RSS_KEY_FILL is not defined
#endif

#ifndef HAVE_NETDEV_PHYS_ITEM_ID
#error HAVE_NETDEV_PHYS_ITEM_ID is not defined
#endif

#ifndef HAVE_NETDEV_FEATURES_T
#error HAVE_NETDEV_FEATURES_T is not defined
#endif

/* is available on 3.18 only
#ifndef HAVE_VXLAN_GSO_CHECK
#error HAVE_VXLAN_GSO_CHECK is not defined
#endif
*/

#ifndef HAVE_IEEE_GET_SET_MAXRATE
#error HAVE_IEEE_GET_SET_MAXRATE is not defined
#endif

#ifndef HAVE_SCSI_PROT_INTERVAL
#error HAVE_SCSI_PROT_INTERVAL is not defined
#endif

#ifndef HAVE_TRACK_QUEUE_DEPTH
#error HAVE_TRACK_QUEUE_DEPTH is not defined
#endif

#ifndef HAVE_GET_MODULE_EEPROM
#error HAVE_GET_MODULE_EEPROM is not defined
#endif

#ifndef HAVE_WANTED_FEATURES
#error HAVE_WANTED_FEATURES is not defined
#endif

#ifndef HAVE_BLK_MQ_UNIQUE_TAG
#error HAVE_BLK_MQ_UNIQUE_TAG is not defined
#endif

#ifndef HAVE_ADDRCONF_IFID_EUI48
#error HAVE_ADDRCONF_IFID_EUI48 is not defined
#endif

#ifndef HAVE_NETDEV_BONDING_INFO
#error HAVE_NETDEV_BONDING_INFO is not defined
#endif

#ifndef HAVE_DEV_GET_BY_INDEX_RCU
#error HAVE_DEV_GET_BY_INDEX_RCU is not defined
#endif

#ifndef HAVE_NETDEV_MASTER_UPPER_DEV_GET_RCU
#error HAVE_NETDEV_MASTER_UPPER_DEV_GET_RCU is not defined
#endif

#ifndef HAVE_INET6_IF_LIST
#error HAVE_INET6_IF_LIST is not defined
#endif

#ifndef HAVE_DRAIN_WORKQUEUE
#error HAVE_DRAIN_WORKQUEUE is not defined
#endif

#ifndef HAVE_PINNED_VM
#error HAVE_PINNED_VM is not defined
#endif

#ifndef HAVE_PROC_SET_USER
#error HAVE_PROC_SET_USER is not defined
#endif

#ifndef HAVE_UAPI_IF_BONDING_H
#error HAVE_UAPI_IF_BONDING_H is not defined
#endif

#ifndef HAVE_SVC_XPRT_INIT_4_PARAMS
#error HAVE_SVC_XPRT_INIT_4_PARAMS is not defined
#endif

#ifndef HAVE_RQ_NEXT_PAGE
#error HAVE_RQ_NEXT_PAGE is not defined
#endif

#ifndef HAVE_SUNRPC_ADDR_H
#error HAVE_SUNRPC_ADDR_H is not defined
#endif

#ifndef HAVE_XPRT_ALLOC_SLOT
#error HAVE_XPRT_ALLOC_SLOT is not defined
#endif

#ifndef HAVE_KMAP_ATOMIC_1_PARAM
#error HAVE_KMAP_ATOMIC_1_PARAM is not defined
#endif

#endif /* 3.19 */
#endif /* 3.18 */
#endif /* 3.17 */
#endif /* 3.16 */
#endif /* 3.15 */
#endif /* 3.14 */
#endif /* 3.13 */
#endif /* 3.12 */
#endif /* 3.8 */
#endif /* 3.3 */
#endif /* 3.2 */
#endif /* 3.1 */
#endif /* 2.6.39 */
#endif /* 2.6.34 */
#endif /* 2.6.28 */


/*
 *  TBD - enable tests for the number of parameters
 *
 *
 * #ifndef HAVE_INET_GET_LOCAL_PORT_RANGE_3_PARAMS
 * #error HAVE_INET_GET_LOCAL_PORT_RANGE_3_PARAMS is not defined
 * #endif
 *
 * #ifndef HAVE_BOND_FOR_EACH_SLAVE_3_PARAMS
 * #error HAVE_BOND_FOR_EACH_SLAVE_3_PARAMS is not defined
 * #endif
 *
 * #ifndef HAVE_NDO_RX_ADD_VID_HAS_3_PARAMS
 * #error HAVE_NDO_RX_ADD_VID_HAS_3_PARAMS is not defined
 * #endif
 *
 * #ifndef HAVE_3_PARAMS_FOR_VLAN_PUT_TAG
 * #error HAVE_3_PARAMS_FOR_VLAN_PUT_TAG is not defined
 * #endif
 *
 * #ifndef HAVE_3_PARAMS_FOR_VLAN_HWACCEL_PUT_TAG
 * #error HAVE_3_PARAMS_FOR_VLAN_HWACCEL_PUT_TAG is not defined
 * #endif
 *
 * #ifndef HAVE_CYCLECOUNTER_CYC2NS_4_PARAMS
 * #error HAVE_CYCLECOUNTER_CYC2NS_4_PARAMS is not defined
 * #endif
 *
 * #ifndef HAVE_NETLINK_DUMP_START_6P
 * #error HAVE_NETLINK_DUMP_START_6P is not defined
 * #endif
 *
 * #ifndef HAVE_NETLINK_DUMP_START_5P
 * #error HAVE_NETLINK_DUMP_START_5P is not defined
 * #endif
 */



/*
 *  TBD - enable RedHat specific tests
 * #ifndef HAVE_GET_SET_RXFH_INDIR_EXT
 * #error HAVE_GET_SET_RXFH_INDIR_EXT is not defined
 * #endif
 *
 * #ifndef HAVE_SET_NETDEV_HW_FEATURES
 * #error HAVE_SET_NETDEV_HW_FEATURES is not defined
 * #endif
 *
 * #ifndef HAVE_ETHTOOL_OPS_EXT
 * #error HAVE_ETHTOOL_OPS_EXT is not defined
 * #endif
 *
 * #ifndef HAVE_GET_SET_RXFH_OPS_EXT
 * #error HAVE_GET_SET_RXFH_OPS_EXT is not defined
 * #endif
 *
 * #ifndef HAVE_NETDEV_EXTENDED_HW_FEATURES
 * #error HAVE_NETDEV_EXTENDED_HW_FEATURES is not defined
 * #endif
 *
 * #ifndef HAVE_NET_DEVICE_EXTENDED_TX_EXT
 * #error HAVE_NET_DEVICE_EXTENDED_TX_EXT is not defined
 * #endif
 *
 * #ifndef HAVE_NETDEV_EXTENDED_NDO_BUSY_POLL
 * #error HAVE_NETDEV_EXTENDED_NDO_BUSY_POLL is not defined
 * #endif
 *
 * #ifndef HAVE_NET_DEVICE_OPS_EXT
 * #error HAVE_NET_DEVICE_OPS_EXT is not defined
 * #endif
 *
 * #ifndef HAVE_NETDEV_EXT_NDO_GET_PHYS_PORT_ID
 * #error HAVE_NETDEV_EXT_NDO_GET_PHYS_PORT_ID is not defined
 * #endif
 *
 * #ifndef HAVE_NETDEV_OPS_EXT_NDO_SET_VF_SPOOFCHK
 * #error HAVE_NETDEV_OPS_EXT_NDO_SET_VF_SPOOFCHK is not defined
 * #endif
 *
 * #ifndef HAVE_NETDEV_OPS_EXT_NDO_SET_VF_LINK_STATE
 * #error HAVE_NETDEV_OPS_EXT_NDO_SET_VF_LINK_STATE is not defined
 * #endif
 *
 * #ifndef HAVE_GET_SET_CHANNELS_EXT
 * #error HAVE_GET_SET_CHANNELS_EXT is not defined
 * #endif
 *
 * #ifndef HAVE_GET_TS_INFO_EXT
 * #error HAVE_GET_TS_INFO_EXT is not defined
 * #endif
 *
 * #ifndef HAVE_ETHTOOL_FLOW_EXT_H_DEST
 * #error HAVE_ETHTOOL_FLOW_EXT_H_DEST is not defined
 * #endif
 */
