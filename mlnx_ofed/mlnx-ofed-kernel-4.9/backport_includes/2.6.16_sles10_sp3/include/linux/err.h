#ifndef BACKPORT_LINUX_ERR_H
#define BACKPORT_LINUX_ERR_H

#include_next <linux/err.h>

/**
 * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
 * @ptr: The pointer to cast.
 *
 * Explicitly cast an error-valued pointer to another pointer type in such a
 * way as to make it clear that's what's going on.
 */
static inline void *ERR_CAST(const void *ptr)
{
	/* cast away the const */
	return (void *) ptr;
}

#endif /* BACKPORT_LINUX_ERR_H */
