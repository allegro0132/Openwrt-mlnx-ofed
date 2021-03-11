#ifndef BACKPORT_LINUX_WAIT_H
#define BACKPORT_LINUX_WAIT_H

#include_next <linux/wait.h>

#define __wait_event_killable(wq, condition, ret)		\
do {								\
	DEFINE_WAIT(__wait);					\
								\
	for (;;) {						\
		prepare_to_wait(&wq, &__wait, TASK_KILLABLE);	\
		if (condition)					\
			break;					\
		if (!fatal_signal_pending(current)) {		\
			schedule();				\
			continue;				\
		}						\
		ret = -ERESTARTSYS;				\
		break;						\
	}							\
	finish_wait(&wq, &__wait);				\
} while (0)

/**
 * wait_event_killable - sleep until a condition gets true
 * @wq: the waitqueue to wait on
 * @condition: a C expression for the event to wait for
 *
 * The process is put to sleep (TASK_KILLABLE) until the
 * @condition evaluates to true or a signal is received.
 * The @condition is checked each time the waitqueue @wq is woken up.
 *
 * wake_up() has to be called after changing any variable that could
 * change the result of the wait condition.
 *
 * The function will return -ERESTARTSYS if it was interrupted by a
 * signal and 0 if @condition evaluated to true.
 */
#define wait_event_killable(wq, condition)			\
({								\
	int __ret = 0;						\
	if (!(condition))					\
		__wait_event_killable(wq, condition, __ret);	\
	__ret;							\
})

#endif
