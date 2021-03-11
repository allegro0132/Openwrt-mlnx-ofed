#ifndef BACKPORT_LINUX_GFP_H
#define BACKPORT_LINUX_GFP_H

#include_next <linux/gfp.h>

/* This equals 0, but use constants in case they ever change */
#define GFP_NOWAIT     (GFP_ATOMIC & ~__GFP_HIGH)

#endif /* BACKPORT_LINUX_GFP_H */
