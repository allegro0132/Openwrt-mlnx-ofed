#ifndef __BACKPORT_LINUX_BYTEORDER_GENERIC_H_TO_2_6_24__
#define __BACKPORT_LINUX_BYTEORDER_GENERIC_H_TO_2_6_24__

#include_next <linux/byteorder/generic.h>

static inline void be16_add_cpu(__be16 *var, u16 val)
{
	*var = cpu_to_be16(be16_to_cpu(*var) + val);
}

#endif /* __BACKPORT_LINUX_BYTEORDER_GENERIC_H_TO_2_6_24__ */
