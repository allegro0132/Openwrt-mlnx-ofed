#ifndef _NET_SOCK_LOCKDEP_BACKPORT_H
#define _NET_SOCK_LOCKDEP_BACKPORT_H

#include_next <net/sock.h>

#define lock_sock_nested(_sk, _subclass) lock_sock(sk)

#endif
