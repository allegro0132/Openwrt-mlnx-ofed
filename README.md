# Openwrt-mlnx-ofed

* 该项目为OpenWRT源码包，在编译过程中选中，即能安装最新版本的MLNX_OFED驱动。

* 在一些应用场景下，需要在虚拟机中使用OpenWRT，特别的，会将SR-IOV功能开启的VF，直通进入OpenWRT虚拟机。
* 但是，OpenWRT集成的Mellanox系列网卡驱动，会在这种应用场景下出错，表现为无限重启。该项目则为解决这一问题而开设。

 1. lede/package$下运行 或者openwrt/package$下运行


```bash
 git clone https://github.com/allegro0132/Openwrt-mlnx-ofed.git
```

 2. 亦或是添加下面代码到 openwrt 或lede源码根目录下的feeds.conf.default文件
 
```bash
 src-git allegro https://github.com/allegro0132/Openwrt-mlnx-ofed
```

 3. make menuconfig 并在编译过程中取消"mlx5, mlx4", 选择"mlnx_ofed"
 
 * 说明
 - 倘若直接使用Mellanox提供的源码编译，在mlx5_core的编译过程中将会报错。我简单的修改了源码，在我的测试环境中能正常工作，但目前尚不明确改版驱动是否会导致问题。
 ```bash
  CC [M]  /lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/drivers/net/ethernet/mellanox/mlx5/core/en_tc.o
In file included from /lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:50:
/lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/include/net/tc_act/tc_mirred.h: In function 'to_mirred_compat':
/lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/include/net/tc_act/tc_mirred.h:51:24: error: dereferencing pointer to incomplete type 'const struct tc_action_ops'
  if (!a->ops || !a->ops->dump || !is_tcf_mirred_compat(a))
                        ^~
scripts/Makefile.build:261: recipe for target '/lede/build_dir/target-x86_64_musl/linux-x86_64/mlnx_ofed-4.9-2.2.4.0/mlnx-ofed-kernel-4.9/drivers/net/ethernet/mellanox/mlx5/core/en_tc.o' failed
```
- 修改之后的源码已经push在mlnx_ofed/mlnx-ofed-kernel-4.9文件夹中，还望大家不吝赐教。
