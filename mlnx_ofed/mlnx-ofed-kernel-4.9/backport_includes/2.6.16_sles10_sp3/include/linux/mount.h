#ifndef BACKPORT_LINUX_MOUNT_H
#define BACKPORT_LINUX_MOUNT_H

#include_next <linux/mount.h>
#include <linux/fs.h>

#define MNT_SHRINKABLE  0x100

extern int mnt_want_write(struct vfsmount *mnt);
extern void mnt_drop_write(struct vfsmount *mnt);
extern int init_mnt_writers(void);

static inline struct vfsmount *
vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void *data)
{
	return do_kern_mount(type->name, flags, name, data);
}

#endif
