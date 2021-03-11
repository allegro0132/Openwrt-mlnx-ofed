#ifndef BACKPORT_LINUX_NETLINK_H
#define BACKPORT_LINUX_NETLINK_H

#include_next <linux/netlink.h>

static inline struct nlmsghdr *nlmsg_hdr2(const struct sk_buff *skb)
{
	return (struct nlmsghdr *)skb->data;
}
#define nlmsg_hdr nlmsg_hdr2

#endif
