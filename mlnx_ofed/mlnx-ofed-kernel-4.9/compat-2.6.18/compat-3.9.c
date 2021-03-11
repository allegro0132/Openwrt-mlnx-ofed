/*
 * Copyright 2013  Mellanox Technologies Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux RDMA for kernels 3.9.
 */

#include <linux/skbuff.h>
#include <linux/export.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/if_vlan.h>
#include <net/ip.h>
#include <net/ipv6.h>
#include <linux/igmp.h>
#include <linux/icmp.h>
#include <linux/sctp.h>
#include <linux/dccp.h>
#include <linux/if_tunnel.h>
#include <linux/if_pppox.h>
#include <linux/ppp_defs.h>
#include <net/flow_keys.h>
#include <linux/pci.h>

#ifndef CONFIG_COMPAT_NETIF_HAS_PICK_TX
#define get_xps_queue LINUX_BACKPORT(get_xps_queue)
static inline int get_xps_queue(struct net_device *dev, struct sk_buff *skb)
{
#ifdef CONFIG_XPS
	struct xps_dev_maps *dev_maps;
	struct xps_map *map;
	int queue_index = -1;

	rcu_read_lock();
	dev_maps = rcu_dereference(dev->xps_maps);
	if (dev_maps) {
		map = rcu_dereference(
		    dev_maps->cpu_map[raw_smp_processor_id()]);
		if (map) {
			if (map->len == 1) {
				queue_index = map->queues[0];
			} else {
				u32 hash;

				if (skb->sk && skb->sk->sk_hash)
					hash = skb->sk->sk_hash;
				else
					hash = (__force u16)skb->protocol ^
					    skb->rxhash;
				hash = jhash_1word(hash, hashrnd);
				queue_index = map->queues[
				    ((u64)hash * map->len) >> 32];
			}
			if (unlikely(queue_index >= dev->real_num_tx_queues))
				queue_index = -1;
		}
	}
	rcu_read_unlock();

	return queue_index;
#else
	return -1;
#endif
}

#define __netdev_pick_tx LINUX_BACKPORT(__netdev_pick_tx)
u16 __netdev_pick_tx(struct net_device *dev, struct sk_buff *skb)
{
	int new_index;
#ifdef CONFIG_COMPAT_SOCK_HAS_QUEUE
	struct sock *sk = skb->sk;
	int queue_index = sk_tx_queue_get(sk);

	if (queue_index >= 0 && queue_index < dev->real_num_tx_queues) {
#ifdef CONFIG_COMPAT_NETIF_IS_XPS
		if (!skb->ooo_okay)
#endif /* CONFIG_COMPAT_NETIF_IS_XPS */
			return queue_index;
	}
#endif /* CONFIG_COMPAT_SOCK_HAS_QUEUE */

	new_index = get_xps_queue(dev, skb);
	if (new_index < 0)
		new_index = skb_tx_hash(dev, skb);

#ifdef CONFIG_COMPAT_SOCK_HAS_QUEUE
	if (queue_index != new_index && sk) {
		struct dst_entry *dst = rcu_dereference(sk->sk_dst_cache);

		if (dst && skb_dst(skb) == dst)
			sk_tx_queue_set(sk, new_index);
	}
#endif /* CONFIG_COMPAT_SOCK_HAS_QUEUE */

	return new_index;
}
EXPORT_SYMBOL(__netdev_pick_tx);
#endif /* CONFIG_COMPAT_NETIF_HAS_PICK_TX */
