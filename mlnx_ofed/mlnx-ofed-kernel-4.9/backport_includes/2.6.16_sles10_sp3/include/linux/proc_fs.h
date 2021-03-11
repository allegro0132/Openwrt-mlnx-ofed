#ifndef BACKPORT_LINUX_PROC_FS_H
#define BACKPORT_LINUX_PROC_FS_H

#include_next <linux/proc_fs.h>

static inline struct proc_dir_entry *proc_create(const char *name,
	mode_t mode, struct proc_dir_entry *parent,
	const struct file_operations *fops)
{
	struct proc_dir_entry *res = create_proc_entry(name, mode, parent);
	if (res)
		res->proc_fops = (struct file_operations *)fops;
	return res;
}

static inline struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
				struct proc_dir_entry *parent,
				const struct file_operations *proc_fops,
				void *data)
{
		struct proc_dir_entry *pde;

		pde = proc_create(name, mode, parent, proc_fops);
		if (pde)
			pde->data = data;

		return pde;
}

#endif
