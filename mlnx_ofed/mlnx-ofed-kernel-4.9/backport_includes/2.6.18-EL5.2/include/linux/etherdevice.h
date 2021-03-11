#ifndef BACKPORT_LINUX_ETHERDEVICE
#define BACKPORT_LINUX_ETHERDEVICE

#include_next <linux/etherdevice.h>

static inline unsigned short backport_eth_type_trans(struct sk_buff *skb, 
						     struct net_device *dev)
{
	skb->dev = dev;
	return eth_type_trans(skb, dev);
}

#define eth_type_trans backport_eth_type_trans

#endif
