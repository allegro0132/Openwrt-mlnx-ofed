#ifndef BACKPORT_ASM_BITOPS_H
#define BACKPORT_ASM_BITOPS_H

#include_next <asm/bitops.h>

static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
{
	barrier();
	clear_bit(nr, addr);
}

#endif
