#ifndef BACKPORT_LINUX_CRYPTO_H
#define BACKPORT_LINUX_CRYPTO_H

#include_next <linux/crypto.h>
#include <linux/ncrypto.h>

#define CRYPTO_ALG_ASYNC	NCRYPTO_ALG_ASYNC 

#endif
