#ifndef LINUX_HIGHMEM_H
#define LINUX_HIGHMEM_H

#include_next <linux/highmem.h>

static inline void zero_user_segments(struct page *page,
	unsigned start1, unsigned end1,
	unsigned start2, unsigned end2)
{
	void *kaddr = kmap_atomic(page, KM_USER0);

	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);

	if (end1 > start1)
		memset(kaddr + start1, 0, end1 - start1);

	if (end2 > start2)
		memset(kaddr + start2, 0, end2 - start2);

	kunmap_atomic(kaddr, KM_USER0);
	flush_dcache_page(page);
}

static inline void zero_user_segment(struct page *page,
	unsigned start, unsigned end)
{
	zero_user_segments(page, start, end, 0, 0);
}

static inline void zero_user(struct page *page,
	unsigned start, unsigned size)
{
	zero_user_segments(page, start, start + size, 0, 0);
}

#endif
