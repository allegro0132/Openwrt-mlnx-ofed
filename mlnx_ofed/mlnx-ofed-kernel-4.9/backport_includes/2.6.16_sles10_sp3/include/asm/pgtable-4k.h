#ifndef __BACKPORT_2_6_21_PGTABLE_4k_H__
#define __BACKPORT_2_6_21_PGTABLE_4k_H__
#include_next <asm/pgtable-4k.h>

#ifndef remap_4k_pfn
#define remap_4k_pfn(vma, addr, pfn, prot)	\
	remap_pfn_range((vma), (addr), (pfn), PAGE_SIZE, (prot))
#endif

#endif
