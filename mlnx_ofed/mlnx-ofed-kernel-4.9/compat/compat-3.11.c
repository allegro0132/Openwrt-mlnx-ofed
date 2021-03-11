#include <linux/export.h>
#include <linux/scatterlist.h>
#include <linux/highmem.h>

#define sg_mapping_iter LINUX_BACKPORT(sg_mapping_iter)
#define sg_miter_start LINUX_BACKPORT(sg_miter_start)
#define sg_miter_skip LINUX_BACKPORT(sg_miter_skip)
#define sg_miter_next LINUX_BACKPORT(sg_miter_next)
#define sg_miter_stop LINUX_BACKPORT(sg_miter_stop)

/*
 * Mapping sg iterator
 *
 * Iterates over sg entries mapping page-by-page.  On each successful
 * iteration, @miter->page points to the mapped page and
 * @miter->length bytes of data can be accessed at @miter->addr.  As
 * long as an interation is enclosed between start and stop, the user
 * is free to choose control structure and when to stop.
 *
 * @miter->consumed is set to @miter->length on each iteration.  It
 * can be adjusted if the user can't consume all the bytes in one go.
 * Also, a stopped iteration can be resumed by calling next on it.
 * This is useful when iteration needs to release all resources and
 * continue later (e.g. at the next interrupt).
 */

#define SG_MITER_ATOMIC		(1 << 0)	/* use kmap_atomic */
#define SG_MITER_TO_SG		(1 << 1)	/* flush back to phys on unmap*/
#define SG_MITER_FROM_SG	(1 << 2)	/* nop */

struct sg_mapping_iter {
	/* the following three fields can be accessed directly */
	struct page		*page;		/* currently mapped page */
	void			*addr;		/* pointer to the mapped area */
	size_t			length;		/* length of the mapped area */
	size_t			consumed;	/* number of consumed bytes */
	struct sg_page_iter	piter;		/* page iterator */

	/* these are internal states, keep away */
	unsigned int		__offset;	/* offset within page */
	unsigned int		__remaining;	/* remaining bytes on page */
	unsigned int		__flags;
};

void sg_miter_stop(struct sg_mapping_iter *miter);

#ifndef HAVE_SG_PAGE_ITER
void __sg_page_iter_start(struct sg_page_iter *piter,
			  struct scatterlist *sglist, unsigned int nents,
			  unsigned long pgoffset)
{
	piter->__pg_advance = 0;
	piter->__nents = nents;

	piter->sg = sglist;
	piter->sg_pgoffset = pgoffset;
}
EXPORT_SYMBOL(__sg_page_iter_start);

static int sg_page_count(struct scatterlist *sg)
{
	return PAGE_ALIGN(sg->offset + sg->length) >> PAGE_SHIFT;
}

bool __sg_page_iter_next(struct sg_page_iter *piter)
{
	if (!piter->__nents || !piter->sg)
		return false;

	piter->sg_pgoffset += piter->__pg_advance;
	piter->__pg_advance = 1;

	while (piter->sg_pgoffset >= sg_page_count(piter->sg)) {
		piter->sg_pgoffset -= sg_page_count(piter->sg);
		piter->sg = sg_next(piter->sg);
		if (!--piter->__nents || !piter->sg)
			return false;
	}

	return true;
}
EXPORT_SYMBOL(__sg_page_iter_next);
#endif
/**
 * sg_miter_start - start mapping iteration over a sg list
 * @miter: sg mapping iter to be started
 * @sgl: sg list to iterate over
 * @nents: number of sg entries
 *
 * Description:
 *   Starts mapping iterator @miter.
 *
 * Context:
 *   Don't care.
 */
void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
		    unsigned int nents, unsigned int flags)
{
	memset(miter, 0, sizeof(struct sg_mapping_iter));

	__sg_page_iter_start(&miter->piter, sgl, nents, 0);
	WARN_ON(!(flags & (SG_MITER_TO_SG | SG_MITER_FROM_SG)));
	miter->__flags = flags;
}
/* EXPORT_SYMBOL(sg_miter_start); */

static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
{
	if (!miter->__remaining) {
		struct scatterlist *sg;
		unsigned long pgoffset;

		if (!__sg_page_iter_next(&miter->piter))
			return false;

		sg = miter->piter.sg;
		pgoffset = miter->piter.sg_pgoffset;

		miter->__offset = pgoffset ? 0 : sg->offset;
		miter->__remaining = sg->offset + sg->length -
				(pgoffset << PAGE_SHIFT) - miter->__offset;
		miter->__remaining = min_t(unsigned long, miter->__remaining,
					   PAGE_SIZE - miter->__offset);
	}

	return true;
}

/**
 * sg_miter_skip - reposition mapping iterator
 * @miter: sg mapping iter to be skipped
 * @offset: number of bytes to plus the current location
 *
 * Description:
 *   Sets the offset of @miter to its current location plus @offset bytes.
 *   If mapping iterator @miter has been proceeded by sg_miter_next(), this
 *   stops @miter.
 *
 * Context:
 *   Don't care if @miter is stopped, or not proceeded yet.
 *   Otherwise, preemption disabled if the SG_MITER_ATOMIC is set.
 *
 * Returns:
 *   true if @miter contains the valid mapping.  false if end of sg
 *   list is reached.
 */
bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
{
	sg_miter_stop(miter);

	while (offset) {
		off_t consumed;

		if (!sg_miter_get_next_page(miter))
			return false;

		consumed = min_t(off_t, offset, miter->__remaining);
		miter->__offset += consumed;
		miter->__remaining -= consumed;
		offset -= consumed;
	}

	return true;
}
/* EXPORT_SYMBOL(sg_miter_skip); */

/**
 * sg_miter_next - proceed mapping iterator to the next mapping
 * @miter: sg mapping iter to proceed
 *
 * Description:
 *   Proceeds @miter to the next mapping.  @miter should have been started
 *   using sg_miter_start().  On successful return, @miter->page,
 *   @miter->addr and @miter->length point to the current mapping.
 *
 * Context:
 *   Preemption disabled if SG_MITER_ATOMIC.  Preemption must stay disabled
 *   till @miter is stopped.  May sleep if !SG_MITER_ATOMIC.
 *
 * Returns:
 *   true if @miter contains the next mapping.  false if end of sg
 *   list is reached.
 */
bool sg_miter_next(struct sg_mapping_iter *miter)
{
	sg_miter_stop(miter);

	/*
	 * Get to the next page if necessary.
	 * __remaining, __offset is adjusted by sg_miter_stop
	 */
	if (!sg_miter_get_next_page(miter))
		return false;

	miter->page = sg_page_iter_page(&miter->piter);
	miter->consumed = miter->length = miter->__remaining;

	if (miter->__flags & SG_MITER_ATOMIC)
#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 4, 0))
		miter->addr = kmap_atomic(miter->page, 0) + miter->__offset;
#else
		miter->addr = kmap_atomic(miter->page) + miter->__offset;
#endif
	else
		miter->addr = kmap(miter->page) + miter->__offset;

	return true;
}
/* EXPORT_SYMBOL(sg_miter_next); */

/**
 * sg_miter_stop - stop mapping iteration
 * @miter: sg mapping iter to be stopped
 *
 * Description:
 *   Stops mapping iterator @miter.  @miter should have been started
 *   started using sg_miter_start().  A stopped iteration can be
 *   resumed by calling sg_miter_next() on it.  This is useful when
 *   resources (kmap) need to be released during iteration.
 *
 * Context:
 *   Preemption disabled if the SG_MITER_ATOMIC is set.  Don't care
 *   otherwise.
 */
void sg_miter_stop(struct sg_mapping_iter *miter)
{
	WARN_ON(miter->consumed > miter->length);

	/* drop resources from the last iteration */
	if (miter->addr) {
		miter->__offset += miter->consumed;
		miter->__remaining -= miter->consumed;

		if ((miter->__flags & SG_MITER_TO_SG) &&
		    !PageSlab(miter->page))
			flush_kernel_dcache_page(miter->page);

		if (miter->__flags & SG_MITER_ATOMIC) {
			WARN_ON_ONCE(preemptible());
#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 4, 0))
			kunmap_atomic(miter->addr, 0);
#else
			kunmap_atomic(miter->addr);
#endif
		} else
			kunmap(miter->page);

		miter->page = NULL;
		miter->addr = NULL;
		miter->length = 0;
		miter->consumed = 0;
	}
}
/* EXPORT_SYMBOL(sg_miter_stop); */

/**
 * sg_copy_buffer - Copy data between a linear buffer and an SG list
 * @sgl:		 The SG list
 * @nents:		 Number of SG entries
 * @buf:		 Where to copy from
 * @buflen:		 The number of bytes to copy
 * @skip:		 Number of bytes to skip before copying
 * @to_buffer:		 transfer direction (true == from an sg list to a
 *			 buffer, false == from a buffer to an sg list
 *
 * Returns the number of copied bytes.
 *
 **/
#define sg_copy_buffer LINUX_BACKPORT(sg_copy_buffer)
static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
			     void *buf, size_t buflen, off_t skip,
			     bool to_buffer)
{
	unsigned int offset = 0;
	struct sg_mapping_iter miter;
	unsigned long flags;
	unsigned int sg_flags = SG_MITER_ATOMIC;

	if (to_buffer)
		sg_flags |= SG_MITER_FROM_SG;
	else
		sg_flags |= SG_MITER_TO_SG;

	sg_miter_start(&miter, sgl, nents, sg_flags);

	if (!sg_miter_skip(&miter, skip))
		return false;

	local_irq_save(flags);

	while (sg_miter_next(&miter) && offset < buflen) {
		unsigned int len;

		len = min(miter.length, buflen - offset);

		if (to_buffer)
			memcpy(buf + offset, miter.addr, len);
		else
			memcpy(miter.addr, buf + offset, len);

		offset += len;
	}

	sg_miter_stop(&miter);

	local_irq_restore(flags);
	return offset;
}

/**
 * sg_copy_from_buffer - Copy from a linear buffer to an SG list
 * @sgl:		 The SG list
 * @nents:		 Number of SG entries
 * @buf:		 Where to copy from
 * @buflen:		 The number of bytes to copy
 *
 * Returns the number of copied bytes.
 *
 **/
#define sg_copy_from_buffer LINUX_BACKPORT(sg_copy_from_buffer)
size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
			   void *buf, size_t buflen)
{
	return sg_copy_buffer(sgl, nents, buf, buflen, 0, false);
}
EXPORT_SYMBOL(sg_copy_from_buffer);

/**
 * sg_copy_to_buffer - Copy from an SG list to a linear buffer
 * @sgl:		 The SG list
 * @nents:		 Number of SG entries
 * @buf:		 Where to copy to
 * @buflen:		 The number of bytes to copy
 *
 * Returns the number of copied bytes.
 *
 **/
#define sg_copy_to_buffer LINUX_BACKPORT(sg_copy_to_buffer)
size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
			 void *buf, size_t buflen)
{
	return sg_copy_buffer(sgl, nents, buf, buflen, 0, true);
}
EXPORT_SYMBOL(sg_copy_to_buffer);

/**
 * sg_pcopy_from_buffer - Copy from a linear buffer to an SG list
 * @sgl:		 The SG list
 * @nents:		 Number of SG entries
 * @buf:		 Where to copy from
 * @skip:		 Number of bytes to skip before copying
 * @buflen:		 The number of bytes to copy
 *
 * Returns the number of copied bytes.
 *
 **/
#define sg_pcopy_from_buffer LINUX_BACKPORT(sg_pcopy_from_buffer)
size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
			    void *buf, size_t buflen, off_t skip)
{
	return sg_copy_buffer(sgl, nents, buf, buflen, skip, false);
}
EXPORT_SYMBOL(sg_pcopy_from_buffer);

/**
 * sg_pcopy_to_buffer - Copy from an SG list to a linear buffer
 * @sgl:		 The SG list
 * @nents:		 Number of SG entries
 * @buf:		 Where to copy to
 * @skip:		 Number of bytes to skip before copying
 * @buflen:		 The number of bytes to copy
 *
 * Returns the number of copied bytes.
 *
 **/
#define sg_pcopy_to_buffer LINUX_BACKPORT(sg_pcopy_to_buffer)
size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
			  void *buf, size_t buflen, off_t skip)
{
	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
}
EXPORT_SYMBOL(sg_pcopy_to_buffer);

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0))
/**
 * fixed_size_llseek - llseek implementation for fixed-sized devices
 * @file:   file structure to seek on
 * @offset:    file offset to seek to
 * @whence:   type of seek
 * @size:    size of the file
 *
 **/
#define fixed_size_llseek LINUX_BACKPORT(fixed_size_llseek)
loff_t fixed_size_llseek(struct file *file, loff_t offset, int whence,
			 loff_t size)
{
	switch (whence) {
	case SEEK_SET: case SEEK_CUR: case SEEK_END:
		return generic_file_llseek_size(file, offset, whence,
						size, size);
	default:
		return -EINVAL;
	}
}
EXPORT_SYMBOL(fixed_size_llseek);
#endif
