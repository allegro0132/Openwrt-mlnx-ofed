obj-m += mlx_compat.o

mlx_compat-y += main.o find_last_bit.o

mlx_compat-$(CONFIG_COMPAT_KOBJECT_BACKPORT) += kobject_backport.o

mlx_compat-y += compat-2.6.17.o \
		compat-2.6.37.o \
		compat-2.6.24.o \
		compat-2.6.36.o \
		compat-3.5.o    \
		compat-3.15.o   \
		kstrtox.o
