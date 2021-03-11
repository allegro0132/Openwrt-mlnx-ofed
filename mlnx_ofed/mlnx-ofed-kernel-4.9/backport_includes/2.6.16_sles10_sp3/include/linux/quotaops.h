#ifndef BACKPORT_LINUX_QUOTAOPS_H
#define BACKPORT_LINUX_QUOTAOPS_H

#include_next <linux/quotaops.h>

/* Quota state flags - they actually come in two flavors - for users and groups */
enum {
	_DQUOT_USAGE_ENABLED = 0,	/* Track disk usage for users */
	_DQUOT_LIMITS_ENABLED,		/* Enforce quota limits for users */
	_DQUOT_SUSPENDED,		/* User diskquotas are off, but
					 * we have necessary info in
					 * memory to turn them on */
	_DQUOT_STATE_FLAGS
};

#define DQUOT_USAGE_ENABLED	(1 << _DQUOT_USAGE_ENABLED)
#define DQUOT_LIMITS_ENABLED	(1 << _DQUOT_LIMITS_ENABLED)
#define DQUOT_SUSPENDED		(1 << _DQUOT_SUSPENDED)

static inline unsigned int dquot_state_flag(unsigned int flags, int type)
{
	if (type == USRQUOTA)
		return flags;
	return flags << _DQUOT_STATE_FLAGS;
}

static inline int sb_has_quota_usage_enabled(struct super_block *sb, int type)
{
	return sb_dqopt(sb)->flags &
				dquot_state_flag(DQUOT_USAGE_ENABLED, type);
}

static inline int sb_has_quota_limits_enabled(struct super_block *sb, int type)
{
	return sb_dqopt(sb)->flags &
				dquot_state_flag(DQUOT_LIMITS_ENABLED, type);
}

static inline int sb_has_quota_suspended(struct super_block *sb, int type)
{
	return sb_dqopt(sb)->flags &
				dquot_state_flag(DQUOT_SUSPENDED, type);
}

static inline int sb_has_quota_loaded(struct super_block *sb, int type)
{
	/* Currently if anything is on, then quota usage is on as well */
	return sb_has_quota_usage_enabled(sb, type);
}

static inline int sb_has_quota_active(struct super_block *sb, int type)
{
	return sb_has_quota_loaded(sb, type) &&
	       !sb_has_quota_suspended(sb, type);
}

static inline int sb_any_quota_active(struct super_block *sb)
{
	return sb_has_quota_active(sb, USRQUOTA) ||
	       sb_has_quota_active(sb, GRPQUOTA);
}

static inline void vfs_dq_init(struct inode *inode)
{
	BUG_ON(!inode->i_sb);
	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode))
		inode->i_sb->dq_op->initialize(inode, -1);
}

#endif /* BACKPORT_LINUX_QUOTAOPS_H */
