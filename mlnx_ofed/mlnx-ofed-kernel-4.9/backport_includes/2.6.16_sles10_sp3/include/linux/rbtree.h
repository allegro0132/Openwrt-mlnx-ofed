#ifndef LINUX_RBTREE_H_BACKPORT
#define LINUX_RBTREE_H_BACKPORT

#include_next <linux/rbtree.h>

static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
{
	rb->rb_parent = p;
}

#define rb_parent(r)           ((r)->rb_parent)

#define RB_EMPTY_ROOT(root)    ((root)->rb_node == NULL)
#define RB_EMPTY_NODE(node)    (rb_parent(node) == node)
#define RB_CLEAR_NODE(node)    (rb_set_parent(node, node))

#endif
