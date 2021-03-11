#ifndef LINUX_SMPLOCK_BACKPORT_tO_2_6_26_H
#define LINUX_SMPLOCK_BACKPORT_tO_2_6_26_H

#include_next <linux/smp_lock.h>

/*
 * Various legacy drivers don't really need the BKL in a specific
 * function, but they *do* need to know that the BKL became available.
 * This function just avoids wrapping a bunch of lock/unlock pairs
 * around code which doesn't really need it.
 */
static inline void cycle_kernel_lock(void)
{
	lock_kernel();
	unlock_kernel();
}

#endif
