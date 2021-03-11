dnl Examine kernel functionality

# DO NOT insert new defines in this section!!! 
# Add your defines ONLY in LINUX_CONFIG_COMPAT section
AC_DEFUN([BP_CHECK_RHTABLE],
[
	AC_MSG_CHECKING([if file include/linux/rhashtable-types.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rhashtable-types.h>
	],[
		struct rhltable x;
		x = x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RHASHTABLE_TYPES, 1,
			[file rhashtable-types exists])
	],[
		AC_MSG_RESULT(no)
		AC_MSG_CHECKING([if rhltable defined])
		MLNX_BG_LB_LINUX_TRY_COMPILE([
			#include <linux/rhashtable.h>
		],[
			struct rhltable x;
			x = x;

			return 0;
		],[
			AC_MSG_RESULT(yes)
			MLNX_AC_DEFINE(HAVE_RHLTABLE, 1,
				[struct rhltable is defined])
			AC_MSG_CHECKING([if struct rhashtable_params contains insecure_elasticity])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/rhashtable.h>
			],[
				struct rhashtable_params x;
				unsigned int y;
				y = (unsigned int)x.insecure_elasticity;

				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_RHASHTABLE_INSECURE_ELASTICITY, 1,
					[struct rhashtable_params has insecure_elasticity])
			],[
				AC_MSG_RESULT(no)
			])
			AC_MSG_CHECKING([if struct rhashtable_params contains insecure_max_entries])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/rhashtable.h>
			],[
				struct rhashtable_params x;
				unsigned int y;
				y = (unsigned int)x.insecure_max_entries;

				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_RHASHTABLE_INSECURE_MAX_ENTRIES, 1,
					[struct rhashtable_params has insecure_max_entries])
			],[
				AC_MSG_RESULT(no)
			])
			AC_MSG_CHECKING([if struct rhashtable contains max_elems])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/rhashtable.h>
			],[
				struct rhashtable x;
				unsigned int y;
				y = (unsigned int)x.max_elems;

				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_RHASHTABLE_MAX_ELEMS, 1,
					[struct rhashtable has max_elems])
			],[
				AC_MSG_RESULT(no)
			])
		],[
			AC_MSG_RESULT(no)
			AC_MSG_CHECKING([if struct netns_frags contains rhashtable])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/in6.h>
				#include <net/inet_frag.h>
			],[
				struct netns_frags x;
				struct rhashtable rh;
				rh = x.rhashtable;

				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_NETNS_FRAGS_RHASHTABLE, 1,
					[struct netns_frags has rhashtable])
			],[
				AC_MSG_RESULT(no)
			])
		])
	])
])


AC_DEFUN([LINUX_CONFIG_COMPAT],
[
	AC_MSG_CHECKING([if has kvfree])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/mm.h>
	],[
		kvfree(NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KVFREE, 1,
			[kvfree is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if has is_tcf_police])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <net/tc_act/tc_police.h>
	],[
		return is_tcf_police(NULL) ? 1 : 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_POLICE, 1,
			[is_tcf_police is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if has is_tcf_tunnel_set && is_tcf_tunnel_release])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <net/tc_act/tc_tunnel_key.h>
	],[
		return is_tcf_tunnel_set(NULL) && is_tcf_tunnel_release(NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_TUNNEL, 1,
			[is_tcf_tunnel_set and is_tcf_tunnel_release are defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if has netdev_notifier_info_to_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/netdevice.h>
	],[
		return netdev_notifier_info_to_dev(NULL) ? 1 : 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_NOTIFIER_INFO_TO_DEV, 1,
			[netdev_notifier_info_to_dev is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm has register_netdevice_notifier_rh])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/netdevice.h>
	],[
		return register_netdevice_notifier_rh(NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REGISTER_NETDEVICE_NOTIFIER_RH, 1,
			[register_netdevice_notifier_rh is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/pagemap.h has release_pages ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pagemap.h>
	],[
		release_pages(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RELEASE_PAGES, 1,
			[release_pages is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/mm.h has get_user_pages_longterm])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		get_user_pages_longterm(0, 0, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_LONGTERM, 1,
			[get_user_pages_longterm is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if get_user_pages uses gup flags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		unsigned long start;
		unsigned long nr_pages;
		unsigned int gup_flags;
		struct page **page_list;
		struct vm_area_struct **vmas;
		int ret;

		ret = get_user_pages(start, nr_pages, gup_flags, page_list,
					vmas);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_GUP_FLAGS, 1,
			[get_user_pages uses gup_flags])
	],[
		MLNX_BG_LB_LINUX_TRY_COMPILE([
			#include <linux/mm.h>
		],[
			unsigned long start;
			unsigned long nr_pages;
			unsigned int gup_flags;
			struct page **page_list;
			struct vm_area_struct **vmas;
			int ret;
			ret = get_user_pages(NULL, NULL, start, nr_pages, gup_flags,
					page_list, vmas);
			return 0;
		],[
			AC_MSG_RESULT(yes)
			MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_GUP_FLAGS, 1,
				[NESTED: get_user_pages uses gup_flags])
		],[
			AC_MSG_RESULT(no)
		])

	])

	AC_MSG_CHECKING([if get_user_pages has 7 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		unsigned long start;
		unsigned long nr_pages;
		unsigned int gup_flags;
		struct page **page_list;
		struct vm_area_struct **vmas;
		int ret;

		ret = get_user_pages(NULL, NULL, start, nr_pages, gup_flags,
					page_list, vmas);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_7_PARAMS, 1,
			[get_user_pages has 7 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has memchr_inv])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/string.h>
	],[
		memchr_inv(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MEMCHR_INV, 1,
		[memchr_inv is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has memcpy_and_pad])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/string.h>
	],
	[
		memcpy_and_pad(NULL, 0, NULL, 0, ' ');

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MEMCPY_AND_PAD, 1,
		[memcpy_and_pad is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has strscpy])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/string.h>
	],
	[
		strscpy(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRSCPY, 1,
		[strscpy is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has strscpy_pad])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/string.h>
	],
	[
		strscpy_pad(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRSCPY_PAD, 1,
		[strscpy_pad is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ip6_fib.h has ip6_rt_put])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <uapi/linux/in6.h>
	#include <net/ip6_fib.h>
	],[
		ip6_rt_put(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IP6_RT_PUT, 1,
		[ip6_rt_put is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_namespace.h has possible_net_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <net/net_namespace.h>
	],[
		possible_net_t net;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_POSSIBLE_NET_T, 1,
		[possible_net_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_namespace.h has pernet_operations_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <net/net_namespace.h>
	],[
		int cma_pernet_id = 0;
		int ret;

		struct pernet_operations test = {
			.id = &cma_pernet_id,
		};

		ret = register_pernet_subsys(&test);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PERENT_OPERATIONS_ID, 1,
		[pernet_operations_id is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if rtble has direct dst])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <net/route.h>
	],[
		struct rtable *rt;
		struct dst_entry *dst = NULL;

                rt = container_of(dst, struct rtable, dst);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RT_DIRECT_DST, 1,
		[rtble has direct dst])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm has get_user_pages_remote with 7 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/mm.h>
	],[
		get_user_pages_remote(NULL, NULL, 0, 0, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_REMOTE_7_PARAMS, 1,
			[get_user_pages_remote is defined with 7 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm has get_user_pages_remote with 8 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/mm.h>
	],[
		get_user_pages_remote(NULL, NULL, 0, 0, 0, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_REMOTE_8_PARAMS, 1,
			[get_user_pages_remote is defined with 8 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm has get_user_pages_remote with 8 parameters with locked])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/mm.h>
	],[
		get_user_pages_remote(NULL, NULL, 0, 0, 0, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_REMOTE_8_PARAMS_W_LOCKED, 1,
			[get_user_pages_remote is defined with 8 parameters with locked])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if kernel has ktime_get_ns])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ktime.h>
	],[
		unsigned long long ns;

		ns = ktime_get_ns();
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KTIME_GET_NS, 1,
			  [ktime_get_ns defined])
	],[
		AC_MSG_RESULT(no)
	])
	
	AC_MSG_CHECKING([if if_vlan.h has __vlan_hwaccel_clear_tag])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		__vlan_hwaccel_clear_tag(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE__VLAN_HWACCEL_CLEAR_TAG, 1,
			  [__vlan_hwaccel_clear_tag defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_vlan.h has __vlan_get_protocol])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		__vlan_get_protocol(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VLAN_GET_PROTOCOL, 1,
			  [__vlan_get_protocol defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if page_ref.h has page_ref_count/add/sub/inc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/page_ref.h>
	],[
		page_ref_count(NULL);
		page_ref_add(NULL, 0);
		page_ref_sub(NULL, 0);
		page_ref_inc(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PAGE_REF_COUNT_ADD_SUB_INC, 1,
			  [page_ref_count/add/sub/inc defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ifla_vf_info exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		struct ifla_vf_info ivf;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IFLA_VF_INFO, 1,
			  [struct ifla_vf_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ifla_vf_info has min_tx_rate])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
		#include <linux/netdevice.h>
	],[
		struct ifla_vf_info *ivf;

		ivf->max_tx_rate = 0;
		ivf->min_tx_rate = 0;

		struct net_device_ops ndops = {
			.ndo_set_vf_rate = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VF_TX_RATE_LIMITS, 1,
			  [min_tx_rate is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ifla_vf_info has tx_rate])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
		#include <linux/netdevice.h>
	],[
		struct ifla_vf_info *ivf;

		ivf->tx_rate = 0;

		struct net_device_ops ndops = {
			.ndo_set_vf_tx_rate = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VF_TX_RATE, 1,
			  [tx_rate is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has ndo_get_phys_port_name])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops ndops = {
			.ndo_get_phys_port_name = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_PHYS_PORT_NAME, 1,
			  [ndo_get_phys_port_name is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_info_version_fixed_put])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		devlink_info_version_fixed_put(NULL, NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_INFO_VERSION_FIXED_PUT, 1,
			  [devlink_info_version_fixed_put exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_health_reporter_state_update])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		devlink_health_reporter_state_update(NULL, 0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HEALTH_REPORTER_STATE_UPDATE, 1,
			  [devlink_health_reporter_state_update exist])
	],[
		AC_MSG_RESULT(no)
	])

        AC_MSG_CHECKING([if devlink_health_reporter_ops.recover has extack parameter])
        MLNX_BG_LB_LINUX_TRY_COMPILE([
                #include <net/devlink.h>
		static int reporter_recover(struct devlink_health_reporter *reporter,
						     void *context,
						     struct netlink_ext_ack *extack)
		{
			return 0;
		}
        ],[
		struct devlink_health_reporter_ops mlx5_tx_reporter_ops = {
			.recover = reporter_recover
		}
        ],[
                AC_MSG_RESULT(yes)
                MLNX_AC_DEFINE(HAVE_HEALTH_REPORTER_RECOVER_HAS_EXTACK, 1,
                          [devlink_health_reporter_ops.recover has extack])
        ],[
                AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if devlink has devlink_param_driverinit_value_get])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		devlink_param_driverinit_value_get(NULL, 0, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_DRIVERINIT_VAL, 1,
			  [devlink_param_driverinit_value_get exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink enum has DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		int i = DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT, 1,
			  [struct devlink_param exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink_region_snapshot_create has 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		int i = devlink_region_snapshot_create(NULL, NULL, 0, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_REGION_SNAPSHOT_CREATE_4_PARAM, 1,
			  [devlink_region_snapshot_create has 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

        AC_MSG_CHECKING([if devlink_region_snapshot_id_get exists])
        MLNX_BG_LB_LINUX_TRY_COMPILE([
                #include <net/devlink.h>
        ],[
		struct devlink *devlink;

		u32 id = devlink_region_snapshot_id_get(devlink);
		return 0;
        ],[
                AC_MSG_RESULT(yes)
                MLNX_AC_DEFINE(HAVE_DEVLINK_REGION_SNAPSHOT_EXISTS, 1,
                          [devlink_region_snapshot_id_get exists])
        ],[
                AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if devlink enum has DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		int i = DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE, 1,
			  [struct devlink_param exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_param exist in net/devlink.h])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_param soso;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_PARAM, 1,
			  [struct devlink_param exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_reload_disable])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		devlink_reload_disable(NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_RELOAD_DISABLE, 1,
			  [devlink_reload_disable exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_reload_enable])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		devlink_reload_enable(NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_RELOAD_ENABLE, 1,
			  [devlink_reload_enable exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_net])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		devlink_net(NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_NET, 1,
			  [devlink_net exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops has reload])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_ops dlops = {
			.reload = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_RELOAD, 1,
			  [devlink_ops.reload is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops has reload_up/down])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_ops dlops = {
			.reload_up = NULL,
			.reload_down = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_RELOAD_UP_DOWN, 1,
			  [reload_up/down is defined])
	],[
		AC_MSG_RESULT(no)
	])

        AC_MSG_CHECKING([if devlink_ops.reload_down has 3 params])
        MLNX_BG_LB_LINUX_TRY_COMPILE([
                #include <net/devlink.h>

		static int devlink_reload_down(struct devlink *devlink, bool netns_change,
                                    struct netlink_ext_ack *extack)
		{
		        return 0;
		}

        ],[
                struct devlink_ops dlops = {
                        .reload_down = devlink_reload_down,
		};

                return 0;
        ],[
                AC_MSG_RESULT(yes)
                MLNX_AC_DEFINE(HAVE_DEVLINK_RELOAD_DOWN_HAS_3_PARAMS, 1,
                          [reload_down has 3 params])
        ],[
                AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if struct devlink_ops has info_get])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_ops dlops = {
			.info_get = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_INFO_GET, 1,
			  [info_get is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_health_reporter & devlink_fmsg])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		/* test for devlink_health_reporter and devlink_fmsg */
		struct devlink_health_reporter *r;
		struct devlink_fmsg *fmsg;
		int err;

		r = devlink_health_reporter_create(NULL, NULL, 0, 0, NULL);
		devlink_health_reporter_destroy(r);
		devlink_health_reporter_priv(r);

		err = devlink_health_report(r, NULL, NULL);

		err = devlink_fmsg_arr_pair_nest_start(fmsg, "name");
		err = devlink_fmsg_arr_pair_nest_end(fmsg);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HEALTH_REPORT_SUPPORT, 1,
			  [structs devlink_health_reporter & devlink_fmsg exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_fmsg_binary_put])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_fmsg *fmsg;
		int err;
		int value;

		err =  devlink_fmsg_binary_put(fmsg, &value, 2);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_FMSG_BINARY_PUT, 1,
			  [devlink_fmsg_binary_put exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if devlink has devlink_fmsg_binary_pair_put])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>

		/* Only interested in function with arg u32 and not u16 */
		/* See upstream commit e2cde864a1d3e3626bfc8fa088fbc82b04ce66ed */
		int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name, const void *value, u32 value_len);
	],[
		struct devlink_fmsg *fmsg;
		int err;
		int value;

		err =  devlink_fmsg_binary_pair_put(fmsg, "name", &value, 2);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_FMSG_BINARY_PAIR_PUT_ARG_U32, 1,
			  [devlink_fmsg_binary_pair_put exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops has eswitch_mode_get/set])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_ops dlops = {
			.eswitch_mode_get = NULL,
			.eswitch_mode_set = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_ESWITCH_MODE_GET_SET, 1,
			  [eswitch_mode_get/set is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops.reload has extack])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
		int mlx4_devlink_reload(struct devlink *devlink, struct netlink_ext_ack *extack)
		{
			return 0;
		}
	],[
		static const struct devlink_ops dlops = {
			.reload = mlx4_devlink_reload,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_RELOAD_HAS_EXTACK, 1,
			  [struct devlink_ops.reload has extack])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops.eswitch_mode_set has extack])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
		int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
		                                struct netlink_ext_ack *extack) {
			return 0;
		}
	],[
		static const struct devlink_ops dlops = {
			.eswitch_mode_set = mlx5_devlink_eswitch_mode_set,
		};
		dlops.eswitch_mode_set(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_ESWITCH_MODE_SET_EXTACK, 1,
			  [struct devlink_ops.eswitch_mode_set has extack])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops has reload_up])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		static const struct devlink_ops dlops = {
			.reload_up = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_OPS_RELOAD_UP, 1,
			  [struct devlink_ops has reload_up])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops has eswitch_encap_mode_set/get])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_ops dlops = {
			.eswitch_encap_mode_set = NULL,
			.eswitch_encap_mode_get = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_ESWITCH_ENCAP_MODE_SET, 1,
			  [eswitch_encap_mode_set/get is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops defines eswitch_encap_mode_set/get with enum arg])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
		#include <uapi/linux/devlink.h>
	],[
		int local_eswitch_encap_mode_get(struct devlink *devlink,
					      enum devlink_eswitch_encap_mode *p_encap_mode) {
			return 0;
		}
		int local_eswitch_encap_mode_set(struct devlink *devlink,
					      enum devlink_eswitch_encap_mode encap_mode,
					      struct netlink_ext_ack *extack) {
			return 0;
		}

		struct devlink_ops dlops = {
			.eswitch_encap_mode_set = local_eswitch_encap_mode_set,
			.eswitch_encap_mode_get = local_eswitch_encap_mode_get,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_ESWITCH_ENCAP_MODE_SET_GET_WITH_ENUM, 1,
			  [eswitch_encap_mode_set/get is defined with enum])
	],[
		AC_MSG_RESULT(no)
	])


	AC_MSG_CHECKING([if struct devlink_ops has eswitch_inline_mode_get/set])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_ops dlops = {
			.eswitch_inline_mode_get = NULL,
			.eswitch_inline_mode_set = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_ESWITCH_INLINE_MODE_GET_SET, 1,
			  [eswitch_inline_mode_get/set is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct devlink_ops has flash_update])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		struct devlink_ops dlops = {
			.flash_update = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_HAS_FLASH_UPDATE, 1,
			  [flash_update is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ifla_vf_info has vlan_proto])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		struct ifla_vf_info *ivf;

		ivf->vlan_proto = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VF_VLAN_PROTO, 1,
			  [vlan_proto is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if IP6_ECN_set_ce has 2 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/inet_ecn.h>
	],[
		IP6_ECN_set_ce(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IP6_SET_CE_2_PARAMS, 1,
			  [IP6_ECN_set_ce has 2 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dev_open has 2 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int s = dev_open(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(DEV_OPEN_HAS_2_PARAMS, 1,
			  [dev_open has 2 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if napi_gro_flush has 2 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		napi_gro_flush(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NAPI_GRO_FLUSH_2_PARAMS, 1,
			  [napi_gro_flush has 2 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_master_upper_dev_link gets 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_master_upper_dev_link(NULL, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NETDEV_MASTER_UPPER_DEV_LINK_4_PARAMS, 1,
			  [netdev_master_upper_dev_link gets 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi ethtool.h has IPV6_USER_FLOW])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
                int x = IPV6_USER_FLOW;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_USER_FLOW, 1,
			  [uapi ethtool has IPV6_USER_FLOW])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_rxfh])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_rxfh_key_size = NULL,
			.get_rxfh = NULL,
			.set_rxfh = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_RXFH, 1,
			  [get/set_rxfh is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get_rxfh_indir_size])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_rxfh_indir_size = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RXFH_INDIR_SIZE, 1,
			[get_rxfh_indir_size is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops_ext has get_rxfh_indir_size])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops_ext en_ethtool_ops_ext = {
			.get_rxfh_indir_size = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RXFH_INDIR_SIZE_EXT, 1,
			[get_rxfh_indir_size is defined in ethtool_ops_ext])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_rxfh_indir])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>

		int mlx4_en_get_rxfh_indir(struct net_device *d, u32 *r)
		{
			return 0;
		}
	],[
		struct ethtool_ops en_ethtool_ops;
		en_ethtool_ops.get_rxfh_indir = mlx4_en_get_rxfh_indir;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_RXFH_INDIR, 1,
			[get/set_rxfh_indir is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool has set_phys_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.set_phys_id = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SET_PHYS_ID, 1,
			  [set_phys_id is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_tunable])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_tunable = NULL,
			.set_tunable = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_TUNABLE, 1,
			  [get/set_tunable is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if exist struct ethtool_ops_ext])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops_ext en_ethtool_ops_ext = {
			.size = sizeof(struct ethtool_ops_ext),
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHTOOL_OPS_EXT, 1,
			  [struct ethtool_ops_ext is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if exist struct ethtool_flow_ext])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		struct ethtool_flow_ext en_ethtool_flow_ext;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHTOOL_FLOW_EXT, 1,
			  [struct ethtool_flow_ext is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if exist union ethtool_flow_union])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		union ethtool_flow_union test_ethtool_flow_union;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHTOOL_FLOW_UNION, 1,
			  [union ethtool_flow_union is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops_ext has get/set_rxfh_indir])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops_ext en_ethtool_ops_ext = {
			.get_rxfh_indir = NULL,
			.set_rxfh_indir = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_RXFH_INDIR_EXT, 1,
			  [get/set_rxfh_indir is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool.h has __ethtool_get_link_ksettings])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		 __ethtool_get_link_ksettings(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE___ETHTOOL_GET_LINK_KSETTINGS, 1,
			  [__ethtool_get_link_ksettings is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has neigh_priv_len])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		dev->neigh_priv_len = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_NEIGH_PRIV_LEN, 1,
			  [neigh_priv_len is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has dev_port])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		dev->dev_port = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_DEV_PORT, 1,
			  [dev_port is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has min/max])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		dev->min_mtu = 0;
		dev->max_mtu = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_MIN_MAX_MTU, 1,
			  [net_device min/max is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has needs_free_netdev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		dev->needs_free_netdev = true;
		dev->priv_destructor = NULL;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_NEEDS_FREE_NETDEV, 1,
			  [net_device needs_free_netdev is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has close_list])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;
		struct list_head xlist;

		dev->close_list = xlist;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_HAS_CLOSE_LIST, 1,
			  [net_device close_list is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ktls related structs exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/tls.h>
	],[
		struct tlsdev_ops dev;
		struct tls_offload_context_tx tx_ctx;
		struct tls12_crypto_info_aes_gcm_128 crypto_info;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KTLS_STRUCTS, 1,
			  [ktls related structs exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tlsdev_ops has tls_dev_resync_rx])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct tlsdev_ops dev;

		dev.tls_dev_resync_rx = NULL;
		
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TLSDEV_OPS_HAS_TLS_DEV_RESYNC_RX, 1,
			  [struct tlsdev_ops has tls_dev_resync_rx])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if memzero_explicit exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/string.h>
	],[
		memzero_explicit(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MEMZERO_EXPLICIT, 1,
			  [linux/string.h memzero_explicit is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if barrier_data exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/compiler.h>
	],[
		barrier_data(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BARRIER_DATA, 1,
			  [linux/compiler.h barrier_data is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skb_frag_off_add exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_frag_off_add(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_FRAG_OFF_ADD, 1,
			  [linux/skbuff.h skb_frag_off_add is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if cleanup_srcu_struct_quiesced exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/srcu.h>
	],[
		cleanup_srcu_struct_quiesced(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CLEANUP_SRCU_STRUCT_QUIESCED, 1,
			  [linux/srcu.h cleanup_srcu_struct_quiesced is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if call_srcu exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/srcu.h>
	],[
		call_srcu(NULL,NULL,NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CALL_SRCU, 1,
			  [linux/srcu.h call_srcu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdev_xdp exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct netdev_xdp xdp;
		xdp = xdp;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_XDP, 1,
			  [struct netdev_xdp is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has ndo_xdp])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops netdev_ops = {
			.ndo_bpf = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_XDP, 1,
			  [net_device_ops has ndo_xdp is defined])
	],[
		AC_MSG_RESULT(no)
	])


	AC_MSG_CHECKING([if struct net_device_ops has ndo_xdp_xmit])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops netdev_ops = {
			.ndo_xdp_xmit = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_XDP_XMIT, 1,
			  [net_device_ops has ndo_xdp_xmit is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has ndo_xdp_flush])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops netdev_ops = {
			.ndo_xdp_flush = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_XDP_FLUSH, 1,
			  [ndo_xdp_flush is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended has ndo_xdp])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_extended netdev_ops_extended = {
			.ndo_xdp = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_XDP_EXTENDED, 1,
			  [extended ndo_xdp is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_cls_flower_offload exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_cls_flower_offload x;
		x = x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_FLOWER_OFFLOAD, 1,
			  [struct tc_cls_flower_offload is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if miniflow exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
                int flags = TC_SETUP_MINIFLOW & TC_SETUP_CT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MINIFLOW, 1,
			  [miniflow exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_block_offload exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_block_offload x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_BLOCK_OFFLOAD, 1,
			  [struct tc_block_offload is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct flow_block_offload exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct flow_block_offload x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_BLOCK_OFFLOAD, 1,
			  [struct flow_block_offload exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct flow_block_offload hash unlocked_driver_cb])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct flow_block_offload x;
		x.unlocked_driver_cb = true;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UNLOCKED_DRIVER_CB, 1,
			  [struct flow_block_offload has unlocked_driver_cb])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netlink_ext_ack exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		struct netlink_ext_ack extack;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_EXTACK, 1,
			  [struct netlink_ext_ack exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_cls_common_offload has extack])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_cls_common_offload x;
		x.extack = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CLS_OFFLOAD_EXTACK, 1,
			  [struct tc_cls_common_offload has extack])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_block_offload has extack])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_block_offload x;
		x.extack = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_BLOCK_OFFLOAD_EXTACK, 1,
			  [struct tc_block_offload has extack])
	],[
		AC_MSG_RESULT(no)
	])

	BP_CHECK_RHTABLE

	AC_MSG_CHECKING([if struct ptp_clock_info exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ptp_clock_kernel.h>
	],[
		struct ptp_clock_info info;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PTP_CLOCK_INFO, 1,
			  [ptp_clock_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ptp_clock_info has n_pins])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ptp_clock_kernel.h>
	],[
		struct ptp_clock_info *info;
		info->n_pins = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PTP_CLOCK_INFO_N_PINS, 1,
			  [n_pins is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ptp_clock_info has gettimex64])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ptp_clock_kernel.h>
	],[
		struct ptp_clock_info info = {
			.gettimex64 = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GETTIMEX64, 1,
			  [gettimex64 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ptp_clock_info has gettime])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ptp_clock_kernel.h>
	],[
		struct ptp_clock_info info = {
			.gettime = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PTP_CLOCK_INFO_GETTIME_32BIT, 1,
			  [gettime 32bit is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h pci_enable_msix_range])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		int x = pci_enable_msix_range(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_ENABLE_MSIX_RANGE, 1,
			  [pci_enable_msix_range is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h pci_bus_addr_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_bus_addr_t x = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_BUS_ADDR_T, 1,
			  [pci_bus_addr_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/hash.h hash_32_generic])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/hash.h>
	],[
		int x = hash_32_generic(0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_HASH_32_GENERIC, 1,
			[hash_32_generic is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h pci_sriov_get_totalvfs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		int x = pci_sriov_get_totalvfs(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_SRIOV_GET_TOTALVFS, 1,
			[pci_sriov_get_totalvfs is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has page_is_pfmemalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		bool x = page_is_pfmemalloc(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PAGE_IS_PFMEMALLOC, 1,
			[page_is_pfmemalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct page has pfmemalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm_types.h>
	],[
		struct page *page;
		page->pfmemalloc = true;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PAGE_PFMEMALLOC, 1,
			[pfmemalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has select_queue_fallback_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		select_queue_fallback_t fallback;

		fallback = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SELECT_QUEUE_FALLBACK_T, 1,
			  [select_queue_fallback_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has skb_set_hash])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_set_hash(NULL, 0, PKT_HASH_TYPE_L3);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_SET_HASH, 1,
			  [skb_set_hash is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has skb_frag_off])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_frag_off(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_FRAG_OFF, 1,
			  [skb_frag_off is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has napi_alloc_skb])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		napi_alloc_skb(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NAPI_ALLOC_SKB, 1,
			  [napi_alloc_skb is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has skb_transport_header_was_set])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_transport_header_was_set(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_TRANSPORT_HEADER_WAS_SET, 1,
			  [skb_transport_header_was_set is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has build_skb])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		 build_skb(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BUILD_SKB, 1,
			  [build_skb is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has dev_alloc_pages])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		dev_alloc_pages(0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_ALLOC_PAGES, 1,
			  [dev_alloc_pages is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has dev_alloc_page])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		dev_alloc_page();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_ALLOC_PAGE, 1,
			  [dev_alloc_page is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if gfp.h has gfpflags_allow_blocking])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/gfp.h>
	],[
		gfpflags_allow_blocking(0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAS_GFPFLAGES_ALLOW_BLOCKING, 1,
			  [gfpflags_allow_blocking is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if gfp.h has __alloc_pages_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/gfp.h>
	],[
		__alloc_pages_node(0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAS_ALLOC_PAGES_NODE, 1,
			  [__alloc_pages_node is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if gfp.h has __GFP_DIRECT_RECLAIM])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/gfp.h>
	],[
		gfp_t gfp_mask = __GFP_DIRECT_RECLAIM;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAS_GFP_DIRECT_RECLAIM, 1,
			  [__GFP_DIRECT_RECLAIM is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has skb_vlan_pop])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_vlan_pop(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_VLAN_POP, 1,
			  [skb_vlan_pop is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has skb_pull_inline])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff skb;
		skb_pull_inline(&skb, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_PULL_INLINE, 1,
			  [skb_pull_inline is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if sockios.h has SIOCGHWTSTAMP])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sockios.h>
	],[
		int x = SIOCGHWTSTAMP;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SIOCGHWTSTAMP, 1,
			  [SIOCGHWTSTAMP is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ipv6_chk_addr accepts a const second parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/addrconf.h>
	],[
		const struct sockaddr *addr;
		ipv6_chk_addr(NULL,
					  &((const struct sockaddr_in6 *)addr)->sin6_addr,
					  NULL,
					  0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_CHK_ADDR_TAKES_CONST, 1,
			  [ipv6_chk_addr accepts a const second parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h skb_flow_dissect])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_flow_dissect(NULL, NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_FLOW_DISSECT, 1,
			  [skb_flow_dissect is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h dev_change_flags has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		dev_change_flags(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_CHANGE_FLAGS_HAS_3_PARAMS, 1,
			  [dev_change_flags has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uaccess.h access_ok has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/uaccess.h>
	],[
		access_ok(0, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ACCESS_OK_HAS_3_PARAMS, 1,
			  [access_okhas 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h skb_flow_dissect_flow_keys has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_flow_dissect_flow_keys(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_FLOW_DISSECT_FLOW_KEYS_HAS_3_PARAMS, 1,
			  [skb_flow_dissect_flow_keys has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ip.h ip_local_out has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/ip.h>
	],[
		ip_local_out(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IP_LOCAL_OUT_3_PARAMS, 1,
			  [ip_local_out has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ip.h inet_get_local_port_range has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/ip.h>
	],[
		inet_get_local_port_range(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INET_GET_LOCAL_PORT_RANGE_3_PARAMS, 1,
			  [inet_get_local_port_range has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has enum NAPI_STATE_MISSED])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int napi = NAPI_STATE_MISSED;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NAPI_STATE_MISSED, 1,
			  [NAPI_STATE_MISSED is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has enum pcie_link_width])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		enum pcie_link_width width = PCIE_LNK_WIDTH_UNKNOWN;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCIE_LINK_WIDTH, 1,
			  [pcie_link_width is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h has FLOW_DISSECTOR_KEY_ENC_IP])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		int n = FLOW_DISSECTOR_KEY_ENC_IP;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_ENC_IP, 1,
			  [flow_dissector.h has FLOW_DISSECTOR_KEY_ENC_IP])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h has dissector_uses_key])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		dissector_uses_key(NULL, 1);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_USES_KEY, 1,
			  [flow_dissector.h has dissector_uses_key])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h has FLOW_DISSECTOR_KEY_ENC_KEYID])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		int n = FLOW_DISSECTOR_KEY_ENC_KEYID;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_ENC_KEYID, 1,
			  [flow_dissector.h has FLOW_DISSECTOR_KEY_ENC_KEYID])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has enum pci_bus_speed])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		enum pci_bus_speed speed = PCI_SPEED_UNKNOWN;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_BUS_SPEED, 1,
			  [pci_bus_speed is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ifla_vf_info has linkstate])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		struct ifla_vf_info *x;
		x->linkstate = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINKSTATE, 1,
			  [linkstate is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h enum pci_dev_flags has PCI_DEV_FLAGS_ASSIGNED])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		enum pci_dev_flags x = PCI_DEV_FLAGS_ASSIGNED;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_DEV_FLAGS_ASSIGNED, 1,
			  [PCI_DEV_FLAGS_ASSIGNED is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if switchdev.h has struct switchdev_ops])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/switchdev.h>
		#include <linux/netdevice.h>
	],[
		struct switchdev_ops x;
		struct net_device *ndev;

		ndev->switchdev_ops = &x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SWITCHDEV_OPS, 1,
			  [HAVE_SWITCHDEV_OPS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if switchdev.h has switchdev_port_same_parent_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/switchdev.h>
	],[
		switchdev_port_same_parent_id(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SWITCHDEV_PORT_SAME_PARENT_ID, 1,
			  [switchdev_port_same_parent_id is defined])
	],[
		AC_MSG_RESULT(no)
	])

        AC_MSG_CHECKING([if netdevice.h has netif_keep_dst])
        MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/netdevice.h>
	        ],[
                netif_keep_dst(NULL);

                return 0;
        ],[
                AC_MSG_RESULT(yes)
                MLNX_AC_DEFINE(HAVE_NETIF_KEEP_DST, 1,
                          [netif_keep_dst is defined])
        ],[
                AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if netdevice.h has __netdev_tx_sent_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		__netdev_tx_sent_queue(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_TX_SEND_QUEUE, 1,
			  [__netdev_tx_sent_queue is defined])
	],[
		AC_MSG_RESULT(no)
	])
	AC_MSG_CHECKING([if netdevice.h has netdev_txq_bql_complete_prefetchw])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_txq_bql_complete_prefetchw(NULL);
		netdev_txq_bql_enqueue_prefetchw(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_TXQ_BQL_PREFETCHW, 1,
			  [netdev_txq_bql_complete_prefetchw is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct sk_buff has xmit_more])
	case $LINUXRELEASE in
	3\.1[[0-7]]*fbk*|2*fbk*)
	AC_MSG_RESULT(Not checking xmit_more support for fbk kernel: $LINUXRELEASE)
	;;
	*)
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff *skb;
		skb->xmit_more = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_BUFF_XMIT_MORE, 1,
			  [xmit_more is defined])
	],[
		AC_MSG_RESULT(no)
	])
	;;
	esac

	AC_MSG_CHECKING([if struct sk_buff has decrypted])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff *skb;
		skb->decrypted = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_BUFF_DECRYPTED, 1,
			  [decrypted is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct sk_buff has encapsulation])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff *skb;
		skb->encapsulation = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_BUFF_ENCAPSULATION, 1,
			  [encapsulation is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct sk_buff has struct sock sk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff *skb;
		skb->sk = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_BUFF_STRUCT_SOCK_SK, 1,
			  [struct sock sk is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if secpath_set returns struct sec_path *])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/xfrm.h>
	],[
		struct sec_path *temp = secpath_set(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(SECPATH_SET_RETURN_POINTER, 1,
			  [if secpath_set returns struct sec_path *])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if eth_get_headlen has 3 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/etherdevice.h>
	],[
		eth_get_headlen(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETH_GET_HEADLEN_3_PARAMS, 1,
			  [eth_get_headlen is defined with 3 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if eth_get_headlen has 2 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/etherdevice.h>
	],[
		eth_get_headlen(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETH_GET_HEADLEN_2_PARAMS, 1,
			  [eth_get_headlen is defined with 2 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct sk_buff has csum_level])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff *skb;
		skb->csum_level = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_BUFF_CSUM_LEVEL, 1,
			  [csum_level is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct skbuff.h has skb_inner_transport_header])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_inner_transport_header(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_INNER_TRANSPORT_HEADER, 1,
			  [skb_inner_transport_header is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct skbuff.h has napi_consume_skb])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		napi_consume_skb(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NAPI_CONSUME_SKB, 1,
			  [napi_consume_skb is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct skbuff.h has skb_inner_transport_offset])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_inner_transport_offset(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_INNER_TRANSPORT_OFFSET, 1,
			  [skb_inner_transport_offset is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct skbuff.h has skb_inner_network_header])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_inner_network_header(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_INNER_NETWORK_HEADER, 1,
			  [skb_inner_network_header is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_vlan.h has vlan_dev_get_egress_qos_mask])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		vlan_dev_get_egress_qos_mask(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VLAN_DEV_GET_EGRESS_QOS_MASK, 1,
			  [vlan_dev_get_egress_qos_mask is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_vlan.h has vlan_get_encap_level])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		vlan_get_encap_level(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VLAN_GET_ENCAP_LEVEL, 1,
			  [vlan_get_encap_level is defined])
	],[
		AC_MSG_RESULT(no)
	])


	AC_MSG_CHECKING([if netdevice.h has netdev_set_num_tc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_set_num_tc(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_SET_NUM_TC, 1,
			  [netdev_set_num_tc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_get_num_tc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_get_num_tc(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_GET_NUM_TC, 1,
			  [netdev_get_num_tc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_rx_handler_register])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_rx_handler_register(NULL, NULL, NULL);
		struct net_device x = {
			.rx_handler_data = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_RX_HANDLER_REGISTER, 1,
			  [netdev_rx_handler_register is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_select_queue has accel_priv])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		static u16 select_queue(struct net_device *dev, struct sk_buff *skb,
				        struct net_device *sb_dev)
		{
			return 0;
		}
	],[
		struct net_device_ops ndops = {
			.ndo_select_queue = select_queue,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NDO_SELECT_QUEUE_HAS_3_PARMS_NO_FALLBACK, 1,
			  [ndo_select_queue has 3 params with no fallback])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_select_queue has accel_priv])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		static u16 select_queue(struct net_device *dev, struct sk_buff *skb,
				        void *accel_priv)
		{
			return 0;
		}
	],[
		struct net_device_ops ndops = {
			.ndo_select_queue = select_queue,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NDO_SELECT_QUEUE_HAS_ACCEL_PRIV, 1,
			  [ndo_select_queue has accel_priv])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_select_queue has a second net_device parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		static u16 select_queue(struct net_device *dev, struct sk_buff *skb,
		                        struct net_device *sb_dev,
		                        select_queue_fallback_t fallback)
		{
			return 0;
		}
	],[
		struct net_device_ops ndops = {
			.ndo_select_queue = select_queue,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SELECT_QUEUE_NET_DEVICE, 1,
			  [ndo_select_queue has a second net_device parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_select_queue has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		u16 select_queue(struct net_device *dev, struct sk_buff *skb,
		                 struct net_device *sb_dev)
		{
			return 0;
		}
	],[
		struct net_device_ops ndops = {
			.ndo_select_queue = select_queue,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_3_PARAMS_FOR_NDO_SELECT_QUEUE, 1,
			  [.ndo_select_queue has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if setapp returns int])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>

		static int mlx4_en_dcbnl_setapp(struct net_device *netdev, u8 idtype,
						u16 id, u8 up)
		{
			return 0;
		}

	],[
		struct dcbnl_rtnl_ops mlx4_en_dcbnl_ops = {
			.setapp		= mlx4_en_dcbnl_setapp,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NDO_SETAPP_RETURNS_INT, 1,
			  [if setapp returns int])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if getapp returns int])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>

		static int mlx4_en_dcbnl_getapp(struct net_device *netdev, u8 idtype,
						u16 id)
		{
			return 0;
		}
	],[
		struct dcbnl_rtnl_ops mlx4_en_dcbnl_ops = {
			.getapp		= mlx4_en_dcbnl_getapp,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NDO_GETAPP_RETURNS_INT, 1,
			  [if getapp returns int])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if getnumtcs returns int])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>

		static int mlx4_en_dcbnl_getnumtcs(struct net_device *netdev, int tcid, u8 *num)

		{
			return 0;
		}

	],[
		struct dcbnl_rtnl_ops mlx4_en_dcbnl_ops = {
			.getnumtcs	= mlx4_en_dcbnl_getnumtcs,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NDO_GETNUMTCS_RETURNS_INT, 1,
			  [if getnumtcs returns int])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/trace/trace_events.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
                #undef TRACE_INCLUDE_PATH
                #undef TRACE_INCLUDE_FILE
                #undef TRACE_INCLUDE
                #define TRACE_INCLUDE(a) "/dev/null"

		#include <trace/trace_events.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TRACE_EVENTS_H, 1,
			  [include/trace/trace_events.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/net/vxlan.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/vxlan.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_VXLAN_H, 1,
			  [include/net/vxlan.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/siphash.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/siphash.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_SIPHASH_H, 1,
			  [include/linux/siphash.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/bits.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bits.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BITS_H, 1,
			  [include/linux/bits.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/net/bonding.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/bonding.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BONDING_H, 1,
			  [include/net/bonding.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/generated/utsrelease.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <generated/utsrelease.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UTSRELEASE_H, 1,
			  [include/generated/utsrelease.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/net/devlink.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/devlink.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVLINK_H, 1,
			  [include/net/devlink.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/net/switchdev.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/switchdev.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SWITCHDEV_H, 1,
			  [include/net/switchdev.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/interval_tree_generic.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/interval_tree_generic.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INTERVAL_TREE_GENERIC_H, 1,
			[include/linux/interval_tree_generic.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_vlan.h has is_tcf_vlan])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_vlan.h>
	],[
		is_tcf_vlan(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_VLAN, 1,
			  [is_tcf_vlan is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_vlan.h has tcf_vlan_push_prio])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_vlan.h>
	],[
		tcf_vlan_push_prio(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_VLAN_PUSH_PRIO, 1,
			  [tcf_vlan_push_prio is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h enum flow_dissector_key_keyid has FLOW_DISSECTOR_KEY_VLAN])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		enum flow_dissector_key_id keyid = FLOW_DISSECTOR_KEY_VLAN;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_VLAN, 1,
			  [FLOW_DISSECTOR_KEY_VLAN is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h has flow_dissector_key_vlan.vlan_tpid])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		struct flow_dissector_key_vlan filter_dev_key;
		filter_dev_key.vlan_tpid = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_VLAN_TPID, 1,
			  [HAVE_FLOW_DISSECTOR_KEY_VLAN_TPID is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h enum flow_dissector_key_keyid has FLOW_DISSECTOR_KEY_CVLAN])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		enum flow_dissector_key_id keyid = FLOW_DISSECTOR_KEY_CVLAN;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_CVLAN, 1,
			  [FLOW_DISSECTOR_KEY_CVLAN is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h enum flow_dissector_key_keyid has FLOW_DISSECTOR_KEY_IP])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		enum flow_dissector_key_id keyid = FLOW_DISSECTOR_KEY_IP;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_IP, 1,
			  [FLOW_DISSECTOR_KEY_IP is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h enum flow_dissector_key_keyid has FLOW_DISSECTOR_KEY_TCP])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		enum flow_dissector_key_id keyid = FLOW_DISSECTOR_KEY_TCP;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_TCP, 1,
			  [FLOW_DISSECTOR_KEY_TCP is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h enum flow_dissector_key_keyid has FLOW_DISSECTOR_KEY_MPLS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		enum flow_dissector_key_id keyid = FLOW_DISSECTOR_KEY_MPLS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_MPLS, 1,
			  [FLOW_DISSECTOR_KEY_MPLS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h enum flow_dissector_key_keyid has FLOW_DISSECTOR_KEY_ENC_IP])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		enum flow_dissector_key_id keyid = FLOW_DISSECTOR_KEY_ENC_IP;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_ENC_IP, 1,
			  [FLOW_DISSECTOR_KEY_ENC_IP is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if etherdevice.h has ether_addr_copy])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/etherdevice.h>
	],[
		ether_addr_copy(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHER_ADDR_COPY, 1,
			  [ether_addr_copy is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if etherdevice.h has eth_random_addr])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/etherdevice.h>
	],[
		eth_random_addr(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETH_RANDOM_ADDR, 1,
			  [eth_random_addr is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_extended has hw_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		netdev_extended(dev)->hw_features = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_EXTENDED_HW_FEATURES, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_extended has wanted_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		netdev_extended(dev)->wanted_features = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_EXTENDED_WANTED_FEATURES, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_extended has _tx_ext])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		netdev_extended(dev)->_tx_ext = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_EXTENDED_TX_EXT, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_extended has dev_port])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		netdev_extended(dev)->dev_port = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_EXTENDED_DEV_PORT, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has NAPI_STATE_NO_BUSY_POLL])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int x = NAPI_STATE_NO_BUSY_POLL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NAPI_STATE_NO_BUSY_POLL, 1,
			  [NAPI_STATE_NO_BUSY_POLL is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_busy_poll])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_busy_poll = NULL;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_BUSY_POLL, 1,
			  [ndo_busy_poll is defined])
	],[
		AC_MSG_RESULT(no)
	])


	AC_MSG_CHECKING([if net_device_extended has ndo_busy_poll])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int busy_poll(struct napi_struct *napi)
		{
			return 0;
		}
	],[
		struct net_device *dev = NULL;

		netdev_extended(dev)->ndo_busy_poll = busy_poll;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_EXTENDED_NDO_BUSY_POLL, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has set_netdev_hw_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		set_netdev_hw_features(dev, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SET_NETDEV_HW_FEATURES, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netif_set_xps_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		netif_set_xps_queue(dev, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_SET_XPS_QUEUE, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_update_features exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev = NULL;

		netdev_update_features(dev);

		return 0;
	],[
	AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_UPDATE_FEATURES, 1,
		  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_set_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_set_features = NULL;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SET_FEATURES, 1,
			  [ndo_set_features is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_set_tx_maxrate])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops x = {
			.ndo_set_tx_maxrate = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SET_TX_MAXRATE, 1,
			  [ndo_set_tx_maxrate is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended has *ndo_set_tx_maxrate])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_extended x = {
			.ndo_set_tx_maxrate = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SET_TX_MAXRATE_EXTENDED, 1,
			  [extended ndo_set_tx_maxrate is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended has *ndo_chane_mtu_extended])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_extended x = {
			.ndo_change_mtu = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_CHANGE_MTU_EXTENDED, 1,
			  [extended ndo_change_mtu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_chane_mtu_rh74])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops x = {
			.ndo_change_mtu_rh74 = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_CHANGE_MTU_RH74, 1,
			  [extended ndo_change_mtu_rh74 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_extended has min/max_mtu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_extended x = {
			.min_mtu = 0,
			.max_mtu = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_MIN_MAX_MTU_EXTENDED, 1,
			  [extended min/max_mtu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_setup_tc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops x = {
			.ndo_setup_tc = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SETUP_TC, 1,
			  [ndo_setup_tc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended has  has *ndo_setup_tc_rh])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_extended x = {
			.ndo_setup_tc_rh = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SETUP_TC_RH_EXTENDED, 1,
			  [ndo_setup_tc_rh is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netif_tx_napi_add])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netif_tx_napi_add(NULL, NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_TX_NAPI_ADD, 1,
			  [netif_tx_napi_add is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_setup_tc takes 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int mlx4_en_setup_tc(struct net_device *dev, u32 handle,
							 __be16 protocol, struct tc_to_netdev *tc)
		{
			return 0;
		}
	],[
		struct net_device_ops x = {
			.ndo_setup_tc = mlx4_en_setup_tc,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SETUP_TC_4_PARAMS, 1,
			  [ndo_setup_tc takes 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_setup_tc takes chain_index])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int mlx_en_setup_tc(struct net_device *dev, u32 handle, u32 chain_index,
							__be16 protocol, struct tc_to_netdev *tc)
		{
			return 0;
		}
	],[
		struct net_device_ops x = {
			.ndo_setup_tc = mlx_en_setup_tc,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SETUP_TC_TAKES_CHAIN_INDEX, 1,
			  [ndo_setup_tc takes chain_index])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_setup_tc takes tc_setup_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int mlx_en_setup_tc(struct net_device *dev, enum tc_setup_type type,
				    void *type_data)
		{
			return 0;
		}
	],[
		struct net_device_ops x = {
			.ndo_setup_tc = mlx_en_setup_tc,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SETUP_TC_TAKES_TC_SETUP_TYPE, 1,
			  [ndo_setup_tc takes tc_setup_type])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h has tcf_exts_to_list])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tcf_exts_to_list(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_EXTS_TO_LIST, 1,
			  [tcf_exts_to_list is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h has tc_setup_flow_action])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tc_setup_flow_action(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_SETUP_FLOW_ACTION, 1,
			  [tc_setup_flow_action is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h has tc_setup_flow_action with rtnl_held])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tc_setup_flow_action(NULL, NULL, false);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_SETUP_FLOW_ACTION_WITH_RTNL_HELD, 1,
			  [tc_setup_flow_action has rtnl_held])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h has tcf_queue_work])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tcf_queue_work(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_QUEUE_WORK, 1,
			  [tcf_queue_work is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h has tcf_exts_init])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tcf_exts_init(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_EXTS_INIT, 1,
			  [tcf_exts_init is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h has tcf_exts_get_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tcf_exts_get_dev(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_EXTS_GET_DEV, 1,
			  [tcf_exts_get_dev is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h has __tc_indr_block_cb_register])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		__tc_indr_block_cb_register(NULL, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE___TC_INDR_BLOCK_CB_REGISTER, 1,
			  [__tc_indr_block_cb_register is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if have __flow_indr_block_cb_register])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_offload.h>
	],[
		__flow_indr_block_cb_register(NULL, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE___FLOW_INDR_BLOCK_CB_REGISTER, 1,
			  [__flow_indr_block_cb_register is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if have netif_is_gretap])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/if.h>
		#include <net/gre.h>
	],[
		struct net_device dev = {};

		netif_is_gretap(&dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_IS_GRETAP, 1,
			  [netif_is_gretap is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if have netif_is_vxlan])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/vxlan.h>
	],[
		struct net_device dev = {};

		netif_is_vxlan(&dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_IS_VXLAN, 1,
			  [netif_is_vxlan is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tc_act/tc_mirred.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_mirred.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_TC_ACT_TC_MIRRED_H, 1,
			  [net/tc_act/tc_mirred.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_mirred.h has is_tcf_mirred_redirect])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_mirred.h>
	],[
		is_tcf_mirred_redirect(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_MIRRED_REDIRECT, 1,
			  [is_tcf_mirred_redirect is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_mirred.h has is_tcf_mirred_egress_redirect])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_mirred.h>
	],[
		is_tcf_mirred_egress_redirect(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_MIRRED_EGRESS_REDIRECT, 1,
			  [is_tcf_mirred_egress_redirect is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_mirred.h has is_tcf_mirred_mirror])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_mirred.h>
	],[
		is_tcf_mirred_mirror(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_MIRRED_MIRROR, 1,
			  [is_tcf_mirred_mirror is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_mirred.h has is_tcf_mirred_egress_mirror])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_mirred.h>
	],[
		is_tcf_mirred_egress_mirror(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_MIRRED_EGRESS_MIRROR, 1,
			  [is_tcf_mirred_egress_mirror is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_mirred.h has tcf_mirred_ifindex])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_mirred.h>
	],[
		tcf_mirred_ifindex(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_MIRRED_IFINDEX, 1,
			  [tcf_mirred_ifindex is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_mirred.h has tcf_mirred_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_mirred.h>
	],[
		tcf_mirred_dev(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_MIRRED_DEV, 1,
			  [tcf_mirred_dev is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/ipv6_stubs.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/ipv6_stubs.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_STUBS_H, 1,
			  [net/ipv6_stubs.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_gact.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_gact.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_GACT_H, 1,
			  [tc_gact.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_gact.h has is_tcf_gact_goto_chain])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_gact.h>
	],[
		is_tcf_gact_goto_chain(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_GACT_GOTO_CHAIN, 1,
			  [is_tcf_gact_goto_chain is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_gact.h has is_tcf_gact_shot])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_gact.h>
	],[
		is_tcf_gact_shot(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_GACT_SHOT, 1,
			  [is_tcf_gact_shot is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_gact.h has is_tcf_gact_ok])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_gact.h>
	],[
		struct tc_action a = {};
		is_tcf_gact_ok(&a);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_GACT_OK, 1,
			  [is_tcf_gact_ok is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_gact.h has __is_tcf_gact_act with 3 variables])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_gact.h>
	],[
		struct tc_action a = {};
		__is_tcf_gact_act(&a, 0, false);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_GACT_ACT, 1,
			  [__is_tcf_gact_act is defined with 3 variables])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_gact.h has __is_tcf_gact_act with 2 variables])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_gact.h>
	],[
		struct tc_action a = {};
		__is_tcf_gact_act(&a, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_GACT_ACT_OLD, 1,
			  [__is_tcf_gact_act is defined with 2 variables])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_skbedit.h has is_tcf_skbedit_mark])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_skbedit.h>
	],[
		is_tcf_skbedit_mark(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_SKBEDIT_MARK, 1,
			  [is_tcf_skbedit_mark is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_get_iflink])

	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops x = {
			.ndo_get_iflink = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_IFLINK, 1,
			  [ndo_get_iflink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_fix_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops x = {
			.ndo_fix_features = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_FIX_FEATURES, 1,
			  [ndo_fix_features is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_rx_flow_steer])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int rx_flow_steer(struct net_device *dev,
                                                     const struct sk_buff *skb,
                                                     u16 rxq_index,
                                                     u32 flow_id)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_rx_flow_steer = rx_flow_steer;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_RX_FLOW_STEER, 1,
			  [ndo_rx_flow_steer is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops has *ndo_get_stats64 that returns void])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		void get_stats_64(struct net_device *dev,
						  struct rtnl_link_stats64 *storage)
		{
			return;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_get_stats64 = get_stats_64;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_STATS64_RET_VOID, 1,
			  [ndo_get_stats64 is defined and returns void])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if debugfs_create_u8 function returns struct])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/debugfs.h>
	],[
		u8 test;
		struct dentry *dbg_status;

		dbg_status = debugfs_create_u8("status", 0600, NULL, &test);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEBUGFS_CREATE_U8_RET_STRUCT, 1,
			  [debugfs_create_u8 function returns struct])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct rtnl_link_stats64 is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct rtnl_link_stats64 x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RTNL_LINK_STATS64, 1,
			  [rtnl_link_stats64 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_get_stats64])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		struct rtnl_link_stats64* get_stats_64(struct net_device *dev,
                                                     struct rtnl_link_stats64 *storage)
		{
			struct rtnl_link_stats64 stats_64;
			return &stats_64;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_get_stats64 = get_stats_64;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_STATS64, 1,
			  [ndo_get_stats64 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_stats_to_stats64])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_stats_to_stats64(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_STATS_TO_STATS64, 1,
			[netdev_stats_to_stats64 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops ndo_vlan_rx_add_vid has 3 parameters ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int vlan_rx_add_vid(struct net_device *dev,__be16 proto, u16 vid)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_vlan_rx_add_vid = vlan_rx_add_vid;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_RX_ADD_VID_HAS_3_PARAMS, 1,
			  [ndo_vlan_rx_add_vid has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops ndo_vlan_rx_add_vid has 2 parameters and returns int])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int vlan_rx_add_vid(struct net_device *dev, u16 vid)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops = {
			.ndo_vlan_rx_add_vid = vlan_rx_add_vid,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_RX_ADD_VID_HAS_2_PARAMS_RET_INT, 1,
			  [ndo_vlan_rx_add_vid has 2 parameters and returns int])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops has ndo_get_phys_port_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int get_phys_port_id(struct net_device *dev,
				     struct netdev_phys_port_id *ppid)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_get_phys_port_id = get_phys_port_id;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_NDO_GET_PHYS_PORT_ID, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has ndo_get_port_parent_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int get_port_parent_id(struct net_device *dev,
				       struct netdev_phys_item_id *ppid)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_get_port_parent_id = get_port_parent_id;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_PORT_PARENT_ID, 1,
			  [HAVE_NDO_GET_PORT_PARENT_ID is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_extended has ndo_get_phys_port_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int get_phys_port_name(struct net_device *dev,
				       char *name, size_t len)
		{
			return 0;
		}
	],[
		struct net_device_ops_extended netdev_ops;

		netdev_ops.ndo_get_phys_port_name = get_phys_port_name;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_PHYS_PORT_NAME_EXTENDED, 1,
			  [ is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_ext exist])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_ext netdev_ops_ext = {
			.size = sizeof(struct net_device_ops_ext),
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_OPS_EXT, 1,
			  [struct net_device_ops_ext is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended exist])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_extended ops_extended;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_OPS_EXTENDED, 1,
			  [struct net_device_ops_extended is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct struct dcbnl_rtnl_ops_ext exist])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/dcbnl.h>
	],[
		struct dcbnl_rtnl_ops_ext ops_extended;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DCBNL_RTNL_OPS_EXTENDED, 1,
			  [struct dcbnl_rtnl_ops_ext is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_ext has ndo_get_phys_port_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int get_phys_port_id(struct net_device *dev,
				     struct netdev_phys_port_id *ppid)
		{
			return 0;
		}
	],[
		struct net_device_ops_ext netdev_ops_ext;

		netdev_ops_ext.ndo_get_phys_port_id = get_phys_port_id;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_EXT_NDO_GET_PHYS_PORT_ID, 1,
			  [ndo_get_phys_port_id is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops has ndo_set_vf_spoofchk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_spoofchk(struct net_device *dev, int vf, bool setting)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_set_vf_spoofchk = set_vf_spoofchk;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_NDO_SET_VF_SPOOFCHK, 1,
			  [ndo_set_vf_spoofchk is defined in net_device_ops])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops has ndo_set_vf_trust])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_trust(struct net_device *dev, int vf, bool setting)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_set_vf_trust = set_vf_trust;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_NDO_SET_VF_TRUST, 1,
			  [ndo_set_vf_trust is defined in net_device_ops])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_extended has ndo_set_vf_trust])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_trust(struct net_device *dev, int vf, bool setting)
		{
			return 0;
		}
	],[
		struct net_device_ops_extended netdev_ops;

		netdev_ops.ndo_set_vf_trust = set_vf_trust;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_NDO_SET_VF_TRUST_EXTENDED, 1,
			  [extended ndo_set_vf_trust is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has ndo_set_vf_vlan])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops netdev_ops = {
			.ndo_set_vf_vlan = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SET_VF_VLAN, 1,
			  [ndo_set_vf_vlan is defined in net_device_ops])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended has ndo_set_vf_vlan])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_extended netdev_ops_extended = {
			.ndo_set_vf_vlan = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SET_VF_VLAN_EXTENDED, 1,
			  [ndo_set_vf_vlan is defined in net_device_ops_extended])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_ext has ndo_set_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_ext netdev_ops_ext;

		netdev_ops_ext.ndo_set_features = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_EXT_NDO_SET_FEATURES, 1,
			  [ndo_set_features is defined in net_device_ops_ext])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_ext has ndo_fix_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops_ext netdev_ops_ext;

		netdev_ops_ext.ndo_fix_features = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_EXT_NDO_FIX_FEATURES, 1,
			  [ndo_fix_features is defined in net_device_ops_ext])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_ext has ndo_set_vf_spoofchk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_spoofchk(struct net_device *dev, int vf, bool setting)
		{
			return 0;
		}
	],[
		struct net_device_ops_ext netdev_ops_ext;

		netdev_ops_ext.ndo_set_vf_spoofchk = set_vf_spoofchk;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_EXT_NDO_SET_VF_SPOOFCHK, 1,
			  [ndo_set_vf_spoofchk is defined in net_device_ops_ext])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops has ndo_set_vf_link_state])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_link_state(struct net_device *dev, int vf, int link_state)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;

		netdev_ops.ndo_set_vf_link_state = set_vf_link_state;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_NDO_SET_VF_LINK_STATE, 1,
			  [ndo_set_vf_link_state is defined in net_device_ops])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_ext has ndo_set_vf_link_state])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_link_state(struct net_device *dev, int vf, int link_state)
		{
			return 0;
		}
	],[
		struct net_device_ops_ext netdev_ops_ext;

		netdev_ops_ext.ndo_set_vf_link_state = set_vf_link_state;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_OPS_EXT_NDO_SET_VF_LINK_STATE, 1,
			  [ndo_set_vf_link_state is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netif_set_real_num_tx_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netif_set_real_num_tx_queues(NULL, 2);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_SET_REAL_NUM_TX_QUEUES, 1,
			  [netif_set_real_num_tx_queues is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netif_set_real_num_tx_queues return value exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int ret;

		ret = netif_set_real_num_tx_queues(NULL, 2);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_SET_REAL_NUM_TX_QUEUES_NOT_VOID, 1,
			  [netif_set_real_num_tx_queues return value exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has enum netdev_lag_tx_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		enum netdev_lag_tx_type x;
		x = 0;

		return x;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LAG_TX_TYPE, 1,
			  [enum netdev_lag_tx_type is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdevice.h has struct xps_map])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct xps_map map;
		map.len = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XPS_MAP, 1,
			  [struct xps_map is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool_ext has set_phys_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops_ext en_ethtool_ops_ext = {
			.set_phys_id = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SET_PHYS_ID_EXT, 1,
			  [set_phys_id is defined in ethtool_ops_ext])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_channels])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_channels = NULL,
			.set_channels = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_CHANNELS, 1,
			  [get/set_channels is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_msglevel])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_msglevel = NULL,
			.set_msglevel = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_MSGLEVEL, 1,
			  [get/set_msglevel is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_link_ksettings])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_link_ksettings = NULL,
			.set_link_ksettings = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_LINK_KSETTINGS, 1,
			  [get/set_link_ksettings is defined])
	],[
		AC_MSG_RESULT(no)
	])

       AC_MSG_CHECKING([if ethtool supports 25G,50G,100G link speeds])
       MLNX_BG_LB_LINUX_TRY_COMPILE([
              #include <uapi/linux/ethtool.h>
       ],[
              const enum ethtool_link_mode_bit_indices speeds[] = {
                      ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
                      ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
                      ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT
              };

              return 0;
       ],[
              AC_MSG_RESULT(yes)
              MLNX_AC_DEFINE(HAVE_ETHTOOL_25G_50G_100G_SPEEDS, 1,
                        [ethtool supprts 25G,50G,100G link speeds])
       ],[
              AC_MSG_RESULT(no)
       ])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_priv_flags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_priv_flags = NULL,
			.set_priv_flags = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_PRIV_FLAGS, 1,
			  [get/set_priv_flags is defined])
	],[
		AC_MSG_RESULT(no)
	])

       AC_MSG_CHECKING([if ethtool supports 50G-pre-lane link modes])
       MLNX_BG_LB_LINUX_TRY_COMPILE([
              #include <uapi/linux/ethtool.h>
       ],[
              const enum ethtool_link_mode_bit_indices speeds[] = {
		ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
		ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
		ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
		ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
		ETHTOOL_LINK_MODE_50000baseDR_Full_BIT,
		ETHTOOL_LINK_MODE_100000baseKR2_Full_BIT,
		ETHTOOL_LINK_MODE_100000baseSR2_Full_BIT,
		ETHTOOL_LINK_MODE_100000baseCR2_Full_BIT,
		ETHTOOL_LINK_MODE_100000baseLR2_ER2_FR2_Full_BIT,
		ETHTOOL_LINK_MODE_100000baseDR2_Full_BIT,
		ETHTOOL_LINK_MODE_200000baseKR4_Full_BIT,
		ETHTOOL_LINK_MODE_200000baseSR4_Full_BIT,
		ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
		ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT,
		ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
		};

              return 0;
       ],[
              AC_MSG_RESULT(yes)
              MLNX_AC_DEFINE(HAVE_ETHTOOL_50G_PER_LANE_LINK_MODES, 1,
                        [ethtool supprts 50G-pre-lane link modes])
       ],[
              AC_MSG_RESULT(no)
       ])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_settings])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_settings = NULL,
			.set_settings = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHTOOL_GET_SET_SETTINGS, 1,
			  [get/set_settings is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_flags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_flags = NULL,
			.set_flags = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_FLAGS, 1,
			  [get/set_flags is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_tso])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_tso = NULL,
			.set_tso = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_TSO, 1,
			  [get/set_tso is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_sg])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_sg = NULL,
			.set_sg = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_SG, 1,
			  [get/set_sg is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_tx_csum])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_tx_csum = NULL,
			.set_tx_csum = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_TX_CSUM, 1,
			  [get/set_tx_csum is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get/set_rx_csum])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_rx_csum = NULL,
			.set_rx_csum = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_RX_CSUM, 1,
			  [get/set_rx_csum is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops_ext has get/set_channels])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops_ext en_ethtool_ops_ext = {
			.get_channels = NULL,
			.set_channels = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_CHANNELS_EXT, 1,
			  [get/set_channels is defined in ethtool_ops_ext])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops has get_ts_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops en_ethtool_ops = {
			.get_ts_info = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_TS_INFO, 1,
			  [get_ts_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops_ext has get_ts_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		const struct ethtool_ops_ext en_ethtool_ops_ext = {
			.get_ts_info = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_TS_INFO_EXT, 1,
			  [get_ts_info is defined in ethtool_ops_ext])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_flow_ext has h_dest])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		unsigned char mac[ETH_ALEN];
		struct ethtool_flow_ext h_ext;

		memcpy(&mac, h_ext.h_dest, ETH_ALEN);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHTOOL_FLOW_EXT_H_DEST, 1,
			  [ethtool_flow_ext has h_dest])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ETH_P_8021AD exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		__be16 vlan_proto = htons(ETH_P_8021AD);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETH_P_8021AD, 1,
			  [ETH_P_8021AD exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ETH_P_IBOE exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/if_ether.h>
	],[
		u16 ether_type = ETH_P_IBOE;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETH_P_IBOE, 1,
			  [ETH_P_IBOE exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if TCA_VLAN_ACT_MODIFY exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/tc_act/tc_vlan.h>
	],[
		u16 x = TCA_VLAN_ACT_MODIFY;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCA_VLAN_ACT_MODIFY, 1,
			  [TCA_VLAN_ACT_MODIFY exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ETH_MIN_MTU exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/if_ether.h>
	],[
		u16 min_mtu = ETH_MIN_MTU;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETH_MIN_MTU, 1,
			  [ETH_MIN_MTU exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ethtool_ops get_rxnfc gets u32 *rule_locs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
		static int mlx4_en_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *c,
					     u32 *rule_locs)
		{
			return 0;
		}
	],[
		struct ethtool_ops x = {
			.get_rxnfc = mlx4_en_get_rxnfc,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHTOOL_OPS_GET_RXNFC_U32_RULE_LOCS, 1,
			  [ethtool_ops get_rxnfc gets u32 *rule_locs])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_vfs_assigned])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		struct pci_dev pdev;
		pci_vfs_assigned(&pdev);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_VFS_ASSIGNED, 1,
			  [pci_vfs_assigned is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h struct pci_driver has sriov_configure])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		struct pci_driver x = {
			.sriov_configure = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_DRIVER_SRIOV_CONFIGURE, 1,
			  [pci_driver sriov_configure is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if __vlan_hwaccel_put_tag has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		struct sk_buff *skb;
		__vlan_hwaccel_put_tag(skb, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_3_PARAMS_FOR_VLAN_HWACCEL_PUT_TAG, 1,
			  [__vlan_hwaccel_put_tag has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has num_rx_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device dev;
		dev.num_rx_queues = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_NUM_RX_QUEUES, 1,
			  [net_device num_rx_queues is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has real_num_rx_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device dev;
		dev.real_num_rx_queues = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_DEVICE_REAL_NUM_RX_QUEUES, 1,
			  [net_device real_num_rx_queues is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has hw_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device dev;
		dev.hw_features = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_HW_FEATURES, 1,
			  [hw_features is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has wanted_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device dev;
		dev.wanted_features = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_WANTED_FEATURES, 1,
			  [wanted_features is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_vlan.h has vlan_features_check])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		vlan_features_check(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VLAN_FEATURES_CHECK, 1,
			  [vlan_features_check is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if vxlan.h has vxlan_features_check])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/vxlan.h>
	],[
		vxlan_features_check(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VXLAN_FEATURES_CHECK, 1,
			  [vxlan_features_check is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if vxlan.h has vxlan_vni_field])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/vxlan.h>
	],[
		vxlan_vni_field(0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VXLAN_VNI_FIELD, 1,
			  [vxlan_vni_field is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has hw_enc_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device dev;
		dev.hw_enc_features = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_HW_ENC_FEATURES, 1,
			  [hw_enc_features is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has mpls_features])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device dev;
		dev.mpls_features = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_MPLS_FEATURES, 1,
			  [mpls_features is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device has rx_cpu_rmap])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device dev;
		dev.rx_cpu_rmap = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_RX_CPU_RMAP, 1,
			  [rx_cpu_rmap is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has IFF_UNICAST_FLT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int x = IFF_UNICAST_FLT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_IFF_UNICAST_FLT, 1,
			  [IFF_UNICAST_FLT is defined])
	],[
		AC_MSG_RESULT(no)
	])


	AC_MSG_CHECKING([if netdevice.h has IFF_LIVE_ADDR_CHANGE])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int x = IFF_LIVE_ADDR_CHANGE;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_IFF_LIVE_ADDR_CHANGE, 1,
			  [IFF_LIVE_ADDR_CHANGE is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has dev_uc_del])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		dev_uc_del(NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_UC_DEL, 1,
			  [dev_uc_del is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has dev_mc_del])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		dev_mc_del(NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_MC_DEL, 1,
			  [dev_mc_del is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_for_each_mc_addr])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct netdev_hw_addr *ha;
		struct net_device *netdev;
		netdev_for_each_mc_addr(ha, netdev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_FOR_EACH_MC_ADDR, 1,
			  [netdev_for_each_mc_addr is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_for_each_lower_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *lag, *dev;
		struct list_head *iter;
		netdev_for_each_lower_dev(lag, dev, iter);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_FOR_EACH_LOWER_DEV, 1,
			  [netdev_for_each_lower_dev is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if irqdesc.h has irq_desc_get_irq_data])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/irq.h>
		#include <linux/irqdesc.h>
	],[
		struct irq_desc desc;
		struct irq_data *data = irq_desc_get_irq_data(&desc);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IRQ_DESC_GET_IRQ_DATA, 1,
			  [irq_desc_get_irq_data is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if cpumask.h has cpumask_available])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/cpumask.h>
	],[
                cpumask_available(NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CPUMASK_AVAILABLE, 1,
			  [cpumask_available is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if irq.h irq_data has member affinity])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/irq.h>
		#include <linux/cpumask.h>
	],[
		struct irq_data y;
		const struct cpumask *x = y.affinity;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IRQ_DATA_AFFINITY, 1,
			  [irq_data member affinity is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if interrupt.h has irq_set_affinity_hint])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/interrupt.h>
	],[
		int x = irq_set_affinity_hint(0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IRQ_SET_AFFINITY_HINT, 1,
			  [irq_set_affinity_hint is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci_dev has pcie_mpss])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		struct pci_dev *pdev;

		pdev->pcie_mpss = 0;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_DEV_PCIE_MPSS, 1,
			  [pcie_mpss is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/if_ether.h exist])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/if_ether.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UAPI_LINUX_IF_ETHER_H, 1,
			  [uapi/linux/if_ether.h exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ifla_vf_info has spoofchk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		struct ifla_vf_info *ivf;

		ivf->spoofchk = 0;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VF_INFO_SPOOFCHK, 1,
			  [spoofchk is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ifla_vf_info has trust])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		struct ifla_vf_info *ivf;

		ivf->trusted = 0;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VF_INFO_TRUST, 1,
			  [trust is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_link.h has IFLA_VF_IB_NODE_PORT_GUID])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		int type = IFLA_VF_IB_NODE_GUID;

		type = IFLA_VF_IB_PORT_GUID;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IFLA_VF_IB_NODE_PORT_GUID, 1,
			  [trust is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if kthread.h has struct kthread_work])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kthread.h>
	],[
		struct kthread_work x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KTHREAD_WORK, 1,
			  [struct kthread_work is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if kthread.h has kthread_queue_work])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kthread.h>
	],[
		kthread_queue_work(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KTHREAD_QUEUE_WORK, 1,
			  [kthread_queue_work is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/timecounter.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/timecounter.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TIMECOUNTER_H, 1,
			  [linux/timecounter.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	# timecounter_adjtime can be in timecounter.h or clocksource.h
	AC_MSG_CHECKING([if linux/timecounter.h has timecounter_adjtime])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/timecounter.h>
	],[
		struct timecounter x;
		s64 y = 0;
		timecounter_adjtime(&x, y);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TIMECOUNTER_ADJTIME, 1,
			  [timecounter_adjtime is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/clocksource.h has timecounter_adjtime])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/clocksource.h>
	],[
		struct timecounter x;
		s64 y = 0;
		timecounter_adjtime(&x, y);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TIMECOUNTER_ADJTIME, 1,
			  [timecounter_adjtime is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has napi_schedule_irqoff])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		napi_schedule_irqoff(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NAPI_SCHEDULE_IRQOFF, 1,
			  [napi_schedule_irqoff is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool.h enum ethtool_stringset has ETH_SS_RSS_HASH_FUNCS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		enum ethtool_stringset x = ETH_SS_RSS_HASH_FUNCS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETH_SS_RSS_HASH_FUNCS, 1,
			  [ETH_SS_RSS_HASH_FUNCS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pkt_cls.h enum enum tc_fl_command has TC_CLSFLOWER_STATS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		enum tc_fl_command x = TC_CLSFLOWER_STATS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CLSFLOWER_STATS, 1,
			  [HAVE_TC_CLSFLOWER_STATS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_cls_flower_offload has stats field])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_cls_flower_offload *f;
		struct flow_stats stats;

		f->stats = stats;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CLS_FLOWER_OFFLOAD_HAS_STATS_FIELD, 1,
			  [HAVE_TC_CLS_FLOWER_OFFLOAD_HAS_STATS_FIELD is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has napi_complete_done])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		napi_complete_done(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NAPI_COMPLETE_DONE, 1,
			  [napi_complete_done is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/inetdevice.h inet_confirm_addr has 5 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/inetdevice.h>
        ],[
               inet_confirm_addr(NULL, NULL, 0, 0, 0);

                return 0;
        ],[
                AC_MSG_RESULT(yes)
                MLNX_AC_DEFINE(HAVE_INET_CONFIRM_ADDR_5_PARAMS, 1,
                          [inet_confirm_addr has 5 parameters])
        ],[
                AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if linux/inetdevice.h has for_ifa define])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/inetdevice.h>
        ],[
		struct in_device *in_dev;

		for_ifa(in_dev) {
		}

		endfor_ifa(in_dev);
        ],[
                AC_MSG_RESULT(yes)
                MLNX_AC_DEFINE(HAVE_FOR_IFA, 1,
                          [for_ifa defined])
        ],[
                AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if netdevice.h has netdev_rss_key_fill])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_rss_key_fill(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_RSS_KEY_FILL, 1,
			  [netdev_rss_key_fill is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_port_same_parent_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_port_same_parent_id(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_PORT_SAME_PARENT_ID, 1,
			  [netdev_port_same_parent_id is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has struct netdev_phys_item_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct netdev_phys_item_id x;
		x.id_len = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_PHYS_ITEM_ID, 1,
			  [netdev_phys_item_id is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if cyclecounter_cyc2ns has 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/timecounter.h>
	],[
		cyclecounter_cyc2ns(NULL, 0, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CYCLECOUNTER_CYC2NS_4_PARAMS, 1,
			  [cyclecounter_cyc2ns has 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h struct net_device_ops has ndo_features_check])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		static const struct net_device_ops mlx4_netdev_ops = {
			.ndo_features_check	= NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_FEATURES_T, 1,
			  [netdev_features_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h struct net_device_ops has ndo_gso_check])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		static const struct net_device_ops netdev_ops = {
			.ndo_gso_check= NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GSO_CHECK, 1,
			  [ndo_gso_check is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_features.h has NETIF_F_HW_TLS_RX])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		netdev_features_t tls_rx = NETIF_F_HW_TLS_RX;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_HW_TLS_RX, 1,
			[NETIF_F_HW_TLS_RX is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_features.h has NETIF_F_RXFCS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		netdev_features_t rxfcs = NETIF_F_RXFCS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_RXFCS, 1,
			[NETIF_F_RXFCS is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_features.h has NETIF_F_HW_VLAN_STAG_RX])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		netdev_features_t stag = NETIF_F_HW_VLAN_STAG_RX;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_HW_VLAN_STAG_RX, 1,
			[NETIF_F_HW_VLAN_STAG_RX is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_features.h has NETIF_F_RXALL])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		netdev_features_t rxfcs = NETIF_F_RXALL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_RXALL, 1,
			[NETIF_F_RXALL is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_features.h has NETIF_F_GRO_HW])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		netdev_features_t value = NETIF_F_GRO_HW;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_GRO_HW, 1,
			[NETIF_F_GRO_HW is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has NETIF_IS_LAG_MASTER])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev;
		netif_is_lag_master(dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_IS_LAG_MASTER, 1,
			[NETIF_IS_LAG_MASTER is defined in netdevice.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has NETIF_IS_LAG_PORT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev;
		netif_is_lag_port(dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_IS_LAG_PORT, 1,
			[NETIF_IS_LAG_PORT is defined in netdevice.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_features.h has NETIF_IS_BOND_MASTER])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev;
		return netif_is_bond_master(dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_IS_BOND_MASTER, 1,
			[NETIF_IS_BOND_MASTER is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])
	AC_MSG_CHECKING([if if_vlan.h has vlan_hwaccel_do_receive with *skb])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		struct sk_buff *skb = NULL;
		vlan_hwaccel_do_receive(skb);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VLAN_HWACCEL_DO_RECEIVE_SKB_PTR, 1,
			[vlan_hwaccel_do_receive have *skb in if_vlan.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_vlan.h has vlan_gro_frags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		vlan_gro_frags(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VLAN_GRO_FRAGS, 1,
			[vlan_gro_frags is defined in if_vlan.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_vlan.h has vlan_gro_receive])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_vlan.h>
	],[
		vlan_gro_receive(NULL, NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VLAN_GRO_RECEIVE, 1,
			[vlan_gro_receive is defined in if_vlan.h])
	],[
		AC_MSG_RESULT(no)
	])

       AC_MSG_CHECKING([if if_vlan.h has vlan_hwaccel_rx])
       MLNX_BG_LB_LINUX_TRY_COMPILE([
               #include <linux/if_vlan.h>
       ],[
               vlan_hwaccel_rx(NULL, NULL, 0);

               return 0;
       ],[
               AC_MSG_RESULT(yes)
               MLNX_AC_DEFINE(HAVE_VLAN_HWACCEL_RX, 1,
                       [vlan_hwaccel_rx is defined in if_vlan.h])
       ],[
               AC_MSG_RESULT(no)
       ])

	AC_MSG_CHECKING([if ktime.h ktime is union and has tv64])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ktime.h>
	],[
		ktime_t x;
		x.tv64 = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KTIME_UNION_TV64, 1,
			  [ktime is union and has tv64])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h skb_shared_info has UNION tx_flags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct skb_shared_info x;
		x.tx_flags.flags = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_SHARED_INFO_UNION_TX_FLAGS, 1,
			  [skb_shared_info has union tx_flags])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if vxlan have ndo_add_vxlan_port])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		#if IS_ENABLED(CONFIG_VXLAN)
		void add_vxlan_port(struct net_device *dev, sa_family_t sa_family, __be16 port)
		{
			return;
		}
		#endif
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_add_vxlan_port = add_vxlan_port;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_ADD_VXLAN_PORT, 1,
			[ndo_add_vxlan_port is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_add_vxlan_port have udp_tunnel_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		#if IS_ENABLED(CONFIG_VXLAN)
		void add_vxlan_port(struct net_device *dev, struct udp_tunnel_info *ti)
		{
			return;
		}
		#endif

	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_udp_tunnel_add = add_vxlan_port;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_UDP_TUNNEL_ADD, 1,
			[ndo_add_vxlan_port is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended has ndo_udp_tunnel_add])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		#if IS_ENABLED(CONFIG_VXLAN)
		void add_vxlan_port(struct net_device *dev, struct udp_tunnel_info *ti)
		{
			return;
		}
		#endif

	],[
		struct net_device_ops_extended x = {
			.ndo_udp_tunnel_add = add_vxlan_port,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_UDP_TUNNEL_ADD_EXTENDED, 1,
			[extended ndo_add_vxlan_port is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if vxlan.h has vxlan_gso_check])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/vxlan.h>
	],[
		vxlan_gso_check(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VXLAN_GSO_CHECK, 1,
			  [vxlan_gso_check is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dst.h has dst_get_neighbour])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/dst.h>
	],[
		struct neighbour *neigh = dst_get_neighbour(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DST_GET_NEIGHBOUR, 1,
			  [dst_get_neighbour is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dst.h has skb_dst_update_pmtu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/dst.h>
	],[
		struct sk_buff x;
		skb_dst_update_pmtu(&x, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_DST_UPDATE_PMTU, 1,
			  [skb_dst_update_pmtu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ipv6_stub has ipv6_dst_lookup_flow])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/addrconf.h>
	],[
		int x = ipv6_stub->ipv6_dst_lookup_flow(NULL, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_DST_LOOKUP_FLOW, 1,
			  [if ipv6_stub has ipv6_dst_lookup_flow])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dst.h has dst_neigh_lookup])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/dst.h>
	],[
		struct neighbour *neigh = dst_neigh_lookup(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DST_NEIGH_LOOKUP, 1,
			  [dst_neigh_lookup is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h netlink_dump_control has dump])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		struct netlink_dump_control c = {
			.dump = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_DUMP_CONTROL_DUMP, 1,
			  [netlink_dump_control dump is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h has nla_nest_start_noflag])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/netlink.h>
	],[
		nla_nest_start_noflag(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NLA_NEST_START_NOFLAG, 1,
			  [nla_nest_start_noflag exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h has nlmsg_validate_deprecated ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/netlink.h>
	],[
		nlmsg_validate_deprecated(NULL, 0, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NLMSG_VALIDATE_DEPRECATED, 1,
			  [nlmsg_validate_deprecated exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h has nlmsg_parse_deprecated ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/netlink.h>
	],[
		nlmsg_parse_deprecated(NULL, 0, NULL, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NLMSG_PARSE_DEPRECATED, 1,
			  [nlmsg_parse_deprecated exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h has nla_parse_deprecated ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/netlink.h>
	],[
		nla_parse_deprecated(NULL, 0, NULL, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NLA_PARSE_DEPRECATED, 1,
			  [nla_parse_deprecated exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h nla_parse takes 6 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/netlink.h>
	],[
		nla_parse(NULL, 0, NULL, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NLA_PARSE_6_PARAMS, 1,
			  [nla_parse takes 6 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/netlink.h has nla_put_u64_64bit])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/netlink.h>
	],[
		nla_put_u64_64bit(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NLA_PUT_U64_64BIT, 1,
			  [nla_put_u64_64bit is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h netlink_skb_parms has sk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		struct netlink_skb_parms nsp = {
			.sk = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_SKB_PARMS_SK, 1,
			  [netlink_skb_params has sk])
	],[
		AC_MSG_RESULT(no)
	])

        AC_MSG_CHECKING([if netlink.h has netlink_capable])
        MLNX_BG_LB_LINUX_TRY_COMPILE([
                #include <linux/netlink.h>
        ],[
                bool b = netlink_capable(NULL, 0);

                return 0;
        ],[
                AC_MSG_RESULT(yes)
                MLNX_AC_DEFINE(HAVE_NETLINK_CAPABLE, 1,
                          [netlink_capable is defined])
        ],[
                AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if netlink.h netlink_kernel_cfg has input])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		struct netlink_kernel_cfg cfg = {
			.input = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_KERNEL_CFG_INPUT, 1,
			  [netlink_kernel_cfg input is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink_kernel_create has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		netlink_kernel_create(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_KERNEL_CREATE_3_PARAMS, 1,
			  [netlink_kernel_create has 3 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink_dump_start has 5 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		int ret = netlink_dump_start(NULL, NULL, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_DUMP_START_5P, 1,
			  [netlink_dump_start has 5 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h has struct netlink_ext_ack])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		struct netlink_ext_ack x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_EXT_ACK, 1,
			  [struct netlink_ext_ack is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h struct netlink_skb_parms has portid])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		struct netlink_skb_parms xx = {
			.portid = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_SKB_PARMS_PORTID, 1,
			  [struct netlink_skb_parms has portid])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct dcbnl_rtnl_ops has ieee_getmaxrate/ieee_setmaxrate])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>
	],[
		const struct dcbnl_rtnl_ops en_dcbnl_ops = {
			.ieee_getmaxrate = NULL,
			.ieee_setmaxrate = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IEEE_GET_SET_MAXRATE, 1,
			  [ieee_getmaxrate/ieee_setmaxrate is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dcbnl.h dcbnl_rtnl_ops getnumtcs returns int])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>
		static int func1(struct net_device * a, int b, u8 * c) {
			return 0;
		}

	],[
		struct dcbnl_rtnl_ops x = {
			.getnumtcs = func1,
		};
			return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DCBNL_RTNL_OPS_GETNUMTCS_RET_INT, 1,
 			       [getnumtcs returns int])
 	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool.h has get_module_eeprom])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		struct ethtool_ops x = {
			.get_module_eeprom = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_MODULE_EEPROM, 1,
			  [HAVE_GET_MODULE_EEPROM is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool.h has get/set_fecparam])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		struct ethtool_ops x = {
			.get_fecparam = NULL,
			.set_fecparam = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_FECPARAM, 1,
			[get/set_fecparam is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool.h has set_dump])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		struct ethtool_ops x = {
			.set_dump = NULL,
			.get_dump_data = NULL,
			.get_dump_flag = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_SET_DUMP, 1,
			[HAVE_GET_SET_DUMP is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ethtool.h has get_module_eeprom])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		struct ethtool_ops_ext x = {
			.get_module_eeprom = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_MODULE_EEPROM_EXT, 1,
			[HAVE_GET_MODULE_EEPROM_EXT is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h skb_add_rx_frag has 5 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_add_rx_frag(NULL, 0, NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_ADD_RX_FRAG_5_PARAMS, 1,
			  [skb_add_rx_frag has 5 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has skb_put_zero])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		skb_put_zero(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_PUT_ZERO, 1,
			  [skb_put_zero is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h has skb_clear_hash])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff x;
		skb_clear_hash(&x);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_CLEAR_HASH, 1,
			  [skb_clear_hash is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h struct sk_buff has member l4_rxhash])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff x = {
			.l4_rxhash = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_L4_RXHASH, 1,
			  [sk_buff has member l4_rxhash])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h struct sk_buff has member rxhash])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff x = {
			.rxhash = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_RXHASH, 1,
			  [sk_buff has member rxhash])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if skbuff.h struct sk_buff has member sw_hash])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
	],[
		struct sk_buff x = {
			.sw_hash = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKB_SWHASH, 1,
			  [sk_buff has member sw_hash])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if addrconf.h has addrconf_ifid_eui48])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/addrconf.h>
	],[
		int x = addrconf_ifid_eui48(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ADDRCONF_IFID_EUI48, 1,
			  [addrconf_ifid_eui48 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if addrconf.h has addrconf_addr_eui48])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/addrconf.h>
	],[
		addrconf_addr_eui48(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ADDRCONF_ADDR_EUI48, 1,
			  [addrconf_addr_eui48 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if addrconf.h has ipv6_stub])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/addrconf.h>
	],[
		struct ipv6_stub x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_STUB, 1,
			  [ipv6_stub is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if addrconf.h ipv6_dst_lookup takes net])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/addrconf.h>
	],[
		int x = ipv6_stub->ipv6_dst_lookup(NULL, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_DST_LOOKUP_TAKES_NET, 1,
			  [ipv6_dst_lookup takes net])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has struct netdev_bonding_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct netdev_bonding_info x;
		x.master.num_slaves = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_BONDING_INFO, 1,
			  [netdev_bonding_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/net/dcbnl.h struct dcbnl_rtnl_ops has *ieee_getqcn])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>
	],[
		struct dcbnl_rtnl_ops x = {
			.ieee_getqcn = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IEEE_GETQCN, 1,
			  [ieee_getqcn is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dcbnl.h has struct ieee_qcn])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>
	],[
		struct ieee_qcn x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_IEEE_QCN, 1,
			  [ieee_qcn is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dcbnl.h has struct ieee_pfc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>
	],[
		struct ieee_pfc x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_IEEE_PFC, 1,
			  [ieee_pfc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_master_upper_dev_get])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_master_upper_dev_get(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_MASTER_UPPER_DEV_GET, 1,
			  [netdev_master_upper_dev_get is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_master_upper_dev_get_rcu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_master_upper_dev_get_rcu(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_MASTER_UPPER_DEV_GET_RCU, 1,
			  [netdev_master_upper_dev_get_rcu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_for_each_all_upper_dev_rcu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev;
		struct net_device *upper;
		struct list_head *list;

		netdev_for_each_all_upper_dev_rcu(dev, upper, list);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_FOR_EACH_ALL_UPPER_DEV_RCU, 1,
			  [netdev_master_upper_dev_get_rcu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_walk_all_upper_dev_rcu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		struct upper_list {
			struct list_head list;
			struct net_device *upper;
		};

		static int netdev_upper_walk(struct net_device *upper, void *data) {
			return 0;
		}
	],[
		struct net_device *ndev;
		struct list_head upper_list;

		netdev_walk_all_upper_dev_rcu(ndev, netdev_upper_walk, &upper_list);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_WALK_ALL_UPPER_DEV_RCU, 1,
			  [netdev_walk_all_upper_dev_rcu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_walk_all_lower_dev_rcu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		static int netdev_lower_walk(struct net_device *lower, void *data) {
			return 0;
		}
	],[
		struct net_device *ndev;
		void *data;

		netdev_walk_all_lower_dev_rcu(ndev, netdev_lower_walk, &data);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_WALK_ALL_LOWER_DEV_RCU, 1,
			  [netdev_walk_all_lower_dev_rcu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_has_upper_dev_all_rcu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device *dev;
		struct net_device *upper;

		netdev_has_upper_dev_all_rcu(dev, upper);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_HAS_UPPER_DEV_ALL_RCU, 1,
			  [netdev_has_upper_dev_all_rcu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_notifier_changeupper_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct netdev_notifier_changeupper_info info;

		info.master = 1;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_NOTIFIER_CHANGEUPPER_INFO, 1,
			  [netdev_notifier_changeupper_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if build_bug.h has static_assert])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/build_bug.h>
                #define A 5
                #define B 6
	],[
                static_assert(A < B);

                return 0;
        ],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STATIC_ASSERT, 1,
			[build_bug.h has static_assert])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ip_fib.h fib_nh_notifier_info exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bug.h>
		#include <net/ip_fib.h>
	],[
                struct fib_nh_notifier_info fnh_info;
                struct fib_notifier_info info;

                /* also checking family attr in fib_notifier_info */
                info.family = AF_INET;

                return 0;
        ],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FIB_NH_NOTIFIER_INFO, 1,
			[fib_nh_notifier_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if register_fib_notifier has 4 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/fib_notifier.h>
	],[
		register_fib_notifier(NULL, NULL, NULL, NULL);
	],[
	AC_MSG_RESULT(yes)
	MLNX_AC_DEFINE(HAVE_REGISTER_FIB_NOTIFIER_HAS_4_PARAMS, 1,
		[register_fib_notifier has 4 params])
	],[
	AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if function fib_info_nh exists in file net/nexthop.h])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/nexthop.h>
	],[
		fib_info_nh(NULL, 0);
                return 0;
        ],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FIB_INFO_NH, 1,
			[function fib_info_nh exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/lockdep.h has lockdep_assert_held_exclusive])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/lockdep.h>
	],[
		lockdep_assert_held_exclusive(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LOCKUP_ASSERT_HELD_EXCLUSIVE, 1,
			[linux/lockdep.h has lockdep_assert_held_exclusive])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/lockdep.h has lockdep_assert_held_write])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/lockdep.h>
	],[
		lockdep_assert_held_write(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LOCKUP_ASSERT_HELD_WRITE, 1,
			[linux/lockdep.h has lockdep_assert_held_write])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ip_fib.h fib_res_put exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bug.h>
		#include <linux/string.h>
		#include <net/ip_fib.h>
	],[
		fib_res_put(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FIB_RES_PUT, 1,
			[fib_res_put])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ip_fib.h fib_lookup has 4 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bug.h>
		#include <linux/string.h>
		#include <net/ip_fib.h>
	],[
		fib_lookup(NULL, NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FIB_LOOKUP_4_PARAMS, 1,
			[fib_lookup has 4 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if fib_nh has fib_nh_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/ip_fib.h>
	],[
		struct fib_nh x = {
			.fib_nh_dev = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FIB_NH_DEV, 1,
			[fib_nh has fib_nh_dev])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct inet6_ifaddr has member if_list])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/if_inet6.h>
	],[
		struct inet6_ifaddr x;
		struct list_head xlist;
		x.if_list = xlist;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INET6_IF_LIST, 1,
			  [if_list is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if inet6_hashtables.h __inet6_lookup_established  has 7 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/inet6_hashtables.h>
	],[
	        __inet6_lookup_established(NULL,NULL,NULL,0,NULL,0,0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE___INET6_LOOKUP_ESTABLISHED_HAS_7_PARAMS, 1,
			  [__inet6_lookup_established has 7 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if workqueue.h has __cancel_delayed_work])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		__cancel_delayed_work(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE___CANCEL_DELAYED_WORK, 1,
			  [__cancel_delayed_work is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if workqueue.h has WQ_SYSFS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		struct workqueue_struct *my_wq = alloc_workqueue("my_wq", WQ_SYSFS, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_WQ_SYSFS, 1,
			  [WQ_SYSFS is defined])
	],[
		AC_MSG_RESULT(no)
	])
	AC_MSG_CHECKING([if workqueue.h has WQ_NON_REENTRANT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		struct workqueue_struct *my_wq = alloc_workqueue("my_wq", WQ_NON_REENTRANT, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_WQ_NON_REENTRANT, 1,
			  [WQ_NON_REENTRANT is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if workqueue.h has alloc_workqueue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		struct workqueue_struct *my_wq = alloc_workqueue("my_wq", 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ALLOC_WORKQUEUE, 1,
			  [alloc_workqueue is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if workqueue.h has WQ_HIGHPRI])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		struct workqueue_struct *my_wq = alloc_workqueue("my_wq", WQ_HIGHPRI, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_WQ_HIGHPRI, 1,
			  [WQ_HIGHPRI is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if workqueue.h has WQ_MEM_RECLAIM])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		struct workqueue_struct *my_wq = alloc_workqueue("my_wq", WQ_MEM_RECLAIM, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_WQ_MEM_RECLAIM, 1,
			  [WQ_MEM_RECLAIM is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if workqueue.h has WQ_UNBOUND])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		struct workqueue_struct *my_wq = alloc_workqueue("my_wq", WQ_UNBOUND, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_WQ_UNBOUND, 1,
			  [WQ_UNBOUND is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if workqueue.h has WQ_UNBOUND_MAX_ACTIVE])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/workqueue.h>
	],[
		struct workqueue_struct *my_wq = alloc_workqueue("my_wq", WQ_UNBOUND | WQ_UNBOUND_MAX_ACTIVE, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_WQ_UNBOUND_MAX_ACTIVE, 1,
			  [WQ_UNBOUND_MAX_ACTIVE is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if vm_fault_t exist in mm_types.h])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm_types.h>
	],[
		vm_fault_t a;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VM_FAULT_T, 1,
			  [vm_fault_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct mm_struct has member atomic_pinned_vm])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm_types.h>
	],[
		struct mm_struct x;
                atomic64_t y;
		x.pinned_vm = y;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ATOMIC_PINNED_VM, 1,
			  [atomic_pinned_vm is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct mm_struct has member pinned_vm])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm_types.h>
	],[
		struct mm_struct x;
		x.pinned_vm = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PINNED_VM, 1,
			  [pinned_vm is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/if_bonding.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/if_bonding.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UAPI_IF_BONDING_H, 1,
			  [uapi/linux/if_bonding.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if sock.h has sk_clone_lock])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/sock.h>
	],[
		struct sock sk;
		sk_clone_lock(&sk, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_CLONE_LOCK, 1,
			  [sk_clone_lock is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if sock.h sk_wait_data has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/sock.h>
	],[
		sk_wait_data(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_WAIT_DATA_3_PARAMS, 1,
			  [sk_wait_data has 3 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if sock.h sk_data_ready has 2 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/sock.h>
	],[
		static struct socket *mlx_lag_compat_rtnl_sock;
                mlx_lag_compat_rtnl_sock->sk->sk_data_ready(NULL , 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SK_DATA_READY_2_PARAMS, 1,
			  [sk_data_ready has 2 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if proc_fs.h has PDE_DATA])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/proc_fs.h>
	],[
		PDE_DATA(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PDE_DATA, 1,
			  [PDE_DATA is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if route.h struct rtable has member rt_gw_family])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/route.h>
	],[
		struct rtable x = {
			.rt_gw_family = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RT_GW_FAMILY, 1,
			  [rt_gw_family is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h struct class has member ns_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
	],[
		struct class x = {
			.ns_type = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_CLASS_NS_TYPE, 1,
			  [struct class has member ns_type])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if route.h struct rtable has member rt_uses_gateway])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/route.h>
	],[
		struct rtable x = {
			.rt_uses_gateway = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RT_USES_GATEWAY, 1,
			  [rt_uses_gateway is defined])
	],[
		AC_MSG_RESULT(no)
	])

	LB_CHECK_SYMBOL_EXPORT([get_net_ns_by_fd],
		[net/core/net_namespace.c],
		[AC_DEFINE(HAVE_GET_NET_NS_BY_FD_EXPORTED, 1,
			[get_net_ns_by_fd is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([flow_rule_match_cvlan],
		[net/core/flow_offload.c],
		[AC_DEFINE(HAVE_FLOW_RULE_MATCH_CVLAN, 1,
			[flow_rule_match_cvlan is exported by the kernel])],
	[])
	LB_CHECK_SYMBOL_EXPORT([devlink_params_publish],
		[net/core/devlink.c],
		[AC_DEFINE(HAVE_DEVLINK_PARAMS_PUBLISHED, 1,
			[devlink_params_publish is exported by the kernel])],
	[])
	LB_CHECK_SYMBOL_EXPORT([split_page],
		[mm/page_alloc.c],
		[AC_DEFINE(HAVE_SPLIT_PAGE_EXPORTED, 1,
			[split_page is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([ip6_dst_hoplimit],
                [net/ipv6/output_core.c],
                [AC_DEFINE(HAVE_IP6_DST_HOPLIMIT, 1,
                        [ip6_dst_hoplimit is exported by the kernel])],
        [])

	LB_CHECK_SYMBOL_EXPORT([udp4_hwcsum],
		[net/ipv4/udp.c],
		[AC_DEFINE(HAVE_UDP4_HWCSUM, 1,
			[udp4_hwcsum is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([__ip_dev_find],
		[net/ipv4/devinet.c],
		[AC_DEFINE(HAVE___IP_DEV_FIND, 1,
			[HAVE___IP_DEV_FIND is exported by the kernel])],
	[])
	LB_CHECK_SYMBOL_EXPORT([inet_confirm_addr],
		[net/ipv4/devinet.c],
		[AC_DEFINE(HAVE_INET_CONFIRM_ADDR_EXPORTED, 1,
			[inet_confirm_addr is exported by the kernel])],
	[])

	AC_MSG_CHECKING([if route.h has ip4_dst_hoplimit])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/route.h>
	],[
		ip4_dst_hoplimit(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IP4_DST_HOPLIMIT, 1,
		[ip4_dst_hoplimit is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ipv6.h has ip6_make_flowinfo])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/ipv6.h>
	],[
		ip6_make_flowinfo(0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IP6_MAKE_FLOWINFO, 1,
		[ip6_make_flowinfo is defined])
	],[
		AC_MSG_RESULT(no)
	])

	LB_CHECK_SYMBOL_EXPORT([irq_to_desc],
		[kernel/irq/irqdesc.c],
		[AC_DEFINE(HAVE_IRQ_TO_DESC_EXPORTED, 1,
			[irq_to_desc is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([dev_pm_qos_update_user_latency_tolerance],
		[drivers/base/power/qos.c],
		[AC_DEFINE(HAVE_PM_QOS_UPDATE_USER_LATENCY_TOLERANCE_EXPORTED, 1,
			[dev_pm_qos_update_user_latency_tolerance is exported by the kernel])],
	[])

	AC_MSG_CHECKING([if pm_qos.h has DEV_PM_QOS_RESUME_LATENCY])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pm_qos.h>
	],[
		enum dev_pm_qos_req_type type = DEV_PM_QOS_RESUME_LATENCY;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_PM_QOS_RESUME_LATENCY, 1,
			  [DEV_PM_QOS_RESUME_LATENCY is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pm_qos.h has DEV_PM_QOS_LATENCY_TOLERANCE])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pm_qos.h>
	],[
		enum dev_pm_qos_req_type type = DEV_PM_QOS_LATENCY_TOLERANCE;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_PM_QOS_LATENCY_TOLERANCE, 1,
			  [DEV_PM_QOS_LATENCY_TOLERANCE is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pm_qos.h has PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pm_qos.h>
	],[
		int x = PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT, 1,
			  [PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ptp_clock_kernel.h ptp_clock_register has 2 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ptp_clock_kernel.h>
	],[
		ptp_clock_register(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PTP_CLOCK_REGISTER_2_PARAMS, 1,
			  [ptp_clock_register has 2 params is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if sock.h has skwq_has_sleeper])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/net.h>
		#include <net/sock.h>
	],[
		struct socket_wq wq;
		skwq_has_sleeper(&wq);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SKWQ_HAS_SLEEPER, 1,
			  [skwq_has_sleeper is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net.h sock_create_kern has 5 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/net.h>
		#include <net/sock.h>
	],[
		sock_create_kern(NULL, 0, 0, 0, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SOCK_CREATE_KERN_5_PARAMS, 1,
			  [sock_create_kern has 5 params is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h pci_physfn])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		struct pci_dev x;
		pci_physfn(&x);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_PHYSFN, 1,
			  [pci_physfn is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_pool_zalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_pool_zalloc(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_POOL_ZALLOC, 1,
			  [pci_pool_zalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/printk.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/printk.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_PRINTK_H, 1,
			  [linux/printk.h is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if printk.h has struct va_format])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/printk.h>
	],[
		struct va_format x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VA_FORMAT, 1,
			  [va_format is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if printk.h has print_hex_dump_debug])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/printk.h>
	],[
		print_hex_dump_debug(" TEST ", 0, 0, 0, NULL, 0, true);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PRINT_HEX_DUMP_DEBUG, 1,
			  [print_hex_dump_debug is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdevice.h has NETIF_F_RXHASH])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int x = NETIF_F_RXHASH;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_RXHASH, 1,
			  [NETIF_F_RXHASH is defined in netdevice.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if  netdev_features.h has NETIF_F_GSO_UDP_L4])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		int x = NETIF_F_GSO_UDP_L4;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_GSO_UDP_L4, 1,
			  [HAVE_NETIF_F_GSO_UDP_L4 is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdev_features.h has NETIF_F_RXHASH])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		int x = NETIF_F_RXHASH;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_RXHASH, 1,
			  [NETIF_F_RXHASH is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdev_features.h has NETIF_F_GSO_UDP_TUNNEL])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		int x = NETIF_F_GSO_UDP_TUNNEL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_GSO_UDP_TUNNEL, 1,
			  [NETIF_F_GSO_UDP_TUNNEL is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdev_features.h has NETIF_F_GSO_UDP_TUNNEL_CSUM])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		int x = NETIF_F_GSO_UDP_TUNNEL_CSUM;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_GSO_UDP_TUNNEL_CSUM, 1,
			  [NETIF_F_GSO_UDP_TUNNEL_CSUM is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdev_features.h has NETIF_F_GSO_GRE_CSUM])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		int x = NETIF_F_GSO_GRE_CSUM;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_GSO_GRE_CSUM, 1,
			  [NETIF_F_GSO_GRE_CSUM is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdev_features.h has NETIF_F_GSO_PARTIAL])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdev_features.h>
	],[
		int x = NETIF_F_GSO_PARTIAL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_F_GSO_PARTIAL, 1,
			  [NETIF_F_GSO_PARTIAL is defined in netdev_features.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iova.h has struct iova_rcache])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/iova.h>
	],[
		struct iova_rcache *c = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IOVA_RCACHE, 1,
			  [struct iova_rcache is defined in iova.h])
	],[
		AC_MSG_RESULT(no)
	])

	# this checker will test if the function exist
	# it may get:  warning: ?*((void *)&dev+548)? is used uninitialized in this function [-Wuninitialized]
	# but wont fail compilaton
	AC_MSG_CHECKING([if if_vlan.h has is_vlan_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <linux/if_vlan.h>
	],[
		struct net_device dev;
		is_vlan_dev(&dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_VLAN_DEV, 1,
			  [is_vlan_dev is defined])
	],[
		AC_MSG_RESULT(no)
	])

	# this checker will test if the function exist AND gets const
	# otherwise it will fail.
	AC_MSG_CHECKING([if if_vlan.h has is_vlan_dev get const])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <linux/if_vlan.h>
	],[
		const struct net_device *dev;
		is_vlan_dev(dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_VLAN_DEV_CONST, 1,
			  [is_vlan_dev get const])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_bridge_setlink])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
				   u16 flags)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_bridge_setlink = bridge_setlink;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_BRIDGE_SETLINK, 1,
			  [ndo_bridge_setlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_bridge_setlink])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
				   u16 flags, struct netlink_ext_ack *extack)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_bridge_setlink = bridge_setlink;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_BRIDGE_SETLINK_EXTACK, 1,
			  [ndo_bridge_setlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_bridge_getlink])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
				   struct net_device *dev, u32 filter_mask,
				   int nlflags)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_bridge_getlink = bridge_getlink;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_BRIDGE_GETLINK_NLFLAGS, 1,
			  [ndo_bridge_getlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_bridge_getlink])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
				   struct net_device *dev, u32 filter_mask)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_bridge_getlink = bridge_getlink;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_BRIDGE_GETLINK, 1,
			  [ndo_bridge_getlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/rtnetlink.h] has ndo_dflt_bridge_getlink)
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rtnetlink.h>
	],[
		ndo_dflt_bridge_getlink(NULL, 0, 0, NULL, 0, 0, 0,
					0, 0, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_DFLT_BRIDGE_GETLINK_FLAG_MASK_NFLAGS_FILTER, 1,
			  [ndo_dflt_bridge_getlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/rtnetlink.h] has ndo_dflt_bridge_getlink)
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rtnetlink.h>
	],[
		ndo_dflt_bridge_getlink(NULL, 0, 0, NULL, 0, 0, 0,
					0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_DFLT_BRIDGE_GETLINK_FLAG_MASK_NFLAGS, 1,
			  [ndo_dflt_bridge_getlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/rtnetlink.h] has ndo_dflt_bridge_getlink)
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rtnetlink.h>
	],[
		ndo_dflt_bridge_getlink(NULL, 0, 0, NULL, 0, 0, 0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_DFLT_BRIDGE_GETLINK_FLAG_MASK, 1,
			  [ndo_dflt_bridge_getlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/rtnetlink.h] has ndo_dflt_bridge_getlink)
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rtnetlink.h>
	],[
		ndo_dflt_bridge_getlink(NULL, 0, 0, NULL, 0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_DFLT_BRIDGE_GETLINK, 1,
			  [ndo_dflt_bridge_getlink is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_set_vf_mac])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_mac(struct net_device *dev, int queue, u8 *mac)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_set_vf_mac = set_vf_mac;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SET_VF_MAC, 1,
			  [ndo_set_vf_mac is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_get_vf_stats])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int get_vf_stats(struct net_device *dev, int vf, struct ifla_vf_stats *vf_stats)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_get_vf_stats = get_vf_stats;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_VF_STATS, 1,
			  [ndo_get_vf_stats is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops has *ndo_set_vf_guid])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int set_vf_guid(struct net_device *dev, int vf, u64 guid, int guid_type)
		{
			return 0;
		}
	],[
		struct net_device_ops netdev_ops;
		netdev_ops.ndo_set_vf_guid = set_vf_guid;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_SET_VF_GUID, 1,
			  [ndo_set_vf_guid is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if if_link.h struct has struct ifla_vf_stats])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>

	],[
		struct ifla_vf_stats x;
		x = x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IFLA_VF_STATS, 1,
			  [struct ifla_vf_stats is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_num_vf])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		struct pci_dev x;
		pci_num_vf(&x);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_NUM_VF, 1,
			  [pci_num_vf is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_irq_get_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_irq_get_node(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_IRQ_GET_NODE, 1,
			  [pci_irq_get_node is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_irq_get_affinity])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_irq_get_affinity(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_IRQ_GET_AFFINITY, 1,
			  [pci_irq_get_affinity is defined])
	],[
		AC_MSG_RESULT(no)
	])

	LB_CHECK_SYMBOL_EXPORT([elfcorehdr_addr],
		[kernel/crash_dump.c],
		[AC_DEFINE(HAVE_ELFCOREHDR_ADDR_EXPORTED, 1,
			[elfcorehdr_addr is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([fib_lookup],
		[net/ipv4/fib_rules.c],
		[AC_DEFINE(HAVE_FIB_LOOKUP_EXPORTED, 1,
			[fib_lookup is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([idr_get_next_ul],
		[lib/idr.c],
		[AC_DEFINE(HAVE_IDR_GET_NEXT_UL_EXPORTED, 1,
			[idr_get_next_ul is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([idr_get_next],
		[lib/idr.c],
		[AC_DEFINE(HAVE_IDR_GET_NEXT_EXPORTED, 1,
			[idr_get_next is exported by the kernel])],
	[])

	AC_MSG_CHECKING([if idr struct has idr_rt])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		struct idr tmp_idr;
		struct radix_tree_root tmp_radix;

		tmp_idr.idr_rt = tmp_radix;
		tmp_idr.idr_base = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDR_RT, 1,
			  [struct idr has idr_rt])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr_remove return value exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		void *ret;

		ret = idr_remove(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDR_REMOVE_RETURN_VALUE, 1,
			  [idr_remove return value exists])
	],[
		AC_MSG_RESULT(no)
	])
	AC_MSG_CHECKING([if idr.h has idr_for_each_entry])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
                int id;
		void * entry;
		struct idr * tmp_idr;
		idr_for_each_entry(tmp_idr, entry, id);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDR_FOR_EACH_ENTRY, 1,
			  [idr_for_each_entry is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr.h has idr_preload_end])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		idr_preload_end();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDR_PRELOAD_END, 1,
			  [idr_preload_end is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr.h has idr_alloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		idr_alloc(NULL, NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDR_ALLOC, 1,
			  [idr_alloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr.h has ida_is_empty])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		struct ida ida;
		ida_is_empty(&ida);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDA_IS_EMPTY, 1,
			  [ida_is_empty is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr.h has idr_is_empty])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		struct ida ida;
		idr_is_empty(&ida.idr);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDR_IS_EMPTY, 1,
			  [idr_is_empty is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr.h has ida_simple_get])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		ida_simple_get(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDA_SIMPLE_GET, 1,
			  [ida_simple_get is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if xarray is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/xarray.h>
	],[
                struct xa_limit x;
		
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XARRAY, 1,
			  [xa_array is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if nospec.h has array_index_nospec])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/nospec.h>
	],[
		array_index_nospec(0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ARRAY_INDEX_NOSPEC, 1,
			  [array_index_nospec is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr.h has ida_alloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		ida_alloc(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDA_ALLOC, 1,
			  [ida_alloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if idr.h has ida_alloc_max])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/idr.h>
	],[
		ida_alloc_max(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IDA_ALLOC_MAX, 1,
			  [ida_alloc_max is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if random.h has prandom_u32])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/random.h>
	],[
		prandom_u32();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PRANDOM_U32, 1,
			  [prandom_u32 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if timekeeping.h has ktime_get_real_ns])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ktime.h>
		#include <linux/timekeeping.h>
	],[
		ktime_get_real_ns();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KTIME_GET_REAL_NS, 1,
			  [ktime_get_real_ns is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if timekeeping.h has ktime_get_boot_ns])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ktime.h>
		#include <linux/timekeeping.h>
	],[
		ktime_get_boot_ns();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KTIME_GET_BOOT_NS, 1,
			  [ktime_get_boot_ns is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_transfer_length is defind])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_cmnd.h>
	],[
		scsi_transfer_length(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_TRANSFER_LENGTH, 1,
			  [scsi_transfer_length is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has strnicmp])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/string.h>
	],[
		char a[10] = "aaa";
		char b[10] = "bbb";
		strnicmp(a, b, sizeof(a));

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRNICMP, 1,
			  [strnicmp is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has kfree_const])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/string.h>
	],[
		const char *x;
		kfree_const(x);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KFREE_CONST, 1,
			  [kfree_const is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if alloc_etherdev_mq is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/etherdevice.h>
	],[
		alloc_etherdev_mq(0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ALLOC_ETHERDEV_MQ, 1,
			  [alloc_etherdev_mq is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netif_set_real_num_rx_queues is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		int rc = netif_set_real_num_rx_queues(NULL, 0);

		return rc;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_SET_REAL_NUM_RX_QUEUES, 1,
			  [netif_set_real_num_rx_queues is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct dcbnl_rtnl_ops has get/set ets and dcbnl defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>
	],[
		const struct dcbnl_rtnl_ops en_dcbnl_ops = {
			.ieee_getets = NULL,
			.ieee_setets = NULL,
		};

		struct net_device dev = {
			.dcbnl_ops = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IEEE_DCBNL_ETS, 1,
			  [ieee_getets/ieee_setets is defined and dcbnl defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct dcbnl_rtnl_ops has dcbnl_get/set buffer])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/dcbnl.h>
	],[
		const struct dcbnl_rtnl_ops en_dcbnl_ops = {
			.dcbnl_getbuffer = NULL,
			.dcbnl_setbuffer = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DCBNL_GETBUFFER, 1,
			  [struct dcbnl_rtnl_ops has dcbnl_get/set buffer])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if list.h hlist_for_each_entry has 3 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/list.h>

		struct mlx5_l2_addr_node {
			struct hlist_node hlist;
			u8                addr[10];
		};
	],[
		struct mlx5_l2_addr_node *hn;
		struct hlist_head *hash;
		hlist_for_each_entry(hn, hash, hlist);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_HLIST_FOR_EACH_ENTRY_3_PARAMS, 1,
			  [hlist_for_each_entry has 3 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h has dev_vprintk_emit])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>

	],[
		dev_vprintk_emit(0, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_PRINTK_EMIT, 1,
			  [device.h has dev_vprintk_emit])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h struct class has dev_groups])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>

	],[
		struct class cm_class = {
			.dev_groups   = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_GROUPS, 1,
			  [struct class has dev_groups])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h struct class has class_groups])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>

	],[
		struct class cm_class = {
			.class_groups   = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CLASS_GROUPS, 1,
			  [struct class has class_groups])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h struct vm_operations_struct has .fault])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
		static vm_fault_t rdma_umap_fault(struct vm_fault *vmf) {
			return NULL;
		}

	],[
		struct vm_operations_struct rdma_umap_ops = {
			.fault = rdma_umap_fault,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_VM_OPERATIONS_STRUCT_HAS_FAULT, 1,
			  [vm_operations_struct has .fault])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h class devnode gets umode_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
		static char *cm_devnode(struct device *dev, umode_t *mode) {
			return NULL;
		}

	],[
		struct class cm_class = {
			.devnode = cm_devnode,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CLASS_DEVNODE_UMODE_T, 1,
			  [class devnode gets umode_t])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h CLASS_ATTR_STRING])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
		#include <linux/stat.h>
		#include <linux/stringify.h>
	],[
		CLASS_ATTR_STRING(abi_version, S_IRUGO,
			 __stringify(5));

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CLASS_ATTR_STRING, 1,
			  [CLASS_ATTR_STRING is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h struct device has dma_ops])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
	],[
		struct device devx = {
			.dma_ops = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVICE_DMA_OPS, 1,
			  [struct device has dma_ops])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h(ppc) has struct dev_arch_dmadata])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
	],[
		struct dev_arch_dmadata x;
		x.dma_offset = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_ARCH_DMADATA_DMA_OFFSET, 1,
			  [device.h(ppc) has struct dev_arch_dmadata])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h(ppc) has struct dev_archdata with dma_data union and dma_offset in it])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
	],[
		struct dev_archdata x;
		x.dma_data.dma_offset = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_ARCHDATA_DMA_OFFSET_IN_DMA_DATA_UNION, 1,
			  [if device.h(ppc) has struct dev_archdata with dma_data union and dma_offset in it])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if file.h has fdget])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/file.h>
	],[
		fdget(0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FDGET, 1,
			  [fdget is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if file.h has get_unused_fd_flags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/file.h>
		/* Don't use backported get_unused_fd_flags
		** it uses an unexported function
		*/
		#ifdef get_unused_fd_flags
		#undef get_unused_fd_flags
		#endif
	],[
		get_unused_fd_flags(0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_UNUSED_FD_FLAGS, 1,
			  [GET_UNUSED_FD_FLAGS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow.h has flowi4, flowi6 - AF specific instances])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bug.h>
		#include <net/flow.h>
	],[
		struct flowi4 fl4;
		struct flowi6 fl6;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOWI_AF_SPECIFIC_INSTANCES, 1,
			  [flowi4, flowi6  is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pat.h has pat_enabled as a function])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <asm/pat.h>
	],[
		bool px = pat_enabled();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PAT_ENABLED_AS_FUNCTION, 1,
			  [pat.h has pat_enabled as a function])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if icmpv6.h icmpv6_send has 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/icmpv6.h>
	],[
		icmpv6_send(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ICMPV6_SEND_4_PARAMS, 1,
			  [icmpv6_send has 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dst_ops.h update_pmtu has 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
		#include <net/dst_ops.h>

		static void mtu_up (struct dst_entry *dst, struct sock *sk,
				    struct sk_buff *skb, u32 mtu)
		{
			return;
		}
	],[
		struct dst_ops x = {
			.update_pmtu = mtu_up,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UPDATE_PMTU_4_PARAMS, 1,
			  [update_pmtu has 4 paramters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if rtnetlink.h rtnl_link_ops newlink has 4 paramters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/rtnetlink.h>

		static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
						struct nlattr *tb[], struct nlattr *data[])
		{
			return 0;
		}
	],[
		struct rtnl_link_ops x = {
			.newlink = ipoib_new_child_link,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RTNL_LINK_OPS_NEWLINK_4_PARAMS, 1,
			  [newlink has 4 paramters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if rtnetlink.h rtnl_link_ops newlink has 5 paramters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
		#include <net/rtnetlink.h>

		static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
										struct nlattr *tb[], struct nlattr *data[],
										struct netlink_ext_ack *extack)
		{
			return 0;
		}
	],[
		struct rtnl_link_ops x = {
			.newlink = ipoib_new_child_link,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RTNL_LINK_OPS_NEWLINK_5_PARAMS, 1,
			  [newlink has 5 paramters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/ipv6.h has ipv6_mod_enabled])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ipv6.h>
	],[

		ipv6_mod_enabled();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_MOD_ENABLED, 1,
			  [ipv6_mod_enabled is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ipv6.h has ipv6_addr_copy])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/ipv6.h>
	],[

		struct in6_addr x1;
		const struct in6_addr x2;
		ipv6_addr_copy(&x1, &x2);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IPV6_ADDR_COPY, 1,
			  [ipv6_addr_copy is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/flow_keys.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/skbuff.h>
		#include <net/flow_keys.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_FLOW_KEYS_H, 1,
			  [net/flow_keys.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netif_tx_queue_stopped])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netif_tx_queue_stopped(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_TX_QUEUE_STOPPED, 1,
			  [netif_tx_queue_stopped is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netif_trans_update])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netif_trans_update(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_TRANS_UPDATE, 1,
			  [netif_trans_update is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/inet_lro.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/inet_lro.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INET_LRO_H, 1,
			  [include/linux/inet_lro.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netif_xmit_stopped])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netif_xmit_stopped(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_XMIT_STOPPED, 1,
			  [netif_xmit_stopped is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_xmit_more])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_xmit_more();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_XMIT_MORE, 1,
			  [netdev_xmit_more is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_get_tx_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_get_tx_queue(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_GET_TX_QUEUE, 1,
			  [netdev_get_tx_queue is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h alloc_netdev_mqs has 5 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		alloc_netdev_mqs(0, NULL, NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ALLOC_NETDEV_MQS_5_PARAMS, 1,
			  [alloc_netdev_mqs has 5 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h alloc_netdev_mq has 4 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		alloc_netdev_mq(0, NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ALLOC_NETDEV_MQ_4_PARAMS, 1,
			  [alloc_netdev_mq has 4 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h get_user_pages has 8 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		get_user_pages(NULL, NULL, 0, 0, 0, 0, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GET_USER_PAGES_8_PARAMS, 1,
			[get_user_pages has 8 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has FOLL_LONGTERM])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		int x = FOLL_LONGTERM;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FOLL_LONGTERM, 1,
			[FOLL_LONGTERM is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has kvzalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		kvzalloc(0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KVZALLOC, 1,
			[kvzalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has mmget])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched/mm.h>
	],[
		mmget(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMGET, 1,
			[mmget is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has mmget_not_zero])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
                #include <linux/sched/mm.h>
	],[
		mmget_not_zero(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMGET_NOT_ZERO, 1,
			[mmget_not_zero is defined])
	],[
		MLNX_BG_LB_LINUX_TRY_COMPILE([
			#include <linux/sched.h>
		],[
			mmget_not_zero(NULL);

			return 0;
		],[
			AC_MSG_RESULT(yes)
			MLNX_AC_DEFINE(HAVE_MMGET_NOT_ZERO, 1,
				[NESTED: mmget_not_zero is defined])
		],[
			AC_MSG_RESULT(no)
		])
	])

	AC_MSG_CHECKING([if mm.h has mmgrab])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched/mm.h>
	],[
		mmgrab(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMGRAB, 1,
			[mmgrab is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has kvmalloc_array])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		kvmalloc_array(0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
	MLNX_AC_DEFINE(HAVE_KVMALLOC_ARRAY, 1,
			[kvmalloc_array is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has kvmalloc_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		kvmalloc_node(0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KVMALLOC_NODE, 1,
			[kvmalloc_node is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has kvmalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		kvmalloc(0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KVMALLOC, 1,
			[kvmalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has kvzalloc_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		kvzalloc_node(0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KVZALLOC_NODE, 1,
			[kvzalloc_node is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has kvcalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		kvcalloc(0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KVCALLOC, 1,
			[kvcalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm_types.h struct page has _count])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
		#include <linux/mm_types.h>
	],[
		struct page p;
		p._count.counter = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MM_PAGE__COUNT, 1,
			  [struct page has _count])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/ethtool.h has ETHTOOL_xLINKSETTINGS API])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ethtool.h>
	],[
		enum ethtool_link_mode_bit_indices x = ETHTOOL_LINK_MODE_TP_BIT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ETHTOOL_xLINKSETTINGS, 1,
			  [ETHTOOL_xLINKSETTINGS API is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if configfs.h default_groups is list_head])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/configfs.h>
	],[
		struct config_group x = {
			.group_entry = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CONFIGFS_DEFAULT_GROUPS_LIST, 1,
			  [default_groups is list_head])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/irq_poll.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/irq_poll.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IRQ_POLL_H, 1,
			  [include/linux/irq_poll.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if slab.h has kmalloc_array])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/slab.h>
	],[
		kmalloc_array(0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KMALLOC_ARRAY, 1,
			  [kmalloc_array is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if kernel.h has reciprocal_scale])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kernel.h>
	],[
		reciprocal_scale(0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RECIPROCAL_SCALE, 1,
			  [reciprocal_scale is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if hex2bin return value exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kernel.h>
	],[
		int ret;

		ret = hex2bin(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_HEX2BIN_NOT_VOID, 1,
			  [hex2bin return value exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if io_mapping_map_wc has 3 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/io-mapping.h>
	],[
		io_mapping_map_wc(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IO_MAPPING_MAP_WC_3_PARAMS, 1,
			  [io_mapping_map_wc has 3 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/dma-mapping.h has struct dma_attrs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		struct dma_attrs *attrs;
		int ret;

		ret = dma_get_attr(DMA_ATTR_WRITE_BARRIER, attrs);

		return ret;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_DMA_ATTRS, 1,
			  [struct dma_attrs is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct blk_mq_ops has map_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		struct blk_mq_ops ops = {
			.map_queue = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_OPS_MAP_QUEUE, 1,
			  [struct blk_mq_ops has map_queue])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_freeze_queue_wait_timeout])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_freeze_queue_wait_timeout(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_FREEZE_QUEUE_WAIT_TIMEOUT, 1,
			  [blk_mq_freeze_queue_wait_timeout is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_freeze_queue_wait])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_freeze_queue_wait(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_FREEZE_QUEUE_WAIT, 1,
			  [blk_mq_freeze_queue_wait is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct blk_mq_ops has map_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		struct blk_mq_ops ops = {
			.map_queues = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_OPS_MAP_QUEUES, 1,
			  [struct blk_mq_ops has map_queues])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/blk-mq-pci.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq-pci.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_PCI_H, 1,
			  [include/linux/blk-mq-pci.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-mapping.h has DMA_ATTR_NO_WARN])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		int x = DMA_ATTR_NO_WARN;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_ATTR_NO_WARN, 1,
			  [DMA_ATTR_NO_WARN is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-mapping.h has dma_zalloc_coherent function])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		dma_zalloc_coherent(NULL, 0, NULL, GFP_KERNEL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_ZALLOC_COHERENT, 1,
			  [dma-mapping.h has dma_zalloc_coherent function])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-mapping.h has dma_alloc_attrs takes unsigned long attrs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		dma_alloc_attrs(NULL, 0, NULL, GFP_KERNEL, DMA_ATTR_NO_KERNEL_MAPPING);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_SET_ATTR_TAKES_UNSIGNED_LONG_ATTRS, 1,
			  [dma_alloc_attrs takes unsigned long attrs])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if filter.h has struct xdp_buff])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/filter.h>
	],[
		struct xdp_buff d = {
			.data = NULL,
			.data_end = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDP_BUFF, 1,
			  [xdp is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if filter.h struct xdp_buff has data_hard_start])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/filter.h>
	],[
		struct xdp_buff d = {
			.data_hard_start = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDP_BUFF_DATA_HARD_START, 1,
			  [xdp_buff data_hard_start is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/xdp.h has struct xdp_frame])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/xdp.h>
	],[
		struct xdp_frame f = {};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDP_FRAME, 1,
			  [struct xdp_frame is defined])
	],[
		AC_MSG_RESULT(no)
			AC_MSG_CHECKING([if net/xdp.h has struct xdp_frame workaround for 5.4.17-2011.1.2.el8uek.x86_64])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/uek_kabi.h>
				#include <net/xdp.h>

			],[
				struct xdp_frame f = {};

				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_XDP_FRAME, 1,
					  [NESTED: struct xdp_frame is defined in 5.4.17-2011.1.2.el8uek.x86_64])
			],[
				AC_MSG_RESULT(no)
			])
	])

	AC_MSG_CHECKING([if filter.h has xdp_set_data_meta_invalid])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/filter.h>
	],[
		struct xdp_buff d;
		xdp_set_data_meta_invalid(&d);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDP_SET_DATA_META_INVALID, 1,
			  [xdp_set_data_meta_invalid is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi.h has SG_MAX_SEGMENTS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi.h>
	],[
		int x = SG_MAX_SEGMENTS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SG_MAX_SEGMENTS, 1,
			  [SG_MAX_SEGMENTS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_device.h has SCSI_SCAN_INITIAL])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_device.h>
	],[
		int x = SCSI_SCAN_INITIAL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_SCAN_INITIAL, 1,
			  [SCSI_SCAN_INITIAL is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_device.h has enum scsi_scan_mode])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_device.h>
	],[
		enum scsi_scan_mode xx = SCSI_SCAN_INITIAL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ENUM_SCSI_SCAN_MODE, 1,
			  [enum scsi_scan_mode is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_device.h has blist_flags_t])
       	MLNX_BG_LB_LINUX_TRY_COMPILE([
               	#include <scsi/scsi_device.h>
        ],[
               blist_flags_t x = 0;

               return 0;
        ],[
               AC_MSG_RESULT(yes)
               MLNX_AC_DEFINE(HAVE_BLIST_FLAGS_T, 1,
                         [blist_flags_t is defined])
        ],[
               AC_MSG_RESULT(no)
        ])

	AC_MSG_CHECKING([if iscsi_transport.h struct iscsit_transport has member rdma_shutdown])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_transport.h>
	],[
		struct iscsit_transport it = {
			.rdma_shutdown = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSIT_TRANSPORT_RDMA_SHUTDOWN, 1,
			  [rdma_shutdown is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iscsi_transport.h struct iscsit_transport has member iscsit_get_rx_pdu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_transport.h>

		static void isert_get_rx_pdu(struct iscsi_conn *conn)
		{
			return;
		}
	],[
		struct iscsit_transport it = {
			.iscsit_get_rx_pdu = isert_get_rx_pdu,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSIT_TRANSPORT_ISCSIT_GET_RX_PDU, 1,
			  [iscsit_get_rx_pdu is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iscsi_target_core.h struct iscsi_conn has member login_sockaddr])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_target_core.h>
	],[
		struct iscsi_conn c = {
			.login_sockaddr = {0},
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_CONN_LOGIN_SOCKADDR, 1,
			  [iscsi_conn has member login_sockaddr])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iscsi_target_core.h struct iscsi_conn has member local_sockaddr])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_target_core.h>
	],[
		struct iscsi_conn c = {
			.local_sockaddr = {0},
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_CONN_LOCAL_SOCKADDR, 1,
			  [iscsi_conn has members local_sockaddr])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk_queue_virt_boundary exist])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_queue_virt_boundary(NULL, 0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_QUEUE_VIRT_BOUNDARY, 1,
				[blk_queue_virt_boundary exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blkdev.h has blk_rq_is_passthrough])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_rq_is_passthrough(NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_RQ_IS_PASSTHROUGH, 1,
				[blk_rq_is_passthrough is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if target_put_sess_cmd has 1 parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/target_core_base.h>
		#include <target/target_core_fabric.h>
	],[
		target_put_sess_cmd(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TARGET_PUT_SESS_CMD_HAS_1_PARAM, 1,
			  [target_put_sess_cmd in target_core_fabric.h has 1 parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_device.h has scsi_change_queue_depth])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_device.h>
	],[
		scsi_change_queue_depth(NULL, 0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_CHANGE_QUEUE_DEPTH, 1,
			[scsi_change_queue_depth exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_host.h struct scsi_host_template has member track_queue_depth])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct scsi_host_template sh = {
			.track_queue_depth = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_TEMPLATE_TRACK_QUEUE_DEPTH, 1,
			[scsi_host_template has members track_queue_depth])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk-mq.h has blk_mq_unique_tag])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_unique_tag(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_UNIQUE_TAG, 1,
				[blk_mq_unique_tag exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_host.h struct Scsi_Host has member nr_hw_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct Scsi_Host sh = {
			.nr_hw_queues = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_NR_HW_QUEUES, 1,
				[Scsi_Host has members nr_hw_queues])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_host.h struct Scsi_Host has member max_segment_size])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct Scsi_Host sh = {
			.max_segment_size = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_MAX_SEGMENT_SIZE, 1,
				[Scsi_Host has members max_segment_size])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_host.h struct Scsi_Host has member virt_boundary_mask])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct Scsi_Host sh = {
			.virt_boundary_mask = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_VIRT_BOUNDARY_MASK, 1,
				[Scsi_Host has members virt_boundary_mask])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iscsi_target_core and iscsi_target_stat.h are under include/])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_target_core.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_TARGET_CORE_ISCSI_TARGET_STAT_H, 1,
			  [iscsi_target_core.h and iscsi_target_stat.h are under include/])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iscsi_target_core.h has iscsit_find_cmd_from_itt])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_target_core.h>
	],[
		iscsit_find_cmd_from_itt(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSIT_FIND_CMD_FROM_ITT, 1,
		[iscsit_find_cmd_from_itt is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_cmnd.h struct scsi_cmnd  has member prot_flags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_cmnd.h>
	],[
		struct scsi_cmnd sc = {
			.prot_flags = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_CMND_PROT_FLAGS, 1,
			[scsi_cmnd has members prot_flags])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_transport_iscsi.h struct iscsi_transport has member check_protection])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_transport_iscsi.h>
	],[
		struct iscsi_transport iscsi_iser_transport = {
			.check_protection = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_TRANSPORT_CHECK_PROTECTION, 1,
			  [check_protection is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct iscsi_transport attr_is_visible returns umode_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_transport_iscsi.h>
		static umode_t iser_attr_is_visible(int param_type, int param)
		{
			return 0;
		}

	],[
		struct iscsi_transport iscsi_iser_transport = {
			.attr_is_visible = iser_attr_is_visible,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ATTR_IS_VISIBLE_RET_UMODE_T, 1,
			  [attr_is_visible returns umode_t])
	],[
		AC_MSG_RESULT(no)
	])

    AC_MSG_CHECKING([if iscsi_transport.h struct iscsit_transport has member iscsit_get_sup_prot_ops])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_transport.h>

		enum target_prot_op get_sup_prot_ops(struct iscsi_conn *conn)
		{
			return 0;
		}

	],[
		struct iscsit_transport it = {
			.iscsit_get_sup_prot_ops = get_sup_prot_ops,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSIT_TRANSPORT_HAS_GET_SUP_PROT_OPS, 1,
			[iscsit_transport has member iscsit_get_sup_prot_ops])
	],[
		AC_MSG_RESULT(no)
	])

    AC_MSG_CHECKING([if target_core_base.h struct se_cmd has member prot_checks])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/target_core_base.h>

	],[
		struct se_cmd se = {
			.prot_checks = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SE_CMD_HAS_PROT_CHECKS, 1,
			[struct se_cmd has member prot_checks])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if target_core_fabric.h has target_reverse_dma_direction function])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/target_core_base.h>
		#include <target/target_core_fabric.h>
	],[
		target_reverse_dma_direction(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TARGET_FABRIC_HAS_TARGET_REVERSE_DMA_DIRECTION, 1,
			  [target_core_fabric.h has target_reverse_dma_direction function])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm_types.h struct mm_struct has free_area_cache ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm_types.h>
	],[
		struct mm_struct x;
		x.free_area_cache = NULL;
		x.cached_hole_size = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MM_STRUCT_FREE_AREA_CACHE, 1,
			[mm_types.h struct mm_struct has free_area_cache])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if types.h has cycle_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/types.h>
	],[
		cycle_t x = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TYPE_CYCLE_T, 1,
			[type cycle_t is defined in linux/types.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/clocksource.h has cycle_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/clocksource.h>
	],[
		cycle_t x = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CLOCKSOURCE_CYCLE_T, 1,
			  [cycle_t is defined in linux/clocksource.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if highmem.h has kmap_atomic function with km_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/highmem.h>
	],[
		kmap_atomic(NULL, KM_USER0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KM_TYPE, 1,
			  [highmem.h has kmap_atomic function with km_type])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iscsi_proto.h has structure iscsi_cmd])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/iscsi_proto.h>
	],[
		struct iscsi_cmd hdr;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_CMD, 1,
			  [iscsi_proto.h has structure iscsi_cmd])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_device.h struct scsi_device has member state_mutex])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mutex.h>
		#include <scsi/scsi_device.h>
	],[
		struct scsi_device sdev;
		mutex_init(&sdev.state_mutex);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_DEVICE_STATE_MUTEX, 1,
			  [scsi_device.h struct scsi_device has member state_mutex])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_namespace.h has register_net_sysctl])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/net_namespace.h>
	],[
		register_net_sysctl(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REGISTER_NET_SYSCTL, 1_SHOULD_BE_FXED_FAILED_ON_PURPOUSE,
			  [register_net_sysctl is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netlink.h has netlink_ns_capable])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netlink.h>
	],[
		netlink_ns_capable(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETLINK_NS_CAPABLE, 1,
			  [netlink_ns_capable is defined])
	],[
		AC_MSG_RESULT(no)
	])
	AC_MSG_CHECKING([if scsi_host.h struct scsi_host_template has member use_blk_tags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct scsi_host_template sh = {
			.use_blk_tags = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_TEMPLATE_USE_BLK_TAGS, 1,
			[scsi_host_template has members use_blk_tags])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_host.h struct scsi_host_template has member change_queue_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct scsi_host_template sh = {
			.change_queue_type = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_TEMPLATE_CHANGE_QUEUE_TYPE, 1,
			[scsi_host_template has members change_queue_type])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_host.h struct scsi_host_template has member use_host_wide_tags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct scsi_host_template sh = {
			.use_host_wide_tags = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_TEMPLATE_USE_HOST_WIDE_TAGS, 1,
			[scsi_host_template has members use_host_wide_tags])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if target_core_base.h se_cmd transport_complete_callback has three params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/target_core_base.h>

		sense_reason_t transport_complete_callback(struct se_cmd *se, bool b, int *i) {
			  return 0;
		}
	],[
		struct se_cmd se = {
			  .transport_complete_callback = transport_complete_callback,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SE_CMD_TRANSPORT_COMPLETE_CALLBACK_HAS_THREE_PARAM, 1,
			  [target_core_base.h se_cmd transport_complete_callback has three params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if target_core_base.h se_cmd supports compare_and_write])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/target_core_base.h>
	],[
		uint64_t flag = SCF_COMPARE_AND_WRITE;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TARGET_SUPPORT_COMPARE_AND_WRITE, 1,
			  [target_core_base.h se_cmd supports compare_and_write])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/lightnvm.h has struct nvm_user_vio])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/genhd.h>
		#include <uapi/linux/lightnvm.h>
	],[
		struct nvm_user_vio vio;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NVM_USER_VIO, 1,
			  [struct nvm_user_vio is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h struct request has rq_flags])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct request rq = { .rq_flags = 0 };
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQUEST_RQ_FLAGS, 1,
			[blkdev.h struct request has rq_flags])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk-mq.h blk_mq_requeue_request has 2 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_requeue_request(NULL, false);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_REQUEUE_REQUEST_2_PARAMS, 1,
			  [blk-mq.h blk_mq_requeue_request has 2 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has blk_mq_quiesce_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
		#include <linux/blk-mq.h>
	],[
		blk_mq_quiesce_queue(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_QUIESCE_QUEUE, 1,
				[blk_mq_quiesce_queue exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk-mq.h has BLK_MQ_F_NO_SCHED])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		int x = BLK_MQ_F_NO_SCHED;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_F_NO_SCHED, 1,
				[BLK_MQ_F_NO_SCHED is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has blk_rq_nr_phys_segments])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_rq_nr_phys_segments(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_RQ_NR_PHYS_SEGMENTS, 1,
			[blk_rq_nr_phys_segments exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has blk_rq_payload_bytes])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_rq_payload_bytes(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_RQ_NR_PAYLOAD_BYTES, 1,
			[blk_rq_payload_bytes exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has req_op])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct request *req;
		req_op(req);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQ_OP, 1,
			[req_op exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has blk_rq_nr_discard_segments])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_rq_nr_discard_segments(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_RQ_NR_DISCARD_SEGMENTS, 1,
			[blk_rq_nr_discard_segments is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci_ids.h has PCI_CLASS_STORAGE_EXPRESS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci_ids.h>
	],[
		int x = PCI_CLASS_STORAGE_EXPRESS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_CLASS_STORAGE_EXPRESS, 1,
			  [PCI_CLASS_STORAGE_EXPRESS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has REQ_OP_DRV_OUT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		enum req_opf xx = REQ_OP_DRV_OUT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_TYPES_REQ_OP_DRV_OUT, 1,
			  [REQ_OP_DRV_OUT is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has blk_mq_req_flags_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		blk_mq_req_flags_t x = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_REQ_FLAGS_T, 1,
			  [blk_mq_req_flags_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/cgroup_rdma.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/cgroup_rdma.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CGROUP_RDMA_H, 1,
			  [linux/cgroup_rdma exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/pci-p2pdma.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci-p2pdma.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_P2PDMA_H, 1,
			  [linux/pci-p2pdma.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/sched/signal.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched/signal.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCHED_SIGNAL_H, 1,
			  [linux/sched/signal.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/sched.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCHED_H, 1,
			  [linux/sched.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/sched/mm.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched/mm.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCHED_MM_H, 1,
			  [linux/sched/mm.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if memalloc_noio_save defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched.h>
		#include <linux/sched/mm.h>
	],[
		unsigned int noio_flag = memalloc_noio_save();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MEMALLOC_NOIO_SAVE, 1,
			  [memalloc_noio_save is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/sched/task.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched/task.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCHED_TASK_H, 1,
			  [linux/sched/task.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/ip_tunnels.h has struct ip_tunnel_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if.h>
		#include <net/ip_tunnels.h>
	],[
		struct ip_tunnel_info ip_tunnel_info_test;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IP_TUNNEL_INFO, 1,
			  [struct ip_tunnel_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/hashtable.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/hashtable.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_HASHTABLE_H, 1,
			  [linux/hashtable.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bpf_trace exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bpf.h>
		#include <linux/bpf_trace.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_BPF_TRACE_H, 1,
			  [linux/bpf_trace exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bpf_trace has trace_xdp_exception])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bpf_trace.h>
	],[
		trace_xdp_exception(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TRACE_XDP_EXCEPTION, 1,
			  [trace_xdp_exception is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bpf.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bpf.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_BPF_H, 1,
			  [uapi/bpf.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	LB_CHECK_SYMBOL_EXPORT([tcf_exts_num_actions],
		[net/sched/cls_api.c],
		[AC_DEFINE(HAVE_TCF_EXTS_NUM_ACTIONS, 1,
			[tcf_exts_num_actions is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([netpoll_poll_dev],
		[net/core/netpoll.c],
		[AC_DEFINE(HAVE_NETPOLL_POLL_DEV_EXPORTED, 1,
			[netpoll_poll_dev is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([bpf_prog_inc],
		[kernel/bpf/syscall.c],
		[AC_DEFINE(HAVE_BPF_PROG_INC_EXPORTED, 1,
			[bpf_prog_inc is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([__put_task_struct],
		[kernel/fork.c],
		[AC_DEFINE(HAVE_PUT_TASK_STRUCT_EXPORTED, 1,
			[__put_task_struct is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([get_pid_task],
		[kernel/pid.c],
		[AC_DEFINE(HAVE_GET_PID_TASK_EXPORTED, 1,
			[get_pid_task is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([get_task_pid],
		[kernel/pid.c],
		[AC_DEFINE(HAVE_GET_TASK_PID_EXPORTED, 1,
			[get_task_pid is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([get_task_comm],
		[fs/exec.c],
		[AC_DEFINE(HAVE_GET_TASK_COMM_EXPORTED, 1,
			[get_task_comm is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([__get_task_comm],
		[fs/exec.c],
		[AC_DEFINE(HAVE___GET_TASK_COMM_EXPORTED, 1,
			[__get_task_comm is exported by the kernel])],
	[])

	AC_MSG_CHECKING([if linux/bpf.h has bpf_prog_sub])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bpf.h>
	],[
		bpf_prog_sub(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BPF_PROG_SUB, 1,
			  [bpf_prog_sub is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bpf.h bpf_prog_aux has feild id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bpf.h>
	],[
		struct bpf_prog_aux x = {
			.id = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BPF_PROG_AUX_FEILD_ID, 1,
			  [bpf_prog_aux has feild id])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if bpf_prog_add\bfs_prog_inc functions return struct])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bpf.h>
	],[
		struct bpf_prog *prog;

		prog = bpf_prog_add(prog, 0);
		prog = bpf_prog_inc(prog);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BPF_PROG_ADD_RET_STRUCT, 1,
			  [bpf_prog_add\bfs_prog_inc functions return struct])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bpf.h has XDP_REDIRECT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bpf.h>
	],[
		enum xdp_action x = XDP_REDIRECT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDP_REDIRECT, 1,
			  [XDP_REDIRECT is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_cls_flower_offload has common])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_cls_flower_offload x = {
			.common = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CLS_FLOWER_OFFLOAD_COMMON, 1,
			  [struct tc_cls_flower_offload has common])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_to_netdev has egress_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct tc_to_netdev x = {
			.egress_dev = false,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_TO_NETDEV_EGRESS_DEV, 1,
			  [struct tc_to_netdev has egress_dev])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_cls_flower_offload has egress_dev])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_cls_flower_offload x = {
			.egress_dev = false,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CLS_FLOWER_OFFLOAD_EGRESS_DEV, 1,
			  [struct tc_cls_flower_offload has egress_dev])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct flow_cls_offload exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_offload.h>
	],[
		struct flow_cls_offload x = {
			.classid = 3,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_CLS_OFFLOAD, 1,
			  [struct flow_cls_offload exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tc_to_netdev has tc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct tc_to_netdev x;
		x.tc = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_TO_NETDEV_TC, 1,
			  [struct tc_to_netdev has tc])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_has_offload_stats gets net_device])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		bool mlx5e_has_offload_stats(const struct net_device *dev, int attr_id)
		{
			return true;
		}
	],[
		struct net_device_ops ndops = {
			.ndo_has_offload_stats = mlx5e_has_offload_stats,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NDO_HAS_OFFLOAD_STATS_GETS_NET_DEVICE, 1,
			  [ndo_has_offload_stats gets net_device])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net_device_ops_extended has ndo_has_offload_stats])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		bool mlx5e_has_offload_stats(const struct net_device *dev, int attr_id)
		{
			return true;
		}
	],[
		struct net_device_ops_extended ndops = {
			.ndo_has_offload_stats = mlx5e_has_offload_stats,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_HAS_OFFLOAD_STATS_EXTENDED, 1,
			  [ndo_has_offload_stats gets net_device])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_get_offload_stats defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int mlx5e_get_offload_stats(int attr_id, const struct net_device *dev,
									void *sp)
		{
			return 0;
		}
	],[
		struct net_device_ops ndops = {
			.ndo_get_offload_stats = mlx5e_get_offload_stats,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_OFFLOAD_STATS, 1,
			  [ndo_get_offload_stats is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct net_device_ops_extended has ndo_get_offload_stats])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>

		int mlx5e_get_offload_stats(int attr_id, const struct net_device *dev,
									void *sp)
		{
			return 0;
		}
	],[
		struct net_device_ops_extended ndops = {
			.ndo_get_offload_stats = mlx5e_get_offload_stats,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NDO_GET_OFFLOAD_STATS_EXTENDED, 1,
			  [extended ndo_get_offload_stats is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ib_umem_notifier_invalidate_range_start has parameter blockable])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_notifier.h>
		static int notifier(struct mmu_notifier *mn,
				    struct mm_struct *mm,
				    unsigned long start,
				    unsigned long end,
				    bool blockable) {
			return 0;
		}
	],[
		static const struct mmu_notifier_ops notifiers = {
			.invalidate_range_start = notifier
		};
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UMEM_NOTIFIER_PARAM_BLOCKABLE, 1,
			  [ib_umem_notifier_invalidate_range_start has parameter blockable])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has struct netdev_notifier_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct netdev_notifier_info x = {
			.dev = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_NOTIFIER_INFO, 1,
			  [struct netdev_notifier_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has field upper_info in struct netdev_notifier_changeupper_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct netdev_notifier_changeupper_info x = {
			.upper_info = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_NOTIFIER_CHANGEUPPER_INFO_UPPER_INFO, 1,
			  [struct netdev_notifier_changeupper_info has upper_info])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tc_act/tc_tunnel_key.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_tunnel_key.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_TC_ACT_TC_TUNNEL_KEY_H, 1,
			  [net/tc_act/tc_tunnel_key.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tc_act/tc_tunnel_key.h has tcf_tunnel_info])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_tunnel_key.h>
	],[
		const struct tc_action xx;
		tcf_tunnel_info(&xx);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_TUNNEL_INFO, 1,
			  [tcf_tunnel_info is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tc_act/tc_pedit.h has tcf_pedit_nkeys])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_pedit.h>
	],[
		const struct tc_action xx;
		tcf_pedit_nkeys(&xx);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_PEDIT_NKEYS, 1,
			  [tcf_pedit_nkeys is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tc_act/tc_pedit.h struct tcf_pedit has member tcfp_keys_ex])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_pedit.h>
	],[
		struct tcf_pedit x = {
			.tcfp_keys_ex = NULL,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_PEDIT_TCFP_KEYS_EX, 1,
			  [struct tcf_pedit has member tcfp_keys_ex])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_device.h has function scsi_internal_device_block])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_device.h>
	],[
		scsi_internal_device_block(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_DEVICE_SCSI_INTERNAL_DEVICE_BLOCK, 1,
			[scsi_device.h has function scsi_internal_device_block])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if libiscsi.h has iscsi_eh_cmd_timed_out])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
		#include <scsi/libiscsi.h>
	],[
		iscsi_eh_cmd_timed_out(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_EH_CMD_TIMED_OUT, 1,
			[iscsi_eh_cmd_timed_out is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/sed-opal.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sed-opal.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_SED_OPAL_H, 1,
			[linux/sed-opal.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if bio.h bio_init has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bio.h>
	],[
		bio_init(NULL, NULL, false);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BIO_INIT_3_PARAMS, 1,
			  [bio.h bio_init has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk_types.h has REQ_IDLE])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		int flags = REQ_IDLE;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQ_IDLE, 1,
			[blk_types.h has REQ_IDLE])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has __blkdev_issue_zeroout])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		__blkdev_issue_zeroout(NULL, 0, 0, 0, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLKDEV_ISSUE_ZEROOUT, 1,
			[__blkdev_issue_zeroout exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if compiler.h has const __read_once_size])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/compiler.h>
	],[
		const unsigned long tmp;
		__read_once_size(&tmp, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CONST_READ_ONCE_SIZE, 1,
			[const __read_once_size exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if configfs_item_operations drop_link returns int])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/configfs.h>

		static int my_drop_link(struct config_item *parent, struct config_item *target)

		{
			return 0;
		}

	],[
		static struct configfs_item_operations item_ops = {
			.drop_link	= my_drop_link,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(CONFIGFS_DROP_LINK_RETURNS_INT, 1,
			  [if configfs_item_operations drop_link returns int])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if argument 3 of config_group_init_type_name should const])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/configfs.h>

		static const struct config_item_type cma_port_group_type = {
			.ct_attrs	= cma_configfs_attributes,
		};

	],[
		config_group_init_type_name(NULL,
					    NULL,
					    &cma_port_group_type);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(CONFIG_GROUP_INIT_TYPE_NAME_PARAM_3_IS_CONST, 1,
			[argument 3 of config_group_init_type_name should const])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/nvme-fc-driver.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
		#include <uapi/scsi/fc/fc_fs.h>
		#include <linux/nvme-fc-driver.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_NVME_FC_DRIVER_H, 1,
			[linux/nvme-fc-driver.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if moduleparam.h has kernel_param_ops])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/moduleparam.h>
	],[
		static struct kernel_param_ops ops = {0};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MODULEPARAM_KERNEL_PARAM_OPS, 1,
			[moduleparam.h has kernel_param_ops])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi_host.h struct scsi_host_template has member lockless])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_host.h>
	],[
		struct scsi_host_template sh = {
			.lockless = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_HOST_TEMPLATE_LOCKLESS, 1,
			[scsi_host_template has members lockless])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_freeze_queue_start])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_freeze_queue_start(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_FREEZE_QUEUE_START, 1,
			  [blk_freeze_queue_start is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h blk_mq_complete_request has 2 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_complete_request(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_COMPLETE_REQUEST_HAS_2_PARAMS, 1,
			  [linux/blk-mq.h blk_mq_complete_request has 2 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h blk_mq_ops init_request has 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>

		int init_request(struct blk_mq_tag_set *set, struct request * req,
				 unsigned int i, unsigned int k) {
			return 0;
		}
	],[
		struct blk_mq_ops ops = {
			.init_request = init_request,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_OPS_INIT_REQUEST_HAS_4_PARAMS, 1,
			  [linux/blk-mq.h blk_mq_ops init_request has 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h blk_mq_ops exit_request has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>

		void exit_request(struct blk_mq_tag_set *set, struct request * req,
				  unsigned int i) {
			return;
		}
	],[
		struct blk_mq_ops ops = {
			.exit_request = exit_request,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_OPS_EXIT_REQUEST_HAS_3_PARAMS, 1,
			  [linux/blk-mq.h blk_mq_ops exit_request has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h blk_mq_tag_set has member map])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		struct blk_mq_tag_set x = {
			.map = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_TAG_SET_HAS_MAP, 1,
			  [blk_mq_tag_set has member map])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h blk_mq_tag_set has member ops is const])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
		static const struct blk_mq_ops xmq = {0};

	],[
		struct blk_mq_tag_set x = {
			.ops = &xmq,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_TAG_SET_HAS_CONST_OPS, 1,
			  [ blk_mq_tag_set member ops is const])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blkdev.h has blk_queue_max_write_zeroes_sectors])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_queue_max_write_zeroes_sectors(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_QUEUE_MAX_WRITE_ZEROES_SECTORS, 1,
			  [blk_queue_max_write_zeroes_sectors is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/pci.h has pci_free_irq])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_free_irq(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_FREE_IRQ, 1,
			  [linux/pci.h has pci_free_irq])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/security.h has register_lsm_notifier])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/security.h>
	],[
		register_lsm_notifier(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REGISTER_LSM_NOTIFIER, 1,
			  [linux/security.h has register_lsm_notifier])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/cdev.h has cdev_set_parent])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/cdev.h>
	],[
		cdev_set_parent(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_CDEV_SET_PARENT, 1,
			  [linux/cdev.h has cdev_set_parent])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/atomic.h has __atomic_add_unless])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/highmem.h>
	],[
		atomic_t x;
		__atomic_add_unless(&x, 1, 1);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE___ATOMIC_ADD_UNLESS, 1,
			  [__atomic_add_unless is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/atomic.h has atomic_fetch_add_unless])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/highmem.h>
	],[
		atomic_t x;
		atomic_fetch_add_unless(&x, 1, 1);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ATOMIC_FETCH_ADD_UNLESS, 1,
			  [atomic_fetch_add_unless is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/net_tstamp.h has HWTSTAMP_FILTER_NTP_ALL])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/net_tstamp.h>
	],[
		int x = HWTSTAMP_FILTER_NTP_ALL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_HWTSTAMP_FILTER_NTP_ALL, 1,
			  [HWTSTAMP_FILTER_NTP_ALL is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/pkt_cls.h has tcf_exts_stats_update])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tcf_exts_stats_update(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_EXTS_STATS_UPDATE, 1,
			  [tcf_exts_stats_update is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct  tcf_exts has actions as array])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tcf_exts x;
		x.actions = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_EXTS_HAS_ARRAY_ACTIONS, 1,
			  [struct  tcf_exts has actions as array])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/pkt_cls.h has tc_cls_can_offload_and_chain0])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		tc_cls_can_offload_and_chain0(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CLS_CAN_OFFLOAD_AND_CHAIN0, 1,
			  [tc_cls_can_offload_and_chain0 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/tc_act/tc_csum.h has TCA_CSUM_UPDATE_FLAG_IPV4HDR])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/tc_act/tc_csum.h>
	],[
		int x = TCA_CSUM_UPDATE_FLAG_IPV4HDR;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCA_CSUM_UPDATE_FLAG_IPV4HDR, 1,
			  [TCA_CSUM_UPDATE_FLAG_IPV4HDR is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tc_act/tc_sum.h has is_tcf_csum])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tc_act/tc_csum.h>
	],[
		is_tcf_csum(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_TCF_CSUM, 1,
			  [is_tcf_csum is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct  tc_action_ops has id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/act_api.h>
	],[
		struct tc_action_ops x = { .id = 0, };

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_ACTION_OPS_HAS_ID, 1,
			  [struct  tc_action_ops has id])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct tcf_common exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/act_api.h>
	],[
		struct tcf_common pc;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_COMMON, 1,
			  [struct tcf_common is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tcf_hash helper functions have tcf_hashinfo parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/act_api.h>
	],[
		tcf_hash_check(0, NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_HASH_WITH_HASHINFO, 1,
			  [tcf_hash helper functions have tcf_hashinfo parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/nvme_ioctl.h has NVME_IOCTL_RESCAN])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/nvme_ioctl.h>
		#include <linux/types.h>
		#include <uapi/asm-generic/ioctl.h>
	],[
		unsigned int x = NVME_IOCTL_RESCAN;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UAPI_LINUX_NVME_IOCTL_RESCAN, 1,
			[uapi/linux/nvme_ioctl.h has NVME_IOCTL_RESCAN])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if refcount.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/refcount.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REFCOUNT, 1,
			  [refcount.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if firmware.h has request_firmware_direct])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/firmware.h>
	],[
		request_firmware_direct(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQUEST_FIRMWARE_DIRECT, 1,
			  [request_firmware_direct is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if nodemask.h has N_MEMORY])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/nodemask.h>
	],[
		enum node_states x = N_MEMORY;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_N_MEMORY, 1,
			  [N_MEMORY is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if topology.h has numa_mem_id])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/firmware.h>
	],[
		int x = numa_mem_id();

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NUMA_MEM_ID, 1,
			  [numa_mem_id is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/netlink.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/netlink.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UAPI_LINUX_NETLINK_H, 1,
			  [uapi/linux/netlink.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/xz.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/xz.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_XZ_H, 1,
			  [linux/xz.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/pr.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/fs.h>
		#include <linux/pr.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PR_H, 1,
			[linux/pr.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/t10-pi.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/t10-pi.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_T10_PI_H, 1,
			[linux/t10-pi.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pm.h struct dev_pm_info has member set_latency_tolerance])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pm.h>
		#include <asm/device.h>
		#include <linux/types.h>

		static void nvme_set_latency_tolerance(struct device *dev, s32 val)
		{
			return;
		}
	],[
		struct dev_pm_info dpinfo = {
			.set_latency_tolerance = nvme_set_latency_tolerance,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEV_PM_INFO_SET_LATENCY_TOLERANCE, 1,
			[set_latency_tolerance is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h blk_mq_alloc_request has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_alloc_request(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_ALLOC_REQUEST_HAS_3_PARAMS, 1,
			  [linux/blk-mq.h blk_mq_alloc_request has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has REQ_TYPE_DRV_PRIV])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		enum rq_cmd_type_bits rctb = REQ_TYPE_DRV_PRIV;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLKDEV_REQ_TYPE_DRV_PRIV, 1,
			[REQ_TYPE_DRV_PRIV is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h blk_add_request_payload has 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_add_request_payload(NULL, NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_ADD_REQUEST_PAYLOAD_HAS_4_PARAMS, 1,
			[blkdev.h blk_add_request_payload has 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has REQ_OP_FLUSH])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		int x = REQ_OP_FLUSH;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_TYPES_REQ_OP_FLUSH, 1,
			[REQ_OP_FLUSH is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has REQ_OP_DISCARD])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		int x = REQ_OP_DISCARD;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_TYPES_REQ_OP_DISCARD, 1,
			[REQ_OP_DISCARD is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has blk_status_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		blk_status_t xx;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_STATUS_T, 1,
			[blk_status_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if bio.h struct bio_integrity_payload has member bip_iter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bio.h>
		#include <linux/bvec.h>
	],[
		struct bvec_iter bip_it = {0};
		struct bio_integrity_payload bip = {
			.bip_iter = bip_it,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BIO_INTEGRITY_PYLD_BIP_ITER, 1,
			[bio_integrity_payload has members bip_iter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has BLK_INTEGRITY_DEVICE_CAPABLE])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		enum  blk_integrity_flags bif = BLK_INTEGRITY_DEVICE_CAPABLE;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_INTEGRITY_DEVICE_CAPABLE, 1,
			[BLK_INTEGRITY_DEVICE_CAPABLE is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has BLK_MAX_WRITE_HINTS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		int x = BLK_MAX_WRITE_HINTS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MAX_WRITE_HINTS, 1,
			[BLK_MAX_WRITE_HINTS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has blk_rq_append_bio])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct bio **bio;

		blk_rq_append_bio(NULL, bio);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_RQ_APPEND_BIO, 1,
			[blk_rq_append_bio is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has blk_init_request_from_bio])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_init_request_from_bio(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_INIT_REQUEST_FROM_BIO, 1,
			[blk_init_request_from_bio is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if device.h has device_remove_file_self])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
	],[
		device_remove_file_self(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVICE_REMOVE_FILE_SELF, 1,
			[device.h has device_remove_file_self])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if genhd.h has device_add_disk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/genhd.h>
	],[
		device_add_disk(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVICE_ADD_DISK, 1,
			[genhd.h has device_add_disk])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if genhd.h has device_add_disk 3 args])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/genhd.h>
	],[
		device_add_disk(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DEVICE_ADD_DISK_3_ARGS, 1,
			[genhd.h has device_add_disk])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_unquiesce_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_unquiesce_queue(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_UNQUIESCE_QUEUE, 1,
			  [blk_mq_unquiesce_queue is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_alloc_request_hctx])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_alloc_request_hctx(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_ALLOC_REQUEST_HCTX, 1,
			  [linux/blk-mq.h has blk_mq_alloc_request_hctx])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/lightnvm.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/lightnvm.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LIGHTNVM_H, 1,
			[linux/lightnvm.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h struct pci_error_handlers has reset_notify])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>

		void reset(struct pci_dev *dev, bool prepare) {
			return;
		}
	],[
		struct pci_error_handlers x = {
			.reset_notify = reset,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_ERROR_HANDLERS_RESET_NOTIFY, 1,
			  [pci.h struct pci_error_handlers has reset_notify])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi.h has SCSI_MAX_SG_SEGMENTS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi.h>
	],[
		int x = SCSI_MAX_SG_SEGMENTS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_MAX_SG_SEGMENTS, 1,
			  [SCSI_MAX_SG_SEGMENTS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/scatterlist.h sg_alloc_table_chained has 4 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
		gfp_t gfp_mask;
		sg_alloc_table_chained(NULL, 0, gfp_mask, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SG_ALLOC_TABLE_CHAINED_4_PARAMS, 1,
			[sg_alloc_table_chained has 4 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/scatterlist.h has sgl_free])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
		sgl_free(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SGL_FREE, 1,
			[sgl_free is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/scatterlist.h has sgl_alloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
		sgl_alloc(0, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SGL_ALLOC, 1,
			[sgl_alloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/scatterlist.h has sg_page_iter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
                struct sg_page_iter sg_iter;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SG_PAGE_ITER, 1,
			[sg_page_iter is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/scatterlist.h has sg_zero_buffer])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
		sg_zero_buffer(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SG_ZERO_BUFFER, 1,
			[sg_zero_buffer is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/uuid.h has uuid_gen])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/uuid.h>
	],[
		uuid_t id;
		uuid_gen(&id);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UUID_GEN, 1,
			[uuid_gen is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/uuid.h has uuid_is_null])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/uuid.h>
	],[
		uuid_t uuid;
		uuid_is_null(&uuid);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UUID_IS_NULL, 1,
			[uuid_is_null is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/uuid.h has uuid_be_to_bin])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/uuid.h>
	],[
		uuid_be_to_bin(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UUID_BE_TO_BIN, 1,
			[uuid_be_to_bin is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/uuid.h has uuid_equal])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/uuid.h>
	],[
		uuid_equal(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UUID_EQUAL, 1,
			[uuid_equal is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/inet.h inet_pton_with_scope])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/inet.h>
	],[
		inet_pton_with_scope(NULL, 0, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INET_PTON_WITH_SCOPE, 1,
			[inet_pton_with_scope is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/nvme_ioctl.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/nvme_ioctl.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UAPI_LINUX_NVME_IOCTL_H, 1,
			[uapi/linux/nvme_ioctl.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has QUEUE_FLAG_WC_FUA])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		int x = QUEUE_FLAG_WC;
		int y = QUEUE_FLAG_FUA;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_QUEUE_FLAG_WC_FUA, 1,
			[QUEUE_FLAG_WC_FUA is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/scatterlist.h sg_alloc_table_chained has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
		sg_alloc_table_chained(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SG_ALLOC_TABLE_CHAINED_3_PARAMS, 1,
			[sg_alloc_table_chained has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_tagset_busy_iter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>

		static void
		nvme_cancel_request(struct request *req, void *data, bool reserved) {
			return;
		}
	],[
		blk_mq_tagset_busy_iter(NULL, nvme_cancel_request, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_TAGSET_BUSY_ITER, 1,
			  [blk_mq_tagset_busy_iter is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct request_queue has q_usage_counter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct percpu_ref counter = {0};
		struct request_queue rq = {
			.q_usage_counter = counter,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQUEST_QUEUE_Q_USAGE_COUNTER, 1,
			  [struct request_queue has q_usage_counter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has memdup_user_nul])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/string.h>
	],[
		memdup_user_nul(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MEMDUP_USER_NUL, 1,
		[memdup_user_nul is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if radix-tree.h has struct radix_tree_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/radix-tree.h>
	],[
		struct radix_tree_node x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RADIX_TREE_NODE, 1,
		[struct radix_tree_node  is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if radix-tree.h has radix_tree_next_chunk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/radix-tree.h>
	],[
		radix_tree_next_chunk(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RADIX_TREE_NEXT_CHUNK, 1,
		[radix_tree_next_chunk is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if radix-tree.h hasradix_tree_is_internal_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/radix-tree.h>
	],[
		radix_tree_is_internal_node(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RADIX_TREE_IS_INTERNAL, 1,
		[radix_tree_is_internal_node is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if radix-tree.h has radix_tree_iter_delete])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/radix-tree.h>
	],[
		radix_tree_iter_delete(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RADIX_TREE_ITER_DELETE, 1,
		[radix_tree_iter_delete is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if radix-tree.h has radix_tree_iter_lookup])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/radix-tree.h>
	],[
		radix_tree_iter_lookup(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RADIX_TREE_ITER_LOOKUP, 1,
		[radix_tree_iter_lookup is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has blk_queue_write_cache])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_queue_write_cache(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_QUEUE_WRITE_CACHE, 1,
			[blkdev.h has blk_queue_write_cache])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_all_tag_busy_iter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>

		static void
		nvme_cancel_request(struct request *req, void *data, bool reserved) {
			return;
		}
	],[
		blk_mq_all_tag_busy_iter(NULL, nvme_cancel_request, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_ALL_TAG_BUSY_ITER, 1,
			  [blk_mq_all_tag_busy_iter is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_update_nr_hw_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_update_nr_hw_queues(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_UPDATE_NR_HW_QUEUES, 1,
			  [blk_mq_update_nr_hw_queues is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_map_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_map_queues(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_MAP_QUEUES, 1,
			  [blk_mq_map_queues is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if etherdevice.h has alloc_etherdev_mqs, alloc_etherdev_mqs, num_tc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/etherdevice.h>
		#include <linux/netdevice.h>
	],[
		struct net_device x = {
			.num_tx_queues = 0,
			.num_tc = 0,
		};
		alloc_etherdev_mqs(0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NEW_TX_RING_SCHEME, 1,
			  [alloc_etherdev_mqs, alloc_etherdev_mqs, num_tc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_set_tc_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_set_tc_queue(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_SET_TC_QUEUE, 1,
			  [netdev_set_tc_queue is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_reset_tc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_reset_tc(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_RESET_TC, 1,
			  [netdev_reset_tc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netif_is_rxfh_configured])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netif_is_rxfh_configured(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_IS_RXFH_CONFIGURED, 1,
			  [netif_is_rxfh_configured is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has enum tc_setup_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		enum tc_setup_type x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_SETUP_TYPE, 1,
			  [TC_SETUP_TYPE is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has TC_SETUP_QDISC_MQPRIO])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		enum tc_setup_type x = TC_SETUP_QDISC_MQPRIO;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_SETUP_QDISC_MQPRIO, 1,
			  [TC_SETUP_QDISC_MQPRIO is defined])
	],[
		AC_MSG_RESULT(no)
	])

	# this one has 2 checkers
	AC_MSG_CHECKING([if pr_debug_ratelimited is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kernel.h>
	],[
		pr_debug_ratelimited("test");

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PR_DEBUG_RATELIMITED, 1,
			  [pr_debug_ratelimited is defined])
	],[
		AC_MSG_RESULT(no)
	])
	# check in another header that does not exist on all kernels
	AC_MSG_CHECKING([if pr_debug_ratelimited is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kernel.h>
		#include <linux/ratelimit.h>
		#include <linux/printk.h>
	],[
		pr_debug_ratelimited("test");

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PR_DEBUG_RATELIMITED, 1,
			  [pr_debug_ratelimited is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct iscsi_transport has attr_is_visible])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_transport_iscsi.h>
	],[
		static struct iscsi_transport iscsi_iser_transport = {
			.attr_is_visible = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_ATTR_IS_VISIBLE, 1,
			  [attr_is_visible is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct iscsi_transport has get_ep_param])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_transport_iscsi.h>
	],[
		static struct iscsi_transport iscsi_iser_transport = {
			.get_ep_param = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_GET_EP_PARAM, 1,
			  [get_ep_param is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if iscsit_set_unsolicited_dataout is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <target/iscsi/iscsi_transport.h>
	],[
		iscsit_set_unsolicited_dataout(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSIT_SET_UNSOLICITED_DATAOUT, 1,
			  [iscsit_set_unsolicited_dataout is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mmu_notifier.h has mmu_notifier_call_srcu])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_notifier.h>
	],[
		mmu_notifier_call_srcu(NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMU_NOTIFIER_CALL_SRCU, 1,
			  [mmu_notifier_call_srcu defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mmu_notifier.h has mmu_notifier_range_blockable])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_notifier.h>
	],[
                const struct mmu_notifier_range *range;

		mmu_notifier_range_blockable(range);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMU_NOTIFIER_RANGE_BLOCKABLE, 1,
			  [mmu_notifier_range_blockable defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mmu_notifier_mm has lock])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_notifier.h>
		#include <linux/spinlock.h>
	],[
                const struct mm_struct *mm;

		spin_is_locked(&mm->mmu_notifier_mm->lock);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMU_NOTIFIER_HAS_LOCK, 1,
			  [mmu_notifier_mm has lock])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ib_umem_notifier_invalidate_range_start get struct mmu_notifier_range ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_notifier.h>
		static int notifier(struct mmu_notifier *mn,
					const struct mmu_notifier_range *range)
		{
			return 0;
		}
	],[
		static const struct mmu_notifier_ops notifiers = {
			.invalidate_range_start = notifier
		};
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMU_NOTIFIER_RANGE_STRUCT, 1,
			  [ ib_umem_notifier_invalidate_range_start get struct mmu_notifier_range ])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mmu_notifier.h has mmu_notifier_unregister_no_release])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_notifier.h>
	],[
		mmu_notifier_unregister_no_release(NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMU_NOTIFIER_UNREGISTER_NO_RELEASE, 1,
			  [mmu_notifier_unregister_no_release defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct mmu_notifier_ops has invalidate_page])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_notifier.h>
	],[
		static struct mmu_notifier_ops mmu_notifier_ops_xx= {
			.invalidate_page = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INVALIDATE_PAGE, 1,
			  [invalidate_page defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/sizes.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sizes.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SIZES_H, 1,
			  [include/linux/sizes.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk_mq_end_request accepts blk_status_t as second parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
		#include <linux/blk_types.h>
	],[
		blk_status_t error = BLK_STS_OK;

		blk_mq_end_request(NULL, error);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_END_REQUEST_TAKES_BLK_STATUS_T, 1,
			  [blk_mq_end_request accepts blk_status_t as second parameter])
	],[
		AC_MSG_RESULT(no)
	])


	AC_MSG_CHECKING([if linux/blk_types.h has REQ_INTEGRITY])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		int x = REQ_INTEGRITY;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_TYPES_REQ_INTEGRITY, 1,
			[REQ_INTEGRITY is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bio.h bio_endio has 1 parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bio.h>
	],[
		bio_endio(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BIO_ENDIO_1_PARAM, 1,
			[linux/bio.h bio_endio has 1 parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has __blkdev_issue_discard])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		__blkdev_issue_discard(NULL, 0, 0, 0, 0, NULL);

		return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE___BLKDEV_ISSUE_DISCARD, 1,
	                [__blkdev_issue_discard is defined])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bio.h submit_bio has 1 parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bio.h>
		#include <linux/fs.h>
	],[
		submit_bio(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SUBMIT_BIO_1_PARAM, 1,
			[linux/bio.h submit_bio has 1 parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct bio has member bi_opf])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		struct bio b = {
			.bi_opf = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_BIO_BI_OPF, 1,
			[struct bio has member bi_opf])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct bio has member bi_iter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		struct bio b = {
			.bi_iter = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_BIO_BI_ITER, 1,
			[struct bio has member bi_iter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct bio has member bi_disk])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		struct bio b = {
			.bi_disk = NULL,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BIO_BI_DISK, 1,
			[struct bio has member bi_disk])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct bio has member bi_error])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		struct bio b = {
			.bi_error = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_BIO_BI_ERROR, 1,
			[struct bio has member bi_error])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ifla_vf_stats has member tx_broadcast])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		struct ifla_vf_stats x = {
			.tx_broadcast = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_IFLA_VF_STATS_TX_BROADCAST, 1,
			[struct ifla_vf_stats has member tx_broadcast])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct ifla_vf_stats has rx_dropped and tx_dropped])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/if_link.h>
	],[
		struct ifla_vf_stats x = {
			.rx_dropped = 0,
			.tx_dropped = 0,
		};
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STRUCT_IFLA_VF_STATS_RX_TX_DROPPED, 1,
			[struct ifla_vf_stats has memebers rx_dropped and tx_dropped])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/moduleparam.h has member param_ops_ullong])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/moduleparam.h>
	],[
		param_get_ullong(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PARAM_OPS_ULLONG, 1,
			[param_ops_ullong is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if fs.h has stream_open])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/fs.h>
	],[
		stream_open(NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_STREAM_OPEN, 1,
			[fs.h has stream_open])
	],[
		AC_MSG_RESULT(no)
	])


	AC_MSG_CHECKING([if vfs_getattr has 4 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/fs.h>
	],[
		vfs_getattr(NULL, NULL, 0, 0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(VFS_GETATTR_HAS_4_PARAMS, 1,
			[vfs_getattr has 4 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/fs.h has struct kiocb definition])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/fs.h>
	],[
		struct kiocb x = {
			.ki_flags = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FS_HAS_KIOCB, 1,
			[struct kiocb is defined in linux/fs.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has struct bio_aux])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/errno.h>
		#include <linux/blk_types.h>
	],[
		struct bio_aux x;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RH7_STRUCT_BIO_AUX, 1,
			[struct bio_aux is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/pci.h has pci_irq_vector, pci_free_irq_vectors, pci_alloc_irq_vectors])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_irq_vector(NULL, 0);
		pci_free_irq_vectors(NULL);
		pci_alloc_irq_vectors(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_IRQ_API, 1,
			[linux/pci.h has pci_irq_vector, pci_free_irq_vectors, pci_alloc_irq_vectors])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h struct pci_error_handlers has reset_prepare])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>

		void reset_prepare(struct pci_dev *dev) {
			return;
		}
	],[
		struct pci_error_handlers x = {
			.reset_prepare = reset_prepare,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_ERROR_HANDLERS_RESET_PREPARE, 1,
			[pci.h struct pci_error_handlers has reset_prepare])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h struct pci_error_handlers has reset_done])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>

		void reset_done(struct pci_dev *dev) {
			return;
		}
	],[
		struct pci_error_handlers x = {
			.reset_done = reset_done,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_ERROR_HANDLERS_RESET_DONE, 1,
		[pci.h struct pci_error_handlers has reset_done])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/io-64-nonatomic-lo-hi.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/io-64-nonatomic-lo-hi.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IO_64_NONATOMIC_LO_HI_H, 1,
			[linux/io-64-nonatomic-lo-hi.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_request_mem_regions])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_request_mem_regions(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_REQUEST_MEM_REGIONS, 1,
			[pci_request_mem_regions is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_release_mem_regions])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_release_mem_regions(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_RELEASE_MEM_REGIONS, 1,
			[pci_release_mem_regions is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h pcie_get_minimum_link])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pcie_get_minimum_link(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCIE_GET_MINIMUM_LINK, 1,
			[pcie_get_minimum_link is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h pcie_print_link_status])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pcie_print_link_status(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCIE_PRINT_LINK_STATUS, 1,
			[pcie_print_link_status is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h pci_upstream_bridge])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_upstream_bridge(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_UPSTREAM_BRIDGE, 1,
			[pci_upstream_bridge is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pnv-pci.h has pnv_pci_set_p2p])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <asm/pnv-pci.h>
	],[
		pnv_pci_set_p2p(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PNV_PCI_SET_P2P, 1,
			[pnv-pci.h has pnv_pci_set_p2p])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pnv-pci.h has pnv_pci_enable_tunnel])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <asm/pnv-pci.h>
	],[
		pnv_pci_enable_tunnel(NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PNV_PCI_AS_NOTIFY, 1,
			[pnv-pci.h has pnv_pci_enable_tunnel])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if rbtree.h has struct rb_root_cached])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rbtree.h>
	],[
		struct rb_root_cached rb_root_cached_test;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RB_ROOT_CACHED, 1,
			[struct rb_root_cached is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if rbtree.h has rb_first_postorder])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rbtree.h>
	],[
		struct rb_root x;
		rb_first_postorder(&x);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RB_FIRST_POSTORDER, 1,
			[rb_first_postorder is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if INTERVAL_TREE takes rb_root])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rbtree.h>
		#include <linux/interval_tree_generic.h>

		struct x_node {
			u64 __subtree_last;
			struct rb_node rb;
		};
		static u64 node_last(struct x_node *n)
		{
			return 0;
		}
		static u64 node_start(struct x_node *n)
		{
			return 0;
		}
		INTERVAL_TREE_DEFINE(struct x_node, rb, u64, __subtree_last,
			node_start, node_last, static, rbt_x)
	],[
		struct x_node x_interval_tree;
		struct rb_root x_tree;
		rbt_x_insert(&x_interval_tree, &x_tree);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INTERVAL_TREE_TAKES_RB_ROOT, 1,
			[INTERVAL_TREE takes rb_root])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if timer.h has timer_setup])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/timer.h>

		static void activate_timeout_handler_task(struct timer_list *t)
		{
			return;
		}
	],[
		struct timer_list tmr;
		timer_setup(&tmr, activate_timeout_handler_task, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TIMER_SETUP, 1,
			[timer_setup is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dmapool.h has dma_pool_zalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dmapool.h>
	],[
		dma_pool_zalloc(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_POOL_ZALLOC, 1,
			  [dma_pool_zalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if trace_seq.h has trace_seq_buffer_ptr])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/trace_seq.h>
	],[
		struct trace_seq ts;
		trace_seq_buffer_ptr(&ts);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TRACE_SEQ_BUFFER_PTR, 1,
			  [trace_seq_buffer_ptr is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if act_apt.h tc_setup_cb_egdev_register])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/act_api.h>
	],[
		tc_setup_cb_egdev_register(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_SETUP_CB_EGDEV_REGISTER, 1,
			  [tc_setup_cb_egdev_register is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if act_api.h has tcf_action_stats_update])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/act_api.h>
	],[
		tcf_action_stats_update(NULL, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCF_ACTION_STATS_UPDATE, 1,
			  [tc_action_stats_update is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/once.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/once.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ONCE_H, 1,
			  [include/linux/once.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if has mm_context_add_copro])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mmu_context.h>
	],[
		mm_context_add_copro(NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MM_CONTEXT_ADD_COPRO, 1,
			[mm_context_add_copro is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has blk_path_error])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/errno.h>
		#include <linux/blkdev.h>
		#include <linux/blk_types.h>
	],[
		blk_path_error(0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_PATH_ERROR, 1,
			  [blk_path_error is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if slab.h has kcalloc_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/slab.h>
	],[
		kcalloc_node(0, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KCALLOC_NODE, 1,
			  [kcalloc_node is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if slab.h has kmalloc_array_node])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/slab.h>
	],[
		kmalloc_array_node(0, 0, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KMALLOC_ARRAY_NODE, 1,
			  [kmalloc_array_node is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if kref.h has kref_get_unless_zero])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kref.h>
	],[
		kref_get_unless_zero(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KREF_GET_UNLESS_ZERO, 1,
			  [kref_get_unless_zero is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if kref.h has kref_read])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/kref.h>
	],[
		kref_read(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KREF_READ, 1,
			  [kref_read is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/inet.h has inet_addr_is_any])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/inet.h>
	],[
		inet_addr_is_any(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_INET_ADDR_IS_ANY, 1,
			[inet_addr_is_any is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blkdev.h has bdev_write_zeroes_sectors])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		bdev_write_zeroes_sectors(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BDEV_WRITE_ZEROES_SECTORS, 1,
			  [bdev_write_zeroes_sectors is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blkdev.h has blk_queue_flag_set])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_queue_flag_set(0, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_QUEUE_FLAG_SET, 1,
				[blk_queue_flag_set is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if include/linux/blk-mq-pci.h has blk_mq_pci_map_queues])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq-pci.h>
	],[
		blk_mq_pci_map_queues(NULL, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_PCI_MAP_QUEUES_3_ARGS, 1,
			[blk_mq_pci_map_queues is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ndo_add_slave has 3 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct net_device_ops ndops;
		ndops.ndo_add_slave(NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NDO_ADD_SLAVE_3_PARAMS, 1,
			  [ndo_add_slave has 3 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdev_master_upper_dev_link gets 5 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		netdev_master_upper_dev_link(NULL, NULL, NULL, NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(NETDEV_MASTER_UPPER_DEV_LINK_5_PARAMS, 1,
			[netdev_master_upper_dev_link gets 5 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blkdev.h has BLK_EH_DONE])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		int x = BLK_EH_DONE;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_EH_DONE, 1,
				[BLK_EH_DONE is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has netdev_reg_state])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		const struct net_device x;
		netdev_reg_state(&x);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETDEV_REG_STATE, 1,
			  [netdev_reg_state is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct xfrmdev_ops has member xdo_dev_state_advance_esn])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct xfrmdev_ops x = {
			.xdo_dev_state_advance_esn = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDO_DEV_STATE_ADVANCE_ESN, 1,
			  [struct xfrmdev_ops has member xdo_dev_state_advance_esn])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if interrupt.h has irq_calc_affinity_vectors with 3 args])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/interrupt.h>
	],[
		int x = irq_calc_affinity_vectors(0, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IRQ_CALC_AFFINITY_VECTORS_3_ARGS, 1,
			  [irq_calc_affinity_vectors is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/overflow.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/overflow.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_LINUX_OVERFLOW_H, 1,
			  [linux/overflow.h is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/rtnetlink.h has net_rwsem])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/rtnetlink.h>
	],[
		down_read(&net_rwsem);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RTNETLINK_NET_RWSEM, 1,
			  [linux/rtnetlink.h has net_rwsem])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/net/ip6_route.h rt6_lookup takes 6 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/ip6_route.h>
	],[
		rt6_lookup(NULL, NULL, NULL, 0, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RT6_LOOKUP_TAKES_6_PARAMS, 1,
			  [rt6_lookup takes 6 params])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if type __poll_t is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/types.h>
	],[
		__poll_t x = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TYPE___POLL_T, 1,
			  [type __poll_t is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/netlink.h NLA_S32 is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/netlink.h>
	],[
		u16 x = NLA_S32;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NLA_S32, 1,
			  [NLA_S32 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/xdp.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/xdp.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_XDP_H, 1,
			  [net/xdp.h is defined])
	],[
		AC_MSG_RESULT(no)
			AC_MSG_CHECKING([if net/xdp.h exists workaround for 5.4.17-2011.1.2.el8uek.x86_64])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/uek_kabi.h>
				#include <net/xdp.h>
			],[
				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_NET_XDP_H, 1,
					  [NESTED: net/xdp.h is defined workaround for 5.4.17-2011.1.2.el8uek.x86_64])
			],[
				AC_MSG_RESULT(no)
			])
	])

	AC_MSG_CHECKING([if net/xdp.h has convert_to_xdp_frame])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/xdp.h>
	],[
		convert_to_xdp_frame(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDP_CONVERT_TO_XDP_FRAME, 1,
			  [net/xdp.h has convert_to_xdp_frame])
	],[
		AC_MSG_RESULT(no)
			AC_MSG_CHECKING([if net/xdp.h has convert_to_xdp_frame workaround for 5.4.17-2011.1.2.el8uek.x86_64])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/uek_kabi.h>
				#include <net/xdp.h>
			],[
				convert_to_xdp_frame(NULL);

				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_XDP_CONVERT_TO_XDP_FRAME, 1,
					  [NESTED: net/xdp.h has convert_to_xdp_frame workaround for 5.4.17-2011.1.2.el8uek.x86_64])
			],[
				AC_MSG_RESULT(no)
			])
	])

	AC_MSG_CHECKING([if net/xdp.h has xdp_rxq_info_reg_mem_model])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/xdp.h>
	],[
		xdp_rxq_info_reg_mem_model(NULL, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDP_RXQ_INFO_REG_MEM_MODEL, 1,
			  [net/xdp.h has xdp_rxq_info_reg_mem_model])
	],[
		AC_MSG_RESULT(no)
			AC_MSG_CHECKING([if net/xdp.h has xdp_rxq_info_reg_mem_model workaround for 5.4.17-2011.1.2.el8uek.x86_64])
			MLNX_BG_LB_LINUX_TRY_COMPILE([
				#include <linux/uek_kabi.h>
				#include <net/xdp.h>
			],[
				xdp_rxq_info_reg_mem_model(NULL, 0, NULL);

				return 0;
			],[
				AC_MSG_RESULT(yes)
				MLNX_AC_DEFINE(HAVE_XDP_RXQ_INFO_REG_MEM_MODEL, 1,
					  [NESTED: net/xdp.h has xdp_rxq_info_reg_mem_model workaround for 5.4.17-2011.1.2.el8uek.x86_64])
			],[
				AC_MSG_RESULT(no)
			])
	])

	AC_MSG_CHECKING([if net/geneve.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/if.h>
		#include <net/geneve.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_GENEVE_H, 1,
			  [net/geneve.h is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/page_pool.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/page_pool.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_PAGE_POOL_H, 1,
			  [net/page_pool.h is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/page_pool.h has page_pool_release_page])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/page_pool.h>
	],[
		page_pool_release_page(NULL, NULL);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PAGE_POOL_RELEASE_PAGE, 1,
			  [net/page_pool.h has page_pool_release_page])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tls.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tls.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NET_TLS_H, 1,
			  [net/tls.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/tls.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/tls.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UAPI_LINUX_TLS_H, 1,
			  [uapi/linux/tls.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tls.h has tls_offload_context_tx])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tls.h>
	],[
                struct tls_offload_context_tx tmp;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TLS_OFFLOAD_CONTEXT_TX_STRUCT, 1,
			  [net/tls.h has tls_offload_context_tx])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tls.h has tls_offload_context_rx])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tls.h>
	],[
                struct tls_offload_context_rx tmp;
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TLS_OFFLOAD_CONTEXT_RX_STRUCT, 1,
			  [net/tls.h has tls_offload_context_rx])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if net/tls.h has tls_offload_rx_resync_request])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/tls.h>
	],[
                tls_offload_rx_resync_request(NULL,0);
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TLS_OFFLOAD_RX_RESYNC_REQUEST, 1,
			  [net/tls.h has tls_offload_rx_resync_request])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if smp_load_acquire is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <asm-generic/barrier.h>
	],[
		u32 x;
		smp_load_acquire(&x);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SMP_LOAD_ACQUIRE, 1,
			  [smp_load_acquire is defined])
	],[
		AC_MSG_RESULT(no)
	])

	LB_CHECK_SYMBOL_EXPORT([idr_preload],
		[lib/radix-tree.c],
		[AC_DEFINE(HAVE_IDR_PRELOAD_EXPORTED, 1,
			[idr_preload is exported by the kernel])],
	[])

	LB_CHECK_SYMBOL_EXPORT([radix_tree_iter_delete],
		[lib/radix-tree.c],
		[AC_DEFINE(HAVE_RADIX_TREE_ITER_DELETE_EXPORTED, 1,
			[radix_tree_iter_delete is exported by the kernel])],
	[])
	LB_CHECK_SYMBOL_EXPORT([kobj_ns_grab_current],
		[lib/kobject.c],
		[AC_DEFINE(HAVE_KOBJ_NS_GRAB_CURRENT_EXPORTED, 1,
			[kobj_ns_grab_current is exported by the kernel])],
	[])

	AC_MSG_CHECKING([if linux/blk_types.h has REQ_DRV])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		int x = REQ_DRV;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_TYPES_REQ_DRV, 1,
			  [REQ_DRV is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk_alloc_queue_node has 3 args])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		blk_alloc_queue_node(0, 0, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_ALLOC_QUEUE_NODE_3_ARGS, 1,
				[blk_alloc_queue_node has 3 args])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_enable_atomic_ops_to_root])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_enable_atomic_ops_to_root(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_ENABLE_ATOMIC_OPS_TO_ROOT, 1,
		[pci_enable_atomic_ops_to_root is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if pci.h has pci_cfg_access_lock])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/pci.h>
	],[
		pci_cfg_access_lock(NULL);
		pci_cfg_access_unlock(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PCI_CFG_ACCESS_LOCK, 1,
		[pci_cfg_access_lock is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if string.h has kstrtobool])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/string.h>
	],[
		char s[] = "test";
		bool res;

		kstrtobool(s, &res);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KSTRTOBOOL, 1,
		[kstrtobool is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct blk_mq_ops has poll])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		struct blk_mq_ops ops = {
			.poll = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_OPS_POLL, 1,
			  [struct blk_mq_ops has poll])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct iscsi_session has discovery_sess])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/libiscsi.h>
	],[
		struct iscsi_session session = {
			.discovery_sess = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_ISCSI_DISCOVERY_SESSION, 1,
			  [struct iscsi_session has discovery_sess])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if select_queue_fallback_t has third parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		extern select_queue_fallback_t fallback;
                fallback(NULL, NULL, NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SELECT_QUEUE_FALLBACK_T_3_PARAMS, 1,
			  [select_queue_fallback_t has third parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if t10_pi_ref_tag() exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_cmnd.h>
	],[
		t10_pi_ref_tag(NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_T10_PI_REF_TAG, 1,
			  [t10_pi_ref_tag() exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct netdev_bonding_info has prog_attached])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
                struct netdev_bpf s = {};
	],[
                s.prog_attached = 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BPF_PROG_PROG_ATTACHED, 1,
			  [netdev_bpf has prog_attached])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has QUEUE_FLAG_PCI_P2PDMA])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		int x = QUEUE_FLAG_PCI_P2PDMA;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_QUEUE_FLAG_PCI_P2PDMA, 1,
			[QUEUE_FLAG_PCI_P2PDMA is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if mm.h has mmget_still_valid])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched/mm.h>
	],[
		mmget_still_valid(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMGET_STILL_VALID, 1,
			[mmget_still_valid is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/sched.h has mmget_still_valid])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sched.h>
	],[
		mmget_still_valid(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMGET_STILL_VALID_IN_SCHED_H, 1,
			[mmget_still_valid is defined in linux/sched.h])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/mm.h has mmget_still_valid])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		mmget_still_valid(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MMGET_STILL_VALID_IN_MM_H, 1,
			[mmget_still_valid is defined in linux/mm.h])
	],[
		AC_MSG_RESULT(no)
	])
	AC_MSG_CHECKING([if mm.h has is_pci_p2pdma_page])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/mm.h>
	],[
		is_pci_p2pdma_page(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IS_PCI_P2PDMA_PAGE, 1,
			[is_pci_p2pdma_page is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if t10-pi.h has t10_pi_prepare])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/t10-pi.h>
	],[
		t10_pi_prepare(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_T10_PI_PREPARE, 1,
			[t10_pi_prepare is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct request_queue has integrity])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct request_queue rq = {
			.integrity = {0},
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQUEST_QUEUE_INTEGRITY, 1,
			  [struct request_queue has integrity])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/bio.h has bip_get_seed])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bio.h>
	],[
		bip_get_seed(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BIO_BIP_GET_SEED, 1,
			[linux/bio.h has bip_get_seed])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if t10-pi.h has enum t10_dif_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/t10-pi.h>
	],[
		enum t10_dif_type x = T10_PI_TYPE0_PROTECTION;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_T10_DIF_TYPE, 1,
			  [enum t10_dif_type is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct blk_integrity has sector_size])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct blk_integrity bi = {
			.sector_size = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_INTEGRITY_SECTOR_SIZE, 1,
			  [struct blk_integrity has sector_size])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if need expose current_link_speed/width in sysfs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/device.h>
		#include <linux/pci_regs.h>
	],[
		struct kobject kobj = {};
		struct device *dev = kobj_to_dev(&kobj);
		/* https://patchwork.kernel.org/patch/9759133/
		 * patch exposing link stats also introduce this const */
		#ifdef PCI_EXP_LNKCAP_SLS_8_0GB
		#error no need
		#endif

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NO_LINKSTA_SYSFS, 1,
			  [current_link_speed/width not exposed])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/pkt_cls.h has TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/pkt_cls.h>
	],[
		int x = TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT, 1,
				[TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/pkt_cls.h has TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/pkt_cls.h>
	],[
		int x = TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST, 1,
				[TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/pkt_cls.h has TCA_FLOWER_KEY_SCTP_SRC_MASK])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	        #include <uapi/linux/pkt_cls.h>
	],[
	        int x = TCA_FLOWER_KEY_SCTP_SRC_MASK;

	        return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE_TCA_FLOWER_KEY_SCTP_SRC_MASK, 1,
	                        [TCA_FLOWER_KEY_SCTP_SRC_MASK is defined])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/pkt_cls.h has TCA_FLOWER_KEY_MPLS_TTL])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	        #include <uapi/linux/pkt_cls.h>
	],[
	        int x = TCA_FLOWER_KEY_MPLS_TTL;

	        return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE_TCA_FLOWER_KEY_MPLS_TTL, 1,
	                        [TCA_FLOWER_KEY_MPLS_TTL is defined])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/pkt_cls.h has TCA_FLOWER_KEY_CVLAN_ID])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	        #include <uapi/linux/pkt_cls.h>
	],[
	        int x = TCA_FLOWER_KEY_CVLAN_ID;

	        return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE_TCA_FLOWER_KEY_CVLAN_ID, 1,
	                        [TCA_FLOWER_KEY_CVLAN_ID is defined])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if TCA_TUNNEL_KEY_ENC_TOS exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	        #include <uapi/linux/tc_act/tc_tunnel_key.h>
	],[
	        int x = TCA_TUNNEL_KEY_ENC_TOS;

	        return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE_TCA_TUNNEL_KEY_ENC_TOS, 1,
	                        [TCA_TUNNEL_KEY_ENC_TOS is defined])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if TCA_TUNNEL_KEY_ENC_DST_PORT exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	        #include <uapi/linux/tc_act/tc_tunnel_key.h>
	],[
	        int x = TCA_TUNNEL_KEY_ENC_DST_PORT;

	        return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE_TCA_TUNNEL_KEY_ENC_DST_PORT, 1,
	                        [TCA_TUNNEL_KEY_ENC_DST_PORT is defined])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has struct blk_mq_queue_map])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		struct blk_mq_queue_map x = {};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_QUEUE_MAP, 1,
			  [linux/blk-mq.h has struct blk_mq_queue_map])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has busy_tag_iter_fn return bool])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>

		static bool
		nvme_cancel_request(struct request *req, void *data, bool reserved) {
			return true;
		}
	],[
		busy_tag_iter_fn *fn = nvme_cancel_request;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_BUSY_TAG_ITER_FN_BOOL, 1,
			  [linux/blk-mq.h has busy_tag_iter_fn return bool])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has poll_fn 1 arg])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>

		static int nvme_poll(struct blk_mq_hw_ctx *hctx) {
			return 0;
		}
	],[
		poll_fn *fn = nvme_poll;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_POLL_FN_1_ARG, 1,
			  [linux/blk-mq.h has poll_fn 1 arg])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct Qdisc_ops has ingress_block_set net/sch_generic.h ])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/sch_generic.h>
	],[
		struct Qdisc_ops ops = {
			.ingress_block_set = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_QDISC_SUPPORTS_BLOCK_SHARING, 1,
			  [struct Qdisc_ops has ingress_block_set])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uuid.h has guid_parse])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/uuid.h>
	],[
		char *str;
        guid_t uuid;
        int ret;

		ret = guid_parse(str, &uuid);

		return ret;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_GUID_PARSE, 1,
		[guid_parse is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if bitmap.h has bitmap_kzalloc])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	#include <linux/bitmap.h>
	],[
		unsigned long *bmap;

		bmap = bitmap_zalloc(1, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BITMAP_KZALLOC, 1,
		[bitmap_kzalloc is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if bitmap.h has bitmap_free])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bitmap.h>
		#include <linux/slab.h>
	],[
		unsigned long *bmap;

		bmap = kcalloc(BITS_TO_LONGS(1), sizeof(unsigned long), 0);
		bitmap_free(bmap);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BITMAP_FREE, 1,
		[bitmap_free is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if bitmap.h has bitmap_from_arr32])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/bitmap.h>
		#include <linux/slab.h>
	],[
		unsigned long *bmap;
		u32 *word;

		bmap = kcalloc(BITS_TO_LONGS(1), sizeof(unsigned long), 0);
		bitmap_from_arr32(bmap, word, 1);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BITMAP_FROM_ARR32, 1,
		[bitmap_from_arr32 is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-mapping.h struct dma_map_ops has cache_sync])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		struct dma_map_ops ops = {
			.cache_sync = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_MAP_OPS_CACHE_SYNC, 1,
			[struct dma_map_ops has cache_sync])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-mapping.h struct dma_map_ops has map_resource])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		struct dma_map_ops ops = {
			.map_resource = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_MAP_OPS_MAP_RESOURCE, 1,
			[struct dma_map_ops has map_resource])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-mapping.h has dma_map_page_attrs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		struct device *dev;
                struct page *page;
		size_t offset, size;
                enum dma_data_direction dir;
		unsigned long attrs;

		dma_map_page_attrs(dev, page, offset, size, dir, attrs);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_MAP_PAGE_ATTRS, 1,
			[dma_map_page_attrs is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-mapping.h has set_dma_ops])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-mapping.h>
	],[
		struct device *dev;
		struct dma_map_ops *dma_ops;

		set_dma_ops(dev, dma_ops);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SET_DMA_OPS, 1,
			[set_dma_ops is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if rx_queue_attribute is defined in netdevice.h])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	        #include <linux/netdevice.h>
	],[
		struct rx_queue_attribute attr;

		attr.show = 0;

	        return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE_NETDEV_QUEUE_SYSFS, 1,
	                        [rx_queue_attribute is defined in netdevice.h])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if rx_queue_attribute->show/store changed])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
	        #include <linux/netdevice.h>
		static int dummy_show(void *queue, void *attr, void *buf)
		{
			return 0;
		}

	],[
		struct rx_queue_attribute attr;

		attr.show = dummy_show;
		attr.show(NULL, NULL, NULL);

	        return 0;
	],[
	        AC_MSG_RESULT(yes)
	        MLNX_AC_DEFINE(HAVE_NETDEV_QUEUE_SYSFS_ATTRIBUTE, 1,
	                        [netdev queue sysfs has attribute])
	],[
	        AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if tc_cls_common_offload has handle])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct tc_cls_common_offload x;
		x.handle = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CLS_OFFLOAD_HANDLE, 1,
			  [struct tc_cls_common_offload has handle])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if built in flower supports multi mask per prio])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/pkt_cls.h>
	],[
		struct rcu_work *rwork;
		work_func_t func;

		tcf_queue_work(rwork, func);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOWER_MULTI_MASK, 1,
			  [tcf_queue_work has 2 params per prio])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk-mq.h has enum hctx_type])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		enum hctx_type type = HCTX_TYPE_DEFAULT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_HCTX_TYPE, 1,
			[blk-mq.h has enum hctx_type])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blk-mq.h has blk_mq_complete_request_sync])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_complete_request_sync(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_COMPLETE_REQUEST_SYNC, 1,
			[blk-mq.h has blk_mq_complete_request_sync])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if scsi/scsi_transport_fc.h has FC_PORT_ROLE_NVME_TARGET])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <scsi/scsi_transport_fc.h>
	],[
		int x = FC_PORT_ROLE_NVME_TARGET;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SCSI_TRANSPORT_FC_FC_PORT_ROLE_NVME_TARGET, 1,
			[scsi/scsi_transport_fc.h has FC_PORT_ROLE_NVME_TARGET])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has REQ_HIPRI])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		int x = REQ_HIPRI;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_TYPES_REQ_HIPRI, 1,
			  [REQ_HIPRI is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct blk_mq_ops has commit_rqs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		struct blk_mq_ops ops = {
			.commit_rqs = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_OPS_COMMIT_RQS, 1,
			  [struct blk_mq_ops has commit_rqs])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if struct irq_affinity has priv])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/interrupt.h>
	],[
		struct irq_affinity affd = {
			.priv = NULL,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IRQ_AFFINITY_PRIV, 1,
			  [struct irq_affinity has priv])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if fs.h has IOCB_NOWAIT])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/fs.h>
	],[
		int x = IOCB_NOWAIT;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_IOCB_NOWAIT, 1,
			[fs.h has IOCB_NOWAIT])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma-attrs.h has struct dma_attrs])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/dma-attrs.h>
	],[
		struct dma_attrs attr = {};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_DMA_ATTRS, 1,
			[dma-attrs.h has struct dma_attrs])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_delay_kick_requeue_list])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_delay_kick_requeue_list(NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_DELAY_KICK_REQUEUE_LIST, 1,
			  [blk_mq_delay_kick_requeue_list is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk_types.h has op_is_write])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk_types.h>
	],[
		op_is_write(0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_OP_IS_WRITE, 1,
			  [op_is_write is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if dma_map_bvec exist])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
		#include <linux/dma-mapping.h>
	],[
		struct bio_vec bv = {};

		dma_map_bvec(NULL, &bv, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLKDEV_DMA_MAP_BVEC, 1,
				[dma_map_bvec exist])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/scatterlist.h sg_alloc_table_chained has nents_first_chunk parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
		sg_alloc_table_chained(NULL, 0, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SG_ALLOC_TABLE_CHAINED_NENTS_FIRST_CHUNK_PARAM, 1,
			[sg_alloc_table_chained has nents_first_chunk parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq-rdma.h has blk_mq_rdma_map_queues with map])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
		#include <linux/blk-mq-rdma.h>
	],[
		struct blk_mq_queue_map *map = NULL;

		blk_mq_rdma_map_queues(map, NULL, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_RDMA_MAP_QUEUES_MAP, 1,
			  [linux/blk-mq-rdma.h has blk_mq_rdma_map_queues with map])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has request_to_qc_t])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		request_to_qc_t(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQUEST_TO_QC_T, 1,
			  [linux/blk-mq.h has request_to_qc_t])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_request_completed])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_request_completed(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_REQUEST_COMPLETED, 1,
			  [linux/blk-mq.h has blk_mq_request_completed])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h has enum mq_rq_state])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		enum mq_rq_state state = MQ_RQ_COMPLETE;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_MQ_RQ_STATE, 1,
			  [mq_rq_state is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blk-mq.h has blk_mq_tagset_wait_completed_request])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blk-mq.h>
	],[
		blk_mq_tagset_wait_completed_request(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLK_MQ_TAGSET_WAIT_COMPLETED_REQUEST, 1,
			  [linux/blk-mq.h has blk_mq_tagset_wait_completed_request])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/net.h has kernel_getsockname 2 parameters])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/net.h>
	],[
		kernel_getsockname(NULL, NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_KERNEL_GETSOCKNAME_2_PARAMS, 1,
			  [linux/net.h has kernel_getsockname 2 parameters])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if uapi/linux/eventpoll.h exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/capability.h>
		#include <uapi/linux/eventpoll.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_UAPI_LINUX_EVENTPOLL_H, 1,
			  [uapi/linux/eventpoll.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if *xpo_secure_port returns void])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/svc_xprt.h>

		void secure_port(struct svc_rqst *rqstp)
		{
			return;
		}
	],[
		struct svc_xprt_ops check_rdma_ops;

		check_rdma_ops.xpo_secure_port = secure_port;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XPO_SECURE_PORT_NO_RETURN, 1,
			[xpo_secure_port is defined and returns void])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if *send_request has 'struct rpc_rqst *req' as a param])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>

		int send_request(struct rpc_rqst *req)
		{
			return 0;
		}
	],[
		struct rpc_xprt_ops ops;

		ops.send_request = send_request;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XPRT_OPS_SEND_REQUEST_RQST_ARG, 1,
			[*send_request has 'struct rpc_rqst *req' as a param])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for rpc_reply_expected])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/clnt.h>
	],[
		return rpc_reply_expected(NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RPC_REPLY_EXPECTED, 1, [rpc reply expected])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for xprt_request_get_cong])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		return xprt_request_get_cong(NULL, NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XPRT_REQUEST_GET_CONG, 1, [get cong request])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for "xpt_remotebuf" inside "struct svc_xprt"])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/svc_xprt.h>
	],[
		struct svc_xprt dummy_xprt;

		dummy_xprt.xpt_remotebuf[0] = 0;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SVC_XPRT_XPT_REMOTEBUF, 1,
			[struct svc_xprt has 'xpt_remotebuf' field])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for "xpo_prep_reply_hdr" inside "struct svc_xprt_ops"])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/svc_xprt.h>
	],[
		struct svc_xprt_ops dummy_svc_ops;

		dummy_svc_ops.xpo_prep_reply_hdr = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SVC_XPRT_XPO_PREP_REPLY_HDR, 1,
			[struct svc_xprt_ops 'xpo_prep_reply_hdr' field])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for "free_slot" inside "struct rpc_xprt_ops"])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		struct rpc_xprt_ops dummy_ops;

		dummy_ops.free_slot = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RPC_XPRT_OPS_FREE_SLOT, 1,
			[struct rpc_xprt_ops has 'free_slot' field])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for "set_retrans_timeout" inside "struct rpc_xprt_ops"])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		struct rpc_xprt_ops dummy_ops;

		dummy_ops.set_retrans_timeout = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RPC_XPRT_OPS_SET_RETRANS_TIMEOUT, 1,
			[struct rpc_xprt_ops has 'set_retrans_timeout' field])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for "wait_for_reply_request" inside "struct rpc_xprt_ops"])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		struct rpc_xprt_ops dummy_ops;

		dummy_ops.wait_for_reply_request = NULL;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RPC_XPRT_OPS_WAIT_FOR_REPLY_REQUEST, 1,
			[struct rpc_xprt_ops has 'wait_for_reply_request' field])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for "queue_lock" inside "struct rpc_xprt"])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		spinlock_t *dummy_lock;
		struct rpc_xprt dummy_xprt;

		dummy_lock = &dummy_xprt.queue_lock;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XPRT_QUEUE_LOCK, 1,
			[struct rpc_xprt has 'queue_lock' field])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if 'struct rpc_xprt_ops *ops' field is const inside 'struct rpc_xprt'])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		const struct rpc_xprt_ops ops = {0};
		struct rpc_xprt xprt;
		const struct rpc_xprt_ops *ptr = &ops;

		xprt.ops = ptr;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RPC_XPRT_OPS_CONST, 1,
			  [struct rpc_xprt_ops *ops' field is const inside 'struct rpc_xprt'])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if 'struct svc_xprt_ops *xcl_ops' field is const inside 'struct svc_xprt_class'])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/svc_xprt.h>
	],[
		const struct svc_xprt_ops xcl_ops = {0};
		struct svc_xprt_class xprt;
		const struct svc_xprt_ops *ptr = &xcl_ops;

		xprt.xcl_ops = ptr;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SVC_XPRT_CLASS_XCL_OPS_CONST, 1,
			  ['struct svc_xprt_ops *xcl_ops' field is const inside 'struct svc_xprt_class'])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if xprt_wait_for_buffer_space has xprt as a parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		struct rpc_xprt xprt = {0};

		xprt_wait_for_buffer_space(&xprt);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XPRT_WAIT_FOR_BUFFER_SPACE_RQST_ARG, 1,
			  [xprt_wait_for_buffer_space has xprt as a parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for "recv_lock" inside "struct rpc_xprt"])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xprt.h>
	],[
		spinlock_t *dummy_lock;
		struct rpc_xprt dummy_xprt;

		dummy_lock = &dummy_xprt.recv_lock;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_RPC_XPRT_RECV_LOCK, 1, [struct rpc_xprt has 'recv_lock' field])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if xdr_init_encode has rqst as a parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xdr.h>
	],[
		struct rpc_rqst *rqst = NULL;

		xdr_init_encode(NULL, NULL, NULL, rqst);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDR_INIT_ENCODE_RQST_ARG, 1,
			  [xdr_init_encode has rqst as a parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if xdr_init_decode has rqst as a parameter])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xdr.h>
	],[
		struct rpc_rqst *rqst = NULL;

		xdr_init_decode(NULL, NULL, NULL, rqst);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDR_INIT_DECODE_RQST_ARG, 1,
			  [xdr_init_decode has rqst as a parameter])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([for xdr_stream_remaining])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/xdr.h>
	],[
		return xdr_stream_remaining(NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_XDR_STREAM_REMAINING, 1,
			  [xdr_stream_remaining function definition])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if sg_alloc_table_chained has 4 params])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/scatterlist.h>
	],[
		return sg_alloc_table_chained(NULL, 0, GFP_ATOMIC, NULL);
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_SG_ALLOC_TABLE_CHAINED_GFP_MASK, 1,
			  [sg_alloc_table_chained has 4 params])
	],[
		AC_MSG_RESULT(no)
	])

	LB_CHECK_SYMBOL_EXPORT([xprt_pin_rqst],
		[net/sunrpc/xprt.c],
		[AC_DEFINE(HAVE_XPRT_PIN_RQST, 1,
			[xprt_pin_rqst is exported by the sunrpc core])],
	[])

	LB_CHECK_SYMBOL_EXPORT([nvm_alloc_dev],
		[drivers/lightnvm/core.c],
		[AC_DEFINE(HAVE_NVM_ALLOC_DEV_EXPORTED, 1,
			[nvm_alloc_dev is exported by the kernel])],
	[])

	AC_MSG_CHECKING([for trace/events/rpcrdma.h])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/sunrpc/svc_rdma.h>
		#include "../../net/sunrpc/xprtrdma/xprt_rdma.h"

		#include <trace/events/rpcrdma.h>
	],[
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TRACE_RPCRDMA_H, 1, [rpcrdma.h exists])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h struct request_queue has timeout_work])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct request_queue q = { .timeout_work = {} };

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQUEST_QUEUE_TIMEOUT_WORK, 1,
			[blkdev.h struct request_queue has timeout_work])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h struct tc_ct_offload has member nat])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		struct tc_ct_offload cto = {
			.nat = 0,
		};

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_TC_CT_OFFLOAD_NAT, 1,
			  [tc_ct_offload has member nat])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netdevice.h has __netdev_tx_sent_queue])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/netdevice.h>
	],[
		__netdev_tx_sent_queue(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE___NETDEV_TX_SENT_QUEUE, 1,
			  [netdevice.h has __netdev_tx_sent_queue])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if flow_dissector.h enum flow_dissector_key_keyid has FLOW_DISSECTOR_KEY_ENC_OPTS])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <net/flow_dissector.h>
	],[
		enum flow_dissector_key_id keyid = FLOW_DISSECTOR_KEY_ENC_OPTS;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_FLOW_DISSECTOR_KEY_ENC_OPTS, 1,
			  [FLOW_DISSECTOR_KEY_ENC_OPTS is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if netif_is_geneve exists])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <uapi/linux/if.h>
		#include <net/geneve.h>
	],[
		struct net_device dev = {};

		netif_is_geneve(&dev);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_NETIF_IS_GENEVE, 1,
			  [netif_is_geneve is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blkdev.h has req_bvec])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		req_bvec(NULL);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLKDEV_REQ_BVEC, 1,
				[linux/blkdev.h has req_bvec])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if linux/blkdev.h has QUEUE_FLAG_QUIESCED])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		int x = QUEUE_FLAG_QUIESCED;

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_BLKDEV_QUEUE_FLAG_QUIESCED, 1,
				[linux/blkdev.h has QUEUE_FLAG_QUIESCED])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if ptp_find_pin_unlocked is defined])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/ptp_clock_kernel.h>
	],[
		ptp_find_pin_unlocked(NULL, 0, 0);

		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_PTP_FIND_PIN_UNLOCK, 1,
			  [ptp_find_pin_unlocked is defined])
	],[
		AC_MSG_RESULT(no)
	])

	AC_MSG_CHECKING([if blkdev.h struct request has mq_hctx])
	MLNX_BG_LB_LINUX_TRY_COMPILE([
		#include <linux/blkdev.h>
	],[
		struct request rq = { .mq_hctx = NULL };
		return 0;
	],[
		AC_MSG_RESULT(yes)
		MLNX_AC_DEFINE(HAVE_REQUEST_MQ_HCTX, 1,
			[blkdev.h struct request has mq_hctx])
	],[
		AC_MSG_RESULT(no)
	])
])
#
# COMPAT_CONFIG_HEADERS
#
# add -include config.h
#
AC_DEFUN([COMPAT_CONFIG_HEADERS],[
#
#	Wait for remaining build tests running in background
#
	wait
#
#	Append confdefs.h files from CONFDEFS_H_DIR to the main confdefs.h file
#
	/bin/cat CONFDEFS_H_DIR/confdefs.h.* >> confdefs.h
	/bin/rm -rf CONFDEFS_H_DIR
#
#	Generate the config.h header file
#
	AC_CONFIG_HEADERS([config.h])
	EXTRA_KCFLAGS="-include $PWD/config.h $EXTRA_KCFLAGS"
	AC_SUBST(EXTRA_KCFLAGS)
])

AC_DEFUN([MLNX_PROG_LINUX],
[

LB_LINUX_PATH
LB_LINUX_SYMVERFILE
LB_LINUX_CONFIG([MODULES],[],[
    AC_MSG_ERROR([module support is required to build mlnx kernel modules.])
])
LB_LINUX_CONFIG([MODVERSIONS])
LB_LINUX_CONFIG([KALLSYMS],[],[
    AC_MSG_ERROR([compat_mlnx requires that CONFIG_KALLSYMS is enabled in your kernel.])
])

LINUX_CONFIG_COMPAT
COMPAT_CONFIG_HEADERS

])
