#include_next <linux/bitops.h>
#ifndef LINUX_BITOPS_BACKPORT_2_6_16
#define LINUX_BITOPS_BACKPORT_2_6_16
#define BIT(nr)			(1UL << (nr))
#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)

static inline unsigned fls_long(unsigned long l)
{
	if (sizeof(l) == 4)
		return fls(l);
	return fls64(l);
}

#endif
