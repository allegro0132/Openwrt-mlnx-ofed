#ifndef __BACKPORT_LINUX_TIMER_TO_2_6_19__
#define __BACKPORT_LINUX_TIMER_TO_2_6_19__

#include <linux/jiffies.h>
#include_next <linux/timer.h>

static inline unsigned long round_jiffies(unsigned long j)
{
	return j;
}

#define round_jiffies_relative round_jiffies

#endif
