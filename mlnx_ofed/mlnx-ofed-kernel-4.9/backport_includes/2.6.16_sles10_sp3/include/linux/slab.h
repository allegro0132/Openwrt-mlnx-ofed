#include_next <linux/slab.h>

#include_next <linux/slab.h>

#ifndef BACKPORT_LINUX_STRING_TO_2_6_18
#define BACKPORT_LINUX_STRING_TO_2_6_18

static inline
void *kmemdup(const void *src, size_t len, gfp_t gfp)
{
       void *p;

       p = kmalloc(len, gfp);
       if (p)
               memcpy(p, src, len);
       return p;
}

#endif
#ifndef BACKPORT_LINUX_STRING_TO_2_6_18
#define BACKPORT_LINUX_STRING_TO_2_6_18

static inline
void *kmemdup(const void *src, size_t len, gfp_t gfp)
{
       void *p;

       p = kmalloc(len, gfp);
       if (p)
               memcpy(p, src, len);
       return p;
}

#endif
#ifndef LINUX_SLAB_BACKPORT_tO_2_6_22_H
#define LINUX_SLAB_BACKPORT_tO_2_6_22_H

#include_next <linux/slab.h>

static inline
struct kmem_cache *
kmem_cache_create_for_2_6_22 (const char *name, size_t size, size_t align,
			      unsigned long flags,
			      void (*ctor)(void*, struct kmem_cache *, unsigned long)
			      )
{
	return kmem_cache_create(name, size, align, flags, ctor, NULL);
}

#define kmem_cache_create kmem_cache_create_for_2_6_22

#endif
#ifndef SLAB_H_KMEMCACHE_ZALLOC_BACKPORT_TO_2_6_16
#define SLAB_H_KMEMCACHE_ZALLOC_BACKPORT_TO_2_6_16

static inline
void *kmem_cache_zalloc(struct kmem_cache *cache, gfp_t flags)
{
       void *ret = kmem_cache_alloc(cache, flags);
       if (ret)
	       memset(ret, 0, kmem_cache_size(cache));

       return ret;
}

static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
{
	void *ptr = kmalloc_node(size, flags, node);
	if (ptr)
		memset(ptr, 0, size);
	return ptr;
}


#endif

