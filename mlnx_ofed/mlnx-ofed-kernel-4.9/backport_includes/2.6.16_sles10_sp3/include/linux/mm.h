#ifndef _BACKPORT_LINUX_MM_H_
#define _BACKPORT_LINUX_MM_H_

#include_next <linux/mm.h>

#if defined(__i386__)
#include <asm/highmem.h>
#endif

#define VM_CAN_NONLINEAR 0x08000000     /* Has ->fault & does nonlinear pages */
#define VM_FAULT_LOCKED  0x0200		/* ->fault locked the returned page */

#define is_vmalloc_addr(x) ((unsigned long)(x) >= VMALLOC_START && (unsigned long)(x) < VMALLOC_END)

struct shrinker {
	shrinker_t		shrink;
	struct list_head	list;
	int			seeks;  /* seeks to recreate an obj */
	long			nr;     /* objs pending delete */
};

static inline void task_io_account_cancelled_write(size_t bytes)
{
}

static inline void cancel_dirty_page(struct page *page, unsigned int account_size)
{
	if (test_clear_page_dirty(page)) {
		struct address_space *mapping = page->mapping;
		if (mapping && account_size)
			task_io_account_cancelled_write(account_size);
	}
}

#endif
