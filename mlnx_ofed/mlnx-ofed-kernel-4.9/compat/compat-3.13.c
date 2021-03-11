#include <linux/export.h>
#include <linux/pci.h>

/**
 * pcie_get_mps - get PCI Express maximum payload size
 * @dev: PCI device to query
 *
 * Returns maximum payload size in bytes
 */
#define pcie_get_mps LINUX_BACKPORT(pcie_get_mps)
int pcie_get_mps(struct pci_dev *dev)
{
	u16 ctl;

	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &ctl);

	return 128 << ((ctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5);
}
EXPORT_SYMBOL(pcie_get_mps);

#ifdef HAVE_PCI_DEV_PCIE_MPSS
/**
 * pcie_set_mps - set PCI Express maximum payload size
 * @dev: PCI device to query
 * @mps: maximum payload size in bytes
 *    valid values are 128, 256, 512, 1024, 2048, 4096
 *
 * If possible sets maximum payload size
 */
#define pcie_set_mps LINUX_BACKPORT(pcie_set_mps)
int pcie_set_mps(struct pci_dev *dev, int mps)
{
	u16 v;

	if (mps < 128 || mps > 4096 || !is_power_of_2(mps))
		return -EINVAL;

	v = ffs(mps) - 8;
	if (v > dev->pcie_mpss)
		return -EINVAL;
	v <<= 5;

	return pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
						  PCI_EXP_DEVCTL_PAYLOAD, v);
}
EXPORT_SYMBOL(pcie_set_mps);
#endif
