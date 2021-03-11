#ifndef __BACKPORT_LINUX_UDP_H_TO_2_6_21__
#define __BACKPORT_LINUX_UDP_H_TO_2_6_21__

#include_next <linux/udp.h>

static inline struct udphdr *udp_hdr(const struct sk_buff *skb)
{
        return (struct udphdr *)skb_transport_header(skb);
}

#endif /* __BACKPORT_LINUX_UDP_H_TO_2_6_21__ */
