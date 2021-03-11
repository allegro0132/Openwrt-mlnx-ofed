#ifndef __BACKPORT_ASM_GENERIC_ATOMIC_H
#define __BACKPORT_ASM_GENERIC_ATOMIC_H

#include_next <asm-generic/atomic.h>

#if BITS_PER_LONG == 64

static inline long atomic_long_inc_return(atomic_long_t *l)
{
	atomic64_t *v = (atomic64_t *)l;

	return (long)atomic64_inc_return(v);
}

static inline long atomic_long_dec_return(atomic_long_t *l)
{
	atomic64_t *v = (atomic64_t *)l;

	return (long)atomic64_dec_return(v);
}

#else

static inline long atomic_long_inc_return(atomic_long_t *l)
{
	atomic_t *v = (atomic_t *)l;

	return (long)atomic_inc_return(v);
}

static inline long atomic_long_dec_return(atomic_long_t *l)
{
	atomic_t *v = (atomic_t *)l;

	return (long)atomic_dec_return(v);
}

#endif  /*  BITS_PER_LONG == 64  */

#endif  /*  __BACKPORT_ASM_GENERIC_ATOMIC_H  */
