#ifdef HAVE_XDP_BUFF

#ifndef HAVE_BPF_PROG_SUB
#include <linux/filter.h>
#include <linux/bpf.h>
void bpf_prog_sub(struct bpf_prog *prog, int i)
{
	/* Only to be used for undoing previous bpf_prog_add() in some
	 * error path. We still know that another entity in our call
	 * path holds a reference to the program, thus atomic_sub() can
	 * be safely used in such cases!
	 */
	WARN_ON(atomic_sub_return(i, &prog->aux->refcnt) == 0);
}
EXPORT_SYMBOL_GPL(bpf_prog_sub);
#endif /* HAVE_BPF_PROG_SUB */

#endif /* HAVE_XDP_BUFF */
