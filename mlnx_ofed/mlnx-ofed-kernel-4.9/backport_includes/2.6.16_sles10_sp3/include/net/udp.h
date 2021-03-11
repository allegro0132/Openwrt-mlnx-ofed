#ifndef BACKPORT_NET_UDP_H
#define BACKPORT_NET_UDP_H

#include_next <net/udp.h>

static inline void UDPX_INC_STATS_BH(struct sock *sk, int field)
{ }

#endif
