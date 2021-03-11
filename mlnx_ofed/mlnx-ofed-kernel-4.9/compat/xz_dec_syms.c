#if !(defined(HAVE_LINUX_XZ_H) && IS_ENABLED(CONFIG_XZ_DEC))

/*
 * XZ decoder module information
 *
 * Author: Lasse Collin <lasse.collin@tukaani.org>
 *
 * This file has been put into the public domain.
 * You can do whatever you want with this file.
 */

#include <linux/module.h>
#include <linux/export.h>
#include <linux/xz.h>

#define xz_dec_init LINUX_BACKPORT(xz_dec_init)
EXPORT_SYMBOL(xz_dec_init);
#define xz_dec_reset LINUX_BACKPORT(xz_dec_reset)
EXPORT_SYMBOL(xz_dec_reset);
#define xz_dec_run LINUX_BACKPORT(xz_dec_run)
EXPORT_SYMBOL(xz_dec_run);
#define xz_dec_end LINUX_BACKPORT(xz_dec_end)
EXPORT_SYMBOL(xz_dec_end);

/*
MODULE_DESCRIPTION("XZ decompressor");
MODULE_VERSION("1.0");
MODULE_AUTHOR("Lasse Collin <lasse.collin@tukaani.org> and Igor Pavlov");
*/
/*
 * This code is in the public domain, but in Linux it's simplest to just
 * say it's GPL and consider the authors as the copyright holders.
 */
/*MODULE_LICENSE("GPL");*/
#ifdef RETPOLINE_MLNX
MODULE_INFO(retpoline, "Y");
#endif

#endif /* !(defined(HAVE_LINUX_XZ_H) && IS_ENABLED(CONFIG_XZ_DEC)) */
