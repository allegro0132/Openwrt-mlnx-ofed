#ifndef BACKPORT_LINUX_PCI_REGS_TO_2_6_18
#define BACKPORT_LINUX_PCI_REGS_TO_2_6_18

#include_next <linux/pci_regs.h>

#define PCI_CAP_ID_HT PCI_CAP_ID_HT_IRQCONF

#endif
