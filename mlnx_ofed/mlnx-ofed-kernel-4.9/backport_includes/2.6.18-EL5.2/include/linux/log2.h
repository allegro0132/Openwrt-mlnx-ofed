#ifndef _LINUX_BACKPORT_LOG2_H
#define _LINUX_BACKPORT_LOG2_H

#include_next <linux/log2.h>

/*
 * round down to nearest power of two
 */
static inline __attribute__((const))
unsigned long __rounddown_pow_of_two(unsigned long n)
{
	return 1UL << (fls_long(n) - 1);
}


/**
 * rounddown_pow_of_two - round the given value down to nearest power of two
 * @n - parameter
 *
 * round the given value down to the nearest power of two
 * - the result is undefined when n == 0
 * - this can be used to initialise global variables from constant data
 */
#define rounddown_pow_of_two(n)			\
(						\
	__builtin_constant_p(n) ? (		\
		(n == 1) ? 0 :			\
		(1UL << ilog2(n))) :		\
	__rounddown_pow_of_two(n)		\
 )

#endif /* _LINUX_BACKPORT_LOG2_H */
