#ifndef BACKPORT_LINUX_RADIX_TREE_H
#define BACKPORT_LINUX_RADIX_TREE_H

#include_next <linux/radix-tree.h>
#if 0
static inline int radix_tree_preload(gfp_t gfp_mask)
{
	return 0;
}

static inline void radix_tree_preload_end(void)
{
}

#endif
#endif
