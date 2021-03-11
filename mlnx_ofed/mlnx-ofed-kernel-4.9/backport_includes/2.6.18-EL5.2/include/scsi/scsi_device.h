#ifndef SCSI_SCSI_DEVICE_BACKPORT_TO_2_6_26_H
#define SCSI_SCSI_DEVICE_BACKPORT_TO_2_6_26_H

#include_next <scsi/scsi_device.h>

#define __starget_for_each_device(scsi_target, p, fn) starget_for_each_device(scsi_target, p, fn)

#endif
