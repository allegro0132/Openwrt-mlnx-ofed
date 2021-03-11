#ifndef LINUX_MUTEX_BACKPORT_H
#define LINUX_MUTEX_BACKPORT_H

#include_next <linux/mutex.h>
#include <linux/lockdep.h>

#define mutex_lock_nested(a, b) mutex_lock(a)
#define mutex_lock_killable(lock) mutex_lock_interruptible(lock)

#endif
