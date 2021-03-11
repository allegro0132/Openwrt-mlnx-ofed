#ifndef __BACKPORT_CHECKSUM_H__
#define __BACKPORT_CHECKSUM_H__

#include_next <asm/checksum.h>

#if defined(__ia64__)

static inline __wsum
backport_csum_tcpudp_nofold (__be32 saddr, __be32 daddr, unsigned short len,
		    unsigned short proto, __wsum sum)
{
	unsigned long result;

	result = (__force u64)saddr + (__force u64)daddr +
		 (__force u64)sum + ((len + proto) << 8);

	/* Fold down to 32-bits so we don't lose in the typedef-less network stack.  */
	/* 64 to 33 */
	result = (result & 0xffffffff) + (result >> 32);
	/* 33 to 32 */
	result = (result & 0xffffffff) + (result >> 32);
	return (__force __wsum)result;
}

#undef csum_tcpudp_nofold
#define csum_tcpudp_nofold backport_csum_tcpudp_nofold

#endif

#endif /* __BACKPORT_CHECKSUM_H__ */
