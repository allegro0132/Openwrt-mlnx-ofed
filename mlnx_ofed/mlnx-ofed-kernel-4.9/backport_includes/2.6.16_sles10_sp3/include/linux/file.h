#ifndef _BACKPORT_LINUX_FILE_H_
#define _BACKPORT_LINUX_FILE_H_

#include_next <linux/file.h>
#include <linux/fs.h>

static inline void drop_file_write_access(struct file *filp)
{
	put_write_access(filp->f_dentry->d_inode);
}

#endif
