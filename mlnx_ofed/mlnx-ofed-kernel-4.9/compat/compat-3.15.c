#include <linux/export.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>

#define kvfree LINUX_BACKPORT(kvfree)
void kvfree(const void *addr)
{
	if (is_vmalloc_addr(addr))
		vfree(addr);
	else
		kfree(addr);
}
EXPORT_SYMBOL(kvfree);
