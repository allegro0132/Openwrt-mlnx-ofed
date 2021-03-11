/*
 * Copyright 2012 Mellanox Technologies Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux wireless for kernels 3.4.
 */

#include <linux/kernel.h>
#include <linux/bitops.h>
#include <linux/export.h>
#include <linux/types.h>
#include <linux/pkt_sched.h>

#define ECN_OR_COST(class)	TC_PRIO_##class

#ifndef CONFIG_COMPAT_IS_IP_TOS2PRIO
#define ip_tos2prio LINUX_BACKPORT(ip_tos2prio)
const __u8 ip_tos2prio[16] = {
	TC_PRIO_BESTEFFORT,
	ECN_OR_COST(BESTEFFORT),
	TC_PRIO_BESTEFFORT,
	ECN_OR_COST(BESTEFFORT),
	TC_PRIO_BULK,
	ECN_OR_COST(BULK),
	TC_PRIO_BULK,
	ECN_OR_COST(BULK),
	TC_PRIO_INTERACTIVE,
	ECN_OR_COST(INTERACTIVE),
	TC_PRIO_INTERACTIVE,
	ECN_OR_COST(INTERACTIVE),
	TC_PRIO_INTERACTIVE_BULK,
	ECN_OR_COST(INTERACTIVE_BULK),
	TC_PRIO_INTERACTIVE_BULK,
	ECN_OR_COST(INTERACTIVE_BULK)
};
EXPORT_SYMBOL(ip_tos2prio);
#endif

#define dev_uc_add_excl LINUX_BACKPORT(dev_uc_add_excl)
#ifdef CONFIG_COMPAT_DEV_UC_MC_ADD_CONST
int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
#else
int dev_uc_add_excl(struct net_device *dev, unsigned char *addr)
#endif
{
	struct netdev_hw_addr *ha;
	int err;

	netif_addr_lock_bh(dev);
	netdev_for_each_uc_addr(ha, dev) {
		if (!memcmp(ha->addr, addr, dev->addr_len) &&
		    ha->type == NETDEV_HW_ADDR_T_UNICAST) {
			err = -EEXIST;
			goto out;
		}
	}
	netif_addr_unlock_bh(dev);

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
	return dev_uc_add(dev, addr);
#else
	return dev_unicast_add(dev, addr);
#endif

out:
	netif_addr_unlock_bh(dev);
	return err;
}
EXPORT_SYMBOL(dev_uc_add_excl);

#define dev_mc_add_excl LINUX_BACKPORT(dev_mc_add_excl)
#ifdef CONFIG_COMPAT_DEV_UC_MC_ADD_CONST
int dev_mc_add_excl(struct net_device *dev, const unsigned char *addr)
#else
int dev_mc_add_excl(struct net_device *dev, unsigned char *addr)
#endif
{
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
	struct netdev_hw_addr *ha;
#else
	struct dev_addr_list *ha;
#endif
	int err;

	netif_addr_lock_bh(dev);
	netdev_for_each_mc_addr(ha, dev) {
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
		if (!memcmp(ha->addr, addr, dev->addr_len)) {
#else
		if (!memcmp(ha->da_addr, addr, dev->addr_len)) {
#endif
			err = -EEXIST;
			goto out;
		}
	}
	netif_addr_unlock_bh(dev);

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
	return dev_mc_add(dev, addr);
#else
	return dev_mc_add(dev, addr, ETH_ALEN, true);
#endif

out:
	netif_addr_unlock_bh(dev);
	return err;
}
EXPORT_SYMBOL(dev_mc_add_excl);
