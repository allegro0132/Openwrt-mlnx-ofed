#ifndef LINUX_SWAP_BACKPORT_H
#define LINUX_SWAP_BACKPORT_H

#include_next <linux/swap.h>

static inline unsigned int backport_nr_free_buffer_pages(void)
{
	/* Just pick one node, since fallback list is circular */
	pg_data_t *pgdat = NODE_DATA(numa_node_id());
	unsigned int sum = 0;

	struct zonelist *zonelist = pgdat->node_zonelists + gfp_zone(GFP_USER);
	struct zone **zonep = zonelist->zones;
	struct zone *zone;

	for (zone = *zonep++; zone; zone = *zonep++) {
		unsigned long size = zone->present_pages;
		unsigned long high = zone->pages_high;
		if (size > high)
			sum += size - high;
	}

	return sum;
}

#define nr_free_buffer_pages backport_nr_free_buffer_pages

#endif
