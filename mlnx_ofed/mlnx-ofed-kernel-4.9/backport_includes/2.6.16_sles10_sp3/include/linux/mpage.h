#ifndef BACKPORT_LINUX_MPAGE_H
#define BACKPORT_LINUX_MPAGE_H

#include_next <linux/mpage.h>
#include <linux/pagevec.h>

typedef int (*backport_writepage_t)(struct page *page, struct writeback_control *wbc,
                                void *data);

extern int write_cache_pages(struct address_space *mapping,
                      struct writeback_control *wbc, backport_writepage_t writepage,
                      void *data);
#endif
