#ifndef BACKPORT_LINUX_DCACHE_H
#define BACKPORT_LINUX_DCACHE_H

#include_next <linux/dcache.h>
#include <linux/err.h>

#define d_materialise_unique(dentry, inode) d_add_unique(dentry, inode)

extern void iput(struct inode *);

static inline struct dentry *d_obtain_alias(struct inode *inode)
{
	struct dentry *rc;

	rc = d_alloc_anon(inode);
	if (!rc) {
		iput(inode);
		return ERR_PTR(-ENOMEM);
	}

	return rc;
}

#endif
