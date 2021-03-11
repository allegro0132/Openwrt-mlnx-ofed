#ifndef BACKPORT_LINUX_MOUNT_H
#define BACKPORT_LINUX_MOUNT_H

#include_next <linux/mount.h>
#include <linux/fs.h>

extern int mnt_want_write(struct vfsmount *mnt);
extern void mnt_drop_write(struct vfsmount *mnt);
extern int init_mnt_writers(void);

#endif
