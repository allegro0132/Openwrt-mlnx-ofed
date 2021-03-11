#ifndef __BACKPORT_DMA_ATTR_H_TO_2_6_25__
#define __BACKPORT_DMA_ATTR_H_TO_2_6_25__

/**
 * an enum dma_attr represents an attribute associated with a DMA
 * mapping. The semantics of each attribute should be defined in
 * Documentation/DMA-attributes.txt.
 */
enum dma_attr {
	DMA_ATTR_WRITE_BARRIER,
	DMA_ATTR_MAX,
};

#define __DMA_ATTRS_LONGS BITS_TO_LONGS(DMA_ATTR_MAX)

/**
 * struct dma_attrs - an opaque container for DMA attributes
 * @flags - bitmask representing a collection of enum dma_attr
 */
struct dma_attrs {
	unsigned long flags[__DMA_ATTRS_LONGS];
};

#define DEFINE_DMA_ATTRS(x) 					\
	struct dma_attrs x = {					\
		.flags = { [0 ... __DMA_ATTRS_LONGS-1] = 0 },	\
	}

#ifdef CONFIG_HAVE_DMA_ATTRS
/**
 * dma_set_attr - set a specific attribute
 * @attr: attribute to set
 * @attrs: struct dma_attrs (may be NULL)
 */
static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
{
	if (attrs == NULL)
		return;
	BUG_ON(attr >= DMA_ATTR_MAX);
	__set_bit(attr, attrs->flags);
}
#else /* !CONFIG_HAVE_DMA_ATTRS */
static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
{
}
#endif /* CONFIG_HAVE_DMA_ATTRS */
#endif /* __BACKPORT_DMA_ATTR_H_TO_2_6_25__ */
