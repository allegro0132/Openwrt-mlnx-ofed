#ifndef __BACKPORT_SYSCTL_H_TO_2_6_18__
#define __BACKPORT_SYSCTL_H_TO_2_6_18__

#include <linux/slab.h>
#include <linux/err.h>
#include_next <linux/sysctl.h>

#define CTL_NONE	0

#define CTL_SUNRPC	7249            /* sunrpc debug */
#define FAKE_SYSCTL_MAGIC1	((void *) 0xcafebabe)

static inline void __fake_sysctl_table_destroy(struct ctl_table *node)
{
	struct ctl_table *next;

	while (node && node[1].extra1 == FAKE_SYSCTL_MAGIC1) {
		next = node->child;
		kfree(node);
		node = next;
	}
}

/*
 * Given a ctl_path and a ctl_table, convert this to the old-fashioned
 * table hierarchy, linked through table->child.
 */
static inline struct ctl_table_header *
register_sysctl_paths(const struct ctl_path *path, struct ctl_table *table)
{
	struct ctl_table_header *result = NULL;
	struct ctl_table *root = NULL, *tp, **prev = &root;

	for (; path->procname; ++path) {
		tp = kzalloc(2 * sizeof(struct ctl_table), GFP_KERNEL);
		if (!tp)
			goto out;

		tp->ctl_name = path->ctl_name;
		tp->procname = path->procname;
		tp->mode = 0555;
		tp[1].extra1 = FAKE_SYSCTL_MAGIC1;
		*prev = tp;
		prev = &tp->child;
	}
	*prev = table;

	result = register_sysctl_table(root, 0);

out:
	if (!result)
		__fake_sysctl_table_destroy(root);

	return result;
}

static inline void
fake_unregister_sysctl_table(struct ctl_table_header *hdr)
{
	struct ctl_table *node = hdr->ctl_table;

	unregister_sysctl_table(hdr);
	__fake_sysctl_table_destroy(node);
}

#define unregister_sysctl_table(hdr)	fake_unregister_sysctl_table(hdr)

static inline struct ctl_table_header *
backport_register_sysctl_table(ctl_table *table) {
	return register_sysctl_table(table, 0);
}

#define register_sysctl_table backport_register_sysctl_table
#endif /* __BACKPORT_SYSCTL_H_TO_2_6_18__ */
