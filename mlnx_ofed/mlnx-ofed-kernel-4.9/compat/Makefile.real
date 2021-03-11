obj-m += mlx_compat.o
#compat-objs :=

obj-$(CONFIG_COMPAT_FIRMWARE_CLASS) += compat_firmware_class.o
obj-$(CONFIG_COMPAT_NET_SCH_CODEL) += sch_codel.o
obj-$(CONFIG_COMPAT_NET_SCH_FQ_CODEL) += sch_fq_codel.o

mlx_compat-y += main.o

# Compat kernel compatibility code
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_18) += compat-2.6.18.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_19) += compat-2.6.19.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_21) += compat-2.6.21.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_22) += compat-2.6.22.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_23) += compat-2.6.23.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_24) += compat-2.6.24.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_25) += \
	compat-2.6.25.o

mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_26) += compat-2.6.26.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_27) += compat-2.6.27.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_28) += compat-2.6.28.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_29) += compat-2.6.29.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_32) += compat-2.6.32.o

mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_33) += compat-2.6.33.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_34) += compat-2.6.34.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_35) += compat-2.6.35.o

mlx_compat-y += kthread.o

mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_36) += compat-2.6.36.o

mlx_compat-$(CONFIG_COMPAT_KFIFO) += kfifo.o

mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_37) += compat-2.6.37.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_38) += compat-2.6.38.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
	compat-2.6.39.o \
	kstrtox.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_2) += compat-3.2.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_3) += \
	compat-3.3.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_4) += compat-3.4.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_5) += compat-3.5.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_6) += compat-3.6.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_7) += compat-3.7.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_9) += compat-3.9.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_10) += compat-3.10.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_11) += compat-3.11.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_12) += compat-3.12.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_13) += compat-3.13.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_15) += compat-3.15.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_16) += compat-3.16.o
mlx_compat-$(CONFIG_COMPAT_KERNEL_3_18) += compat-3.18.o

mlx_compat-$(CONFIG_COMPAT_KERNEL_4_1) += compat-4.1.o

mlx_compat-$(CONFIG_COMPAT_CORDIC) += cordic.o
mlx_compat-$(CONFIG_COMPAT_CRC8) += crc8.o
mlx_compat-$(CONFIG_COMPAT_FLOW_DISSECTOR) += flow_dissector.o
mlx_compat-y += string.o
mlx_compat-y += output_core.o
mlx_compat-y += idr.o

ifndef CONFIG_64BIT
ifndef CONFIG_GENERIC_ATOMIC64
  mlx_compat-y += compat_atomic.o
endif
endif

mlx_compat-y += xz_crc32.o
mlx_compat-y += xz_dec_lzma2.o
mlx_compat-y += xz_dec_stream.o
mlx_compat-y += xz_dec_syms.o
mlx_compat-$(CONFIG_XZ_DEC_BCJ) += xz_dec_bcj.o

mlx_compat-y += mm_util.o
mlx_compat-y += uuid.o
mlx_compat-y += rhashtable.o
mlx_compat-y += ../block/blk-mq-rdma.o
mlx_compat-y += exec.o
mlx_compat-y += pci.o
mlx_compat-y += rbtree.o
mlx_compat-y += syscall.o
mlx_compat-y += mmu_notifier.o
mlx_compat-y += radix-tree.o
mlx_compat-y += xarray.o
ifdef CONFIG_MLX5_ESWITCH
mlx_compat-y += flow_offload.o
mlx_compat-y += cls_api.o
endif

mlx_compat-y += bitmap.o
