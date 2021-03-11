#ifndef BACKPORT_LINUX_NETLINK_H
#define BACKPORT_LINUX_NETLINK_H

#include_next <linux/netlink.h>

#define netlink_kernel_create(net, uint, groups, input, mutex, mod) \
       netlink_kernel_create(uint, groups, input, mod)

static inline struct nlmsghdr *nlmsg_hdr(const struct sk_buff *skb)
{
	return (struct nlmsghdr *)skb->data;
}

#endif
