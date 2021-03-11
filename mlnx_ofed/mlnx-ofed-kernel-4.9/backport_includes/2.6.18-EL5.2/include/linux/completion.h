#ifndef BACKPORT_LINUX_COMPLETION_H
#define BACKPORT_LINUX_COMPLETION_H

#include_next <linux/completion.h>

#define wait_for_completion_killable(_args) wait_for_completion_interruptible(_args)

#endif /* BACKPORT_LINUX_COMPLETION_H */
