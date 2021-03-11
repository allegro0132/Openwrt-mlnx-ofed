#ifndef BACKPORT_LINUX_SPINLOCK_TYPES_H
#define BACKPORT_LINUX_SPINLOCK_TYPES_H

#include_next <linux/spinlock_types.h>

#define __SPIN_LOCK_UNLOCKED(x) SPIN_LOCK_UNLOCKED

#endif
