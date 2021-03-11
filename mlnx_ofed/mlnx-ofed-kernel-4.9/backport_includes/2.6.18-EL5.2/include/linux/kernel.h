#ifndef BACKPORT_KERNEL_H_2_6_22
#define BACKPORT_KERNEL_H_2_6_22

#include_next <linux/kernel.h>

#include <asm/errno.h>
#include <asm/string.h>

#define USHORT_MAX	((u16)(~0U))


#endif
