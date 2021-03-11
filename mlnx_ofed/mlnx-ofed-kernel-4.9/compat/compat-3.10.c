#include <linux/pci.h>
#include <linux/export.h>

#ifndef HAVE_PCI_VFS_ASSIGNED
#define pci_vfs_assigned LINUX_BACKPORT(pci_vfs_assigned)
int pci_vfs_assigned(struct pci_dev *pdev)
{
	struct pci_dev *dev;
	int vfs = 0, pos;
	u16 offset, stride;

#ifndef HAVE_PCI_PHYSFN
	if (!pdev->is_physfn)
		return 0;
#endif

	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
	if (!pos)
		return 0;
	pci_read_config_word(pdev, pos + PCI_SRIOV_VF_OFFSET, &offset);
	pci_read_config_word(pdev, pos + PCI_SRIOV_VF_STRIDE, &stride);

	dev = pci_get_device(pdev->vendor, PCI_ANY_ID, NULL);
#ifdef HAVE_PCI_DEV_FLAGS_ASSIGNED
	while (dev) {
		if (dev->is_virtfn && pci_physfn(dev) == pdev &&
			(dev->dev_flags & PCI_DEV_FLAGS_ASSIGNED))
			vfs++;
		dev = pci_get_device(pdev->vendor, PCI_ANY_ID, dev);
	}
#endif
	return vfs;
}
EXPORT_SYMBOL_GPL(pci_vfs_assigned);
#endif /* HAVE_PCI_VFS_ASSIGNED */
