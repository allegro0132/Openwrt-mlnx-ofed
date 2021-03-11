#ifndef BACKPORT_LINUX_RANDOM_TO_2_6_18
#define BACKPORT_LINUX_RANDOM_TO_2_6_18
#include_next <linux/random.h>
#include_next <linux/net.h>

#define random32() net_random()

#endif
