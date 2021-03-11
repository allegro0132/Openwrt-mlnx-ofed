#ifndef BACKPORT_LINUX_NODEMASK_H
#define BACKPORT_LINUX_NODEMASK_H

#include_next <linux/nodemask.h>

#if MAX_NUMNODES > 1
/*
 * Find the highest possible node id.
 */
static inline int highest_possible_node_id(void)
{
	unsigned int node;
	unsigned int highest = 0;

	for_each_node_mask(node, node_possible_map)
		highest = node;
	return highest;
}
#else
#define highest_possible_node_id()	0
#endif

#ifndef first_online_node
#define first_online_node	0
#endif

#endif
