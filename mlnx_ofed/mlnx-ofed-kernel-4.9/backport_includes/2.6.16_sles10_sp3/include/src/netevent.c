/*
 *	Network event notifiers
 *
 *	Authors:
 *      Tom Tucker             <tom@opengridcomputing.com>
 *      Steve Wise             <swise@opengridcomputing.com>
 *
 *	This program is free software; you can redistribute it and/or
 *      modify it under the terms of the GNU General Public License
 *      as published by the Free Software Foundation; either version
 *      2 of the License, or (at your option) any later version.
 *
 *	Fixes:
 */

#include <linux/rtnetlink.h>
#include <linux/notifier.h>
#include <linux/mutex.h>
#include <linux/if.h>
#include <linux/netdevice.h>
#include <linux/if_arp.h>

#include <net/arp.h>
#include <net/neighbour.h>
#include <net/route.h>
#include <net/netevent.h>

static DEFINE_MUTEX(lock);
static int count;

static void destructor(struct sk_buff *skb)
{
	struct neighbour *n;
	u8 *arp_ptr;
	__be32 gw;

	/* Pull the SPA */
	arp_ptr = skb->nh.raw + sizeof(struct arphdr) + skb->dev->addr_len;
	memcpy(&gw, arp_ptr, 4);
	n = neigh_lookup(&arp_tbl, &gw, skb->dev);
	if (n) {
		call_netevent_notifiers(NETEVENT_NEIGH_UPDATE, n);
		neigh_release(n);
	}
	return;
}

static int arp_recv(struct sk_buff *skb, struct net_device *dev,
			 struct packet_type *pkt, struct net_device *dev2)
{
	struct arphdr *arp_hdr;
	u16 op;

	arp_hdr = (struct arphdr *) skb->nh.raw;
	op = ntohs(arp_hdr->ar_op);

	if ((op == ARPOP_REQUEST || op == ARPOP_REPLY) && !skb->destructor)
		skb->destructor = destructor;

	kfree_skb(skb);
	return 0;
}

static struct packet_type arp = {
	.type = __constant_htons(ETH_P_ARP),
	.func = arp_recv,
	.af_packet_priv = (void *)1,
};

static struct notifier_block *netevent_notif_chain;

/**
 *	register_netevent_notifier - register a netevent notifier block
 *	@nb: notifier
 *
 *	Register a notifier to be called when a netevent occurs.
 *	The notifier passed is linked into the kernel structures and must
 *	not be reused until it has been unregistered. A negative errno code
 *	is returned on a failure.
 */
int register_netevent_notifier(struct notifier_block *nb)
{
	int err;

	err = notifier_chain_register(&netevent_notif_chain, nb);
	if (!err) {
		mutex_lock(&lock);
		if (count++ == 0)
			dev_add_pack(&arp);
		mutex_unlock(&lock);
	}
	return err;
}

/**
 *	netevent_unregister_notifier - unregister a netevent notifier block
 *	@nb: notifier
 *
 *	Unregister a notifier previously registered by
 *	register_neigh_notifier(). The notifier is unlinked into the
 *	kernel structures and may then be reused. A negative errno code
 *	is returned on a failure.
 */

int unregister_netevent_notifier(struct notifier_block *nb)
{
	int err;

	err = notifier_chain_unregister(&netevent_notif_chain, nb);
	if (!err) {
		mutex_lock(&lock);
		if (--count == 0)
			dev_remove_pack(&arp);
		mutex_unlock(&lock);
	}
	return err;
}

/**
 *	call_netevent_notifiers - call all netevent notifier blocks
 *      @val: value passed unmodified to notifier function
 *      @v:   pointer passed unmodified to notifier function
 *
 *	Call all neighbour notifier blocks.  Parameters and return value
 *	are as for notifier_call_chain().
 */

int call_netevent_notifiers(unsigned long val, void *v)
{
	return notifier_call_chain(&netevent_notif_chain, val, v);
}

EXPORT_SYMBOL_GPL(register_netevent_notifier);
EXPORT_SYMBOL_GPL(unregister_netevent_notifier);
EXPORT_SYMBOL_GPL(call_netevent_notifiers);
