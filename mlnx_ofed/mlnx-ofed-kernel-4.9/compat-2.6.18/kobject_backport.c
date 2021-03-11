#include <linux/slab.h>
#include <linux/kobject.h>
#include <linux/module.h>

struct kobj_attribute {
	struct attribute attr;
	ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,
			char *buf);
	ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
			 const char *buf, size_t count);
};

/* default kobject attribute operations */
static ssize_t kobj_attr_show(struct kobject *kobj, struct attribute *attr,
			      char *buf)
{
	struct kobj_attribute *kattr;
	ssize_t ret = -EIO;

	kattr = container_of(attr, struct kobj_attribute, attr);
	if (kattr->show)
		ret = kattr->show(kobj, kattr, buf);
	return ret;
}

static ssize_t kobj_attr_store(struct kobject *kobj, struct attribute *attr,
			       const char *buf, size_t count)
{
	struct kobj_attribute *kattr;
	ssize_t ret = -EIO;

	kattr = container_of(attr, struct kobj_attribute, attr);
	if (kattr->store)
		ret = kattr->store(kobj, kattr, buf, count);
	return ret;
}

static struct sysfs_ops kobj_sysfs_ops = {
	.show   = kobj_attr_show,
	.store  = kobj_attr_store,
};

static void dynamic_kobj_release(struct kobject *kobj)
{
	pr_debug("kobject: (%p): %s\n", kobj, __FUNCTION__);
	kfree(kobj);
}

static struct kobj_type dynamic_kobj_ktype = {
	.release        = dynamic_kobj_release,
	.sysfs_ops      = &kobj_sysfs_ops,
};

/**
 * kobject_create_and_add - create a struct kobject dynamically and register it with sysfs
 *
 * @name: the name for the kset
 * @parent: the parent kobject of this kobject, if any.
 *
 * This function creates a kobject structure dynamically and registers it
 * with sysfs.  When you are finished with this structure, call
 * kobject_put() and the structure will be dynamically freed when
 * it is no longer being used.
 *
 * If the kobject was not able to be created, NULL will be returned.
 */
#define kobject_create_and_add LINUX_BACKPORT(kobject_create_and_add)
struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
{
	struct kobject *kobj;
	int retval;

	kobj = kzalloc(sizeof(*kobj), GFP_KERNEL);
	if (!kobj)
		return NULL;

	kobject_init(kobj);
	kobj->ktype = &dynamic_kobj_ktype;
	kobj->parent = parent;

	retval = kobject_set_name(kobj, "%s", name);
	if (retval) {
		printk(KERN_WARNING "%s: kobject_set_name error: %d\n",
			__FUNCTION__, retval);
		goto err;
	}

	retval = kobject_add(kobj);
	if (retval) {
		printk(KERN_WARNING "%s: kobject_add error: %d\n",
			__FUNCTION__, retval);
		goto err;
	}

	return kobj;

err:
	kobject_put(kobj);
	return NULL;
}
EXPORT_SYMBOL(kobject_create_and_add);

/**
 * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
 * @kobj: pointer to the kobject to initialize
 * @ktype: pointer to the ktype for this kobject.
 * @parent: pointer to the parent of this kobject.
 * @fmt: the name of the kobject.
 *
 * This function combines the call to kobject_init() and
 * kobject_add().  The same type of error handling after a call to
 * kobject_add() and kobject lifetime rules are the same here.
 */
#define kobject_init_and_add LINUX_BACKPORT(kobject_init_and_add)
int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
                         struct kobject *parent, const char *fmt, ...)
{
	int retval;
	int limit;
	int need;
	va_list args;
	char *name;

	/* find out how big a buffer we need */
	name = kmalloc(1024, GFP_KERNEL);
	if (!name) {
		retval = -ENOMEM;
		goto out;
	}
	va_start(args, fmt);
	need = vsnprintf(name, 1024, fmt, args);
	va_end(args);
	kfree(name);

	/* Allocate the new space and copy the string in */
	limit = need + 1;
	name = kmalloc(limit, GFP_KERNEL);
	if (!name) {
		retval = -ENOMEM;
		goto out;
	}

	va_start(args, fmt);
	need = vsnprintf(name, limit, fmt, args);
	va_end(args);

	kobject_init(kobj);

	kobj->ktype = ktype;
	kobj->parent = parent;

	retval = kobject_set_name(kobj, name);
	kfree(name);
	if (retval)
		goto out;

	retval = kobject_add(kobj);
	if (retval)
		goto out;

out:
	return retval;
}
EXPORT_SYMBOL(kobject_init_and_add);
