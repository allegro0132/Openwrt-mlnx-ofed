/*
 * Copyright 2012    Luis R. Rodriguez <mcgrof@do-not-panic.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux wireless for kernels 2.6.34.
 */

#include <linux/pci.h>
#include <linux/export.h>

#define pci_vpd_find_tag LINUX_BACKPORT(pci_vpd_find_tag)
int pci_vpd_find_tag(const u8 *buf, unsigned int off, unsigned int len, u8 rdt)
{
	int i;

	for (i = off; i < len; ) {
		u8 val = buf[i];

		if (val & PCI_VPD_LRDT) {
			/* Don't return success of the tag isn't complete */
			if (i + PCI_VPD_LRDT_TAG_SIZE > len)
				break;

			if (val == rdt)
				return i;

			i += PCI_VPD_LRDT_TAG_SIZE +
			     pci_vpd_lrdt_size(&buf[i]);
		} else {
			u8 tag = val & ~PCI_VPD_SRDT_LEN_MASK;

			if (tag == rdt)
				return i;

			if (tag == PCI_VPD_SRDT_END)
				break;

			i += PCI_VPD_SRDT_TAG_SIZE +
			     pci_vpd_srdt_size(&buf[i]);
		}
	}

	return -ENOENT;
}
EXPORT_SYMBOL_GPL(pci_vpd_find_tag);

#define pci_vpd_find_info_keyword LINUX_BACKPORT(pci_vpd_find_info_keyword)
int pci_vpd_find_info_keyword(const u8 *buf, unsigned int off,
			      unsigned int len, const char *kw)
{
	int i;

	for (i = off; i + PCI_VPD_INFO_FLD_HDR_SIZE <= off + len;) {
		if (buf[i + 0] == kw[0] &&
		    buf[i + 1] == kw[1])
			return i;

		i += PCI_VPD_INFO_FLD_HDR_SIZE +
		     pci_vpd_info_field_size(&buf[i]);
	}

	return -ENOENT;
}
EXPORT_SYMBOL_GPL(pci_vpd_find_info_keyword);

#ifndef HAVE_PCI_NUM_VF
#define pci_num_vf LINUX_BACKPORT(pci_num_vf)
int pci_num_vf(struct pci_dev *pdev)
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
	while (dev) {
		if (dev->is_virtfn && pci_physfn(dev) == pdev) {
			vfs++;
		}
		dev = pci_get_device(pdev->vendor, PCI_ANY_ID, dev);
	}
	return vfs;
}
EXPORT_SYMBOL_GPL(pci_num_vf);
#endif
