#ifndef _BACKPORT_LINUX_PAGE_FLAGS_H_
#define _BACKPORT_LINUX_PAGE_FLAGS_H_

#define NR_UNSTABLE_NFS 0

#define inc_zone_page_state(...) inc_page_state(nr_unstable)
#define dec_zone_page_state(...) dec_page_state(nr_unstable)

#endif
