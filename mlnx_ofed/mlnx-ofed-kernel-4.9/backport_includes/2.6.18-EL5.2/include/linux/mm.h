#ifndef _BACKPORT_LINUX_MM_H_
#define _BACKPORT_LINUX_MM_H_

#include_next <linux/mm.h>
#include <linux/vmstat.h>

#if defined(__i386__)
#include <asm/highmem.h>
#endif

#define VM_FAULT_LOCKED  0x0200		/* ->fault locked the returned page */
#define VM_CAN_NONLINEAR 0x08000000     /* Has ->fault & does nonlinear pages */

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
	if (TestClearPageDirty(page)) {
		struct address_space *mapping = page->mapping;
		if (mapping && mapping_cap_account_dirty(mapping)) {
			dec_zone_page_state(page, NR_FILE_DIRTY);
			dec_bdi_stat(mapping->backing_dev_info,
					BDI_RECLAIMABLE);
			if (account_size)
				task_io_account_cancelled_write(account_size);
		}
	}
}

#endif
