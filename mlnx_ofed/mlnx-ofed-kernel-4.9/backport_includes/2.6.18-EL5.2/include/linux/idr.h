#ifndef __IDR_H_BACKPORT__
#define __IDR_H_BACKPORT__
#include_next <linux/idr.h>

int idr_for_each(struct idr *idp,
                 int (*fn)(int id, void *p, void *data), void *data);

#endif
