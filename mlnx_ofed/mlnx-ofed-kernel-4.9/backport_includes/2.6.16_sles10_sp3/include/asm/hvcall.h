#ifndef ASM_HVCALL_BACKPORT_2616_H
#define ASM_HVCALL_BACKPORT_2616_H

#include_next <asm/hvcall.h>

#ifdef __KERNEL__

#define H_SUCCESS               H_Success
#define H_CONSTRAINED           H_Constrained
#define H_PAGE_REGISTERED       15

#define H_PARAMETER             H_Parameter
#define H_NO_MEM                H_NoMem
#define H_HARDWARE              H_Hardware
#define H_ADAPTER_PARM          -17
#define H_RH_PARM               -18
#define H_RT_PARM               -22
#define H_MLENGTH_PARM          -27
#define H_MEM_PARM              -28
#define H_MEM_ACCESS_PARM       -29
#define H_ALIAS_EXIST           -39
#define H_TABLE_FULL            -41
#define H_NOT_ENOUGH_RESOURCES  -44
#define H_R_STATE               -45

#define H_CB_ALIGNMENT          4096

#define H_RESET_EVENTS          0x15C
#define H_ALLOC_RESOURCE        0x160
#define H_FREE_RESOURCE         0x164
#define H_MODIFY_QP             0x168
#define H_QUERY_QP              0x16C
#define H_REREGISTER_PMR        0x170
#define H_REGISTER_SMR          0x174
#define H_QUERY_MR              0x178
#define H_QUERY_MW              0x17C
#define H_QUERY_HCA             0x180
#define H_QUERY_PORT            0x184
#define H_MODIFY_PORT           0x188
#define H_DEFINE_AQP1           0x18C
#define H_DEFINE_AQP0           0x194
#define H_RESIZE_MR             0x198
#define H_ATTACH_MCQP           0x19C
#define H_DETACH_MCQP           0x1A0
#define H_REGISTER_RPAGES       0x1AC
#define H_DISABLE_AND_GETC      0x1B0
#define H_ERROR_DATA            0x1B4
#define H_QUERY_INT_STATE       0x1E4

#define H_LONG_BUSY_ORDER_1_MSEC   H_LongBusyOrder1msec
#define H_LONG_BUSY_ORDER_10_MSEC  H_LongBusyOrder10msec
#define H_LONG_BUSY_ORDER_100_MSEC H_LongBusyOrder100msec
#define H_LONG_BUSY_ORDER_1_SEC    H_LongBusyOrder1sec
#define H_LONG_BUSY_ORDER_10_SEC   H_LongBusyOrder10sec
#define H_LONG_BUSY_ORDER_100_SEC  H_LongBusyOrder100sec


#ifndef __ASSEMBLY__
#include <linux/kernel.h>

#define PLPAR_HCALL9_BUFSIZE 9
inline static long plpar_hcall9(unsigned long opcode,
				unsigned long *retbuf,
				unsigned long arg1,	/* <R4  */
				unsigned long arg2,	/* <R5  */
				unsigned long arg3,	/* <R6  */
				unsigned long arg4,	/* <R7  */
				unsigned long arg5,	/* <R8  */
				unsigned long arg6,	/* <R9  */
				unsigned long arg7,	/* <R10 */
				unsigned long arg8,	/* <R11 */
				unsigned long arg9	/* <R12 */
    )
{
	int i;
	unsigned long regs[11] = {opcode,
				  arg1, arg2, arg3, arg4, arg5, arg6, arg7,
				  arg8, arg9};

	__asm__ __volatile__("mr 3,%10\n"
			     "mr 4,%11\n"
			     "mr 5,%12\n"
			     "mr 6,%13\n"
			     "mr 7,%14\n"
			     "mr 8,%15\n"
			     "mr 9,%16\n"
			     "mr 10,%17\n"
			     "mr 11,%18\n"
			     "mr 12,%19\n"
			     ".long 0x44000022\n"
			     "mr %0,3\n"
			     "mr %1,4\n"
			     "mr %2,5\n"
			     "mr %3,6\n"
			     "mr %4,7\n"
			     "mr %5,8\n"
			     "mr %6,9\n"
			     "mr %7,10\n"
			     "mr %8,11\n"
			     "mr %9,12\n":"=r"(regs[0]),
			     "=r"(regs[1]), "=r"(regs[2]),
			     "=r"(regs[3]), "=r"(regs[4]),
			     "=r"(regs[5]), "=r"(regs[6]),
			     "=r"(regs[7]), "=r"(regs[8]),
			     "=r"(regs[9])
			     :"r"(regs[0]), "r"(regs[1]),
			     "r"(regs[2]), "r"(regs[3]),
			     "r"(regs[4]), "r"(regs[5]),
			     "r"(regs[6]), "r"(regs[7]),
			     "r"(regs[8]), "r"(regs[9])
			     :"r0", "r2", "r3", "r4", "r5", "r6", "r7",
			     "r8", "r9", "r10", "r11", "r12", "cc",
			     "xer", "ctr", "lr", "cr0", "cr1", "cr5",
			     "cr6", "cr7");
	for (i = 0; i < 9; i++)
		retbuf[i] = regs[i + 1];

	if (!H_isLongBusy(regs[0]) && regs[0] < 0) {
		printk(KERN_ERR "HCALL99_IN r3=%lx r4=%lx r5=%lx r6=%lx "
		       "r7=%lx r8=%lx r9=%lx r10=%lx "
		       "r11=%lx r12=%lx",
		       opcode, arg1, arg2, arg3,
		       arg4, arg5, arg6, arg7,
		       arg8, arg9);
		printk(KERN_ERR "HCALL99_OUT r3=%lx r4=%lx r5=%lx "
		       "r6=%lx r7=%lx r8=%lx r9=%lx r10=%lx "
		       "r11=%lx r12=lx",
		       regs[0], regs[1],
		       regs[2], regs[3],
		       regs[4], regs[5],
		       regs[6], regs[7],
		       regs[8]);
	}
	return regs[0];
}

#endif /* __ASSEMBLY__ */
#endif /* __KERNEL__ */
#endif
