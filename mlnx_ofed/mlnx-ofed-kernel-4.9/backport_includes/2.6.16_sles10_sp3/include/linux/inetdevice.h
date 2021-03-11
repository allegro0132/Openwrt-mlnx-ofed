#ifndef _LINUX_INETDEVICE_BACKPORT_TO_2_6_17
#define _LINUX_INETDEVICE_BACKPORT_TO_2_6_17

#include_next <linux/inetdevice.h>
#include <linux/rtnetlink.h>

static inline struct net_device *xxx_ip_dev_find(u32 addr)
{
	struct net_device *dev;
	struct in_ifaddr **ifap;
	struct in_ifaddr *ifa;
	struct in_device *in_dev;

	read_lock(&dev_base_lock);
	for (dev = dev_base; dev; dev = dev->next)
		if ((in_dev = in_dev_get(dev))) {
			for (ifap = &in_dev->ifa_list; (ifa = *ifap);
			     ifap = &ifa->ifa_next) {
				if (addr == ifa->ifa_address) {
					dev_hold(dev);
					in_dev_put(in_dev);
					goto found;
				}
			}
			in_dev_put(in_dev);
		}
found:
	read_unlock(&dev_base_lock);

	return dev;
}

#define ip_dev_find(net, addr) xxx_ip_dev_find(addr)

#endif

