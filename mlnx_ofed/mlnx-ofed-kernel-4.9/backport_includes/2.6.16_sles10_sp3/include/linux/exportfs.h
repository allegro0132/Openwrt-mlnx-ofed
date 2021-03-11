#ifndef BACKPORT_LINUX_EXPORTFS_H
#define BACKPORT_LINUX_EXPORTFS_H

#ifndef LINUX_EXPORTFS_H
#define LINUX_EXPORTFS_H 1

#include <linux/types.h>

struct dentry;
struct inode;
struct super_block;
struct vfsmount;

/*
 * The fileid_type identifies how the file within the filesystem is encoded.
 * In theory this is freely set and parsed by the filesystem, but we try to
 * stick to conventions so we can share some generic code and don't confuse
 * sniffers like ethereal/wireshark.
 *
 * The filesystem must not use the value '0' or '0xff'.
 */
enum fid_type {
	/*
	 * The root, or export point, of the filesystem.
	 * (Never actually passed down to the filesystem.
	 */
	FILEID_ROOT = 0,

	/*
	 * 32bit inode number, 32 bit generation number.
	 */
	FILEID_INO32_GEN = 1,

	/*
	 * 32bit inode number, 32 bit generation number,
	 * 32 bit parent directory inode number.
	 */
	FILEID_INO32_GEN_PARENT = 2,
};

struct fid {
	union {
		struct {
			u32 ino;
			u32 gen;
			u32 parent_ino;
			u32 parent_gen;
		} i32;
		__u32 raw[0];
	};
};

extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
	int *max_len, int connectable);
extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
	int fh_len, int fileid_type, int (*acceptable)(void *, struct dentry *),
	void *context);

#endif /* LINUX_EXPORTFS_H */
#endif /* BACKPORT_LINUX_EXPORTFS_H */
