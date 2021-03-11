#ifndef _LINUX_RWSEM_BACKPORT_TO_2_6_17
#define _LINUX_RWSEM_BACKPORT_TO_2_6_17

#include_next <linux/rwsem.h>

#define down_read_nested(sem, subclass) down_read(sem)

#endif
