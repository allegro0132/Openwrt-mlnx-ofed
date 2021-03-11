#ifndef __BACKPORT_LINUX_LIST_H_TO_2_6_24__
#define __BACKPORT_LINUX_LIST_H_TO_2_6_24__
#include_next<linux/list.h>

#define list_first_entry(ptr, type, member) \
	list_entry((ptr)->next, type, member)


#endif
