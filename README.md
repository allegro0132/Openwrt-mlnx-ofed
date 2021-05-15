# Openwrt-mlnx-ofed

* 该项目为OpenWRT源码包，在编译过程中选中以集成最新版本MLNX_OFED驱动。本源码包默认提供MLNX_OFED 4.9版本驱动，同时支持cx3，cx4及之后的Mellanox网卡。本项目开发目的如下：

* a) 增加IB网络支持
- 通过安装本驱动，可以令你的OpenWRT路由器同时支持Infiniband和ETH网络，并能利用ipoib在ib网络上实现tcpip通信。本源码包正确编译运行后，输入
```bash
ip address
```
- 即可在输出中看到“ib0” ipoib网络适配器。
* b) 在IB子网与ETH子网间通信
- 网络拓扑如下：外网通过eth接入wan端口，eth子网从lan端口接出，而ib子网从ib0端口输出。
需要先在IB子网的一台机器上开启opensm服务程序（暂不支持Openwrt），然后给ib0适配器配置ip地址，并将lan与ib0置于防火墙的同一区域下。这时ib适配器可与lan侧的eth设备通信，同理也能和wan侧通信。ib子网将与原有的eth网络通过openwrt三层功能连在一起，从而自由的访问外网。
* c) 增强SRIOV兼容性
- 在虚拟机宿主开启SRIOV功能，并将VF直通进入OpenWRT虚拟机，能达到极佳的网友性能。但是OpenWRT集成的Mellanox系列网卡驱动，会在这种应用场景下无限重启，使用本源码包替代原有的mlx4，mlx5驱动，便能解决这一问题。

使用方法：

 1. lede/package$下运行 或者openwrt/package$下运行


```bash
git clone https://github.com/allegro0132/Openwrt-mlnx-ofed.git
```

 2. make menuconfig 并在编译过程中选择"mlnx_ofed"，取消选择"kmod-mlx5, kmod-mlx4" 

 3. 一点优化(可选)
  由于compat与mlx_compat存在冲突，ath系列和rx2x00系列驱动无法安装，并会在开机时产生如下报错
 ```
 kmodloader: 15 modules could not be probed
 ```
 可以按照如下次序取消选择kmod，让开机界面清爽一些：
```
kmod-rt2800-usb
kmod-rt2x00-lib
kmod-ath9k
kmod-ath9k-htc
kmod-ath5k
kmod-ath10k
kmod-ath
kmod-mac80211
kmod-cfg80211
```


 * 说明
 - 直接使用Mellanox提供的源码编译，在mlx5_core的编译过程中将会报错。我简单的修改了源码，使其能正常编译，但目前尚不明确改版驱动是否会导致问题。
 ```bash
  CC [M]  /lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/drivers/net/ethernet/mellanox/mlx5/core/en_tc.o
In file included from /lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:50:
/lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/include/net/tc_act/tc_mirred.h: In function 'to_mirred_compat':
/lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/include/net/tc_act/tc_mirred.h:51:24: error: dereferencing pointer to incomplete type 'const struct tc_action_ops'
  if (!a->ops || !a->ops->dump || !is_tcf_mirred_compat(a))
                        ^~
scripts/Makefile.build:261: recipe for target '/lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/drivers/net/ethernet/mellanox/mlx5/core/en_tc.o' failed
```
- 我在这里直接去掉
```
|| !a->ops->dump
```
- 具体的改动已经注释在"mlnx-ofed-kernel-4.9/drivers/net/ethernet/mellanox/mlx5/core/en_tc.o"中，还望大家不吝赐教。
