#ifndef _BACKPORT_LINUX_PATH_H
#define _BACKPORT_LINUX_PATH_H

#include <linux/mount.h>
#include <linux/namei.h>

static inline void path_put(struct path *path)
{
	dput(path->dentry);
	mntput(path->mnt);
}

static inline void path_get(struct path *path)
{
	mntget(path->mnt);
	dget(path->dentry);
}

static inline void backport_path_put(struct nameidata *nd)
{
	dput(nd->dentry);
	mntput(nd->mnt);
}

static inline void backport_path_get(struct nameidata *nd)
{
	mntget(nd->mnt);
	dget(nd->dentry);
}

#endif  /* _BACKPORT_LINUX_PATH_H */
