#ifndef __BACKPORT_LINUX_SCATTERLIST_H_TO_2_6_23__
#define __BACKPORT_LINUX_SCATTERLIST_H_TO_2_6_23__

#include_next<linux/scatterlist.h>
#include <linux/ncrypto.h>

static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
{
	sg->page = page;
}

#define for_each_sg(sglist, sg, nr, __i)	\
	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg++)

static inline struct scatterlist *sg_next(struct scatterlist *sg)
{
	if (!sg) {
		BUG();
		return NULL;
	}
	return sg + 1;
}

#endif
