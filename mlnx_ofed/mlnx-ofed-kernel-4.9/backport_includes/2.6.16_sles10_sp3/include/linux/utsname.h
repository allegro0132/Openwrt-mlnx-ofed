#ifndef _UTSNAME_BACKPORT_H
#define _UTSNAME_BACKPORT_H

#include_next <linux/utsname.h>

static inline struct new_utsname *init_utsname(void)
{
        return &system_utsname;
}

#endif /* _UTSNAME_BACKPORT_H */
