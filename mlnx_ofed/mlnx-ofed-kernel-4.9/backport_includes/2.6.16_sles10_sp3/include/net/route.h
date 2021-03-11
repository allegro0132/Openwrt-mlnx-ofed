#ifndef _BACKPORT_NET_ROUTE_H_
#define _BACKPORT_NET_ROUTE_H_

#include_next <net/route.h>

#define ip_route_output_flow(net, rp, fl, sk, flags) \
	ip_route_output_flow(rp, fl, sk, flags)

#define ip_route_output_key(net, rp, fl) ip_route_output_key(rp, fl)

#define inet_addr_type(net, addr) inet_addr_type(addr)

#endif
