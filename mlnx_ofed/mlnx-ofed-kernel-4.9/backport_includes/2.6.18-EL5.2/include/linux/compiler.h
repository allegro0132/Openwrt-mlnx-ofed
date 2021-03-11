#ifndef BACKPORT_LINUX_COMPILER_TO_2_6_22_H
#define BACKPORT_LINUX_COMPILER_TO_2_6_22_H

#include_next <linux/compiler.h>

#define uninitialized_var(x) x = x

#ifndef __maybe_unused
# define __maybe_unused         /* unimplemented */
#endif

#endif
