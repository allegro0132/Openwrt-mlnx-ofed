#ifndef __BACKPORT_DEBUGFS_H_
#define __BACKPORT_DEBUGFS_H_

#include_next <linux/debugfs.h>

#define LINUX_BACKPORT(__sym) backport_ ##__sym

#define debugfs_remove_recursive LINUX_BACKPORT(debugfs_remove_recursive)
static inline void debugfs_remove_recursive(struct dentry *dentry)
{
	struct dentry *last = NULL;

	/* Sanity checks */
	if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
		return;

	while (dentry != last) {
		struct dentry *child = dentry;

		/* Find a child without children */
		while (!list_empty(&child->d_subdirs))
			child = list_entry(child->d_subdirs.next,
					   struct dentry,
					   d_u.d_child);

		/* Bail out if we already tried to remove that entry */
		if (child == last)
			return;

		last = child;
		debugfs_remove(child);
	}
}

#endif /* __BACKPORT_DEBUGFS_H_ */
