#include <linux/kernel.h>
#include <linux/export.h>
#include <linux/crash_dump.h>

#ifndef HAVE_ELFCOREHDR_ADDR_EXPORTED
#ifndef ELFCORE_ADDR_MAX
#define ELFCORE_ADDR_MAX        (-1ULL)
#endif

#define elfcorehdr_addr LINUX_BACKPORT(elfcorehdr_addr)
unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
EXPORT_SYMBOL_GPL(elfcorehdr_addr);
#endif /* HAVE_ELFCOREHDR_ADDR_EXPORTED */
