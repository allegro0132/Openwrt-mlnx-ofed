#if !defined(HAVE___GET_TASK_COMM_EXPORTED) && !defined(HAVE_GET_TASK_COMM_EXPORTED)

#include <linux/sched.h>
#include <linux/sched/task.h>

char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
{
	task_lock(tsk);
	strncpy(buf, tsk->comm, buf_size);
	task_unlock(tsk);
	return buf;
}
EXPORT_SYMBOL_GPL(__get_task_comm);

#endif
