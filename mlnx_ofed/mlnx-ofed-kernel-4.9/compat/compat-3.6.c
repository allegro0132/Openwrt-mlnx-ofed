/*
 * Copyright 2012 Mellanox Technologies Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <linux/cpu.h>
#include <linux/kernel.h>
#include <linux/bitops.h>
#include <linux/export.h>
#include <linux/types.h>
#include <linux/netdevice.h>

/**
 * netif_get_num_default_rss_queues - default number of RSS queues
 *
 * This routine should set an upper limit on the number of RSS queues
 * used by default by multiqueue devices.
 */
#define netif_get_num_default_rss_queues LINUX_BACKPORT(netif_get_num_default_rss_queues)
int netif_get_num_default_rss_queues(void)
{
	return min_t(int, DEFAULT_MAX_NUM_RSS_QUEUES, num_online_cpus());
}
EXPORT_SYMBOL(netif_get_num_default_rss_queues);
