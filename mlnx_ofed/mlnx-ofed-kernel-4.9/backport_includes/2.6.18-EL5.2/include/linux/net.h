#ifndef BACKPORT_LINUX_NET_H
#define BACKPORT_LINUX_NET_H

#include_next <linux/net.h>
#include <linux/random.h>

enum sock_shutdown_cmd {
	SHUT_RD		= 0,
	SHUT_WR		= 1,
	SHUT_RDWR	= 2,
};


static inline int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd flags)
{
	return sock->ops->shutdown(sock, flags);
}

#endif
