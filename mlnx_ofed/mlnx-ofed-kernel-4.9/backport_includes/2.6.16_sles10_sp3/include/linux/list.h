#ifndef _BACKPORT_LINUX_LIST_H
#define _BACKPORT_LINUX_LIST_H

#include_next <linux/list.h>

/* list_first_entry - get the first element from a list
 * @ptr:       the list head to take the element from.
 * @type:      the type of the struct this is embedded in.
 * @member:    the name of the list_struct within the struct.
 *
 * Note, that list is expected to be not empty.
 */
#define list_first_entry(ptr, type, member) \
	list_entry((ptr)->next, type, member)

static inline void list_replace(struct list_head *old,
				struct list_head *new)
{
	new->next = old->next;
	new->next->prev = new;
	new->prev = old->prev;
	new->prev->next = new;
}

static inline void list_replace_init(struct list_head *old,
					struct list_head *new)
{
	list_replace(old, new);
	INIT_LIST_HEAD(old);
}

#endif  /* _BACKPORT_LINUX_LIST_H */
