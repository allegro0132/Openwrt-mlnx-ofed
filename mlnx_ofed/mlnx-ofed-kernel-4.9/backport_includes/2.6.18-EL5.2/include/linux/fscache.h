#ifndef BACKPORT_LINUX_FSCACHE_H
#define BACKPORT_LINUX_FSCACHE_H

#include_next <linux/fscache.h>
#include <linux/page-flags.h>

#define NFS_PAGE_WRITING	0
#define NFS_PAGE_CACHED		1

#define PageNfsBit(bit, page)		test_bit(bit, &(page)->private)

#define SetPageNfsBit(bit, page)		\
do {						\
	SetPagePrivate((page));			\
	set_bit(bit, &(page)->private);		\
} while(0)

#define ClearPageNfsBit(bit, page)		\
do {						\
	clear_bit(bit, &(page)->private);	\
} while(0)

#define PageNfsWriting(page)		PageNfsBit(NFS_PAGE_WRITING, (page))
#define SetPageNfsWriting(page)		SetPageNfsBit(NFS_PAGE_WRITING, (page))
#define ClearPageNfsWriting(page)	ClearPageNfsBit(NFS_PAGE_WRITING, (page))

#define PageNfsCached(page)		PageNfsBit(NFS_PAGE_CACHED, (page))
#define SetPageNfsCached(page)		SetPageNfsBit(NFS_PAGE_CACHED, (page))
#define ClearPageNfsCached(page)	ClearPageNfsBit(NFS_PAGE_CACHED, (page))


#define PageFsCache(page)		PageNfsCached(page)
#define ClearPageFsCache(page)		ClearPageNfsCached(page)
#define fscache_check_page_write(cookie, page)	PageNfsWriting(page)

static inline void
fscache_wait_on_page_write(struct fscache_cookie *cookie, struct page *page)
{
	wait_queue_head_t *wq = bit_waitqueue(&(page)->private, 0);
	wait_event(*wq, !PageNfsWriting(page));
}

static inline int
backport_fscache_write_page(struct fscache_cookie *cookie, struct page *page, gfp_t gfp)
{
	return fscache_write_page(cookie, page, NULL, NULL, gfp);
}
#define fscache_write_page backport_fscache_write_page

#endif
