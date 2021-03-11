#ifndef __BACKPORT_LINUX_IF_H_TO_2_6_18__
#define __BACKPORT_LINUX_IF_H_TO_2_6_18__

#include_next <linux/if.h>

#if defined(__powerpc64__)
#define IFF_BONDING	0x20		/* bonding master or slave      */
#endif

#endif /* __BACKPORT_LINUX_IF_H_TO_2_6_18__ */
