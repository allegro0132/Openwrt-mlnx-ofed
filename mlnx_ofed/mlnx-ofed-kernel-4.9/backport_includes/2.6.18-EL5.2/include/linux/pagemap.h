#ifndef BACKPORT_LINUX_PAGEMAP_H
#define BACKPORT_LINUX_PAGEMAP_H

#include_next <linux/pagemap.h>

#define __grab_cache_page	grab_cache_page

#endif
