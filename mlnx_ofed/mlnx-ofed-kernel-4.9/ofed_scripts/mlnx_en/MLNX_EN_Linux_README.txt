                    Mellanox Technologies
                    =====================

===============================================================================
                   MLNX_EN for Linux README
     Driver Kit for Mellanox Adapter Cards with 10GigE Support
                 Version 1.5.10 January 2013
                      Document No. 2950
===============================================================================


-------------------------------------------------------------
NOTE:

THIS HARDWARE, SOFTWARE OR TEST SUITE PRODUCT (PRODUCT(S)) 
AND ITS RELATED DOCUMENTATION ARE PROVIDED BY MELLANOX 
TECHNOLOGIES AS-IS WITH ALL FAULTS OF ANY KIND AND SOLELY 
FOR THE PURPOSE OF AIDING THE CUSTOMER IN TESTING APPLICATIONS 
THAT USE THE PRODUCTS IN DESIGNATED SOLUTIONS. THE CUSTOMER'S 
MANUFACTURING TEST ENVIRONMENT HAS NOT MET THE STANDARDS SET 
BY MELLANOX TECHNOLOGIES TO FULLY QUALIFY THE PRODUCTO(S) 
AND/OR THE SYSTEM USING IT. THEREFORE, MELLANOX TECHNOLOGIES 
CANNOT AND DOES NOT GUARANTEE OR WARRANT THAT THE PRODUCTS 
WILL OPERATE WITH THE HIGHEST QUALITY. ANY EXPRESS OR IMPLIED 
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE AND NONINFRINGEMENT ARE DISCLAIMED. IN NO EVENT SHALL 
MELLANOX BE LIABLE TO CUSTOMER OR ANY THIRD PARTIES FOR ANY 
DIRECT, INDIRECT, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
OF ANY KIND (INCLUDING, BUT NOT LIMITED TO, PAYMENT FOR 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY FROM THE USE OF THE PRODUCT(S) AND RELATED 
DOCUMENTATION EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE.

--------------------------------------------------------------
© Copyright 2013. Mellanox Technologies. All rights reserved. 

Mellanox®, Mellanox Logo®, BridgeX®, ConnectX®, CORE-Direct®, 
InfiniBridge®, InfiniHost®, InfiniScale®, PhyX®, SwitchX®, 
Virtual Protocol Interconnect® and Voltaire® 
are registered trademarks of Mellanox Technologies, Ltd.

Connect-IB™, FabricIT™, MLNX-OS™, MetroX™, ScalableHPC™, 
Unbreakable-Link™, UFM™ and Unified Fabric Manager™ 
are trademarks of Mellanox Technologies, Ltd. 

All other trademarks are property of their respective owners.


Contents:
=========
1. Overview
   1.1 Package Contents
2. Supported Platforms, Operating Systems and Firmware
3. Software Dependencies
4. Driver Installation
   4.1 Installing the Driver
   4.2 Loading the Driver
   4.3 Unloading the Driver
   4.4 Uninstalling the Driver
5. Ethernet Driver Usage and Configuration
6. Firmware Programming
   6.1 Installing Firmware Tools
   6.2 Downloading the Firmware Image of the Adapter Card
   6.3 Updating Adapter Card Firmware
7. Perfromance Tuning
8. Revision History

===============================================================================
1. Overview
===============================================================================
This document provides information on the MLNX_EN Linux driver and
instructions for installing the driver on Mellanox ConnectX adapter cards
supporting 10Gb/s Ethernet. 

The driver is intended for adapter cards that identify on the PCI bus as with
one of the following PCI Device IDs (decimal): 25408, 25418, 25448, 26418,
26448, 26428, 25458, 26458, 26468, 26438, 26478, 26488 4099.

The MLNX_EN driver release exposes the following capabilities:
- Single/Dual port
- Up to 16 Rx queues per port
- 16 Tx queues per port
- Rx steering mode: Receive Core Affinity (RCA)
- MSI-X or INTx
- Adaptive interrupt moderation
- HW Tx/Rx checksum calculation
- Large Send Offload (i.e., TCP Segmentation Offload)
- Large Receive Offload
- Multi-core NAPI support
- VLAN Tx/Rx acceleration (HW VLAN stripping/insertion)
- Ethtool support
- Net device statistics

1.1 Package Contents
--------------------
This driver kit contains the following:

- Kernel modules
  * mlx4 driver
    mlx4 is the low level driver implementation for the ConnectX adapters
    designed by Mellanox Technologies. The ConnectX can operate as an
    InfiniBand adapter and as an Ethernet NIC.
    To accommodate the two flavors, the driver is split into modules: 
    mlx4_core, mlx4_en, and mlx4_ib.
    
    Note: mlx4_ib is not part of this package

    - mlx4_core
      Handles low-level functions like device initialization and firmware
      commands processing. Also controls resource allocation so that the
      InfiniBand, Ethernet and FC functions can share a device without
      interfering with each other.

    - mlx4_en
      Handles Ethernet specific functions and plugs into the netdev
      mid-layer.
    

- mstflint
  An application to burn a firmware binary image

- Sources of all software modules (under conditions mentioned in the modules'
  LICENSE files)

- Documentation

===============================================================================
2. Supported Platforms, Operating Systems and Firmware
===============================================================================
  o   CPU architectures:
        - x86_64

  o   HW:
	- Winterfell servers
	- Dragonstone servers

  o   Cards:
	- Harrier 2G
	- Harrier 3G

  o   Linux Operating Systems:
	- CentOS5.2 + 2.6.38fbk32
	- CentOS5.2 + 3.2.18fbk11
    
  o   Supported Firmware
    	- 2.10.3898 or higher verified for Facebook

===============================================================================
3. Software Dependencies
===============================================================================
- To install the driver software, kernel sources must be installed on the
  machine.
- MLNX_EN driver cannot coexist with OFED software on the same machine.
  Hence when installing MLNX_EN all OFED packages should be removed (done by
  the mlnx_en install script).

===============================================================================
4. Driver Installation
===============================================================================
4.1 Installing the Driver
-------------------------
Step 1: Download Driver Package
        Please download the current driver package from
        http://www.mellanox.com/content/pages.php?pg=products_dyn&product_family=27&menu_section=35

Step 2: Install Driver
        Run the following commands to install the driver:
        #> tar xzvf mlnx_en-1.5.10.tgz file
        #> cd mlnx_en-1.5.10
        #> ./install.sh

   The package consists of several source RPMs. The install script rebuilds the
   source RPMs and then installs the created binary RPMs. The created kernel
   module binaries are placed under /lib/modules/<kernel-ver>/updates/kernel/drivers/net/mlx4.

   mlnx_en installer supports 2 modes of installation.
   The install scripts selects the mode of driver installation depending of
   the running OS/kernel version.
       1. Kernel Module Packaging (KMP) mode, where the source rpm is 
          rebuilt for each installed flavor of the kernel. This mode is used
          for RedHat and SUSE distributions.
       2. Non KMP installation mode, where the sources are rebuilt with
          the running kernel. This mode is used for vanilla kernels.
   
   NOTE: If the Vanilla kernel is installed as rpm, please use the "--disable-kmp"
        flag when installing the driver.

   The kernel module sources are placed under /usr/src/mellanox-mlnx-en-1.5.10/.
   Run the following commands to recompile the driver:
        #> cd /usr/src/mellanox-mlnx-en-1.5.10/
        #> scripts/mlnx_en_patch.sh
        #> make
        #> make install
   The uninstall and performance tuning scripts are installed.
   
   NOTE: If the driver was installed without kmp support,
		 the sources would be located under /usr/srs/mlnx_en-1.5.10/

4.2 Loading the Driver
----------------------
Step 1: Make sure no previous driver version is currently loaded
        Run:
        #> modprobe -r mlx4_en
   
Step 2: Load the new driver version
        Run:
        #> modprobe mlx4_en

   The result is a new net-device appearing in 'ifconfig -a' output. 
   See "Ethernet Driver Usage" for details on driver usage and configuration.

4.3 Unloading the Driver
------------------------
To unload the Ethernet driver run:
   #> modprobe -r mlx4_en

4.4 Uninstalling the Driver
--------------------------
To uninstall the mlnx_en driver run:
   #> /sbin/mlnx_en_uninstall.sh

===============================================================================
5. Ethernet Driver Usage and Configuration
===============================================================================
- To assign an IP address to the interface run:
  #> ifconfig eth<x> <ip>

   where 'x' is the OS assigned interface number.

- To check driver and device information run:
  #> ethtool -i eth<x>

  Example:
  #> ethtool -i eth2
  driver: mlx4_en (MT_0DD0120009_CX3)
  version: 1.5.10 (Jan 2013)
  firmware-version: 2.10.3898
  bus-info: 0000:1a:00.0

- To query stateless offload status run:
  #> ethtool -k eth<x>

- To set stateless offload status run:
  #> ethtool -K eth<x> [rx on|off] [tx on|off] [sg on|off] [tso on|off] [lro on|off]

- To query interrupt coalescing settings run:
  #> ethtool -c eth<x>

- By default, the driver uses adaptive interrupt moderation for the receive
  path, which adjusts the moderation time to the traffic pattern.
  To enable/disable adaptive interrupt moderation use the following command:
  #>ethtool -C eth<x> adaptive-rx on|off

- Above an upper limit of packet rate, adaptive moderation will set the
  moderation time to its highest value. Below a lower limit of packet rate,
  the moderation time will be set to its lowest value.
  To set the values for packet rate limits and for moderation time high and low
  values, use the following command:
  #> ethtool -C eth<x> [pkt-rate-low N] [pkt-rate-high N] [rx-usecs-low N] [rx-usecs-high N]

- To set interrupt coalescing settings when adaptive moderation is disabled, use:
  #> ethtool -C eth<x> [rx-usecs N] [rx-frames N]
 
  Note: usec settings correspond to the time to wait after the *last* packet is
  sent/received before triggering an interrupt.

- To query pause frame settings run:
  #> ethtool -a eth<x>

- To set pause frame settings run:
  #> ethtool -A eth<x> [rx on|off] [tx on|off]

- To query ring size values run:
  #> ethtool -g eth<x>

- To modify rings size run:
  #> ethtool -G eth<x> [rx <N>] [tx <N>]

- To obtain additional device statistics, run:
  #> ethtool -S eth<x>

- To perform a self diagnostics test, run:
  #> ethtool -t eth<x>


The driver defaults to the following parameters:
- Both ports are activated (i.e., a net device is created for each port)
- The number of Rx rings for each port is the nearest power of 2 of number of cpu cores, limited by 16.
- LRO is enabled with 32 concurrent sessions per Rx ring

Some of these values can be changed using module parameters, which can be
displayed by running:
#> modinfo mlx4_en 

To set non-default values to module parameters, the following line should be
added to /etc/modprobe.conf file:
 "options mlx4_en <param_name>=<value> <param_name>=<value> ..."

Values of all parameters can be observed in /sys/module/mlx4_en/parameters/. 

===============================================================================
6. Firmware Programming
===============================================================================
The adapter card was shipped with the most current firmware available. This
section is intended for future firmware upgrades, and provides instructions for
(1) installing Mellanox firmware update tools (MFT), (2) downloading FW, and
(3) updating adapter card firmware.

6.1 Installing Firmware Tools
-----------------------------
The driver package compiles and installs the Mellanox 'mstflint' utility under
/usr/local/bin/. You may also use this tool to burn a card-specific firmware
binary image. See the file /tmp/mlnx_en/src/utils/mstflint/README file for
details.

Alternatively, you can download the current Mellanox Firmware Tools package 
(MFT) from http://www.mellanox.com > Downloads > Firmare Tools. The tools 
package to download is "MFT_SW for Linux" (tarball name is mft-X.X.X.tgz).

6.2 Downloading the Firmware Image of the Adapter Card
------------------------------------------------------
To download the correct card firmware image, please visit
http://www.mellanox.com > Downloads > Firmware.

For help in identifying your adapter card, please visit
http://www.mellanox.com/content/pages.php?pg=firmware_HCA_FW_identification.

6.3 Updating Adapter Card Firmware
---------------------------------
Using a card specific binary firmware image file, enter the following command:
#> mstflint -d mtXXXXX_pci_cr0 -i <image_name.bin> b

 where XXXXX stands for the PCI Device ID (decimal).

For burning firmware using the MFT package, please check the MFT user's manual
under http://www.mellanox.com > Downloads > Firmare Tools.

*** IMPORTANT NOTE ***
After burning new firmware to an adapter card, reboot the machine so that the
new firmware can take effect.

===============================================================================
7. Perfromance Tuning
===============================================================================
7.1 Increasing packet rate
--------------------------
To increase packet rate (especially for small packets), set the value of 
"high_rate_steer" module parameter in mlx4_module to 1 (default 0).
*** Note: Enabling this mode will cause the following chassis management features 
          to stop working:
	      NCSI
	      RoL

7.2 Managing IRQ Core Affinity
------------------------------
IRQ Affinity scripts are installed as part of driver installation.
   o For Intel Sandy Bridge systems set the irq affinity to the adapter's NUMA
     node:
       - For optimizing single-port traffic, run:
         # set_irq_affinity_bynode.sh <numa node> <interface>
       - For optimizing dual-port traffic, run:
         # set_irq_affinity_bynode.sh <numa node> <interface1> <interface2>
       - To show the current irq affinity settings, run:
         # show_irq_affinity.sh <interface>
       - To show the current irq affinity hints settings, run:
         # show_irq_affinity_hints.sh <interface>

   o AMD systems hase 2 NUMA nodes which are closer to the PCIe adapter.
       - In 2-socket system the adapter is connected to socket 0 (NUMA 0 + 1)
         # set_irq_affinity_cpulist.sh <numa 0 and numa 1 cores> <interface>
       - In 4-socket system the adapter is connected either to socket 0
         (NUMA 0 + 1) of socket 3 (NUMA 6 + 7)
         # set_irq_affinity_cpulist.sh <numa 6 and numa 7 cores> <interface>
         Example:
         # set_irq_affinity_cpulist.sh 0-12 eth5

   For Intel Nehalem/Westmere platforms set the irq affinity balanced across all
   the cores in the system.

   o For all other systems:
       - For optimizing single-port traffic, run:
         # set_irq_affinity.sh <interface>
       - For optimizing dual-port traffic, run:
         # set_irq_affinity.sh <interface1> <interface2>
       - To show the current irq affinity settings, run:
         # show_irq_affinity.sh <interface>
       - To show the current irq affinity hints settings, run:
         # show_irq_affinity_hints.sh <interface>

   Example:
   Tuning for RFC2544 throughput benchmark where adapter's node is '0':
     # /etc/init.d/irqbalancer stop
     # set_irq_affinity_bynode.sh 0 eth3 eth4

===============================================================================
8. Revision History
===============================================================================
* Rev 1.5.10  (January 2013)
* Rev 1.5.9   (September 2012)
* Rev 1.5.8.3 (June 2012)
* Rev 1.5.8.2 (June 2012)
* Rev 1.5.8.1 (May 2012)
* Rev 1.5.7.2 (March 2012)
* Rev 1.5.7   (November 2011)
* Rev 1.5.6   (January 2011)
* Rev 1.5.1.3 (July 2010)
* Rev 1.4.2   (September 2009)
* Rev 1.4.1   (April 2009)
* Rev 1.3.0   (Sep 2008)
* Rev 1.0     (July 2008)
