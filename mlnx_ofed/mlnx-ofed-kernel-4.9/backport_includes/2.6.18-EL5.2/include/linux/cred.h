#ifndef BACKPORT_LINUX_CRED_H
#define BACKPORT_LINUX_CRED_H

#define current_cred_xxx(xxx)	\
({				\
	current->xxx;	\
})

#define current_fsuid()	(current_cred_xxx(fsuid))

#endif /* BACKPORT_LINUX_CRED_H */
