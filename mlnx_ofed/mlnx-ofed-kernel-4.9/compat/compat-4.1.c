#include <linux/slab.h>
#include <linux/kernel.h>
#include <linux/bitops.h>
#include <linux/cpumask.h>
#include <linux/export.h>
#include <linux/bootmem.h>

/**
 * cpumask_local_spread - select the i'th cpu with local numa cpu's first
 * @i: index number
 * @node: local numa_node
 *
 * This function selects an online CPU according to a numa aware policy;
 * local cpus are returned first, followed by non-local ones, then it
 * wraps around.
 *
 * It's not very efficient, but useful for setup.
 */
#define cpumask_local_spread LINUX_BACKPORT(cpumask_local_spread)
unsigned int cpumask_local_spread(unsigned int i, int node)
{
	int cpu;

	/* Wrap: we always want a cpu. */
	i %= num_online_cpus();

	if (node == -1) {
		for_each_cpu(cpu, cpu_online_mask)
			if (i-- == 0)
				return cpu;
	} else {
		/* NUMA first. */
		for_each_cpu_and(cpu, cpumask_of_node(node), cpu_online_mask)
			if (i-- == 0)
				return cpu;

		for_each_cpu(cpu, cpu_online_mask) {
			/* Skip NUMA nodes, done above. */
			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
				continue;

			if (i-- == 0)
				return cpu;
		}
	}
	BUG();
}
EXPORT_SYMBOL(cpumask_local_spread);
