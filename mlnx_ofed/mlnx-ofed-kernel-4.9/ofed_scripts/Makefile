EXTRA_CFLAGS += $(OPENIB_KERNEL_EXTRA_CFLAGS) \
		$(KERNEL_MEMTRACK_CFLAGS) \
		-I$(CWD)/include \
		-I$(CWD)/drivers/infiniband/ulp/ipoib$(CONFIG_IPOIB_VERSION) \
		-I$(CWD)/drivers/infiniband/debug \
		-I$(CWD)/net/rds \
		-I$(CWD)/drivers/net/ethernet/mellanox/mlx4 \
		-I$(CWD)/drivers/net/ethernet/mellanox/mlx5/core \
		-I$(CWD)/drivers/infiniband/hw/mlx4 \
		-I$(CWD)/drivers/infiniband/hw/mlx5 \

ifneq (,$(CFLAGS_RETPOLINE))
# This is x86 and kernel has no retpoline support.
# Now we need to check for gcc support
ifneq (,$(shell $(CC) --target-help 2>/dev/null | grep -- -mindirect-branch=))
# The compiler supports it. Set the proper flags (inline or extern):
subdir-ccflags-y += $(CFLAGS_RETPOLINE)
endif
endif

obj-y := compat$(CONFIG_COMPAT_VERSION)/
obj-$(CONFIG_INFINIBAND)        += drivers/infiniband/
obj-$(CONFIG_INFINIBAND_IPATH)  += drivers/infiniband/hw/ipath/
obj-$(CONFIG_INFINIBAND_EHCA)   += drivers/infiniband/hw/ehca/
obj-$(CONFIG_INFINIBAND_AMSO1100)   += drivers/infiniband/hw/amso1100/
obj-$(CONFIG_MLX4_CORE)         += drivers/net/ethernet/mellanox/mlx4/
obj-$(CONFIG_MLX5_CORE)         += drivers/net/ethernet/mellanox/mlx5/core/
obj-$(CONFIG_MLX5_FPGA_TOOLS)   += drivers/net/ethernet/mellanox/mlx5/fpga/
obj-$(CONFIG_MLXFW)             += drivers/net/ethernet/mellanox/mlxfw/
obj-$(CONFIG_VFIO_MDEV)         += drivers/vfio/mdev/
obj-$(CONFIG_RDS)               += net/rds/
obj-$(CONFIG_MEMTRACK)          += drivers/infiniband/debug/
obj-$(CONFIG_SUNRPC_XPRT_RDMA)  += net/sunrpc/xprtrdma/
obj-$(CONFIG_SUNRPC_XPRT_RDMA_DUMMY)  += net/sunrpc/xprtrdma/
obj-$(CONFIG_SUNRPC_XPRT_RDMA_CLIENT)  += net/sunrpc/xprtrdma/
obj-$(CONFIG_SUNRPC_XPRT_RDMA_SERVER)  += net/sunrpc/xprtrdma/
obj-$(CONFIG_NET_9P_RDMA) += net/9p/
obj-$(CONFIG_SCSI_SRP_ATTRS)    += drivers/scsi/
obj-$(CONFIG_NVME_CORE)         += drivers/nvme/host/
obj-$(CONFIG_NVME_HOST_WITHOUT_FC)      += drivers/nvme/host/
obj-$(CONFIG_NVME_HOST_WITHOUT_FC)      += drivers/nvme/target/
obj-$(CONFIG_BLK_DEV_NVME)      += drivers/nvme/host/
obj-$(CONFIG_NVME_FABRICS)      += drivers/nvme/host/
obj-$(CONFIG_NVME_FC)           += drivers/nvme/host/
obj-$(CONFIG_NVME_RDMA)         += drivers/nvme/host/
obj-$(CONFIG_NVME_TCP)          += drivers/nvme/host/
obj-$(CONFIG_NVME_MULTIPATH)    += drivers/nvme/host/
obj-$(CONFIG_NVME_HOST_DUMMY)   += drivers/nvme/host/
obj-$(CONFIG_NVME_TARGET)       += drivers/nvme/target/
obj-$(CONFIG_NVME_TARGET_LOOP)  += drivers/nvme/target/
obj-$(CONFIG_NVME_TARGET_RDMA)  += drivers/nvme/target/
obj-$(CONFIG_NVME_TARGET_TCP)   += drivers/nvme/target/
obj-$(CONFIG_NVME_TARGET_FC)    += drivers/nvme/target/
obj-$(CONFIG_NVME_TARGET_FCLOOP)  += drivers/nvme/target/
obj-$(CONFIG_NVME_TARGET_DUMMY) += drivers/nvme/target/
obj-$(CONFIG_RDMA_RXE_DUMMY)	+= drivers/infiniband/sw/rxe/
obj-$(CONFIG_SMC)		+= net/smc/
obj-$(CONFIG_SMC_DIAG)		+= net/smc/

ifneq ($(CONFIG_MLX5_ESWITCH),)
	obj-$(CONFIG_COMPAT_CLS_FLOWER_MOD)     += net/sched/cls_flower.o
	obj-$(CONFIG_COMPAT_TCF_TUNNEL_KEY_MOD) += net/sched/act_tunnel_key.o
	obj-$(CONFIG_COMPAT_TCF_VLAN_MOD)       += net/sched/act_vlan.o
	obj-$(CONFIG_COMPAT_TCF_PEDIT_MOD)      += net/sched/act_pedit.o
endif
