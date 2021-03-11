#ifndef BACKPORT_LINUX_CAPABILITY_H
#define BACKPORT_LINUX_CAPABILITY_H

#include_next <linux/capability.h>

/* Override MAC access.
   The base kernel enforces no MAC policy.
   An LSM may enforce a MAC policy, and if it does and it chooses
   to implement capability based overrides of that policy, this is
   the capability it should use to do so. */

#define CAP_MAC_OVERRIDE     32

#define CAP_FS_MASK_B0	(CAP_TO_MASK(CAP_CHOWN)			\
			 | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
			 | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
			 | CAP_TO_MASK(CAP_FOWNER)		\
			 | CAP_TO_MASK(CAP_FSETID))

#define CAP_FS_MASK_B1	(CAP_TO_MASK(CAP_MAC_OVERRIDE))

#define CAP_NFSD_SET	(CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE))
#define CAP_FS_SET	(CAP_FS_MASK_B0)

static inline kernel_cap_t cap_raise_nfsd_set(const kernel_cap_t a,
					      const kernel_cap_t permitted)
{
	const kernel_cap_t __cap_nfsd_set = CAP_NFSD_SET;
	return cap_combine(a,
			   cap_intersect(permitted, __cap_nfsd_set));
}

static inline kernel_cap_t cap_drop_nfsd_set(const kernel_cap_t a)
{
	const kernel_cap_t __cap_fs_set = CAP_NFSD_SET;
	return cap_drop(a, __cap_fs_set);
}

#endif
