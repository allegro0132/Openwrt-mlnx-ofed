#ifndef SCSI_SCSI_CMND_BACKPORT_TO_2_6_22_H
#define SCSI_SCSI_CMND_BACKPORT_TO_2_6_22_H

#include_next <scsi/scsi_cmnd.h>

#define scsi_sg_count(cmd) ((cmd)->use_sg)
#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
#define scsi_bufflen(cmd) ((cmd)->request_bufflen)

/*static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
{
	cmd->resid = resid;
}

static inline int scsi_get_resid(struct scsi_cmnd *cmd)
{
	return cmd->resid;
}*/

#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
	for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)

#endif
