#ifndef _BACKPORT_LINUX_INETDEVICE_H
#define _BACKPORT_LINUX_INETDEVICE_H

#include_next <linux/inetdevice.h>

#define ip_dev_find(net, addr) ip_dev_find(addr)

#endif
