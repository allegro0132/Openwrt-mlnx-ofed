#ifndef ASM_PROM_BACKPORT_TO_2_6_21_H
#define ASM_PROM_BACKPORT_TO_2_6_21_H

#include_next <asm/prom.h>

#define of_get_property(a, b, c)	get_property((a), (b), (c))

#endif
