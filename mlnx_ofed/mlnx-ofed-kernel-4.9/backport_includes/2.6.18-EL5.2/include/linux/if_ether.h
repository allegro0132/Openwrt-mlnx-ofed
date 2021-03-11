#ifndef __BACKPORT_LINUX_IF_ETHER_H_TO_2_6_21__
#define __BACKPORT_LINUX_IF_ETHER_H_TO_2_6_21__

#include_next <linux/if_ether.h>

#define ETH_P_FCOE      0x8906          /* Fibre Channel over Ethernet  */
#define ETH_FCS_LEN     4               /* Octets in the FCS             */
#define MAC_BUF_SIZE    18
#define DECLARE_MAC_BUF(var) char var[MAC_BUF_SIZE] __maybe_unused

static inline size_t _format_mac_addr(char *buf, int buflen,
                                const unsigned char *addr, int len)
{
        int i;
        char *cp = buf;
        for (i = 0; i < len; i++) {
                cp += scnprintf(cp, buflen - (cp - buf), "%02x", addr[i]);
                if (i == len - 1)
                        break;
                cp += strlcpy(cp, ":", buflen - (cp - buf));
        }
        return cp - buf;
}


static inline char *print_mac(char *buf, const unsigned char *addr)
{
        _format_mac_addr(buf, MAC_BUF_SIZE, addr, ETH_ALEN);
        return buf;
}

#endif
