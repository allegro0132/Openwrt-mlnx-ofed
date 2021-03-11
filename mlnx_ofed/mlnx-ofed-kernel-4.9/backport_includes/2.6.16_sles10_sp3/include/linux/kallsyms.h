#ifndef _BACKPORT_LINUX_KALLSYMS_H
#define _BACKPORT_LINUX_KALLSYMS_H

#include_next <linux/kallsyms.h>

#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)

#if 0
static inline int sprint_symbol(char *buffer, unsigned long address)
{
	char *modname;
	const char *name;
	unsigned long offset, size;
	int len;

	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
	if (!name)
		return sprintf(buffer, "0x%lx", address);

	if (name != buffer)
		strcpy(buffer, name);
	len = strlen(buffer);
	buffer += len;

	if (modname)
		len += sprintf(buffer, "+%#lx/%#lx [%s]",
						offset, size, modname);
	else
		len += sprintf(buffer, "+%#lx/%#lx", offset, size);

	return len;
}
#else
static inline int sprint_symbol(char *buffer, unsigned long address)
{
	__print_symbol(buffer, address);
	return sizeof(buffer);
}
#endif

#endif  /* _BACKPORT_LINUX_KALLSYMS_H */
