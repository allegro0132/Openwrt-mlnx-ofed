#ifndef BACKPORT_RTNETLINK_2_6_16
#define BACKPORT_RTNETLINK_2_6_16
#include_next <linux/rtnetlink.h>

static inline int rtnl_trylock(void)
{
	return !rtnl_shlock_nowait();
}

#endif
