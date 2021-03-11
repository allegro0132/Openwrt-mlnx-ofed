#ifndef BACKPORT_LINUX_RADIX_TREE_H
#define BACKPORT_LINUX_RADIX_TREE_H

#include_next <linux/radix-tree.h>

static inline int backport_radix_tree_preload(gfp_t gfp_mask)
{
	return 0;
}

#define radix_tree_preload backport_radix_tree_preload

static inline void backport_radix_tree_preload_end(void)
{
}

#define radix_tree_preload_end backport_radix_tree_preload_end

#endif
