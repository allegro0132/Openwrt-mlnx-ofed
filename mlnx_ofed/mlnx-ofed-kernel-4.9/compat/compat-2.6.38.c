/*
 * Copyright 2010    Hauke Mehrtens <hauke@hauke-m.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux wireless for kernels 2.6.38.
 */

#if !defined(RHEL_MINOR) || (RHEL_MINOR < 3)
#include <linux/compat.h>
#include <linux/module.h>
#include <linux/bug.h>

/**
 * ewma_init() - Initialize EWMA parameters
 * @avg: Average structure
 * @factor: Factor to use for the scaled up internal value. The maximum value
 *	of averages can be ULONG_MAX/(factor*weight).
 * @weight: Exponential weight, or decay rate. This defines how fast the
 *	influence of older values decreases. Has to be bigger than 1.
 *
 * Initialize the EWMA parameters for a given struct ewma @avg.
 */
#define ewma_init LINUX_BACKPORT(ewma_init)
void ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
{
	WARN_ON(weight <= 1 || factor == 0);
	avg->internal = 0;
	avg->weight = weight;
	avg->factor = factor;
}
EXPORT_SYMBOL_GPL(ewma_init);

/**
 * ewma_add() - Exponentially weighted moving average (EWMA)
 * @avg: Average structure
 * @val: Current value
 *
 * Add a sample to the average.
 */
#define ewma_add LINUX_BACKPORT(ewma_add)
struct ewma *ewma_add(struct ewma *avg, unsigned long val)
{
	avg->internal = avg->internal  ?
		(((avg->internal * (avg->weight - 1)) +
			(val * avg->factor)) / avg->weight) :
		(val * avg->factor);
	return avg;
}
EXPORT_SYMBOL_GPL(ewma_add);

#endif
