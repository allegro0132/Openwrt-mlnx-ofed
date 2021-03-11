#include <linux/jhash.h>
#include <net/ip.h>

static u32 skb_tx_hashrnd;
/*
 * Returns a Tx hash based on the given packet descriptor a Tx queues' number
 * to be used as a distribution range.
 */
#define __skb_tx_hash LINUX_BACKPORT(__skb_tx_hash)
u16 __skb_tx_hash(const struct net_device *dev, const struct sk_buff *skb)
{
#ifdef HAVE_ALLOC_ETHERDEV_MQ
	u32 hash;

	if (skb_rx_queue_recorded(skb)) {
		hash = skb_get_rx_queue(skb);
		while (unlikely(hash >= dev->real_num_tx_queues))
			hash -= dev->real_num_tx_queues;
		return hash;
	}

	if (skb->sk && skb->sk->sk_hash)
		hash = skb->sk->sk_hash;
	else
		hash = skb->protocol;

	hash = jhash_1word(hash, skb_tx_hashrnd);

	return (u16)(((u64)hash * dev->real_num_tx_queues) >> 32);
#else
	return 0;
#endif
}
EXPORT_SYMBOL(__skb_tx_hash);
