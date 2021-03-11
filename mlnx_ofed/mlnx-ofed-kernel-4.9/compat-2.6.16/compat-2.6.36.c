/*
 * Copyright 2010    Hauke Mehrtens <hauke@hauke-m.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux wireless for kernels 2.6.36.
 */

#include <linux/compat.h>
#include <linux/export.h>

#define system_wq LINUX_BACKPORT(system_wq)
struct workqueue_struct *system_wq __read_mostly;
#define system_long_wq LINUX_BACKPORT(system_long_wq)
struct workqueue_struct *system_long_wq __read_mostly;
#define system_nrt_wq LINUX_BACKPORT(system_nrt_wq)
struct workqueue_struct *system_nrt_wq __read_mostly;
EXPORT_SYMBOL_GPL(system_wq);
EXPORT_SYMBOL_GPL(system_long_wq);
EXPORT_SYMBOL_GPL(system_nrt_wq);

#define schedule_work LINUX_BACKPORT(schedule_work)
int schedule_work(struct work_struct *work)
{
	return queue_work(system_wq, work);
}
EXPORT_SYMBOL_GPL(schedule_work);

#define schedule_work_on LINUX_BACKPORT(schedule_work_on)
int schedule_work_on(int cpu, struct work_struct *work)
{
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
	return queue_work_on(cpu, system_wq, work);
#else
	return queue_work(system_wq, work);
#endif
}
EXPORT_SYMBOL_GPL(schedule_work_on);

#define flush_scheduled_work LINUX_BACKPORT(flush_scheduled_work)
void flush_scheduled_work(void)
{
	flush_workqueue(system_wq);
}
EXPORT_SYMBOL_GPL(flush_scheduled_work);

int backport_system_workqueue_create()
{
	system_wq = alloc_workqueue("events", 0, 0);
	if (!system_wq)
		return -ENOMEM;

	system_long_wq = alloc_workqueue("events_long", 0, 0);
	if (!system_long_wq)
		goto err1;

	system_nrt_wq = create_singlethread_workqueue("events_nrt");
	if (!system_nrt_wq)
		goto err2;

	return 0;

err2:
	destroy_workqueue(system_long_wq);
err1:
	destroy_workqueue(system_wq);
	return -ENOMEM;
}

void backport_system_workqueue_destroy()
{
	destroy_workqueue(system_nrt_wq);
	destroy_workqueue(system_wq);
	destroy_workqueue(system_long_wq);
}
