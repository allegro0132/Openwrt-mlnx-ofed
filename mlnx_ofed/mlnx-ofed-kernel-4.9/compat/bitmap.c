#include <linux/export.h>
#include <linux/thread_info.h>
#include <linux/ctype.h>
#include <linux/errno.h>
#include <linux/bitmap.h>
#include <linux/bitops.h>
#include <linux/bug.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/slab.h>
#include <linux/string.h>
#include <linux/uaccess.h>

#include <asm/page.h>

#ifndef HAVE_BITMAP_KZALLOC
unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
{
	return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long),
			     flags);
}
EXPORT_SYMBOL(bitmap_alloc);

unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
{
	return bitmap_alloc(nbits, flags | __GFP_ZERO);
}
EXPORT_SYMBOL(bitmap_zalloc);
#endif

#ifndef HAVE_BITMAP_FREE
void bitmap_free(const unsigned long *bitmap)
{
	kfree(bitmap);
}
EXPORT_SYMBOL(bitmap_free);
#endif

#ifndef HAVE_BITMAP_FROM_ARR32
#if BITS_PER_LONG == 64
void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
		       unsigned int nbits)
{
	unsigned int i, halfwords;

	halfwords = DIV_ROUND_UP(nbits, 32);
	for (i = 0; i < halfwords; i++) {
		bitmap[i/2] = (unsigned long) buf[i];
		if (++i < halfwords)
			bitmap[i/2] |= ((unsigned long) buf[i]) << 32;
	}

	/* Clear tail bits in last word beyond nbits. */
	if (nbits % BITS_PER_LONG)
		bitmap[(halfwords - 1) / 2] &= BITMAP_LAST_WORD_MASK(nbits);
}
EXPORT_SYMBOL(bitmap_from_arr32);
#endif
#endif
