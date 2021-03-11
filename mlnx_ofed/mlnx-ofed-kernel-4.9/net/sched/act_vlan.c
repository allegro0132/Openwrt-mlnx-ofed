/*
 * Copyright (c) 2014 Jiri Pirko <jiri@resnulli.us>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/skbuff.h>
#include <linux/rtnetlink.h>
#include <linux/if_vlan.h>
#include <net/netlink.h>
#include <net/pkt_sched.h>

#include <linux/types.h>
#include <linux/string.h>
#include <linux/errno.h>
#include <linux/gfp.h>
#include <net/net_namespace.h>

#include <net/sch_generic.h>
#include <net/pkt_cls.h>
#include <net/tc_act/tc_gact.h>
#include <net/tc_act/tc_skbedit.h>

#include <linux/tc_act/tc_vlan.h>
#include <net/tc_act/tc_vlan.h>

#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/errno.h>
#include <linux/skbuff.h>
#include <linux/rtnetlink.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/gfp.h>
#include <net/net_namespace.h>
#include <net/netlink.h>
#include <net/pkt_sched.h>

#include <linux/if_arp.h>
#define VLAN_TAB_MASK     7

static struct tcf_common *tcf_vlan_ht[VLAN_TAB_MASK + 1];
static u32 vlan_idx_gen;
static DEFINE_RWLOCK(vlan_lock);
static LIST_HEAD(vlan_list);

static struct tcf_hashinfo vlan_hash_info = {
	.htab	=	tcf_vlan_ht,
	.hmask	=	VLAN_TAB_MASK,
	.lock	=	&vlan_lock,
};

static int tcf_vlan_release(struct tcf_vlan *v, int bind)
{
	if (v) {
		if (bind)
			v->tcf_bindcnt--;
		v->tcf_refcnt--;
		if (!v->tcf_bindcnt && v->tcf_refcnt <= 0) {
			tcf_hash_destroy(&v->common, &vlan_hash_info);
			return 1;
		}
	}
	return 0;
}

static const struct nla_policy vlan_policy[TCA_VLAN_MAX + 1] = {
	[TCA_VLAN_PARMS]		= { .len = sizeof(struct tc_vlan) },
	[TCA_VLAN_PUSH_VLAN_ID]		= { .type = NLA_U16 },
	[TCA_VLAN_PUSH_VLAN_PROTOCOL]	= { .type = NLA_U16 },
	[TCA_VLAN_PUSH_VLAN_PRIORITY]	= { .type = NLA_U8 },
};

static int tcf_vlan_init(struct net *net, struct nlattr *nla,
			 struct nlattr *est, struct tc_action *a,
			 int ovr, int bind)
{
	struct nlattr *tb[TCA_VLAN_MAX + 1];
	struct tc_vlan *parm;
	struct tcf_vlan *v;
	struct tcf_common *pc;
	__be16 push_vid = 0;
	__be16 push_proto = 0;
	u8 push_prio = 0;
	int ret = 0;

	if (!nla)
		return -EINVAL;

	ret = nla_parse_nested(tb, TCA_VLAN_MAX, nla, vlan_policy);
	if (ret < 0)
		return ret;

	if (!tb[TCA_VLAN_PARMS])
		return -EINVAL;

	parm = nla_data(tb[TCA_VLAN_PARMS]);
	switch (parm->v_action) {
	case TCA_VLAN_ACT_POP:
		break;
	case TCA_VLAN_ACT_PUSH:
		push_vid = nla_get_u16(tb[TCA_VLAN_PUSH_VLAN_ID]);
		if (push_vid >= VLAN_VID_MASK)
			return -ERANGE;

		if (tb[TCA_VLAN_PUSH_VLAN_PROTOCOL]) {
			push_proto = nla_get_be16(tb[TCA_VLAN_PUSH_VLAN_PROTOCOL]);
			switch (push_proto) {
			case htons(ETH_P_8021Q):
			case htons(ETH_P_8021AD):
				break;
			default:
				return -EPROTONOSUPPORT;
			}
		} else {
			push_proto = htons(ETH_P_8021Q);
		}

		if (tb[TCA_VLAN_PUSH_VLAN_PRIORITY])
			push_prio = nla_get_u8(tb[TCA_VLAN_PUSH_VLAN_PRIORITY]);
		break;
	default:
		return -EINVAL;
	}

	pc = tcf_hash_check(parm->index, a, bind, &vlan_hash_info);
	if (!pc) {
		pc = tcf_hash_create(parm->index, est, a, sizeof(*v),
				      bind, &vlan_idx_gen, &vlan_hash_info);
		if (IS_ERR(pc))
			return PTR_ERR(pc);
		ret = ACT_P_CREATED;
	} else {
		if (!ovr) {
			tcf_vlan_release(pc_to_vlan(pc), bind);
			return -EEXIST;
		}
	}
	v = pc_to_vlan(pc);

	spin_lock_bh(&v->tcf_lock);
	v->tcfv_action = parm->v_action;
	v->tcfv_push_vid = push_vid;
	v->tcfv_push_prio = push_prio;
	v->tcfv_push_proto = push_proto;
	v->tcf_action = parm->action;
	spin_unlock_bh(&v->tcf_lock);

	if (ret == ACT_P_CREATED)
		tcf_hash_insert(pc, &vlan_hash_info);
	return ret;
}

static int tcf_vlan_cleanup(struct tc_action *a, int bind)
{
	struct tcf_vlan *v = a->priv;

	if (v)
		return tcf_vlan_release(v, bind);
	return 0;
}

static __always_inline void
__skb_postpush_rcsum(struct sk_buff *skb, const void *start, unsigned int len,
		     unsigned int off)
{
	if (skb->ip_summed == CHECKSUM_COMPLETE)
		skb->csum = csum_block_add(skb->csum,
					   csum_partial(start, len, 0), off);
}

static unsigned char *skb_push_rcsum(struct sk_buff *skb, unsigned int len)
{
	skb_push(skb, len);
	__skb_postpush_rcsum(skb, skb->data, len, 0);
	return skb->data;
}

#define skb_at_tc_ingress(skb) \
	(G_TC_AT(skb->tc_verd) & AT_INGRESS)
static int tcf_vlan(struct sk_buff *skb, const struct tc_action *a,
		    struct tcf_result *res)
{
	struct tcf_vlan *v = a->priv;
	int action;
	int err;

	spin_lock(&v->tcf_lock);
	v->tcf_tm.lastuse = jiffies;
	bstats_update(&v->tcf_bstats, skb);
	action = v->tcf_action;

	/* Ensure 'data' points at mac_header prior calling vlan manipulating
	 * functions.
	 */
	if (skb_at_tc_ingress(skb))
		skb_push_rcsum(skb, skb->mac_len);

	switch (v->tcfv_action) {
	case TCA_VLAN_ACT_POP:
		err = skb_vlan_pop(skb);
		if (err)
			goto drop;
		break;
	case TCA_VLAN_ACT_PUSH:
		err = skb_vlan_push(skb, v->tcfv_push_proto, v->tcfv_push_vid |
				    (v->tcfv_push_prio << VLAN_PRIO_SHIFT));
		if (err)
			goto drop;
		break;
	default:
		BUG();
	}

	goto unlock;

drop:
	action = TC_ACT_SHOT;
	v->tcf_qstats.drops++;
unlock:
	if (skb_at_tc_ingress(skb))
		skb_pull_rcsum(skb, skb->mac_len);

	spin_unlock(&v->tcf_lock);
	return action;
}

static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
			 int bind, int ref)
{
	unsigned char *b = skb_tail_pointer(skb);
	struct tcf_vlan *v = a->priv;
	struct tc_vlan opt = {
		.index    = v->tcf_index,
		.refcnt   = v->tcf_refcnt - ref,
		.bindcnt  = v->tcf_bindcnt - bind,
		.action   = v->tcf_action,
		.v_action = v->tcfv_action,
	};
	struct tcf_t t;

	if (nla_put(skb, TCA_VLAN_PARMS, sizeof(opt), &opt))
		goto nla_put_failure;

	if ((v->tcfv_action == TCA_VLAN_ACT_PUSH ||
	     v->tcfv_action == TCA_VLAN_ACT_MODIFY) &&
	    (nla_put_u16(skb, TCA_VLAN_PUSH_VLAN_ID, v->tcfv_push_vid) ||
	     nla_put_be16(skb, TCA_VLAN_PUSH_VLAN_PROTOCOL,
			  v->tcfv_push_proto) ||
	     (nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY,
					      v->tcfv_push_prio))))
		goto nla_put_failure;
	t.install = jiffies_to_clock_t(jiffies - v->tcf_tm.install);
	t.lastuse = jiffies_to_clock_t(jiffies - v->tcf_tm.lastuse);
	t.expires = jiffies_to_clock_t(v->tcf_tm.expires);
	if (nla_put(skb, TCA_VLAN_TM, sizeof(t), &t))
		goto nla_put_failure;

	return skb->len;

nla_put_failure:
	nlmsg_trim(skb, b);
	return -1;
}

static struct tc_action_ops act_vlan_ops = {
	.kind		=	"vlan",
	.type		=	TCA_ACT_VLAN,
	.owner		=	THIS_MODULE,
	.act		=	tcf_vlan,
	.dump		=	tcf_vlan_dump,
	.cleanup	=	tcf_vlan_cleanup,
	.lookup		=	tcf_hash_search,
	.init		=	tcf_vlan_init,
	.walk		=	tcf_generic_walker,
};

static int __init vlan_init_module(void)
{
	pr_info("Backported vlan action on\n");
	return tcf_register_action(&act_vlan_ops);
}

static void __exit vlan_cleanup_module(void)
{
	tcf_unregister_action(&act_vlan_ops);
}

module_init(vlan_init_module);
module_exit(vlan_cleanup_module);

MODULE_AUTHOR("Jiri Pirko <jiri@resnulli.us>");
MODULE_DESCRIPTION("vlan manipulation actions");
MODULE_LICENSE("GPL v2");
