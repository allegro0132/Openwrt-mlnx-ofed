/*
 * Copyright 2012  Luis R. Rodriguez <mcgrof@frijolero.org>
 * Copyright (c) 2012 Mellanox Technologies. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux wireless for kernels 3.2.
 */

#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/ethtool.h>
#include <linux/rtnetlink.h>
#include <linux/llist.h>

#define __ethtool_get_settings LINUX_BACKPORT(__ethtool_get_settings)
int __ethtool_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
{
        ASSERT_RTNL();

        if (!dev->ethtool_ops || !dev->ethtool_ops->get_settings)
                return -EOPNOTSUPP;

        memset(cmd, 0, sizeof(struct ethtool_cmd));
        cmd->cmd = ETHTOOL_GSET;
        return dev->ethtool_ops->get_settings(dev, cmd);
}
EXPORT_SYMBOL(__ethtool_get_settings);

/**
 * llist_add_batch - add several linked entries in batch
 * @new_first:	first entry in batch to be added
 * @new_last:	last entry in batch to be added
 * @head:	the head for your lock-less list
 *
 * Return whether list is empty before adding.
 */
#define llist_add_batch LINUX_BACKPORT(llist_add_batch)
bool llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
		     struct llist_head *head)
{
	struct llist_node *entry, *old_entry;

	entry = head->first;
	for (;;) {
		old_entry = entry;
		new_last->next = entry;
		entry = cmpxchg(&head->first, old_entry, new_first);
		if (entry == old_entry)
			break;
	}

	return old_entry == NULL;
}
EXPORT_SYMBOL_GPL(llist_add_batch);

/**
 * llist_del_first - delete the first entry of lock-less list
 * @head:	the head for your lock-less list
 *
 * If list is empty, return NULL, otherwise, return the first entry
 * deleted, this is the newest added one.
 *
 * Only one llist_del_first user can be used simultaneously with
 * multiple llist_add users without lock.  Because otherwise
 * llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
 * llist_add) sequence in another user may change @head->first->next,
 * but keep @head->first.  If multiple consumers are needed, please
 * use llist_del_all or use lock between consumers.
 */
#define llist_del_first LINUX_BACKPORT(llist_del_first)
struct llist_node *llist_del_first(struct llist_head *head)
{
	struct llist_node *entry, *old_entry, *next;

	entry = head->first;
	for (;;) {
		if (entry == NULL)
			return NULL;
		old_entry = entry;
		next = entry->next;
		entry = cmpxchg(&head->first, old_entry, next);
		if (entry == old_entry)
			break;
	}

	return entry;
}
EXPORT_SYMBOL_GPL(llist_del_first);
