#ifndef _BACKPORT_ASM_GENERIC_BUG_H
#define _BACKPORT_ASM_GENERIC_BUG_H

#include_next <asm-generic/bug.h>

#ifdef CONFIG_BUG
#define WARN_ON_2(condition) ({                                 \
        typeof(condition) __ret_warn_on = (condition);          \
        if (unlikely(__ret_warn_on)) {                          \
                printk("BUG: at %s:%d %s()\n", __FILE__,        \
                        __LINE__, __FUNCTION__);                \
                dump_stack();                                   \
        }                                                       \
        unlikely(__ret_warn_on);                                \
})

#else /* !CONFIG_BUG */

#define WARN_ON_2(condition) ({                                 \
        typeof(condition) __ret_warn_on = (condition);          \
        unlikely(__ret_warn_on);                                \
})
#endif

#endif
