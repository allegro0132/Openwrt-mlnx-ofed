#ifndef BACKPORT_LINUX_NET_H
#define BACKPORT_LINUX_NET_H

#include_next <linux/net.h>
#include <linux/random.h>

extern ssize_t sock_no_sendpage(struct socket *sock, struct page *page, int offset, size_t size, int flags);

static inline
int kernel_getsockname2(struct socket *sock, struct sockaddr *addr,
			 int *addrlen)
{
	return sock->ops->getname(sock, addr, addrlen, 0);
}
#define kernel_getsockname kernel_getsockname2

static inline
int kernel_getpeername2(struct socket *sock, struct sockaddr *addr,
			 int *addrlen)
{
	return sock->ops->getname(sock, addr, addrlen, 1);
}
#define kernel_getpeername kernel_getpeername2

static inline
int kernel_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
{
	return sock->ops->bind(sock, addr, addrlen);
}

static inline
int kernel_listen(struct socket *sock, int backlog)
{
	return sock->ops->listen(sock, backlog);
}

extern int kernel_accept(struct socket *sock, struct socket **newsock, int flags);

static inline
int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen, int flags)
{
	return sock->ops->connect(sock, addr, addrlen, flags);
}

enum sock_shutdown_cmd {
	SHUT_RD		= 0,
	SHUT_WR		= 1,
	SHUT_RDWR	= 2,
};


static inline int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd flags)
{
	return sock->ops->shutdown(sock, flags);
}

static inline
int kernel_sendpage(struct socket *sock, struct page *page, int offset,
		size_t size, int flags)
{
	if (sock->ops->sendpage)
		return sock->ops->sendpage(sock, page, offset, size, flags);

	return sock_no_sendpage(sock, page, offset, size, flags);
}

extern int kernel_sock_ioctl(struct socket *sock, int cmd, unsigned long arg);

#endif
