#ifndef _NET_SOCK_SLES_BACKPORT_H
#define _NET_SOCK_SLES_BACKPORT_H

#include_next <net/sock.h>

static inline int
kernel_setsockopt(struct socket *sock, int level, int optname, char *optval, int optlen)
{
	return sock_setsockopt(sock, level, optname, optval, optlen);
}

#endif

#ifndef _NET_SOCK_LOCKDEP_BACKPORT_H
#define _NET_SOCK_LOCKDEP_BACKPORT_H

#define lock_sock_nested(_sk, _subclass) lock_sock(sk)

#endif
