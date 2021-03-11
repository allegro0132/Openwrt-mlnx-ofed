#ifndef HAVE_UUID_GEN

#include <linux/kernel.h>
#include <linux/ctype.h>
#include <linux/errno.h>
#include <linux/export.h>
#include <linux/uuid.h>
#include <linux/random.h>

#ifndef HAVE_UUID_BE_TO_BIN
const u8 uuid_le_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
EXPORT_SYMBOL(uuid_le_index);
const u8 uuid_be_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
EXPORT_SYMBOL(uuid_be_index);


/**
  * uuid_is_valid - checks if UUID string valid
  * @uuid:	UUID string to check
  *
  * Description:
  * It checks if the UUID string is following the format:
  *	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  * where x is a hex digit.
  *
  * Return: true if input is valid UUID string.
  */
bool uuid_is_valid(const char *uuid)
{
	unsigned int i;

	for (i = 0; i < UUID_STRING_LEN; i++) {
		if (i == 8 || i == 13 || i == 18 || i == 23) {
			if (uuid[i] != '-')
				return false;
		} else if (!isxdigit(uuid[i])) {
			return false;
		}
	}

	return true;
}
EXPORT_SYMBOL(uuid_is_valid);
#endif

static int __uuid_to_bin(const char *uuid, __u8 b[16], const u8 ei[16])
{
	static const u8 si[16] = {0,2,4,6,9,11,14,16,19,21,24,26,28,30,32,34};
	unsigned int i;

	if (!uuid_is_valid(uuid))
		return -EINVAL;

	for (i = 0; i < 16; i++) {
		int hi = hex_to_bin(uuid[si[i] + 0]);
		int lo = hex_to_bin(uuid[si[i] + 1]);

		b[ei[i]] = (hi << 4) | lo;
	}

	return 0;
}

#ifndef HAVE_UUID_BE_TO_BIN
#define uuid_le_to_bin LINUX_BACKPORT(uuid_le_to_bin)
int uuid_le_to_bin(const char *uuid, uuid_le *u)
{
	return __uuid_to_bin(uuid, u->b, uuid_le_index);
}
EXPORT_SYMBOL(uuid_le_to_bin);

#define uuid_be_to_bin LINUX_BACKPORT(uuid_be_to_bin)
int uuid_be_to_bin(const char *uuid, uuid_be *u)
{
	return __uuid_to_bin(uuid, u->b, uuid_be_index);
}
EXPORT_SYMBOL(uuid_be_to_bin);
#endif

#ifndef HAVE_GUID_PARSE
const u8 guid_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};

int guid_parse(const char *uuid, guid_t *u)
{
	return __uuid_to_bin(uuid, u->b, guid_index);
}
EXPORT_SYMBOL(guid_parse);
#endif
#endif
