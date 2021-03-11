/*
 * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Compatibility file for Linux wireless for kernels 2.6.28.
 */

#include <linux/compat.h>
#include <linux/tty.h>
#include <asm/poll.h>

/* 2.6.28 compat code goes here */

#define pci_ioremap_bar LINUX_BACKPORT(pci_ioremap_bar)
void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
{
	/*
	 * Make sure the BAR is actually a memory resource, not an IO resource
	 */
	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
		WARN_ON(1);
		return NULL;
	}
	return ioremap_nocache(pci_resource_start(pdev, bar),
				     pci_resource_len(pdev, bar));
}
EXPORT_SYMBOL_GPL(pci_ioremap_bar);

static unsigned long round_jiffies_common(unsigned long j, int cpu,
		bool force_up)
{
	int rem;
	unsigned long original = j;

	/*
	 * We don't want all cpus firing their timers at once hitting the
	 * same lock or cachelines, so we skew each extra cpu with an extra
	 * 3 jiffies. This 3 jiffies came originally from the mm/ code which
	 * already did this.
	 * The skew is done by adding 3*cpunr, then round, then subtract this
	 * extra offset again.
	 */
	j += cpu * 3;

	rem = j % HZ;

	/*
	 * If the target jiffie is just after a whole second (which can happen
	 * due to delays of the timer irq, long irq off times etc etc) then
	 * we should round down to the whole second, not up. Use 1/4th second
	 * as cutoff for this rounding as an extreme upper bound for this.
	 * But never round down if @force_up is set.
	 */
	if (rem < HZ/4 && !force_up) /* round down */
		j = j - rem;
	else /* round up */
		j = j - rem + HZ;

	/* now that we have rounded, subtract the extra skew again */
	j -= cpu * 3;

	if (j <= jiffies) /* rounding ate our timeout entirely; */
		return original;
	return j;
}

/**
 * round_jiffies_up - function to round jiffies up to a full second
 * @j: the time in (absolute) jiffies that should be rounded
 *
 * This is the same as round_jiffies() except that it will never
 * round down.  This is useful for timeouts for which the exact time
 * of firing does not matter too much, as long as they don't fire too
 * early.
 */
#define round_jiffies_up LINUX_BACKPORT(round_jiffies_up)
unsigned long round_jiffies_up(unsigned long j)
{
	return round_jiffies_common(j, raw_smp_processor_id(), true);
}
EXPORT_SYMBOL_GPL(round_jiffies_up);

#define v2_6_28_skb_add_rx_frag LINUX_BACKPORT(v2_6_28_skb_add_rx_frag)
void v2_6_28_skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
		int size)
{
	skb_fill_page_desc(skb, i, page, off, size);
	skb->len += size;
	skb->data_len += size;
	skb->truesize += size;
}
EXPORT_SYMBOL_GPL(v2_6_28_skb_add_rx_frag);

void tty_write_unlock(struct tty_struct *tty)
{
	mutex_unlock(&tty->atomic_write_lock);
	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
}

int tty_write_lock(struct tty_struct *tty, int ndelay)
{
	if (!mutex_trylock(&tty->atomic_write_lock)) {
		if (ndelay)
			return -EAGAIN;
		if (mutex_lock_interruptible(&tty->atomic_write_lock))
			return -ERESTARTSYS;
	}
	return 0;
}

/**
 *	send_prio_char		-	send priority character
 *
 *	Send a high priority character to the tty even if stopped
 *
 *	Locking: none for xchar method, write ordering for write method.
 */

static int send_prio_char(struct tty_struct *tty, char ch)
{
	int	was_stopped = tty->stopped;

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
	if (tty->ops->send_xchar) {
		tty->ops->send_xchar(tty, ch);
#else
	if (tty->driver->send_xchar) {
		tty->driver->send_xchar(tty, ch);
#endif
		return 0;
	}

	if (tty_write_lock(tty, 0) < 0)
		return -ERESTARTSYS;

	if (was_stopped)
		start_tty(tty);
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
	tty->ops->write(tty, &ch, 1);
#else
	tty->driver->write(tty, &ch, 1);
#endif
	if (was_stopped)
		stop_tty(tty);
	tty_write_unlock(tty);
	return 0;
}

#define n_tty_ioctl_helper LINUX_BACKPORT(n_tty_ioctl_helper)
int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
		       unsigned int cmd, unsigned long arg)
{
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
	unsigned long flags;
#endif
	int retval;

	switch (cmd) {
	case TCXONC:
		retval = tty_check_change(tty);
		if (retval)
			return retval;
		switch (arg) {
		case TCOOFF:
			if (!tty->flow_stopped) {
				tty->flow_stopped = 1;
				stop_tty(tty);
			}
			break;
		case TCOON:
			if (tty->flow_stopped) {
				tty->flow_stopped = 0;
				start_tty(tty);
			}
			break;
		case TCIOFF:
			if (STOP_CHAR(tty) != __DISABLED_CHAR)
				return send_prio_char(tty, STOP_CHAR(tty));
			break;
		case TCION:
			if (START_CHAR(tty) != __DISABLED_CHAR)
				return send_prio_char(tty, START_CHAR(tty));
			break;
		default:
			return -EINVAL;
		}
		return 0;
	case TCFLSH:
		return tty_perform_flush(tty, arg);
	case TIOCPKT:
	{
		int pktmode;

		if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
		    tty->driver->subtype != PTY_TYPE_MASTER)
			return -ENOTTY;
		if (get_user(pktmode, (int __user *) arg))
			return -EFAULT;
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
		spin_lock_irqsave(&tty->ctrl_lock, flags);
#endif
		if (pktmode) {
			if (!tty->packet) {
				tty->packet = 1;
				tty->link->ctrl_status = 0;
			}
		} else
			tty->packet = 0;
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
#endif
		return 0;
	}
	default:
		/* Try the mode commands */
		return tty_mode_ioctl(tty, file, cmd, arg);
	}
}
EXPORT_SYMBOL_GPL(n_tty_ioctl_helper);

/**
 * pci_wake_from_d3 - enable/disable device to wake up from D3_hot or D3_cold
 * @dev: PCI device to prepare
 * @enable: True to enable wake-up event generation; false to disable
 *
 * Many drivers want the device to wake up the system from D3_hot or D3_cold
 * and this function allows them to set that up cleanly - pci_enable_wake()
 * should not be called twice in a row to enable wake-up due to PCI PM vs ACPI
 * ordering constraints.
 *
 * This function only returns error code if the device is not capable of
 * generating PME# from both D3_hot and D3_cold, and the platform is unable to
 * enable wake-up power for it.
 */
#define pci_wake_from_d3 LINUX_BACKPORT(pci_wake_from_d3)
int pci_wake_from_d3(struct pci_dev *dev, bool enable)
{
	return pci_pme_capable(dev, PCI_D3cold) ?
			pci_enable_wake(dev, PCI_D3cold, enable) :
			pci_enable_wake(dev, PCI_D3hot, enable);
}
EXPORT_SYMBOL_GPL(pci_wake_from_d3);

