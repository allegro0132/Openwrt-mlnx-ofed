#ifndef _LINUX_NETDEVICE_BACKPORT_TO_2_6_16
#define _LINUX_NETDEVICE_BACKPORT_TO_2_6_16

#include_next <linux/netdevice.h>

static inline int skb_checksum_help_to_2_6_18(struct sk_buff *skb)
{
        return skb_checksum_help(skb, 0);
}

#define skb_checksum_help skb_checksum_help_to_2_6_18

#undef SET_ETHTOOL_OPS
#define SET_ETHTOOL_OPS(netdev, ops) \
	(netdev)->ethtool_ops = (struct ethtool_ops *)(ops)

#define NETIF_F_TSO6    0
#define NETIF_F_LRO		32768   /* large receive offload */
#define NETIF_F_IPV6_CSUM	16	/* Can checksum TCP/UDP over IPV6 */

#define dev_get_by_name(net, name) dev_get_by_name(name)

#define for_each_netdev(a, dev) for ((dev) = dev_base; (dev) != NULL; (dev) = (dev)->next)

#define vlan_dev_real_dev(netdev) (VLAN_DEV_INFO(netdev)->real_dev)

static inline int netif_is_bond_slave(struct net_device *dev)
{
        return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_BONDING;
}

#endif
