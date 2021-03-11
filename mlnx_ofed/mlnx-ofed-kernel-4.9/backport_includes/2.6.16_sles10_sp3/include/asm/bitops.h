#ifndef BACKPORT_ASM_BITOPS_H
#define BACKPORT_ASM_BITOPS_H

#include_next <asm/bitops.h>
#include <linux/compiler.h>

#ifdef CONFIG_IA64
#ifdef smp_mb__before_clear_bit
#undef smp_mb__before_clear_bit
#define smp_mb__before_clear_bit ia64_mf
#endif
#else
#if defined(CONFIG_PPC32) || defined(CONFIG_PPC64)
#ifdef CONFIG_SMP
#define mb()   __asm__ __volatile__ ("sync" : : : "memory")
#define smp_mb()	mb()
#else
#define smp_mb()	barrier()
#endif
#endif
#endif

static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
{
	smp_mb__before_clear_bit();
	clear_bit(nr, addr);
}

#endif
