#ifndef __BACKPORT_LINUX_IF_ARP_H_
#define __BACKPORT_LINUX_IF_ARP_H_

#include_next <linux/if_arp.h>

static inline struct arphdr *arp_hdr(const struct sk_buff *skb)
{
	return (struct arphdr *)skb_network_header(skb);
}

#endif
