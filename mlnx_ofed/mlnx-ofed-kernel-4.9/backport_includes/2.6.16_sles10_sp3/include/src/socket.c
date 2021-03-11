#include <linux/socket.h>
#include <net/sock.h>
#include <asm/uaccess.h>

int kernel_accept(struct socket *sock, struct socket **newsock, int flags)
{
	struct sock *sk = sock->sk;
	int err;

	err = sock_create_lite(sk->sk_family, sk->sk_type, sk->sk_protocol, newsock);
	if (err < 0)
		goto done;

	err = sock->ops->accept(sock, *newsock, flags);
	if (err < 0) {
		sock_release(*newsock);
		goto done;
	}

	(*newsock)->ops = sock->ops;

done:
	return err;
}
EXPORT_SYMBOL(kernel_accept);

int kernel_sock_ioctl(struct socket *sock, int cmd, unsigned long arg)
{
	mm_segment_t oldfs = get_fs();
	int err;

	set_fs(KERNEL_DS);
	err = sock->ops->ioctl(sock, cmd, arg);
	set_fs(oldfs);

	return err;
}
EXPORT_SYMBOL(kernel_sock_ioctl);
