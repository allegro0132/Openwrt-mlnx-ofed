#ifndef BACKPORT_LINUX_CPUMASK_H
#define BACKPORT_LINUX_CPUMASK_H

#include_next <linux/cpumask.h>

#define cpumask_of(cpu)			(cpumask_of_cpu(cpu))
#define cpumask_of_node(node)		(node_to_cpumask(node))
#define nr_node_ids			(highest_possible_processor_id() + 1)
#define nr_cpu_ids			(highest_possible_processor_id() + 1)

#endif /* BACKPORT_LINUX_CPUMASK_H */
