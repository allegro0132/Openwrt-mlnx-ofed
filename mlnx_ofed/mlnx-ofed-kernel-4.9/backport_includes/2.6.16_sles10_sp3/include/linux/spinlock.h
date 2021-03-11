#ifndef BACKPORT_LINUX_SPINLOCK_H
#define BACKPORT_LINUX_SPINLOCK_H

#include_next <linux/spinlock.h>
#define spin_lock_nested(lock, subclass) spin_lock(lock)

#endif
