#ifndef _VMALLOC_BACKPORT_H
#define _VMALLOC_BACKPORT_H

#include_next <linux/vmalloc.h>
#include <linux/string.h>

static inline void *vmalloc_user(unsigned long size)
{
       void *ret = vmalloc(size);

       if (ret == NULL)
	       goto bail;

       memset(ret, 0, size);

bail:
       return ret;
}

static inline void *vzalloc(unsigned long size)
{
	void *ret;
	ret = vmalloc(size);
	if(ret)
		memset(ret, 0, size);
	return ret;
}

#endif /* _VMALLOC_BACKPORT_H */
