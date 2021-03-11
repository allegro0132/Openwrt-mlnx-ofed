#ifndef BACKPORT_LINUX_CPUMASK_H
#define BACKPORT_LINUX_CPUMASK_H

#include_next <linux/cpumask.h>

#ifndef cpumask_of
#define cpumask_of(cpu)			(cpumask_of_cpu(cpu))
#endif
#ifndef cpumask_of_node
#define cpumask_of_node(node)		(node_to_cpumask(node))
#endif
#ifdef nr_node_ids
#define nr_node_ids			(highest_possible_processor_id() + 1)
#endif
#ifndef nr_cpu_ids
#define nr_cpu_ids			(highest_possible_processor_id() + 1)
#endif

#endif /* BACKPORT_LINUX_CPUMASK_H */
