#ifndef BACKPORT_LINUX_RBTREE_TO_2_6_18
#define BACKPORT_LINUX_RBTREE_TO_2_6_18
#include_next <linux/rbtree.h>

/* Band-aid for buggy rbtree.h */
#undef RB_EMPTY_NODE
#define RB_EMPTY_NODE(node)	(rb_parent(node) == node)

#endif

