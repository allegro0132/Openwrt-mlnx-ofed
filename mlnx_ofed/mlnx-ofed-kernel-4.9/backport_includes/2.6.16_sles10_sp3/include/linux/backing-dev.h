#ifndef BACKPORT_LINUX_BACK_DEV_H
#define BACKPORT_LINUX_BACK_DEV_H

#include <linux/mm.h>
#include_next <linux/backing-dev.h>
#include <linux/types.h>
#include <linux/kdev_t.h>

struct device;

enum bdi_stat_item {
	BDI_RECLAIMABLE,
	BDI_WRITEBACK,
	NR_BDI_STAT_ITEMS
};


static inline void inc_bdi_stat(struct backing_dev_info *bdi,
		enum bdi_stat_item item)
{
	return;
}

static inline void __dec_bdi_stat(struct backing_dev_info *bdi,
		enum bdi_stat_item item)
{
	return;
}

static inline void dec_bdi_stat(struct backing_dev_info *bdi,
		enum bdi_stat_item item)
{
	return;
}

static inline int bdi_init(struct backing_dev_info *bdi)
{
	return 0;
}

static inline void bdi_destroy(struct backing_dev_info *bdi)
{
	return;
}

static inline int bdi_register(struct backing_dev_info *bdi, struct device *parent,
				const char *fmt, ...)
{
	return 0;
}

static inline int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
{
	return bdi_register(bdi, NULL, "%u:%u", MAJOR(dev), MINOR(dev));
}

static inline void bdi_unregister(struct backing_dev_info *bdi)
{
	return;
}

static inline void clear_bdi_congested(struct backing_dev_info *bdi, int rw)
{
	return;
}

static inline void set_bdi_congested(struct backing_dev_info *bdi, int rw)
{
	return;
}

#endif
