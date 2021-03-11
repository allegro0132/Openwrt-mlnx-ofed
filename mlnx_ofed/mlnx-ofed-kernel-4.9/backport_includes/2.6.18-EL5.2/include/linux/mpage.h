#ifndef BACKPORT_LINUX_MPAGE_H
#define BACKPORT_LINUX_MPAGE_H

#include_next <linux/mpage.h>

static inline int backport_write_cache_pages(struct address_space *mapping,
                      struct writeback_control *wbc, writepage_data_t writepage,
                      void *data)
{
	return write_cache_pages(mapping, 0, wbc, writepage, data);
}
#define write_cache_pages backport_write_cache_pages

#endif
