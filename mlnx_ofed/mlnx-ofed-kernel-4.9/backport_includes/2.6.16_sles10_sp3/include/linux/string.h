#ifndef BACKPORT_LINUX_STRING_H
#define BACKPORT_LINUX_STRING_H

#include_next <linux/string.h>

extern void *__kmalloc(size_t, gfp_t);
extern char *strndup_user(const char __user *, long);

static inline char *kstrndup(const char *s, size_t max, gfp_t gfp)
{
	size_t len;
	char *buf;

	if (!s)
		return NULL;

	len = strnlen(s, max);
	buf = __kmalloc(len+1, gfp);
	if (buf) {
		memcpy(buf, s, len);
		buf[len] = '\0';
	}
	return buf;
}
#endif /* BACKPORT_LINUX_STRING_H */
