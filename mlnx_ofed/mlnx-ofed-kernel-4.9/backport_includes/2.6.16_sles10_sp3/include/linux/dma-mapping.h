#ifndef _DMA_MAPPING_BACKPORT_H
#define _DMA_MAPPING_BACKPORT_H

#include_next <linux/dma-mapping.h>

#ifndef CONFIG_XEN
static inline int valid_dma_direction(int dma_direction)
{
	return ((dma_direction == DMA_BIDIRECTIONAL) ||
		(dma_direction == DMA_TO_DEVICE) ||
		(dma_direction == DMA_FROM_DEVICE));
}
#endif

#define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))

#ifndef CONFIG_HAVE_DMA_ATTRS
struct dma_attrs;

#define dma_map_single_attrs(dev, cpu_addr, size, dir, attrs) \
	dma_map_single(dev, cpu_addr, size, dir)

#define dma_map_sg_attrs(dev, sgl, nents, dir, attrs) \
	dma_map_sg(dev, sgl, nents, dir)

#if defined(CONFIG_PPC32) || defined(CONFIG_PPC64)

static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t daddr,
					  size_t size,
					  enum dma_data_direction dir,
					  struct dma_attrs *attrs)
{
}

static inline void dma_unmap_sg_attrs(struct device *dev,
				      struct scatterlist *sgl, int nents,
				      enum dma_data_direction dir,
				      struct dma_attrs *attrs)
{
}

#else /* CONFIG_PPC32 or CONFIG_PPC64 */

#define dma_unmap_single_attrs(dev, dma_addr, size, dir, attrs) \
	dma_unmap_single(dev, dma_addr, size, dir)

#define dma_unmap_sg_attrs(dev, sgl, nents, dir, attrs) \
	dma_unmap_sg(dev, sgl, nents, dir)

#endif /* CONFIG_PPC32 or CONFIG_PPC64 */

#endif /* CONFIG_HAVE_DMA_ATTRS */

#endif
