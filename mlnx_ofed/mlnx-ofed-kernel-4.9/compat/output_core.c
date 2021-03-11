#include <net/ip.h>
#include <net/ipv6.h>
#include <net/ip6_fib.h>
#include <net/addrconf.h>
#include <linux/kernel.h>
#include <linux/export.h>

#ifndef HAVE_IP6_DST_HOPLIMIT
#if IS_ENABLED(CONFIG_IPV6)
#define ip6_dst_hoplimit  LINUX_BACKPORT(ip6_dst_hoplimit)
int ip6_dst_hoplimit(struct dst_entry *dst)
{
        int hoplimit = dst_metric(dst, RTAX_HOPLIMIT);
        if (hoplimit < 0) {
                struct net_device *dev = dst->dev;
                struct inet6_dev *idev = in6_dev_get(dev);
                if (idev) {
                        hoplimit = idev->cnf.hop_limit;
                        in6_dev_put(idev);
                } else
                        hoplimit = dev_net(dev)->ipv6.devconf_all->hop_limit;
        }
        return hoplimit;
}
EXPORT_SYMBOL(ip6_dst_hoplimit);
#endif
#endif

#ifndef HAVE_IP4_DST_HOPLIMIT
#define ip4_dst_hoplimit  LINUX_BACKPORT(ip4_dst_hoplimit)
int ip4_dst_hoplimit(const struct dst_entry *dst)
{
	int hoplimit = dst_metric(dst, RTAX_HOPLIMIT);

	if (hoplimit <= 0)
		hoplimit =  IPDEFTTL;

	 return hoplimit;
}
EXPORT_SYMBOL(ip4_dst_hoplimit);
#endif
