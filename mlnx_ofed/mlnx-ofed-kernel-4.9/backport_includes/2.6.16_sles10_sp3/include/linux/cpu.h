#ifndef BACKPORT_2_6_17_LINUX_CPU_H
#define BACKPORT_2_6_17_LINUX_CPU_H

#include_next <linux/cpu.h>
#define register_hotcpu_notifier(nb)  register_cpu_notifier(nb)
#define unregister_hotcpu_notifier(nb)  unregister_cpu_notifier(nb)
#endif
