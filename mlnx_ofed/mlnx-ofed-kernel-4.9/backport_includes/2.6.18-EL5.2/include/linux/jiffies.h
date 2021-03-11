#ifndef BACKPORT_LINUX_JIFFIES_H
#define BACKPORT_LINUX_JIFFIES_H

#include_next <linux/jiffies.h>

#define time_in_range_open(a,b,c) \
	(time_after_eq(a,b) && \
	 time_before(a,c))

#endif /* BACKPORT_LINUX_JIFFIES_H */
