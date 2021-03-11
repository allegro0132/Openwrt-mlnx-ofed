#ifndef __BACKPORT__LINUX_SOCKET_H
#define __BACKPORT__LINUX_SOCKET_H

#include_next <linux/socket.h>

#define AF_RDS		21	/* RDS sockets 			*/
#define PF_RDS		AF_RDS
#define SOL_RDS		276

#endif /* __BACKPORT__LINUX_SOCKET_H */
