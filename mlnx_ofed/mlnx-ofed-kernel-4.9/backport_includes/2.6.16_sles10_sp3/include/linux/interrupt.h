#ifndef BACKPORT_LINUX_INTERRUPT_TO_2_6_18
#define BACKPORT_LINUX_INTERRUPT_TO_2_6_18
#include_next <linux/interrupt.h>

static inline int 
backport_request_irq(unsigned int irq,
                     irqreturn_t (*handler)(int, void *),
                     unsigned long flags, const char *dev_name, void *dev_id)
{
	return request_irq(irq, 
		           (irqreturn_t (*)(int, void *, struct pt_regs *))handler, 
			   flags, dev_name, dev_id);
}

#define request_irq backport_request_irq

#define IRQF_DISABLED SA_INTERRUPT

typedef irqreturn_t (*irq_handler_t)(int, void *);

#endif
