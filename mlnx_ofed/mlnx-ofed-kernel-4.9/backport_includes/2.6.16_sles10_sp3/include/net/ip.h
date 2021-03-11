#ifndef __BACKPORT_NET_IP_H_TO_2_6_23__
#define __BACKPORT_NET_IP_H_TO_2_6_23__

#include_next<net/ip.h>
#define inet_get_local_port_range(a, b) { *(a) = sysctl_local_port_range[0]; *(b) = sysctl_local_port_range[1]; }

#endif


#ifndef __BACKPORT_IP_H_TO_2_6_24__
#define __BACKPORT_IP_H_TO_2_6_24__

#include_next <net/ip.h>

static inline void 
backport_ip_ib_mc_map(__be32 naddr, const unsigned char *broadcast, char *buf)
{
	__u32 addr;
	unsigned char scope = broadcast[5] & 0xF;

	buf[0]  = 0;		/* Reserved */
	buf[1]  = 0xff;		/* Multicast QPN */
	buf[2]  = 0xff;
	buf[3]  = 0xff;
	addr    = ntohl(naddr);
	buf[4]  = 0xff;
	buf[5]  = 0x10 | scope;	/* scope from broadcast address */
	buf[6]  = 0x40;		/* IPv4 signature */
	buf[7]  = 0x1b;
	buf[8]  = broadcast[8];		/* P_Key */
	buf[9]  = broadcast[9];
	buf[10] = 0;
	buf[11] = 0;
	buf[12] = 0;
	buf[13] = 0;
	buf[14] = 0;
	buf[15] = 0;
	buf[19] = addr & 0xff;
	addr  >>= 8;
	buf[18] = addr & 0xff;
	addr  >>= 8;
	buf[17] = addr & 0xff;
	addr  >>= 8;
	buf[16] = addr & 0x0f;
}

static inline unsigned int ip_hdrlen(const struct sk_buff *skb)
{
	return ip_hdr(skb)->ihl * 4;
}

#undef ip_ib_mc_map

#define ip_ib_mc_map(naddr, broadcast, buf) backport_ip_ib_mc_map(naddr, broadcast, buf)

#endif	/* __BACKPORT_IP_H_TO_2_6_24__ */
