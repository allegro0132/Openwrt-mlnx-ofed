#ifndef SCSI_SCSI_TRANSPORT_ISCSI_H_BACKPORT
#define SCSI_SCSI_TRANSPORT_ISCSI_H_BACKPORT

#undef nlmsg_hdr
#undef kernel_getsockname
#undef kernel_getpeername
#undef sg_set_page
#undef sg_page
#undef sg_next
#undef sg_init_table
#define kernel_getsockname static kernel_getsockname
#define kernel_getpeername static kernel_getpeername

#include_next <scsi/scsi_transport_iscsi.h>

#define nlmsg_hdr nlmsg_hdr2
#undef kernel_getsockname
#undef kernel_getpeername
#define kernel_getsockname kernel_getsockname2
#define kernel_getpeername kernel_getpeername2
#define sg_set_page sg_set_page2
#undef sg_page
#define sg_page(a) (a)->page
#define sg_next sg_next2
#undef sg_init_table
#define sg_init_table(a, b)

#endif
