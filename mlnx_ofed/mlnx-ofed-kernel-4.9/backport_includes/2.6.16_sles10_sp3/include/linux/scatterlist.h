#ifndef __BACKPORT_LINUX_SCATTERLIST_H_TO_2_6_23__
#define __BACKPORT_LINUX_SCATTERLIST_H_TO_2_6_23__
#include_next<linux/scatterlist.h>


struct sg_table {
	struct scatterlist *sgl;	/* the list */
	unsigned int nents;		/* number of mapped entries */
	unsigned int orig_nents;	/* original size of list */
};

#define SG_MAGIC	0x87654321

/*
 * We overload the LSB of the page pointer to indicate whether it's
 * a valid sg entry, or whether it points to the start of a new scatterlist.
 * Those low bits are there for everyone! (thanks mason :-)
 */
#define sg_is_chain(sg)		((sg)->page_link & 0x01)
#define sg_is_last(sg)		((sg)->page_link & 0x02)
#define sg_chain_ptr(sg)	\
	((struct scatterlist *) ((sg)->page_link & ~0x03))
static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
{
	sg->page = page;
}

static inline void sg_set_page2(struct scatterlist *sg, struct page *page,
                               unsigned int len, unsigned int offset)
{
	sg->page = page;
	sg->offset = offset;
	sg->length = len;
}
#define sg_set_page sg_set_page2

static inline void sg_mark_end(struct scatterlist *sg)
{
}

#ifndef sg_page
#define sg_page(a) (a)->page
#endif
#ifndef sg_init_table
#define sg_init_table(a, b)
#endif

#define for_each_sg(sglist, sg, nr, __i)	\
	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg++)

static inline struct scatterlist *sg_next2(struct scatterlist *sg)
{
	if (!sg) {
		BUG();
		return NULL;
	}
	return sg + 1;
}
#define sg_next sg_next2

#endif
