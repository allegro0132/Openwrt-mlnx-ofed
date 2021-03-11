#!/bin/bash
#
# Copyright (c) 2016 Mellanox Technologies. All rights reserved.
#
# This Software is licensed under one of the following licenses:
#
# 1) under the terms of the "Common Public License 1.0" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/cpl.php.
#
# 2) under the terms of the "The BSD License" a copy of which is
#    available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/bsd-license.php.
#
# 3) under the terms of the "GNU General Public License (GPL) Version 2" a
#    copy of which is available from the Open Source Initiative, see
#    http://www.opensource.org/licenses/gpl-license.php.
#
# Licensee has the right to choose one of the above licenses.
#
# Redistributions of source code must retain the above copyright
# notice and one of the license notices.
#
# Redistributions in binary form must reproduce both the above copyright
# notice, one of the license notices in the documentation
# and/or other materials provided with the distribution.
#
# Author: Alaa Hleihel <alaa@mellanox.com>
#

i=$1
shift

if [ -z "$i" ]; then
    echo "Usage:"
    echo "      $0 <interface>"
    exit 1
fi

WINDRIVER=0
if (grep -qiE "Wind River" /etc/issue /etc/*release* 2>/dev/null); then
    WINDRIVER=1
fi

BLUENIX=0
if (grep -qiE "Bluenix" /etc/issue /etc/*release* 2>/dev/null); then
    BLUENIX=1
fi

OPENIBD_CONFIG=${OPENIBD_CONFIG:-"/etc/infiniband/openib.conf"}
CONFIG=$OPENIBD_CONFIG
export LANG="C"

if [ ! -f $CONFIG ]; then
    echo No InfiniBand configuration found
    exit 0
fi

OS_IS_BOOTING=0
last_bootID=$(cat /var/run/mlx_ifc-${i}.bootid 2>/dev/null)
if [ "X$last_bootID" == "X" ] && [ -e /sys/class/net/${i}/parent ]; then
    parent=$(cat /sys/class/net/${i}/parent)
    last_bootID=$(cat /var/run/mlx_ifc-${parent}.bootid 2>/dev/null)
fi
bootID=$(cat /proc/sys/kernel/random/boot_id 2>/dev/null | sed -e 's/-//g')
echo $bootID > /var/run/mlx_ifc-${i}.bootid
if [[ "X$last_bootID" == "X" || "X$last_bootID" != "X$bootID" ]]; then
    OS_IS_BOOTING=1
fi
start_time=$(cat /var/run/mlx_os_booting 2>/dev/null)
if [ "X$start_time" != "X" ]; then
    let run_time=$(date +%s | tr -d '[:space:]')-${start_time}
    if [ $run_time -lt 300 ]; then
        OS_IS_BOOTING=1
    fi
fi
# If driver was loaded manually after last boot, then OS boot is over
last_bootID_manual=$(cat /var/run/mlx_ifc.manual 2>/dev/null)
if [[ "X$last_bootID_manual" != "X" && "X$last_bootID_manual" == "X$bootID" ]]; then
    OS_IS_BOOTING=0
fi

. $CONFIG
IPOIB_MTU=${IPOIB_MTU:-65520}

# set configuration files
conf_files=/etc/network/interfaces
if (grep -w source /etc/network/interfaces 2>/dev/null | grep -qvE "^\s*#" 2>/dev/null); then
    # get absolute file paths
    for line in $(grep -w source /etc/network/interfaces 2>/dev/null | grep -vE "^\s*#" 2>/dev/null);
    do
        ff=$(echo "$line" | awk '{print $NF}')

        # check if it's absolute path
        if [ -f "$ff" ]; then
            conf_files="$conf_files $ff"
            continue
        fi

        # check if it's relative path
        if [ -z "$(ls $ff 2>/dev/null)" ]; then
            ff="/etc/network/$ff"
        fi

        # support wildcards
        for file in $(ls -1 $ff 2>/dev/null)
        do
            if [ -f "$file" ]; then
                conf_files="$conf_files $file"
            fi
        done
    done
fi
use_netplan=0
if [ ! -x  /sbin/ifup -a -x /usr/sbin/netplan ]; then
    use_netplan=1
    conf_files=""
fi

log_msg()
{
    logger -t 'mlnx_interface_mgr' -i "$@"
}

set_ipoib_cm()
{
    local i=$1
    shift
    local mtu=$1
    shift
    local is_up=""

    if [ ! -e /sys/class/net/${i}/mode ]; then
        log_msg "Failed to configure IPoIB connected mode for ${i}"
        return 1
    fi

    mtu=${mtu:-$IPOIB_MTU}

    #check what was the previous state of the interface
    is_up=`/sbin/ip link show $i | grep -w UP`

    /sbin/ip link set ${i} down
    if [ $? -ne 0 ]; then
        log_msg "set_ipoib_cm: Failed to bring down ${i} in order to change connection mode"
        return 1
    fi

    if [ -w /sys/class/net/${i}/mode ]; then
        echo connected > /sys/class/net/${i}/mode
        if [ $? -eq 0 ]; then
            log_msg "set_ipoib_cm: ${i} connection mode set to connected"
        else
            log_msg "set_ipoib_cm: Failed to change connection mode for ${i} to connected; this mode might not be supported by this device, please refer to the User Manual."
            RC=1
        fi
    else
        log_msg "set_ipoib_cm: cannot write to /sys/class/net/${i}/mode"
        RC=1
    fi

    if [ $RC -eq 0 ] ; then
        /sbin/ip link set ${i} mtu ${mtu}
        if [ $? -ne 0 ]; then
            log_msg "set_ipoib_cm: Failed to set mtu for ${i}"
            RC=1
        fi
    fi

    #if the intf was up returns it to
    if [ -n "$is_up" ]; then
        /sbin/ip link set ${i} up
        if [ $? -ne 0 ]; then
            log_msg "set_ipoib_cm: Failed to bring up ${i} after setting connection mode to connected"
            RC=1
        fi
    fi

    return $RC
}

set_RPS_cpu()
{
    local i=$1
    shift

    if [ ! -e /sys/class/net/${i}/queues/rx-0/rps_cpus ]; then
        log_msg "set_RPS_cpu: Failed to configure RPS cpu for ${i}; missing queues/rx-0/rps_cpus"
        return 1
    fi

    local LOCAL_CPUS=
    # try to get local_cpus of the device
    if [ -e /sys/class/net/${i}/device/local_cpus ]; then
        LOCAL_CPUS=$(cat /sys/class/net/${i}/device/local_cpus)
    elif [ -e /sys/class/net/${i}/parent ]; then
        # Pkeys do not have local_cpus, so take it from their parent
        local parent=$(cat /sys/class/net/${i}/parent)
        if [ -e /sys/class/net/${parent}/device/local_cpus ]; then
            LOCAL_CPUS=$(cat /sys/class/net/${parent}/device/local_cpus)
        fi
    fi

    if [ "X$LOCAL_CPUS" == "X" ]; then
        log_msg "set_RPS_cpu: Failed to configure RPS cpu for ${i}; cannot get local_cpus"
        return 1
    fi

    echo "$LOCAL_CPUS" > /sys/class/net/${i}/queues/rx-0/rps_cpus
    if [ $? -eq 0 ]; then
        log_msg "set_RPS_cpu: Configured RPS cpu for ${i} to $LOCAL_CPUS"
    else
        log_msg "set_RPS_cpu: Failed to configure RPS cpu for ${i} to $LOCAL_CPUS"
        return 1
    fi

    return 0
}

is_connected_mode_supported()
{
    local i=$1
    shift
    # Devices that support connected mode:
    #  "4113", "Connect-IB"
    #  "4114", "Connect-IBVF"
    local hca_type=""
    if [ -e /sys/class/net/${i}/device/infiniband ]; then
        hca_type=$(cat /sys/class/net/${i}/device/infiniband/*/hca_type 2>/dev/null)
    elif [ -e /sys/class/net/${i}/parent ]; then
        # for Pkeys, check their parent
        local parent=$(cat /sys/class/net/${i}/parent)
        hca_type=$(cat /sys/class/net/${parent}/device/infiniband/*/hca_type 2>/dev/null)
    fi
    if (echo -e "${hca_type}" | grep -qE "4113|4114" 2>/dev/null); then
        return 0
    fi

    # For other devices check the ipoib_enhanced module parameter value
    if (grep -q "^0" /sys/module/ib_ipoib/parameters/ipoib_enhanced 2>/dev/null); then
        # IPoIB enhanced is disabled, so we can use connected mode
        return 0
    fi

    log_msg "INFO: ${i} does not support connected mode"
    return 1
}

bring_up()
{
    local i=$1
    shift
    local RC=0

    MTU=`/usr/sbin/net-interfaces get-mtu ${i}`

    # relevant for IPoIB interfaces only
    local is_ipoib_if=0
    case "$(echo "${i}" | tr '[:upper:]' '[:lower:]')" in
        *ib* | *infiniband*)
        is_ipoib_if=1
        ;;
    esac
    if (/sbin/ethtool -i ${i} 2>/dev/null | grep -q "ib_ipoib"); then
        is_ipoib_if=1
    fi
    if [ $is_ipoib_if -eq 1 ]; then
        if [ "X${SET_IPOIB_CM}" == "Xyes" ]; then
            set_ipoib_cm ${i} ${MTU}
            if [ $? -ne 0 ]; then
                RC=1
            fi
        elif [ "X${SET_IPOIB_CM}" == "Xauto" ]; then
            # handle mlx5 interfaces, assumption: mlx5 interface will be with CM mode.
            local drvname=""
            if [ -e /sys/class/net/${i}/device/driver/module ]; then
                drvname=$(basename `readlink -f /sys/class/net/${i}/device/driver/module 2>/dev/null` 2>/dev/null)
            elif [ -e /sys/class/net/${i}/parent ]; then
                # for Pkeys, check their parent
                local parent=$(cat /sys/class/net/${i}/parent)
                drvname=$(basename `readlink -f /sys/class/net/${parent}/device/driver/module 2>/dev/null` 2>/dev/null)
            fi
            if [ "X${drvname}" == "Xmlx5_core" ]; then
                if is_connected_mode_supported ${i} ; then
                    set_ipoib_cm ${i} ${MTU}
                    if [ $? -ne 0 ]; then
                        RC=1
                    fi
                fi
            fi
        fi
        # Spread the one and only RX queue to more CPUs using RPS.
        local num_rx_queue=$(ls -l /sys/class/net/${i}/queues/ 2>/dev/null | grep rx-  | wc -l | awk '{print $1}')
        if [ $num_rx_queue -eq 1 ]; then
            set_RPS_cpu ${i}
            if [ $? -ne 0 ]; then
                RC=1
            fi
        fi
    fi

    if [ "$use_netplan" = 1 ]; then
        # System does not use ifupdown. No use in manually
        # starting interface.
        return 0
    fi

    if ! (grep -wh ${i} $conf_files 2>/dev/null | grep -qvE "^\s*#" 2>/dev/null); then
        log_msg "No configuration found for ${i}"
        return 4
    fi

    if [ $OS_IS_BOOTING -eq 1 ]; then
        log_msg "OS is booting, will not run ifup on $i"
        return 6
    fi

    local bond=`/usr/sbin/net-interfaces get-bond-master ${i}`
    if [ -z "$bond" ]; then
        if [[ $WINDRIVER -eq 0 && $BLUENIX -eq 0 ]]; then
            /sbin/ifup --force ${i}
        else
            env PATH=$PATH:/sbin /sbin/ifup -f ${i} 2>&1
        fi
        if [ $? -eq 0 ]; then
            log_msg "Bringing up interface $i: PASSED"
        else
            log_msg "Bringing up interface $i: FAILED"
            return 1
        fi
    fi

    local bond_lock="/var/lock/mlnx_bond_${bond}.lock"
    local my_lock=""
    if [ ! -z "$bond" ]; then
        # get an exclusive lock, so taht we will run ifup on the interface just one time
        exec 9>"$bond_lock"
        if (flock -x -n 9 &>/dev/null); then
            my_lock=$bond_lock
            bond_missing=`/sbin/ip link show $bond 2>&1 | grep -i "does not exist"`
            is_up_bond=`/sbin/ip link show $bond 2>/dev/null | grep -w UP`
            if [[ ! -z "$bond_missing" || -z "$is_up_bond" ]]; then
                if [ ! -z "$bond_missing" ]; then
                    /bin/sleep 1
                    /sbin/ifup --force $bond
                elif [ -z "$is_up_bond" ]; then
                    /sbin/ifup $bond
                fi
                if [ $? -eq 0 ]; then
                    log_msg "$i - briging up bond master $bond: PASSED"
                else
                    log_msg "$i - briging up bond master $bond: FAILED"
                    RC=1
                fi
            elif [ -e "/.dockerenv" ] || (grep -q docker /proc/self/cgroup &>/dev/null); then
                /sbin/ifup --force $bond
            fi
        else
            /bin/sleep 1
        fi

        /bin/sleep 2
        bond_missing=`/sbin/ip link show $bond 2>&1 | grep -i "does not exist"`
        if [ -z "$bond_missing" ] && !(grep -Eiw "Slave.*${i}$" /proc/net/bonding/${bond} 2>/dev/null); then
            /sbin/ifenslave -f $bond ${i}
            if [ $? -eq 0 ]; then
                log_msg "$i - enslaving $i to $bond: PASSED"
            else
                log_msg "$i - enslaving $i to $bond: FAILED"
                RC=1
            fi
        fi
    fi

    [ ! -z "$my_lock" ] && /bin/rm -f "$my_lock"

    return $RC
}

# main
log_msg "Setting up Mellanox network interface: $i"

# Don't touch Ethernet interfaces when OS is booting
if [ $OS_IS_BOOTING -eq 1 ]; then
    case "$(echo "$i" | tr '[:upper:]' '[:lower:]')" in
        *ib* | *infiniband*)
        ;;
        *)
        log_msg "Got ETH interface $i and OS is booting, skipping."
        exit 0
        ;;
    esac
fi

# bring up the interface
bring_up $i
if [ $? -eq 1 ]; then
    log_msg "Couldn't fully configure ${i}, review system logs and restart network service after fixing the issues."
fi

# call mlnx_conf_mgr.sh for IB interfaces
case "$(echo "$i" | tr '[:upper:]' '[:lower:]')" in
    *ib* | *infiniband*)
    log_msg "Running: /bin/mlnx_conf_mgr.sh ${i}"
    /bin/mlnx_conf_mgr.sh ${i}
    ;;
esac

# Bring up child interfaces if configured.
for file in $conf_files
do
    while read _line
    do
        if [[ ! "$_line" =~ ^# && "$_line" =~ $i\.[0-9a-fA-F]* && "$_line" =~ "iface" ]]
        then
            ifname=$(echo $_line | cut -f2 -d" ")

            if [ ! -f /sys/class/net/$i/create_child ]; then
                continue
            fi

            suffix=$(echo ${ifname##*.} | tr '[:upper:]' '[:lower:]')
            if [[ ${suffix} =~ ^[0-9a-f]{1,4}$ ]]; then
                hexa=$(printf "%x" $(( 0x${suffix} | 0x8000 )))
                if [[ ${hexa} != ${suffix} ]]; then
                    log_msg "Error: MSB is NOT set for pkey ${suffix} (should be ${hexa}); skipping interface ${ifname}."
                    continue
                fi
            else
                log_msg "Error: pkey ${suffix} is not hexadecimal (maximum 4 digits); skipping."
                continue
            fi
            pkey=0x${hexa}

            if [ ! -e /sys/class/net/$ifname ] ; then
                {
                local retry_cnt=0
                echo $pkey > /sys/class/net/$i/create_child
                while [[ $? -ne 0 && $retry_cnt -lt 10 ]]; do
                    sleep 1
                    let retry_cnt++
                    echo $pkey > /sys/class/net/$i/create_child
                done
                } > /dev/null 2>&1
            fi
            # Note: no need to call 'bring_up $ifname' anymore.
            # There is a new udev rule that calls this script to configure pkeys.
            # This is needed so that the script can configure also manually created pkeys by users.
        fi
    done < "$file"
done

# vi:ts=4 sts=4 sw=0 expandtab:
