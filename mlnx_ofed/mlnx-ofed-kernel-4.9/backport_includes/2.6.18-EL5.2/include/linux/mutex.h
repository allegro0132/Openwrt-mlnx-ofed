#ifndef LINUX_MUTEX_BACKPORT_H
#define LINUX_MUTEX_BACKPORT_H

#include_next <linux/mutex.h>

#define mutex_lock_killable(lock) mutex_lock_interruptible(lock)

#endif
