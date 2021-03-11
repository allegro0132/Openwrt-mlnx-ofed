#include <linux/spinlock_types.h>
#include <linux/percpu.h>
#include <linux/mount.h>
#include <linux/module.h>

struct mnt_writer {
	/*
	 * If holding multiple instances of this lock, they
	 * must be ordered by cpu number.
	 */
	spinlock_t lock;
	struct lock_class_key lock_class; /* compiles out with !lockdep */
	unsigned long count;
	struct vfsmount *mnt;
} ____cacheline_aligned_in_smp;
static DEFINE_PER_CPU(struct mnt_writer, mnt_writers);

int __init init_mnt_writers(void)
{
	int cpu;
	for_each_possible_cpu(cpu) {
		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
		spin_lock_init(&writer->lock);
		lockdep_set_class(&writer->lock, &writer->lock_class);
		writer->count = 0;
	}
	return 0;
}

static inline void __clear_mnt_count(struct mnt_writer *cpu_writer)
{
	if (!cpu_writer->mnt)
		return;
	/*
	 * This is in case anyone ever leaves an invalid,
	 * old ->mnt and a count of 0.
	 */
	if (!cpu_writer->count)
		return;
	cpu_writer->count = 0;
}

static inline void use_cpu_writer_for_mount(struct mnt_writer *cpu_writer,
					  struct vfsmount *mnt)
{
	if (cpu_writer->mnt == mnt)
		return;
	__clear_mnt_count(cpu_writer);
	cpu_writer->mnt = mnt;
}

int mnt_want_write(struct vfsmount *mnt)
{
	int ret = 0;
	struct mnt_writer *cpu_writer;

	cpu_writer = &get_cpu_var(mnt_writers);
	spin_lock(&cpu_writer->lock);
	if (__mnt_is_readonly(mnt)) {
		ret = -EROFS;
		goto out;
	}
	use_cpu_writer_for_mount(cpu_writer, mnt);
	cpu_writer->count++;
out:
	spin_unlock(&cpu_writer->lock);
	put_cpu_var(mnt_writers);
	return ret;
}
EXPORT_SYMBOL(mnt_want_write);

void mnt_drop_write(struct vfsmount *mnt)
{
	struct mnt_writer *cpu_writer;

	cpu_writer = &get_cpu_var(mnt_writers);
	spin_lock(&cpu_writer->lock);

	use_cpu_writer_for_mount(cpu_writer, mnt);
	if (cpu_writer->count > 0) {
		cpu_writer->count--;
	}

	spin_unlock(&cpu_writer->lock);
	/*
	 * This could be done right after the spinlock
	 * is taken because the spinlock keeps us on
	 * the cpu, and disables preemption.  However,
	 * putting it here bounds the amount that
	 * __mnt_writers can underflow.  Without it,
	 * we could theoretically wrap __mnt_writers.
	 */
	put_cpu_var(mnt_writers);
}
EXPORT_SYMBOL(mnt_drop_write);
