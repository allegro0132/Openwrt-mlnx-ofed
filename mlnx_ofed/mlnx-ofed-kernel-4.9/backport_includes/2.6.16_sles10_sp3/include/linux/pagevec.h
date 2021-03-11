#ifndef BACKPORT_LINUX_PAGEVEC_H
#define BACKPORT_LINUX_PAGEVEC_H

#include_next <linux/pagevec.h>

static inline void __pagevec_lru_add_file(struct pagevec *pvec)
{
	__pagevec_lru_add(pvec);
}

static inline void pagevec_lru_add_file(struct pagevec *pvec)
{
	if (pagevec_count(pvec))
		__pagevec_lru_add_file(pvec);
}

#endif
