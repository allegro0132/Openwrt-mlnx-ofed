/*
 * 2002-10-18  written by Jim Houston jim.houston@ccur.com
 *	Copyright (C) 2002 by Concurrent Computer Corporation
 *	Distributed under the GNU GPL license version 2.
 *
 * Modified by George Anzinger to reuse immediately and to use
 * find bit instructions.  Also removed _irq on spinlocks.
 *
 * Small id to pointer translation service.
 *
 * It uses a radix tree like structure as a sparse array indexed
 * by the id to obtain the pointer.  The bitmap makes allocating
 * a new id quick.
 *
 * You call it to allocate an id (an int) an associate with that id a
 * pointer or what ever, we treat it as a (void *).  You can pass this
 * id to a user for him to pass back at a later time.  You then pass
 * that id to this code and it returns your pointer.

 * You can release ids at any time. When all ids are released, most of
 * the memory is returned (we keep IDR_FREE_MAX) in a local pool so we
 * don't need to go to the memory "store" during an id allocate, just
 * so you don't need to be too concerned about locking and conflicts
 * with the slab allocator.
 */
#include <linux/module.h>
#include <linux/idr.h>

int idr_for_each(struct idr *idp,
                 int (*fn)(int id, void *p, void *data), void *data)
{
        int n, id, max, error = 0;
        struct idr_layer *p;
        struct idr_layer *pa[MAX_LEVEL];
        struct idr_layer **paa = &pa[0];

        n = idp->layers * IDR_BITS;
        p = idp->top;
        max = 1 << n;

        id = 0;
        while (id < max) {
                while (n > 0 && p) {
                        n -= IDR_BITS;
                        *paa++ = p;
                        p = p->ary[(id >> n) & IDR_MASK];
                }

                if (p) {
                        error = fn(id, (void *)p, data);
                        if (error)
                                break;
                }

                id += 1 << n;
                while (n < fls(id)) {
                        n += IDR_BITS;
                        p = *--paa;
                }
        }

        return error;
}
EXPORT_SYMBOL(idr_for_each);
