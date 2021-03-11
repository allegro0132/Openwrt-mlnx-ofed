#ifndef __BACKPORT_LINUX_IN_H_TO_2_6_24__
#define __BACKPORT_LINUX_IN_H_TO_2_6_24__

#include_next <linux/in.h>


static inline bool ipv4_is_loopback(__be32 addr)
{
	return (addr & htonl(0xff000000)) == htonl(0x7f000000);
}

static inline bool ipv4_is_zeronet(__be32 addr)
{
	return (addr & htonl(0xff000000)) == htonl(0x00000000);
}

#endif	/* __BACKPORT_LINUX_IN_H_TO_2_6_24__ */
