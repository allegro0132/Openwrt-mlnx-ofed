/*
 * Copyright 2010    Hauke Mehrtens <hauke@hauke-m.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux wireless for kernels 2.6.37.
 */

#include <linux/vmalloc.h>

/**
 *	vzalloc - allocate virtually contiguous memory with zero fill
 *	@size:	allocation size
 *	Allocate enough pages to cover @size from the page level
 *	allocator and map them into contiguous kernel virtual space.
 *	The memory allocated is set to zero.
 *
 *	For tight control over page level allocator and protection flags
 *	use __vmalloc() instead.
 */
#define vzalloc LINUX_BACKPORT(vzalloc)
void *vzalloc(unsigned long size)
{
	void *buf;
	buf = vmalloc(size);
	if (buf)
		memset(buf, 0, size);
	return buf;
}
EXPORT_SYMBOL_GPL(vzalloc);

/**
 * vzalloc_node - allocate memory on a specific node with zero fill
 * @size:       allocation size
 * @node:       numa node
 *
 * Allocate enough pages to cover @size from the page level
 * allocator and map them into contiguous kernel virtual space.
 * The memory allocated is set to zero.
 *
 * For tight control over page level allocator and protection flags
 * use __vmalloc() instead.
 */
#define vzalloc_node LINUX_BACKPORT(vzalloc_node)
void *vzalloc_node(unsigned long size, int node)
{
        return vzalloc(size);
}
EXPORT_SYMBOL(vzalloc_node);
