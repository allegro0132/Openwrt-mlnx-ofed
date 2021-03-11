#include <linux/slab.h>
#include <linux/kernel.h>
#include <linux/bitops.h>
#include <linux/cpumask.h>
#include <linux/export.h>
#include <linux/bootmem.h>

/**
 * cpumask_set_cpu_local_first - set i'th cpu with local numa cpu's first
 *
 * @i: index number
 * @numa_node: local numa_node
 * @dstp: cpumask with the relevant cpu bit set according to the policy
 *
 * This function sets the cpumask according to a numa aware policy.
 * cpumask could be used as an affinity hint for the IRQ related to a
 * queue. When the policy is to spread queues across cores - local cores
 * first.
 *
 * Returns 0 on success, -ENOMEM for no memory, and -EAGAIN when failed to set
 * the cpu bit and need to re-call the function.
 */
#define cpumask_set_cpu_local_first LINUX_BACKPORT(cpumask_set_cpu_local_first)
int cpumask_set_cpu_local_first(int i, int numa_node, cpumask_t *dstp)
{
	cpumask_var_t mask;
	int cpu;
	int ret = 0;

	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
		return -ENOMEM;

	i %= num_online_cpus();

	if (numa_node == -1 || !cpumask_of_node(numa_node)) {
		/* Use all online cpu's for non numa aware system */
		cpumask_copy(mask, cpu_online_mask);
	} else {
		int n;

		cpumask_and(mask,
			    cpumask_of_node(numa_node), cpu_online_mask);

		n = cpumask_weight(mask);
		if (i >= n) {
			i -= n;

			/* If index > number of local cpu's, mask out local
			 * cpu's
			 */
			cpumask_andnot(mask, cpu_online_mask, mask);
		}
	}

	for_each_cpu(cpu, mask) {
		if (--i < 0)
			goto out;
	}

	ret = -EAGAIN;

out:
	free_cpumask_var(mask);

	if (!ret)
		cpumask_set_cpu(cpu, dstp);

	return ret;
}
EXPORT_SYMBOL(cpumask_set_cpu_local_first);
