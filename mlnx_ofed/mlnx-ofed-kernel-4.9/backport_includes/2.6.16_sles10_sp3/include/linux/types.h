#ifndef BACKPORT_LINUX_TYPES_TO_2_6_19
#define BACKPORT_LINUX_TYPES_TO_2_6_19

#include_next <linux/types.h>

typedef _Bool bool;
typedef unsigned __bitwise__ fmode_t;

#ifdef CONFIG_LSF
typedef u64 blkcnt_t;
#else
typedef unsigned long blkcnt_t;
#endif

typedef unsigned long resource_size_t;

#endif
