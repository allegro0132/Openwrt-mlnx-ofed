#ifndef BACKPORT_LINUX_IN6_H
#define BACKPORT_LINUX_IN6_H

#include_next <linux/in6.h>

#define IN6ADDR_ANY_INIT { { { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } } }

#endif
