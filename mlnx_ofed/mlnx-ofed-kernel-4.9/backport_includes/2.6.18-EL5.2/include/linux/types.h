#ifndef BACKPORT_LINUX_TYPES_H
#define BACKPORT_LINUX_TYPES_H

#include_next <linux/types.h>
  
typedef __u16   __sum16;
typedef __u32   __wsum;
typedef unsigned __bitwise__ fmode_t;

#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 phys_addr_t;
#else
typedef u32 phys_addr_t;
#endif

#endif
