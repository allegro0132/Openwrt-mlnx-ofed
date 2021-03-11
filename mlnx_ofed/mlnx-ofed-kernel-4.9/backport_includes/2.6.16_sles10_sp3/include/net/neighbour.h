#ifndef __BACKPORT_NET_NEIGHBOUR_TO_2_6_20__
#define __BACKPORT_NET_NEIGHBOUR_TO_2_6_20__

#include_next <net/neighbour.h>

#define neigh_cleanup neigh_destructor

#endif
