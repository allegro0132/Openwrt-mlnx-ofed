#ifndef BACKPORT_LINUX_FS_H
#define BACKPORT_LINUX_FS_H

#include_next <linux/fs.h>
#include <linux/mount.h>

#define FILE_LOCK_DEFERRED 1

#define ATTR_KILL_PRIV  (1 << 14)

#ifndef FMODE_EXEC
#define FMODE_EXEC	16
#endif

#define SEEK_SET	0	/* seek relative to beginning of file */
#define SEEK_CUR	1	/* seek relative to current file position */
#define SEEK_END	2	/* seek relative to end of file */

#define i_private u.generic_ip

enum inode_i_mutex_lock_class
{
	I_MUTEX_NORMAL,
	I_MUTEX_PARENT,
	I_MUTEX_CHILD,
	I_MUTEX_XATTR,
	I_MUTEX_QUOTA
};

struct lock_manager {
	struct list_head list;
};

void locks_start_grace(struct lock_manager *);
void locks_end_grace(struct lock_manager *);
int locks_in_grace(void);

static inline bool execute_ok(struct inode *inode)
{
	return (inode->i_mode & S_IXUGO) || S_ISDIR(inode->i_mode);
}

static inline int current_umask(void)
{
	return current->fs->umask;
}

#define __locks_copy_lock locks_copy_lock

static inline int __mandatory_lock(struct inode *ino)
{
	return (ino->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID;
}

#define mandatory_lock(_args) MANDATORY_LOCK(_args)

#ifdef CONFIG_DEBUG_WRITECOUNT
static inline void file_take_write(struct file *f)
{
	WARN_ON(f->f_mnt_write_state != 0);
	f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
}
#else
static inline void file_take_write(struct file *filp) {}
#endif

static inline int inode_permission(struct inode *inode, int flags)
{
	return permission(inode, flags, NULL);
}

static inline int __mnt_is_readonly(struct vfsmount *mnt)
{
	if (mnt->mnt_sb->s_flags & MS_RDONLY)
		return 1;
	return 0;
}

static inline void inc_nlink(struct inode *inode)
{
	inode->i_nlink++;
}

static inline void drop_nlink(struct inode *inode)
{
	inode->i_nlink--;
}

static inline void clear_nlink(struct inode *inode)
{
	inode->i_nlink = 0;
}

static inline void free_fs_struct(struct fs_struct *fs)
{
	struct task_struct *tsk;

	tsk = kzalloc(sizeof(struct task_struct), GFP_KERNEL);
	if (!tsk)
		return;

	spin_lock_init(&tsk->alloc_lock);
	tsk->fs = fs;

	exit_fs(tsk);
	kfree(tsk);
}

static inline int unshare_fs_struct(void)
{
	struct fs_struct *fs = current->fs;
	struct fs_struct *new_fs = copy_fs_struct(fs);
	int kill;

	if (!new_fs)
		return -ENOMEM;

	task_lock(current);
	write_lock(&fs->lock);
	kill = atomic_read(&fs->count) == 1;
	current->fs = new_fs;
	write_unlock(&fs->lock);
	task_unlock(current);

	if (kill)
		free_fs_struct(fs);

	return 0;
}

static inline void deactivate_locked_super(struct super_block *s)
{
	up_write(&s->s_umount);
	deactivate_super(s);
}

#endif
