#include <linux/backing-dev.h>
#include <linux/fs.h>
#include <linux/pagemap.h>
#include <linux/pagevec.h>
#include <linux/writeback.h>
#include <linux/mpage.h>
#include <linux/module.h>

int write_cache_pages(struct address_space *mapping,
                      struct writeback_control *wbc, backport_writepage_t writepage,
                      void *data)
{
        struct backing_dev_info *bdi = mapping->backing_dev_info;
        int ret = 0;
        int done = 0;
        struct pagevec pvec;
        int nr_pages;
        pgoff_t index;
        pgoff_t end;            /* Inclusive */
        int scanned = 0;
        int is_range = 0;
        long nr_to_write = wbc->nr_to_write;

        if (wbc->nonblocking && bdi_write_congested(bdi)) {
                wbc->encountered_congestion = 1;
                return 0;
        }

        pagevec_init(&pvec, 0);
        if (wbc->sync_mode == WB_SYNC_NONE) {
                index = mapping->writeback_index; /* Start from prev offset */
                end = -1;
        } else {
		index = 0;                        /* whole-file sweep */
		scanned = 1;
	}
	if (wbc->start || wbc->end) {
                index = wbc->start >> PAGE_CACHE_SHIFT;
                end = wbc->end >> PAGE_CACHE_SHIFT;
                is_range = 1;
                scanned = 1;
        }
retry:
        while (!done && (index <= end) &&
               (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
                                              PAGECACHE_TAG_DIRTY,
                                              min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
                unsigned i;

                scanned = 1;
                for (i = 0; i < nr_pages; i++) {
                        struct page *page = pvec.pages[i];

                        /*
                         * At this point we hold neither mapping->tree_lock nor
                         * lock on the page itself: the page may be truncated or
                         * invalidated (changing page->mapping to NULL), or even
                         * swizzled back from swapper_space to tmpfs file
                         * mapping
                         */
                        lock_page(page);

                        if (unlikely(page->mapping != mapping)) {
                                unlock_page(page);
                                continue;
                        }

                        if (unlikely(is_range) && page->index > end) {
                                done = 1;
                                unlock_page(page);
                                continue;
                        }

                        if (wbc->sync_mode != WB_SYNC_NONE)
                                wait_on_page_writeback(page);

                        if (PageWriteback(page) ||
                            !clear_page_dirty_for_io(page)) {
                                unlock_page(page);
                                continue;
                        }

                        ret = (*writepage)(page, wbc, data);

                        if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
                                unlock_page(page);
                                ret = 0;
                        }
                        if (ret || (--nr_to_write <= 0))
                                done = 1;
                        if (wbc->nonblocking && bdi_write_congested(bdi)) {
                                wbc->encountered_congestion = 1;
                                done = 1;
                        }
                }
                pagevec_release(&pvec);
                cond_resched();
        }
        if (!scanned && !done) {
                /*
                 * We hit the last page and there is more work to be done: wrap
                 * back to the start of the file
                 */
                scanned = 1;
                index = 0;
                goto retry;
        }
        return ret;
}
EXPORT_SYMBOL(write_cache_pages);
