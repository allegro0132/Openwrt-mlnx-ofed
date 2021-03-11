#ifndef __BACKPORT_CHECKSUM_H_TO_2_6_19__
#define __BACKPORT_CHECKSUM_H_TO_2_6_19__

#include_next <net/checksum.h>

static inline __wsum csum_unfold(__sum16 n)
{
	return (__force __wsum)n;
}

#endif
