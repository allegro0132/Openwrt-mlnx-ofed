#ifndef BACKPORT_LINUX_NAMEI_H
#define BACKPORT_LINUX_NAMEI_H

#include_next <linux/namei.h>

struct path {
	struct vfsmount *mnt;
	struct dentry *dentry;
};

#include <linux/path.h>

static inline int kern_path(const char *name, unsigned int flags, struct path *path)
{
	struct nameidata nd;
	int rc = path_lookup(name, flags, &nd);
	if (!rc) {
		(*path).mnt = nd.mnt;
		(*path).dentry = nd.dentry;
	}
	return rc;
}

static inline int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
		    const char *name, unsigned int flags,
		    struct nameidata *nd)
{
	int retval;

	/* same as do_path_lookup */
	nd->last_type = LAST_ROOT;
	nd->flags = flags;
	nd->depth = 0;

	nd->dentry = dentry;
	nd->mnt = mnt;
	mntget(nd->mnt);
	dget(nd->dentry);

	retval = path_walk(name, nd);

	return retval;
}

#endif /* BACKPORT_LINUX_NAMEI_H */
