#ifndef __BACKPORT_2_6_21_PGTABLE_64k_H__
#define __BACKPORT_2_6_21_PGTABLE_64k_H__
#include_next <asm/pgtable-64k.h>

#ifndef remap_4k_pfn
/* if kernel page size is 64k and there is no remap_4k_pfn()
 * declared by native kernel, we don't allow mapping to
 * user space */
#define remap_4k_pfn(vma, addr, pfn, prot) (-ENOMEM)
#endif

#endif
