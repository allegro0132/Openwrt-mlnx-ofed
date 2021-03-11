/* Kernel thread helper functions.
 *   Copyright (C) 2004 IBM Corporation, Rusty Russell.
 *
 * Creation is done via kthreadd, so that we get a clean environment
 * even if we're invoked from userspace (think modprobe, hotplug cpu,
 * etc.).
 */
#ifndef HAVE_KTHREAD_WORK

#include <linux/sched.h>
#include <linux/kthread.h>
#include <linux/completion.h>
#include <linux/err.h>
#include <linux/cpuset.h>
#include <linux/unistd.h>
#include <linux/file.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/slab.h>
#include <linux/freezer.h>
#include <trace/events/sched.h>

#define __init_kthread_worker LINUX_BACKPORT(__init_kthread_worker)
void __init_kthread_worker(struct kthread_worker *worker,
				const char *name,
				struct lock_class_key *key)
{
	spin_lock_init(&worker->lock);
	lockdep_set_class_and_name(&worker->lock, key, name);
	INIT_LIST_HEAD(&worker->work_list);
	worker->task = NULL;
}
EXPORT_SYMBOL_GPL(__init_kthread_worker);

/**
 * kthread_worker_fn - kthread function to process kthread_worker
 * @worker_ptr: pointer to initialized kthread_worker
 *
 * This function can be used as @threadfn to kthread_create() or
 * kthread_run() with @worker_ptr argument pointing to an initialized
 * kthread_worker.  The started kthread will process work_list until
 * the it is stopped with kthread_stop().  A kthread can also call
 * this function directly after extra initialization.
 *
 * Different kthreads can be used for the same kthread_worker as long
 * as there's only one kthread attached to it at any given time.  A
 * kthread_worker without an attached kthread simply collects queued
 * kthread_works.
 */
#define kthread_worker_fn LINUX_BACKPORT(kthread_worker_fn)
int kthread_worker_fn(void *worker_ptr)
{
	struct kthread_worker *worker = worker_ptr;
	struct kthread_work *work;

	WARN_ON(worker->task);
	worker->task = current;
repeat:
	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */

	if (kthread_should_stop()) {
		__set_current_state(TASK_RUNNING);
		spin_lock_irq(&worker->lock);
		worker->task = NULL;
		spin_unlock_irq(&worker->lock);
		return 0;
	}

	work = NULL;
	spin_lock_irq(&worker->lock);
	if (!list_empty(&worker->work_list)) {
		work = list_first_entry(&worker->work_list,
					struct kthread_work, node);
		list_del_init(&work->node);
	}
	spin_unlock_irq(&worker->lock);

	if (work) {
		__set_current_state(TASK_RUNNING);
		work->func(work);
		smp_wmb();	/* wmb worker-b0 paired with flush-b1 */
		work->done_seq = work->queue_seq;
		smp_mb();	/* mb worker-b1 paired with flush-b0 */
		if (atomic_read(&work->flushing))
			wake_up_all(&work->done);
	} else if (!freezing(current))
		schedule();

	try_to_freeze();
	goto repeat;
}
EXPORT_SYMBOL_GPL(kthread_worker_fn);

/**
 * queue_kthread_work - queue a kthread_work
 * @worker: target kthread_worker
 * @work: kthread_work to queue
 *
 * Queue @work to work processor @task for async execution.  @task
 * must have been created with kthread_worker_create().  Returns %true
 * if @work was successfully queued, %false if it was already pending.
 */
#define queue_kthread_work LINUX_BACKPORT(queue_kthread_work)
bool queue_kthread_work(struct kthread_worker *worker,
			struct kthread_work *work)
{
	bool ret = false;
	unsigned long flags;

	spin_lock_irqsave(&worker->lock, flags);
	if (list_empty(&work->node)) {
		list_add_tail(&work->node, &worker->work_list);
		work->queue_seq++;
		if (likely(worker->task))
			wake_up_process(worker->task);
		ret = true;
	}
	spin_unlock_irqrestore(&worker->lock, flags);
	return ret;
}
EXPORT_SYMBOL_GPL(queue_kthread_work);

/**
 * flush_kthread_work - flush a kthread_work
 * @work: work to flush
 *
 * If @work is queued or executing, wait for it to finish execution.
 */
#define flush_kthread_work LINUX_BACKPORT(flush_kthread_work)
void flush_kthread_work(struct kthread_work *work)
{
	int seq = work->queue_seq;

	atomic_inc(&work->flushing);

	/*
	 * mb flush-b0 paired with worker-b1, to make sure either
	 * worker sees the above increment or we see done_seq update.
	 */
	smp_mb__after_atomic_inc();

	/* A - B <= 0 tests whether B is in front of A regardless of overflow */
	wait_event(work->done, seq - work->done_seq <= 0);
	atomic_dec(&work->flushing);

	/*
	 * rmb flush-b1 paired with worker-b0, to make sure our caller
	 * sees every change made by work->func().
	 */
	smp_mb__after_atomic_dec();
}
EXPORT_SYMBOL_GPL(flush_kthread_work);

struct kthread_flush_work {
	struct kthread_work	work;
	struct completion	done;
};

static void kthread_flush_work_fn(struct kthread_work *work)
{
	struct kthread_flush_work *fwork =
		container_of(work, struct kthread_flush_work, work);
	complete(&fwork->done);
}

/**
 * flush_kthread_worker - flush all current works on a kthread_worker
 * @worker: worker to flush
 *
 * Wait until all currently executing or pending works on @worker are
 * finished.
 */
#define flush_kthread_worker LINUX_BACKPORT(flush_kthread_worker)
void flush_kthread_worker(struct kthread_worker *worker)
{
	struct kthread_flush_work fwork = {
		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
	};

	queue_kthread_work(worker, &fwork.work);
	wait_for_completion(&fwork.done);
}
EXPORT_SYMBOL_GPL(flush_kthread_worker);

#endif /* HAVE_KTHREAD_WORK */
