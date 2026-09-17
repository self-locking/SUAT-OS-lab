
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	89010113          	addi	sp,sp,-1904 # 80007890 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc4f>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	de878793          	addi	a5,a5,-536 # 80000e60 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	1a4020ef          	jal	800022c0 <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7d6000ef          	jal	800008fe <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	0000f517          	auipc	a0,0xf
    80000198:	6fc50513          	addi	a0,a0,1788 # 8000f890 <cons>
    8000019c:	25d000ef          	jal	80000bf8 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	0000f497          	auipc	s1,0xf
    800001a4:	6f048493          	addi	s1,s1,1776 # 8000f890 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	0000f917          	auipc	s2,0xf
    800001ac:	78090913          	addi	s2,s2,1920 # 8000f928 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	722010ef          	jal	800018e2 <myproc>
    800001c4:	77f010ef          	jal	80002142 <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	51f010ef          	jal	80001eea <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	2ab000ef          	jal	80000c7c <release>
      sleep();
    800001d6:	551010ef          	jal	80001f26 <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	21d000ef          	jal	80000bf8 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	0000f717          	auipc	a4,0xf
    800001f2:	6a270713          	addi	a4,a4,1698 # 8000f890 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	054020ef          	jal	80002274 <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	0000f517          	auipc	a0,0xf
    8000023c:	65850513          	addi	a0,a0,1624 # 8000f890 <cons>
    80000240:	23d000ef          	jal	80000c7c <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	0000f717          	auipc	a4,0xf
    80000262:	6cf72523          	sw	a5,1738(a4) # 8000f928 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	0000f517          	auipc	a0,0xf
    80000278:	61c50513          	addi	a0,a0,1564 # 8000f890 <cons>
    8000027c:	201000ef          	jal	80000c7c <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	6ea000ef          	jal	80000984 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6dc000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6d4000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ce000ef          	jal	80000984 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	0000f517          	auipc	a0,0xf
    800002cc:	5c850513          	addi	a0,a0,1480 # 8000f890 <cons>
    800002d0:	129000ef          	jal	80000bf8 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	0af48163          	beq	s1,a5,80000378 <consoleintr+0xbc>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48663          	beq	s1,a5,800003cc <consoleintr+0x110>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49763          	bne	s1,a5,800003f4 <consoleintr+0x138>
  case C('P'): // Print process list.
    procdump();
    800002ea:	022020ef          	jal	8000230c <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	0000f517          	auipc	a0,0xf
    800002f2:	5a250513          	addi	a0,a0,1442 # 8000f890 <cons>
    800002f6:	187000ef          	jal	80000c7c <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0cf48263          	beq	s1,a5,800003cc <consoleintr+0x110>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	0000f717          	auipc	a4,0xf
    80000310:	58470713          	addi	a4,a4,1412 # 8000f890 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48963          	beq	s1,a5,800003fa <consoleintr+0x13e>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	0000f717          	auipc	a4,0xf
    80000336:	55e70713          	addi	a4,a4,1374 # 8000f890 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	00173713          	seqz	a4,a4
    8000035a:	14f1                	addi	s1,s1,-4
    8000035c:	0014b493          	seqz	s1,s1
    80000360:	8f45                	or	a4,a4,s1
    80000362:	e361                	bnez	a4,80000422 <consoleintr+0x166>
    80000364:	0000f717          	auipc	a4,0xf
    80000368:	5c472703          	lw	a4,1476(a4) # 8000f928 <cons+0x98>
    8000036c:	9f99                	subw	a5,a5,a4
    8000036e:	08000713          	li	a4,128
    80000372:	f6e79ee3          	bne	a5,a4,800002ee <consoleintr+0x32>
    80000376:	a075                	j	80000422 <consoleintr+0x166>
    80000378:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    8000037a:	0000f717          	auipc	a4,0xf
    8000037e:	51670713          	addi	a4,a4,1302 # 8000f890 <cons>
    80000382:	0a072783          	lw	a5,160(a4)
    80000386:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000038a:	0000f497          	auipc	s1,0xf
    8000038e:	50648493          	addi	s1,s1,1286 # 8000f890 <cons>
    while (cons.e != cons.w &&
    80000392:	4929                	li	s2,10
    80000394:	02f70863          	beq	a4,a5,800003c4 <consoleintr+0x108>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000398:	37fd                	addiw	a5,a5,-1
    8000039a:	07f7f713          	andi	a4,a5,127
    8000039e:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    800003a0:	01874703          	lbu	a4,24(a4)
    800003a4:	03270263          	beq	a4,s2,800003c8 <consoleintr+0x10c>
      cons.e--;
    800003a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ac:	10000513          	li	a0,256
    800003b0:	edbff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ee3          	bne	a4,a5,80000398 <consoleintr+0xdc>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    800003c4:	6902                	ld	s2,0(sp)
    800003c6:	b725                	j	800002ee <consoleintr+0x32>
    800003c8:	6902                	ld	s2,0(sp)
    800003ca:	b715                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003cc:	0000f717          	auipc	a4,0xf
    800003d0:	4c470713          	addi	a4,a4,1220 # 8000f890 <cons>
    800003d4:	0a072783          	lw	a5,160(a4)
    800003d8:	09c72703          	lw	a4,156(a4)
    800003dc:	f0f709e3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003e0:	37fd                	addiw	a5,a5,-1
    800003e2:	0000f717          	auipc	a4,0xf
    800003e6:	54f72723          	sw	a5,1358(a4) # 8000f930 <cons+0xa0>
      consputc(BACKSPACE);
    800003ea:	10000513          	li	a0,256
    800003ee:	e9dff0ef          	jal	8000028a <consputc>
    800003f2:	bdf5                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003f4:	ee048de3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f8:	bf11                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003fa:	4529                	li	a0,10
    800003fc:	e8fff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000400:	0000f797          	auipc	a5,0xf
    80000404:	49078793          	addi	a5,a5,1168 # 8000f890 <cons>
    80000408:	0a07a703          	lw	a4,160(a5)
    8000040c:	0017069b          	addiw	a3,a4,1
    80000410:	8636                	mv	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	0000f797          	auipc	a5,0xf
    80000426:	50c7a523          	sw	a2,1290(a5) # 8000f92c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	0000f517          	auipc	a0,0xf
    8000042e:	4fe50513          	addi	a0,a0,1278 # 8000f928 <cons+0x98>
    80000432:	325010ef          	jal	80001f56 <wakeup>
    80000436:	bd65                	j	800002ee <consoleintr+0x32>

0000000080000438 <consoleinit>:

void
consoleinit(void)
{
    80000438:	1141                	addi	sp,sp,-16
    8000043a:	e406                	sd	ra,8(sp)
    8000043c:	e022                	sd	s0,0(sp)
    8000043e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000440:	00007597          	auipc	a1,0x7
    80000444:	bc058593          	addi	a1,a1,-1088 # 80007000 <etext>
    80000448:	0000f517          	auipc	a0,0xf
    8000044c:	44850513          	addi	a0,a0,1096 # 8000f890 <cons>
    80000450:	728000ef          	jal	80000b78 <initlock>

  uartinit();
    80000454:	454000ef          	jal	800008a8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000458:	0001f797          	auipc	a5,0x1f
    8000045c:	5c078793          	addi	a5,a5,1472 # 8001fa18 <devsw>
    80000460:	00000717          	auipc	a4,0x0
    80000464:	d1870713          	addi	a4,a4,-744 # 80000178 <consoleread>
    80000468:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000046a:	00000717          	auipc	a4,0x0
    8000046e:	c6c70713          	addi	a4,a4,-916 # 800000d6 <consolewrite>
    80000472:	ef98                	sd	a4,24(a5)
}
    80000474:	60a2                	ld	ra,8(sp)
    80000476:	6402                	ld	s0,0(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret

000000008000047c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000047c:	7139                	addi	sp,sp,-64
    8000047e:	fc06                	sd	ra,56(sp)
    80000480:	f822                	sd	s0,48(sp)
    80000482:	f04a                	sd	s2,32(sp)
    80000484:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000486:	c219                	beqz	a2,8000048c <printint+0x10>
    80000488:	08054063          	bltz	a0,80000508 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    8000048c:	4301                	li	t1,0

  i = 0;
    8000048e:	fc840913          	addi	s2,s0,-56
    x = xx;
    80000492:	86ca                	mv	a3,s2
  i = 0;
    80000494:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000496:	00007817          	auipc	a6,0x7
    8000049a:	29a80813          	addi	a6,a6,666 # 80007730 <digits>
    8000049e:	88ba                	mv	a7,a4
    800004a0:	0017061b          	addiw	a2,a4,1
    800004a4:	8732                	mv	a4,a2
    800004a6:	02b577b3          	remu	a5,a0,a1
    800004aa:	97c2                	add	a5,a5,a6
    800004ac:	0007c783          	lbu	a5,0(a5)
    800004b0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004b4:	87aa                	mv	a5,a0
    800004b6:	02b55533          	divu	a0,a0,a1
    800004ba:	0685                	addi	a3,a3,1
    800004bc:	feb7f1e3          	bgeu	a5,a1,8000049e <printint+0x22>

  if (sign)
    800004c0:	00030b63          	beqz	t1,800004d6 <printint+0x5a>
    buf[i++] = '-';
    800004c4:	fe040793          	addi	a5,s0,-32
    800004c8:	963e                	add	a2,a2,a5
    800004ca:	02d00793          	li	a5,45
    800004ce:	fef60423          	sb	a5,-24(a2)
    800004d2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d6:	02e05463          	blez	a4,800004fe <printint+0x82>
    800004da:	f426                	sd	s1,40(sp)
    800004dc:	377d                	addiw	a4,a4,-1
    800004de:	00e904b3          	add	s1,s2,a4
    800004e2:	197d                	addi	s2,s2,-1
    800004e4:	993a                	add	s2,s2,a4
    800004e6:	1702                	slli	a4,a4,0x20
    800004e8:	9301                	srli	a4,a4,0x20
    800004ea:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004ee:	0004c503          	lbu	a0,0(s1)
    800004f2:	d99ff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f6:	14fd                	addi	s1,s1,-1
    800004f8:	ff249be3          	bne	s1,s2,800004ee <printint+0x72>
    800004fc:	74a2                	ld	s1,40(sp)
}
    800004fe:	70e2                	ld	ra,56(sp)
    80000500:	7442                	ld	s0,48(sp)
    80000502:	7902                	ld	s2,32(sp)
    80000504:	6121                	addi	sp,sp,64
    80000506:	8082                	ret
    x = -xx;
    80000508:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    8000050c:	4305                	li	t1,1
    x = -xx;
    8000050e:	b741                	j	8000048e <printint+0x12>

0000000080000510 <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    80000510:	7131                	addi	sp,sp,-192
    80000512:	fc86                	sd	ra,120(sp)
    80000514:	f8a2                	sd	s0,112(sp)
    80000516:	f4a6                	sd	s1,104(sp)
    80000518:	0100                	addi	s0,sp,128
    8000051a:	84aa                	mv	s1,a0
    8000051c:	e40c                	sd	a1,8(s0)
    8000051e:	e810                	sd	a2,16(s0)
    80000520:	ec14                	sd	a3,24(s0)
    80000522:	f018                	sd	a4,32(s0)
    80000524:	f41c                	sd	a5,40(s0)
    80000526:	03043823          	sd	a6,48(s0)
    8000052a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    8000052e:	00007797          	auipc	a5,0x7
    80000532:	3367a783          	lw	a5,822(a5) # 80007864 <panicking>
    80000536:	cf9d                	beqz	a5,80000574 <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000540:	0004c503          	lbu	a0,0(s1)
    80000544:	22050363          	beqz	a0,8000076a <printk+0x25a>
    80000548:	f0ca                	sd	s2,96(sp)
    8000054a:	ecce                	sd	s3,88(sp)
    8000054c:	e8d2                	sd	s4,80(sp)
    8000054e:	e4d6                	sd	s5,72(sp)
    80000550:	e0da                	sd	s6,64(sp)
    80000552:	fc5e                	sd	s7,56(sp)
    80000554:	f862                	sd	s8,48(sp)
    80000556:	f06a                	sd	s10,32(sp)
    80000558:	ec6e                	sd	s11,24(sp)
    8000055a:	4a01                	li	s4,0
    if (cx != '%') {
    8000055c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000560:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000564:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000568:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000056c:	4b29                	li	s6,10
    if (c0 == 'd') {
    8000056e:	06400b93          	li	s7,100
    80000572:	a015                	j	80000596 <printk+0x86>
    acquire(&pr.lock);
    80000574:	0000f517          	auipc	a0,0xf
    80000578:	3c450513          	addi	a0,a0,964 # 8000f938 <pr>
    8000057c:	67c000ef          	jal	80000bf8 <acquire>
    80000580:	bf65                	j	80000538 <printk+0x28>
      consputc(cx);
    80000582:	d09ff0ef          	jal	8000028a <consputc>
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000586:	001a079b          	addiw	a5,s4,1
    8000058a:	8a3e                	mv	s4,a5
    8000058c:	97a6                	add	a5,a5,s1
    8000058e:	0007c503          	lbu	a0,0(a5)
    80000592:	1c050363          	beqz	a0,80000758 <printk+0x248>
    if (cx != '%') {
    80000596:	ff3516e3          	bne	a0,s3,80000582 <printk+0x72>
    i++;
    8000059a:	001a091b          	addiw	s2,s4,1
    c0 = fmt[i + 0] & 0xff;
    8000059e:	012487b3          	add	a5,s1,s2
    800005a2:	0007ca83          	lbu	s5,0(a5)
    if (c0)
    800005a6:	200a8763          	beqz	s5,800007b4 <printk+0x2a4>
      c1 = fmt[i + 1] & 0xff;
    800005aa:	0017c703          	lbu	a4,1(a5)
    if (c1)
    800005ae:	1e070a63          	beqz	a4,800007a2 <printk+0x292>
    if (c0 == 'd') {
    800005b2:	037a8963          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b6:	f94a8793          	addi	a5,s5,-108
    800005ba:	0017b793          	seqz	a5,a5
    800005be:	f9c70693          	addi	a3,a4,-100
    800005c2:	0016b693          	seqz	a3,a3
    800005c6:	8efd                	and	a3,a3,a5
    800005c8:	ca9d                	beqz	a3,800005fe <printk+0xee>
      printint(va_arg(ap, uint64), 10, 1);
    800005ca:	f8843783          	ld	a5,-120(s0)
    800005ce:	00878713          	addi	a4,a5,8
    800005d2:	f8e43423          	sd	a4,-120(s0)
    800005d6:	4605                	li	a2,1
    800005d8:	85da                	mv	a1,s6
    800005da:	6388                	ld	a0,0(a5)
    800005dc:	ea1ff0ef          	jal	8000047c <printint>
      i += 1;
    800005e0:	2a09                	addiw	s4,s4,2
    800005e2:	b755                	j	80000586 <printk+0x76>
      printint(va_arg(ap, int), 10, 1);
    800005e4:	f8843783          	ld	a5,-120(s0)
    800005e8:	00878713          	addi	a4,a5,8
    800005ec:	f8e43423          	sd	a4,-120(s0)
    800005f0:	4605                	li	a2,1
    800005f2:	85da                	mv	a1,s6
    800005f4:	4388                	lw	a0,0(a5)
    800005f6:	e87ff0ef          	jal	8000047c <printint>
    i++;
    800005fa:	8a4a                	mv	s4,s2
    800005fc:	b769                	j	80000586 <printk+0x76>
      c2 = fmt[i + 2] & 0xff;
    800005fe:	012486b3          	add	a3,s1,s2
    80000602:	863a                	mv	a2,a4
    80000604:	0026c703          	lbu	a4,2(a3)
    80000608:	aa65                	j	800007c0 <printk+0x2b0>
      printint(va_arg(ap, uint64), 10, 1);
    8000060a:	f8843783          	ld	a5,-120(s0)
    8000060e:	00878713          	addi	a4,a5,8
    80000612:	f8e43423          	sd	a4,-120(s0)
    80000616:	4605                	li	a2,1
    80000618:	45a9                	li	a1,10
    8000061a:	6388                	ld	a0,0(a5)
    8000061c:	e61ff0ef          	jal	8000047c <printint>
      i += 2;
    80000620:	2a0d                	addiw	s4,s4,3
    80000622:	b795                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 10, 0);
    80000624:	f8843783          	ld	a5,-120(s0)
    80000628:	00878713          	addi	a4,a5,8
    8000062c:	f8e43423          	sd	a4,-120(s0)
    80000630:	4601                	li	a2,0
    80000632:	85da                	mv	a1,s6
    80000634:	0007e503          	lwu	a0,0(a5)
    80000638:	e45ff0ef          	jal	8000047c <printint>
    8000063c:	bf7d                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 10, 0);
    8000063e:	f8843783          	ld	a5,-120(s0)
    80000642:	00878713          	addi	a4,a5,8
    80000646:	f8e43423          	sd	a4,-120(s0)
    8000064a:	4601                	li	a2,0
    8000064c:	85da                	mv	a1,s6
    8000064e:	6388                	ld	a0,0(a5)
    80000650:	e2dff0ef          	jal	8000047c <printint>
      i += 1;
    80000654:	2a09                	addiw	s4,s4,2
    80000656:	bf05                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 10, 0);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4601                	li	a2,0
    80000666:	45a9                	li	a1,10
    80000668:	6388                	ld	a0,0(a5)
    8000066a:	e13ff0ef          	jal	8000047c <printint>
      i += 2;
    8000066e:	2a0d                	addiw	s4,s4,3
    80000670:	bf19                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 16, 0);
    80000672:	f8843783          	ld	a5,-120(s0)
    80000676:	00878713          	addi	a4,a5,8
    8000067a:	f8e43423          	sd	a4,-120(s0)
    8000067e:	4601                	li	a2,0
    80000680:	45c1                	li	a1,16
    80000682:	0007e503          	lwu	a0,0(a5)
    80000686:	df7ff0ef          	jal	8000047c <printint>
    8000068a:	bf85                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 16, 0);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4601                	li	a2,0
    8000069a:	45c1                	li	a1,16
    8000069c:	6388                	ld	a0,0(a5)
    8000069e:	ddfff0ef          	jal	8000047c <printint>
      i += 1;
    800006a2:	2a09                	addiw	s4,s4,2
    800006a4:	b5cd                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 16, 0);
    800006a6:	f8843783          	ld	a5,-120(s0)
    800006aa:	00878713          	addi	a4,a5,8
    800006ae:	f8e43423          	sd	a4,-120(s0)
    800006b2:	45c1                	li	a1,16
    800006b4:	6388                	ld	a0,0(a5)
    800006b6:	dc7ff0ef          	jal	8000047c <printint>
      i += 2;
    800006ba:	2a0d                	addiw	s4,s4,3
    800006bc:	b5e9                	j	80000586 <printk+0x76>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00007c97          	auipc	s9,0x7
    800006e6:	04ec8c93          	addi	s9,s9,78 # 80007730 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1da>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	bde5                	j	800005fa <printk+0xea>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5d5                	j	800005fa <printk+0xea>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x232>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	ec0505e3          	beqz	a0,800005fa <printk+0xea>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x224>
    80000740:	bd6d                	j	800005fa <printk+0xea>
        s = "(null)";
    80000742:	00007a17          	auipc	s4,0x7
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x224>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b555                	j	800005fa <printk+0xea>
    80000758:	7906                	ld	s2,96(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	00007797          	auipc	a5,0x7
    8000076e:	0fa7a783          	lw	a5,250(a5) # 80007864 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x284>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	74a6                	ld	s1,104(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	7906                	ld	s2,96(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x25a>
    release(&pr.lock);
    80000794:	0000f517          	auipc	a0,0xf
    80000798:	1a450513          	addi	a0,a0,420 # 8000f938 <pr>
    8000079c:	4e0000ef          	jal	80000c7c <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x264>
    if (c0 == 'd') {
    800007a2:	e57a81e3          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8793          	addi	a5,s5,-108
    800007aa:	0017b793          	seqz	a5,a5
    800007ae:	863a                	mv	a2,a4
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4681                	li	a3,0
    800007b2:	a01d                	j	800007d8 <printk+0x2c8>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8793          	addi	a5,s5,-108
    800007b8:	0017b793          	seqz	a5,a5
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	8756                	mv	a4,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460693          	addi	a3,a2,-108
    800007c4:	0016b693          	seqz	a3,a3
    800007c8:	8efd                	and	a3,a3,a5
    800007ca:	f9c70593          	addi	a1,a4,-100
    800007ce:	0015b593          	seqz	a1,a1
    800007d2:	8df5                	and	a1,a1,a3
    800007d4:	e2059be3          	bnez	a1,8000060a <printk+0xfa>
    } else if (c0 == 'u') {
    800007d8:	e58a86e3          	beq	s5,s8,80000624 <printk+0x114>
    } else if (c0 == 'l' && c1 == 'u') {
    800007dc:	f8b60593          	addi	a1,a2,-117
    800007e0:	0015b593          	seqz	a1,a1
    800007e4:	8dfd                	and	a1,a1,a5
    800007e6:	e4059ce3          	bnez	a1,8000063e <printk+0x12e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007ea:	f8b70593          	addi	a1,a4,-117
    800007ee:	0015b593          	seqz	a1,a1
    800007f2:	8df5                	and	a1,a1,a3
    800007f4:	e60592e3          	bnez	a1,80000658 <printk+0x148>
    } else if (c0 == 'x') {
    800007f8:	e7aa8de3          	beq	s5,s10,80000672 <printk+0x162>
    } else if (c0 == 'l' && c1 == 'x') {
    800007fc:	f8860613          	addi	a2,a2,-120
    80000800:	00163613          	seqz	a2,a2
    80000804:	8e7d                	and	a2,a2,a5
    80000806:	e80613e3          	bnez	a2,8000068c <printk+0x17c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    8000080a:	f8870713          	addi	a4,a4,-120
    8000080e:	00173713          	seqz	a4,a4
    80000812:	8f75                	and	a4,a4,a3
    80000814:	e80719e3          	bnez	a4,800006a6 <printk+0x196>
    } else if (c0 == 'p') {
    80000818:	ebba83e3          	beq	s5,s11,800006be <printk+0x1ae>
    } else if (c0 == 'c') {
    8000081c:	06300793          	li	a5,99
    80000820:	eefa82e3          	beq	s5,a5,80000704 <printk+0x1f4>
    } else if (c0 == 's') {
    80000824:	07300793          	li	a5,115
    80000828:	eefa88e3          	beq	s5,a5,80000718 <printk+0x208>
    } else if (c0 == '%') {
    8000082c:	02500793          	li	a5,37
    80000830:	f2fa80e3          	beq	s5,a5,80000750 <printk+0x240>
    } else if (c0 == 0) {
    80000834:	f40a86e3          	beqz	s5,80000780 <printk+0x270>
      consputc('%');
    80000838:	02500513          	li	a0,37
    8000083c:	a4fff0ef          	jal	8000028a <consputc>
      consputc(c0);
    80000840:	8556                	mv	a0,s5
    80000842:	a49ff0ef          	jal	8000028a <consputc>
    80000846:	bb55                	j	800005fa <printk+0xea>

0000000080000848 <panic>:

void
panic(char *s)
{
    80000848:	1101                	addi	sp,sp,-32
    8000084a:	ec06                	sd	ra,24(sp)
    8000084c:	e822                	sd	s0,16(sp)
    8000084e:	e426                	sd	s1,8(sp)
    80000850:	e04a                	sd	s2,0(sp)
    80000852:	1000                	addi	s0,sp,32
    80000854:	892a                	mv	s2,a0
  panicking = 1;
    80000856:	4485                	li	s1,1
    80000858:	00007797          	auipc	a5,0x7
    8000085c:	0097a623          	sw	s1,12(a5) # 80007864 <panicking>
  printk("panic: ");
    80000860:	00006517          	auipc	a0,0x6
    80000864:	7b850513          	addi	a0,a0,1976 # 80007018 <etext+0x18>
    80000868:	ca9ff0ef          	jal	80000510 <printk>
  printk("%s\n", s);
    8000086c:	85ca                	mv	a1,s2
    8000086e:	00006517          	auipc	a0,0x6
    80000872:	7b250513          	addi	a0,a0,1970 # 80007020 <etext+0x20>
    80000876:	c9bff0ef          	jal	80000510 <printk>
  panicked = 1; // freeze uart output from other CPUs
    8000087a:	00007797          	auipc	a5,0x7
    8000087e:	fe97a323          	sw	s1,-26(a5) # 80007860 <panicked>
  for (;;)
    80000882:	a001                	j	80000882 <panic+0x3a>

0000000080000884 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000088c:	00006597          	auipc	a1,0x6
    80000890:	79c58593          	addi	a1,a1,1948 # 80007028 <etext+0x28>
    80000894:	0000f517          	auipc	a0,0xf
    80000898:	0a450513          	addi	a0,a0,164 # 8000f938 <pr>
    8000089c:	2dc000ef          	jal	80000b78 <initlock>
}
    800008a0:	60a2                	ld	ra,8(sp)
    800008a2:	6402                	ld	s0,0(sp)
    800008a4:	0141                	addi	sp,sp,16
    800008a6:	8082                	ret

00000000800008a8 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    800008a8:	1141                	addi	sp,sp,-16
    800008aa:	e406                	sd	ra,8(sp)
    800008ac:	e022                	sd	s0,0(sp)
    800008ae:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800008b0:	100007b7          	lui	a5,0x10000
    800008b4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008b8:	10000737          	lui	a4,0x10000
    800008bc:	f8000693          	li	a3,-128
    800008c0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008c4:	468d                	li	a3,3
    800008c6:	10000637          	lui	a2,0x10000
    800008ca:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ce:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008d2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008d6:	8732                	mv	a4,a2
    800008d8:	461d                	li	a2,7
    800008da:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008de:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    800008e2:	00006597          	auipc	a1,0x6
    800008e6:	74e58593          	addi	a1,a1,1870 # 80007030 <etext+0x30>
    800008ea:	0000f517          	auipc	a0,0xf
    800008ee:	06650513          	addi	a0,a0,102 # 8000f950 <tx_lock>
    800008f2:	65a030ef          	jal	80003f4c <initsleeplock>
}
    800008f6:	60a2                	ld	ra,8(sp)
    800008f8:	6402                	ld	s0,0(sp)
    800008fa:	0141                	addi	sp,sp,16
    800008fc:	8082                	ret

00000000800008fe <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008fe:	7139                	addi	sp,sp,-64
    80000900:	fc06                	sd	ra,56(sp)
    80000902:	f822                	sd	s0,48(sp)
    80000904:	f04a                	sd	s2,32(sp)
    80000906:	e456                	sd	s5,8(sp)
    80000908:	0080                	addi	s0,sp,64
    8000090a:	8aaa                	mv	s5,a0
    8000090c:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    8000090e:	0000f517          	auipc	a0,0xf
    80000912:	04250513          	addi	a0,a0,66 # 8000f950 <tx_lock>
    80000916:	66c030ef          	jal	80003f82 <acquiresleep>

  int i = 0;
  while (i < n) {
    8000091a:	05205963          	blez	s2,8000096c <uartwrite+0x6e>
    8000091e:	f426                	sd	s1,40(sp)
    80000920:	ec4e                	sd	s3,24(sp)
    80000922:	e852                	sd	s4,16(sp)
    80000924:	e05a                	sd	s6,0(sp)
  int i = 0;
    80000926:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80000928:	00007a17          	auipc	s4,0x7
    8000092c:	f40a0a13          	addi	s4,s4,-192 # 80007868 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000930:	100009b7          	lui	s3,0x10000
    80000934:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80000936:	10000b37          	lui	s6,0x10000
    8000093a:	a029                	j	80000944 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    8000093c:	5ea010ef          	jal	80001f26 <sleep>
  while (i < n) {
    80000940:	0324d263          	bge	s1,s2,80000964 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80000944:	8552                	mv	a0,s4
    80000946:	5a4010ef          	jal	80001eea <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000094a:	0009c783          	lbu	a5,0(s3)
    8000094e:	0207f793          	andi	a5,a5,32
    80000952:	d7ed                	beqz	a5,8000093c <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80000954:	009a87b3          	add	a5,s5,s1
    80000958:	0007c783          	lbu	a5,0(a5)
    8000095c:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    80000960:	2485                	addiw	s1,s1,1
    80000962:	bff9                	j	80000940 <uartwrite+0x42>
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	69e2                	ld	s3,24(sp)
    80000968:	6a42                	ld	s4,16(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    8000096c:	0000f517          	auipc	a0,0xf
    80000970:	fe450513          	addi	a0,a0,-28 # 8000f950 <tx_lock>
    80000974:	662030ef          	jal	80003fd6 <releasesleep>
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	7902                	ld	s2,32(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6121                	addi	sp,sp,64
    80000982:	8082                	ret

0000000080000984 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000984:	1101                	addi	sp,sp,-32
    80000986:	ec06                	sd	ra,24(sp)
    80000988:	e822                	sd	s0,16(sp)
    8000098a:	e426                	sd	s1,8(sp)
    8000098c:	1000                	addi	s0,sp,32
    8000098e:	84aa                	mv	s1,a0
  if (panicking == 0)
    80000990:	00007797          	auipc	a5,0x7
    80000994:	ed47a783          	lw	a5,-300(a5) # 80007864 <panicking>
    80000998:	cb91                	beqz	a5,800009ac <uartputc_sync+0x28>
    push_off();

  if (panicked) {
    8000099a:	00007797          	auipc	a5,0x7
    8000099e:	ec67a783          	lw	a5,-314(a5) # 80007860 <panicked>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009a2:	10000737          	lui	a4,0x10000
    800009a6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
  if (panicked) {
    800009a8:	c789                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    for (;;)
    800009aa:	a001                	j	800009aa <uartputc_sync+0x26>
    push_off();
    800009ac:	212000ef          	jal	80000bbe <push_off>
    800009b0:	b7ed                	j	8000099a <uartputc_sync+0x16>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009b2:	00074783          	lbu	a5,0(a4)
    800009b6:	0207f793          	andi	a5,a5,32
    800009ba:	dfe5                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    ;
  WriteReg(THR, c);
    800009bc:	100007b7          	lui	a5,0x10000
    800009c0:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009c4:	00007797          	auipc	a5,0x7
    800009c8:	ea07a783          	lw	a5,-352(a5) # 80007864 <panicking>
    800009cc:	c791                	beqz	a5,800009d8 <uartputc_sync+0x54>
    pop_off();
}
    800009ce:	60e2                	ld	ra,24(sp)
    800009d0:	6442                	ld	s0,16(sp)
    800009d2:	64a2                	ld	s1,8(sp)
    800009d4:	6105                	addi	sp,sp,32
    800009d6:	8082                	ret
    pop_off();
    800009d8:	25c000ef          	jal	80000c34 <pop_off>
}
    800009dc:	bfcd                	j	800009ce <uartputc_sync+0x4a>

00000000800009de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	e04a                	sd	s2,0(sp)
    800009e8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ea:	100007b7          	lui	a5,0x10000
    800009ee:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009f2:	100007b7          	lui	a5,0x10000
    800009f6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009fa:	0207f793          	andi	a5,a5,32
    800009fe:	ef99                	bnez	a5,80000a1c <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a00:	100004b7          	lui	s1,0x10000
    80000a04:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    80000a06:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a0a:	0004c783          	lbu	a5,0(s1)
    80000a0e:	8b85                	andi	a5,a5,1
    80000a10:	cf89                	beqz	a5,80000a2a <uartintr+0x4c>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a12:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
    80000a16:	8a7ff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a1a:	bfc5                	j	80000a0a <uartintr+0x2c>
    wakeup(&tx_chan);
    80000a1c:	00007517          	auipc	a0,0x7
    80000a20:	e4c50513          	addi	a0,a0,-436 # 80007868 <tx_chan>
    80000a24:	532010ef          	jal	80001f56 <wakeup>
    80000a28:	bfe1                	j	80000a00 <uartintr+0x22>
  }
}
    80000a2a:	60e2                	ld	ra,24(sp)
    80000a2c:	6442                	ld	s0,16(sp)
    80000a2e:	64a2                	ld	s1,8(sp)
    80000a30:	6902                	ld	s2,0(sp)
    80000a32:	6105                	addi	sp,sp,32
    80000a34:	8082                	ret

0000000080000a36 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a36:	1101                	addi	sp,sp,-32
    80000a38:	ec06                	sd	ra,24(sp)
    80000a3a:	e822                	sd	s0,16(sp)
    80000a3c:	e426                	sd	s1,8(sp)
    80000a3e:	e04a                	sd	s2,0(sp)
    80000a40:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a42:	00020797          	auipc	a5,0x20
    80000a46:	16e78793          	addi	a5,a5,366 # 80020bb0 <end>
    80000a4a:	00f53733          	sltu	a4,a0,a5
    80000a4e:	47c5                	li	a5,17
    80000a50:	07ee                	slli	a5,a5,0x1b
    80000a52:	17fd                	addi	a5,a5,-1
    80000a54:	00a7b7b3          	sltu	a5,a5,a0
    80000a58:	8fd9                	or	a5,a5,a4
    80000a5a:	03451713          	slli	a4,a0,0x34
    80000a5e:	8fd9                	or	a5,a5,a4
    80000a60:	eb9d                	bnez	a5,80000a96 <kfree+0x60>
    80000a62:	84aa                	mv	s1,a0
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	4585                	li	a1,1
    80000a68:	24c000ef          	jal	80000cb4 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a6c:	0000f917          	auipc	s2,0xf
    80000a70:	f1490913          	addi	s2,s2,-236 # 8000f980 <kmem>
    80000a74:	854a                	mv	a0,s2
    80000a76:	182000ef          	jal	80000bf8 <acquire>
  r->next = kmem.freelist;
    80000a7a:	01893783          	ld	a5,24(s2)
    80000a7e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a80:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a84:	854a                	mv	a0,s2
    80000a86:	1f6000ef          	jal	80000c7c <release>
}
    80000a8a:	60e2                	ld	ra,24(sp)
    80000a8c:	6442                	ld	s0,16(sp)
    80000a8e:	64a2                	ld	s1,8(sp)
    80000a90:	6902                	ld	s2,0(sp)
    80000a92:	6105                	addi	sp,sp,32
    80000a94:	8082                	ret
    panic("kfree");
    80000a96:	00006517          	auipc	a0,0x6
    80000a9a:	5a250513          	addi	a0,a0,1442 # 80007038 <etext+0x38>
    80000a9e:	dabff0ef          	jal	80000848 <panic>

0000000080000aa2 <freerange>:
{
    80000aa2:	7179                	addi	sp,sp,-48
    80000aa4:	f406                	sd	ra,40(sp)
    80000aa6:	f022                	sd	s0,32(sp)
    80000aa8:	ec26                	sd	s1,24(sp)
    80000aaa:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000aac:	6785                	lui	a5,0x1
    80000aae:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab2:	00e504b3          	add	s1,a0,a4
    80000ab6:	777d                	lui	a4,0xfffff
    80000ab8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aba:	94be                	add	s1,s1,a5
    80000abc:	0295e263          	bltu	a1,s1,80000ae0 <freerange+0x3e>
    80000ac0:	e84a                	sd	s2,16(sp)
    80000ac2:	e44e                	sd	s3,8(sp)
    80000ac4:	e052                	sd	s4,0(sp)
    80000ac6:	892e                	mv	s2,a1
    kfree(p);
    80000ac8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aca:	89be                	mv	s3,a5
    kfree(p);
    80000acc:	01448533          	add	a0,s1,s4
    80000ad0:	f67ff0ef          	jal	80000a36 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ad4:	94ce                	add	s1,s1,s3
    80000ad6:	fe997be3          	bgeu	s2,s1,80000acc <freerange+0x2a>
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
}
    80000ae0:	70a2                	ld	ra,40(sp)
    80000ae2:	7402                	ld	s0,32(sp)
    80000ae4:	64e2                	ld	s1,24(sp)
    80000ae6:	6145                	addi	sp,sp,48
    80000ae8:	8082                	ret

0000000080000aea <kinit>:
{
    80000aea:	1141                	addi	sp,sp,-16
    80000aec:	e406                	sd	ra,8(sp)
    80000aee:	e022                	sd	s0,0(sp)
    80000af0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af2:	00006597          	auipc	a1,0x6
    80000af6:	54e58593          	addi	a1,a1,1358 # 80007040 <etext+0x40>
    80000afa:	0000f517          	auipc	a0,0xf
    80000afe:	e8650513          	addi	a0,a0,-378 # 8000f980 <kmem>
    80000b02:	076000ef          	jal	80000b78 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b06:	45c5                	li	a1,17
    80000b08:	05ee                	slli	a1,a1,0x1b
    80000b0a:	00020517          	auipc	a0,0x20
    80000b0e:	0a650513          	addi	a0,a0,166 # 80020bb0 <end>
    80000b12:	f91ff0ef          	jal	80000aa2 <freerange>
}
    80000b16:	60a2                	ld	ra,8(sp)
    80000b18:	6402                	ld	s0,0(sp)
    80000b1a:	0141                	addi	sp,sp,16
    80000b1c:	8082                	ret

0000000080000b1e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b1e:	1101                	addi	sp,sp,-32
    80000b20:	ec06                	sd	ra,24(sp)
    80000b22:	e822                	sd	s0,16(sp)
    80000b24:	e426                	sd	s1,8(sp)
    80000b26:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b28:	0000f517          	auipc	a0,0xf
    80000b2c:	e5850513          	addi	a0,a0,-424 # 8000f980 <kmem>
    80000b30:	0c8000ef          	jal	80000bf8 <acquire>
  r = kmem.freelist;
    80000b34:	0000f497          	auipc	s1,0xf
    80000b38:	e644b483          	ld	s1,-412(s1) # 8000f998 <kmem+0x18>
  if (r)
    80000b3c:	c49d                	beqz	s1,80000b6a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b3e:	609c                	ld	a5,0(s1)
    80000b40:	0000f717          	auipc	a4,0xf
    80000b44:	e4f73c23          	sd	a5,-424(a4) # 8000f998 <kmem+0x18>
  release(&kmem.lock);
    80000b48:	0000f517          	auipc	a0,0xf
    80000b4c:	e3850513          	addi	a0,a0,-456 # 8000f980 <kmem>
    80000b50:	12c000ef          	jal	80000c7c <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b54:	6605                	lui	a2,0x1
    80000b56:	4595                	li	a1,5
    80000b58:	8526                	mv	a0,s1
    80000b5a:	15a000ef          	jal	80000cb4 <memset>
  return (void *)r;
}
    80000b5e:	8526                	mv	a0,s1
    80000b60:	60e2                	ld	ra,24(sp)
    80000b62:	6442                	ld	s0,16(sp)
    80000b64:	64a2                	ld	s1,8(sp)
    80000b66:	6105                	addi	sp,sp,32
    80000b68:	8082                	ret
  release(&kmem.lock);
    80000b6a:	0000f517          	auipc	a0,0xf
    80000b6e:	e1650513          	addi	a0,a0,-490 # 8000f980 <kmem>
    80000b72:	10a000ef          	jal	80000c7c <release>
  if (r)
    80000b76:	b7e5                	j	80000b5e <kalloc+0x40>

0000000080000b78 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b78:	1141                	addi	sp,sp,-16
    80000b7a:	e406                	sd	ra,8(sp)
    80000b7c:	e022                	sd	s0,0(sp)
    80000b7e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b80:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b82:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b86:	00053823          	sd	zero,16(a0)
}
    80000b8a:	60a2                	ld	ra,8(sp)
    80000b8c:	6402                	ld	s0,0(sp)
    80000b8e:	0141                	addi	sp,sp,16
    80000b90:	8082                	ret

0000000080000b92 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b92:	411c                	lw	a5,0(a0)
    80000b94:	e399                	bnez	a5,80000b9a <holding+0x8>
    80000b96:	4501                	li	a0,0
  return r;
}
    80000b98:	8082                	ret
{
    80000b9a:	1101                	addi	sp,sp,-32
    80000b9c:	ec06                	sd	ra,24(sp)
    80000b9e:	e822                	sd	s0,16(sp)
    80000ba0:	e426                	sd	s1,8(sp)
    80000ba2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba4:	691c                	ld	a5,16(a0)
    80000ba6:	84be                	mv	s1,a5
    80000ba8:	51b000ef          	jal	800018c2 <mycpu>
    80000bac:	40a48533          	sub	a0,s1,a0
    80000bb0:	00153513          	seqz	a0,a0
}
    80000bb4:	60e2                	ld	ra,24(sp)
    80000bb6:	6442                	ld	s0,16(sp)
    80000bb8:	64a2                	ld	s1,8(sp)
    80000bba:	6105                	addi	sp,sp,32
    80000bbc:	8082                	ret

0000000080000bbe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bbe:	1101                	addi	sp,sp,-32
    80000bc0:	ec06                	sd	ra,24(sp)
    80000bc2:	e822                	sd	s0,16(sp)
    80000bc4:	e426                	sd	s1,8(sp)
    80000bc6:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000bc8:	100177f3          	csrrci	a5,sstatus,2
    80000bcc:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000bce:	4f5000ef          	jal	800018c2 <mycpu>
    80000bd2:	5d3c                	lw	a5,120(a0)
    80000bd4:	cb99                	beqz	a5,80000bea <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd6:	4ed000ef          	jal	800018c2 <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	2785                	addiw	a5,a5,1
    80000bde:	dd3c                	sw	a5,120(a0)
}
    80000be0:	60e2                	ld	ra,24(sp)
    80000be2:	6442                	ld	s0,16(sp)
    80000be4:	64a2                	ld	s1,8(sp)
    80000be6:	6105                	addi	sp,sp,32
    80000be8:	8082                	ret
    mycpu()->intena = old;
    80000bea:	4d9000ef          	jal	800018c2 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000bee:	0014d793          	srli	a5,s1,0x1
    80000bf2:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000bf4:	dd7c                	sw	a5,124(a0)
    80000bf6:	b7c5                	j	80000bd6 <push_off+0x18>

0000000080000bf8 <acquire>:
{
    80000bf8:	1101                	addi	sp,sp,-32
    80000bfa:	ec06                	sd	ra,24(sp)
    80000bfc:	e822                	sd	s0,16(sp)
    80000bfe:	e426                	sd	s1,8(sp)
    80000c00:	1000                	addi	s0,sp,32
    80000c02:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c04:	fbbff0ef          	jal	80000bbe <push_off>
  if (holding(lk))
    80000c08:	8526                	mv	a0,s1
    80000c0a:	f89ff0ef          	jal	80000b92 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c0e:	4705                	li	a4,1
  if (holding(lk))
    80000c10:	ed01                	bnez	a0,80000c28 <acquire+0x30>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c12:	0ce4a7af          	amoswap.w.aq	a5,a4,(s1)
    80000c16:	fff5                	bnez	a5,80000c12 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c18:	4ab000ef          	jal	800018c2 <mycpu>
    80000c1c:	e888                	sd	a0,16(s1)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    panic("acquire");
    80000c28:	00006517          	auipc	a0,0x6
    80000c2c:	42050513          	addi	a0,a0,1056 # 80007048 <etext+0x48>
    80000c30:	c19ff0ef          	jal	80000848 <panic>

0000000080000c34 <pop_off>:

void
pop_off(void)
{
    80000c34:	1141                	addi	sp,sp,-16
    80000c36:	e406                	sd	ra,8(sp)
    80000c38:	e022                	sd	s0,0(sp)
    80000c3a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c3c:	487000ef          	jal	800018c2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c40:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c44:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c46:	ef99                	bnez	a5,80000c64 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c48:	5d3c                	lw	a5,120(a0)
    80000c4a:	02f05363          	blez	a5,80000c70 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c52:	e789                	bnez	a5,80000c5c <pop_off+0x28>
    80000c54:	5d7c                	lw	a5,124(a0)
    80000c56:	c399                	beqz	a5,80000c5c <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c58:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00006517          	auipc	a0,0x6
    80000c68:	3ec50513          	addi	a0,a0,1004 # 80007050 <etext+0x50>
    80000c6c:	bddff0ef          	jal	80000848 <panic>
    panic("pop_off");
    80000c70:	00006517          	auipc	a0,0x6
    80000c74:	3f850513          	addi	a0,a0,1016 # 80007068 <etext+0x68>
    80000c78:	bd1ff0ef          	jal	80000848 <panic>

0000000080000c7c <release>:
{
    80000c7c:	1101                	addi	sp,sp,-32
    80000c7e:	ec06                	sd	ra,24(sp)
    80000c80:	e822                	sd	s0,16(sp)
    80000c82:	e426                	sd	s1,8(sp)
    80000c84:	1000                	addi	s0,sp,32
    80000c86:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000c88:	f0bff0ef          	jal	80000b92 <holding>
    80000c8c:	cd11                	beqz	a0,80000ca8 <release+0x2c>
  lk->cpu = 0;
    80000c8e:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000c92:	0310000f          	fence	rw,w
    80000c96:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c9a:	f9bff0ef          	jal	80000c34 <pop_off>
}
    80000c9e:	60e2                	ld	ra,24(sp)
    80000ca0:	6442                	ld	s0,16(sp)
    80000ca2:	64a2                	ld	s1,8(sp)
    80000ca4:	6105                	addi	sp,sp,32
    80000ca6:	8082                	ret
    panic("release");
    80000ca8:	00006517          	auipc	a0,0x6
    80000cac:	3c850513          	addi	a0,a0,968 # 80007070 <etext+0x70>
    80000cb0:	b99ff0ef          	jal	80000848 <panic>

0000000080000cb4 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000cb4:	1141                	addi	sp,sp,-16
    80000cb6:	e406                	sd	ra,8(sp)
    80000cb8:	e022                	sd	s0,0(sp)
    80000cba:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cbc:	ca19                	beqz	a2,80000cd2 <memset+0x1e>
    80000cbe:	87aa                	mv	a5,a0
    80000cc0:	1602                	slli	a2,a2,0x20
    80000cc2:	9201                	srli	a2,a2,0x20
    80000cc4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cc8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000ccc:	0785                	addi	a5,a5,1
    80000cce:	fee79de3          	bne	a5,a4,80000cc8 <memset+0x14>
  }
  return dst;
}
    80000cd2:	60a2                	ld	ra,8(sp)
    80000cd4:	6402                	ld	s0,0(sp)
    80000cd6:	0141                	addi	sp,sp,16
    80000cd8:	8082                	ret

0000000080000cda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cda:	1141                	addi	sp,sp,-16
    80000cdc:	e406                	sd	ra,8(sp)
    80000cde:	e022                	sd	s0,0(sp)
    80000ce0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000ce2:	ce19                	beqz	a2,80000d00 <memcmp+0x26>
    80000ce4:	1602                	slli	a2,a2,0x20
    80000ce6:	9201                	srli	a2,a2,0x20
    80000ce8:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000cec:	00054783          	lbu	a5,0(a0)
    80000cf0:	0005c703          	lbu	a4,0(a1)
    80000cf4:	00e79b63          	bne	a5,a4,80000d0a <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
    80000cf8:	0505                	addi	a0,a0,1
    80000cfa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000cfc:	fed518e3          	bne	a0,a3,80000cec <memcmp+0x12>
  }

  return 0;
    80000d00:	4501                	li	a0,0
}
    80000d02:	60a2                	ld	ra,8(sp)
    80000d04:	6402                	ld	s0,0(sp)
    80000d06:	0141                	addi	sp,sp,16
    80000d08:	8082                	ret
      return *s1 - *s2;
    80000d0a:	40e7853b          	subw	a0,a5,a4
    80000d0e:	bfd5                	j	80000d02 <memcmp+0x28>

0000000080000d10 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d10:	1141                	addi	sp,sp,-16
    80000d12:	e406                	sd	ra,8(sp)
    80000d14:	e022                	sd	s0,0(sp)
    80000d16:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d18:	c61d                	beqz	a2,80000d46 <memmove+0x36>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d1a:	00a5f963          	bgeu	a1,a0,80000d2c <memmove+0x1c>
    80000d1e:	02061693          	slli	a3,a2,0x20
    80000d22:	9281                	srli	a3,a3,0x20
    80000d24:	00d58733          	add	a4,a1,a3
    80000d28:	02e56363          	bltu	a0,a4,80000d4e <memmove+0x3e>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d2c:	1602                	slli	a2,a2,0x20
    80000d2e:	9201                	srli	a2,a2,0x20
    80000d30:	00c587b3          	add	a5,a1,a2
{
    80000d34:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d36:	0585                	addi	a1,a1,1
    80000d38:	0705                	addi	a4,a4,1
    80000d3a:	fff5c683          	lbu	a3,-1(a1)
    80000d3e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d42:	fef59ae3          	bne	a1,a5,80000d36 <memmove+0x26>

  return dst;
}
    80000d46:	60a2                	ld	ra,8(sp)
    80000d48:	6402                	ld	s0,0(sp)
    80000d4a:	0141                	addi	sp,sp,16
    80000d4c:	8082                	ret
    d += n;
    80000d4e:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d50:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d54:	1782                	slli	a5,a5,0x20
    80000d56:	9381                	srli	a5,a5,0x20
    80000d58:	fff7c793          	not	a5,a5
    80000d5c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d5e:	177d                	addi	a4,a4,-1
    80000d60:	16fd                	addi	a3,a3,-1
    80000d62:	00074603          	lbu	a2,0(a4)
    80000d66:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d6a:	fee79ae3          	bne	a5,a4,80000d5e <memmove+0x4e>
    80000d6e:	bfe1                	j	80000d46 <memmove+0x36>

0000000080000d70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d70:	1141                	addi	sp,sp,-16
    80000d72:	e406                	sd	ra,8(sp)
    80000d74:	e022                	sd	s0,0(sp)
    80000d76:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d78:	f99ff0ef          	jal	80000d10 <memmove>
}
    80000d7c:	60a2                	ld	ra,8(sp)
    80000d7e:	6402                	ld	s0,0(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret

0000000080000d84 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d84:	1141                	addi	sp,sp,-16
    80000d86:	e406                	sd	ra,8(sp)
    80000d88:	e022                	sd	s0,0(sp)
    80000d8a:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000d8c:	ce01                	beqz	a2,80000da4 <strncmp+0x20>
    80000d8e:	00054783          	lbu	a5,0(a0)
    80000d92:	cb99                	beqz	a5,80000da8 <strncmp+0x24>
    80000d94:	0005c703          	lbu	a4,0(a1)
    80000d98:	00f71863          	bne	a4,a5,80000da8 <strncmp+0x24>
    n--, p++, q++;
    80000d9c:	367d                	addiw	a2,a2,-1
    80000d9e:	0505                	addi	a0,a0,1
    80000da0:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000da2:	f675                	bnez	a2,80000d8e <strncmp+0xa>
  if (n == 0)
    return 0;
    80000da4:	4501                	li	a0,0
    80000da6:	a031                	j	80000db2 <strncmp+0x2e>
  return (uchar)*p - (uchar)*q;
    80000da8:	00054503          	lbu	a0,0(a0)
    80000dac:	0005c783          	lbu	a5,0(a1)
    80000db0:	9d1d                	subw	a0,a0,a5
}
    80000db2:	60a2                	ld	ra,8(sp)
    80000db4:	6402                	ld	s0,0(sp)
    80000db6:	0141                	addi	sp,sp,16
    80000db8:	8082                	ret

0000000080000dba <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000dba:	1141                	addi	sp,sp,-16
    80000dbc:	e406                	sd	ra,8(sp)
    80000dbe:	e022                	sd	s0,0(sp)
    80000dc0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000dc2:	87aa                	mv	a5,a0
    80000dc4:	a011                	j	80000dc8 <strncpy+0xe>
    80000dc6:	8636                	mv	a2,a3
    80000dc8:	02c05763          	blez	a2,80000df6 <strncpy+0x3c>
    80000dcc:	fff6069b          	addiw	a3,a2,-1
    80000dd0:	0785                	addi	a5,a5,1
    80000dd2:	0005c703          	lbu	a4,0(a1)
    80000dd6:	fee78fa3          	sb	a4,-1(a5)
    80000dda:	0585                	addi	a1,a1,1
    80000ddc:	f76d                	bnez	a4,80000dc6 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000dde:	873e                	mv	a4,a5
    80000de0:	00d05b63          	blez	a3,80000df6 <strncpy+0x3c>
    80000de4:	9fb1                	addw	a5,a5,a2
    80000de6:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000de8:	0705                	addi	a4,a4,1
    80000dea:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000dee:	40e786bb          	subw	a3,a5,a4
    80000df2:	fed04be3          	bgtz	a3,80000de8 <strncpy+0x2e>
  return os;
}
    80000df6:	60a2                	ld	ra,8(sp)
    80000df8:	6402                	ld	s0,0(sp)
    80000dfa:	0141                	addi	sp,sp,16
    80000dfc:	8082                	ret

0000000080000dfe <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e406                	sd	ra,8(sp)
    80000e02:	e022                	sd	s0,0(sp)
    80000e04:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e06:	02c05363          	blez	a2,80000e2c <safestrcpy+0x2e>
    80000e0a:	fff6069b          	addiw	a3,a2,-1
    80000e0e:	1682                	slli	a3,a3,0x20
    80000e10:	9281                	srli	a3,a3,0x20
    80000e12:	96ae                	add	a3,a3,a1
    80000e14:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e16:	00d58963          	beq	a1,a3,80000e28 <safestrcpy+0x2a>
    80000e1a:	0585                	addi	a1,a1,1
    80000e1c:	0785                	addi	a5,a5,1
    80000e1e:	fff5c703          	lbu	a4,-1(a1)
    80000e22:	fee78fa3          	sb	a4,-1(a5)
    80000e26:	fb65                	bnez	a4,80000e16 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e28:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e2c:	60a2                	ld	ra,8(sp)
    80000e2e:	6402                	ld	s0,0(sp)
    80000e30:	0141                	addi	sp,sp,16
    80000e32:	8082                	ret

0000000080000e34 <strlen>:

int
strlen(const char *s)
{
    80000e34:	1141                	addi	sp,sp,-16
    80000e36:	e406                	sd	ra,8(sp)
    80000e38:	e022                	sd	s0,0(sp)
    80000e3a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e3c:	00054783          	lbu	a5,0(a0)
    80000e40:	cf91                	beqz	a5,80000e5c <strlen+0x28>
    80000e42:	00150793          	addi	a5,a0,1
    80000e46:	86be                	mv	a3,a5
    80000e48:	0785                	addi	a5,a5,1
    80000e4a:	fff7c703          	lbu	a4,-1(a5)
    80000e4e:	ff65                	bnez	a4,80000e46 <strlen+0x12>
    80000e50:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e54:	60a2                	ld	ra,8(sp)
    80000e56:	6402                	ld	s0,0(sp)
    80000e58:	0141                	addi	sp,sp,16
    80000e5a:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e5c:	4501                	li	a0,0
    80000e5e:	bfdd                	j	80000e54 <strlen+0x20>

0000000080000e60 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e406                	sd	ra,8(sp)
    80000e64:	e022                	sd	s0,0(sp)
    80000e66:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e68:	247000ef          	jal	800018ae <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e6c:	00007717          	auipc	a4,0x7
    80000e70:	a0070713          	addi	a4,a4,-1536 # 8000786c <started>
  if (cpuid() == 0) {
    80000e74:	c51d                	beqz	a0,80000ea2 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e76:	431c                	lw	a5,0(a4)
    80000e78:	0230000f          	fence	r,rw
    80000e7c:	2781                	sext.w	a5,a5
    80000e7e:	dfe5                	beqz	a5,80000e76 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000e80:	22f000ef          	jal	800018ae <cpuid>
    80000e84:	85aa                	mv	a1,a0
    80000e86:	00006517          	auipc	a0,0x6
    80000e8a:	21250513          	addi	a0,a0,530 # 80007098 <etext+0x98>
    80000e8e:	e82ff0ef          	jal	80000510 <printk>
    kvminithart();  // turn on paging
    80000e92:	082000ef          	jal	80000f14 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000e96:	5a4010ef          	jal	8000243a <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000e9a:	6ce040ef          	jal	80005568 <plicinithart>
  }

  scheduler();
    80000e9e:	6b7000ef          	jal	80001d54 <scheduler>
    consoleinit();
    80000ea2:	d96ff0ef          	jal	80000438 <consoleinit>
    printkinit();
    80000ea6:	9dfff0ef          	jal	80000884 <printkinit>
    printk("\n");
    80000eaa:	00006517          	auipc	a0,0x6
    80000eae:	1ce50513          	addi	a0,a0,462 # 80007078 <etext+0x78>
    80000eb2:	e5eff0ef          	jal	80000510 <printk>
    printk("xv6 kernel is booting\n");
    80000eb6:	00006517          	auipc	a0,0x6
    80000eba:	1ca50513          	addi	a0,a0,458 # 80007080 <etext+0x80>
    80000ebe:	e52ff0ef          	jal	80000510 <printk>
    printk("\n");
    80000ec2:	00006517          	auipc	a0,0x6
    80000ec6:	1b650513          	addi	a0,a0,438 # 80007078 <etext+0x78>
    80000eca:	e46ff0ef          	jal	80000510 <printk>
    kinit();            // physical page allocator
    80000ece:	c1dff0ef          	jal	80000aea <kinit>
    kvminit();          // create kernel page table
    80000ed2:	2c2000ef          	jal	80001194 <kvminit>
    kvminithart();      // turn on paging
    80000ed6:	03e000ef          	jal	80000f14 <kvminithart>
    procinit();         // process table
    80000eda:	11d000ef          	jal	800017f6 <procinit>
    trapinit();         // trap vectors
    80000ede:	538010ef          	jal	80002416 <trapinit>
    trapinithart();     // install kernel trap vector
    80000ee2:	558010ef          	jal	8000243a <trapinithart>
    plicinit();         // set up interrupt controller
    80000ee6:	668040ef          	jal	8000554e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000eea:	67e040ef          	jal	80005568 <plicinithart>
    binit();            // buffer cache
    80000eee:	3e5010ef          	jal	80002ad2 <binit>
    iinit();            // inode table
    80000ef2:	13e020ef          	jal	80003030 <iinit>
    fileinit();         // file table
    80000ef6:	162030ef          	jal	80004058 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efa:	75e040ef          	jal	80005658 <virtio_disk_init>
    userinit();         // first user process
    80000efe:	4b5000ef          	jal	80001bb2 <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f02:	00007797          	auipc	a5,0x7
    80000f06:	96a78793          	addi	a5,a5,-1686 # 8000786c <started>
    80000f0a:	4705                	li	a4,1
    80000f0c:	0310000f          	fence	rw,w
    80000f10:	c398                	sw	a4,0(a5)
    80000f12:	b771                	j	80000e9e <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e406                	sd	ra,8(sp)
    80000f18:	e022                	sd	s0,0(sp)
    80000f1a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f1c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f20:	00007797          	auipc	a5,0x7
    80000f24:	9507b783          	ld	a5,-1712(a5) # 80007870 <kernel_pagetable>
    80000f28:	83b1                	srli	a5,a5,0xc
    80000f2a:	577d                	li	a4,-1
    80000f2c:	177e                	slli	a4,a4,0x3f
    80000f2e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f30:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f34:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f38:	60a2                	ld	ra,8(sp)
    80000f3a:	6402                	ld	s0,0(sp)
    80000f3c:	0141                	addi	sp,sp,16
    80000f3e:	8082                	ret

0000000080000f40 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f40:	7139                	addi	sp,sp,-64
    80000f42:	fc06                	sd	ra,56(sp)
    80000f44:	f822                	sd	s0,48(sp)
    80000f46:	f426                	sd	s1,40(sp)
    80000f48:	f04a                	sd	s2,32(sp)
    80000f4a:	ec4e                	sd	s3,24(sp)
    80000f4c:	e852                	sd	s4,16(sp)
    80000f4e:	e456                	sd	s5,8(sp)
    80000f50:	e05a                	sd	s6,0(sp)
    80000f52:	0080                	addi	s0,sp,64
    80000f54:	84aa                	mv	s1,a0
    80000f56:	89ae                	mv	s3,a1
    80000f58:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f5a:	57fd                	li	a5,-1
    80000f5c:	83e9                	srli	a5,a5,0x1a
    80000f5e:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f60:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f62:	06b7e363          	bltu	a5,a1,80000fc8 <walk+0x88>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f66:	0149d933          	srl	s2,s3,s4
    80000f6a:	1ff97913          	andi	s2,s2,511
    80000f6e:	090e                	slli	s2,s2,0x3
    80000f70:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f72:	00093483          	ld	s1,0(s2)
    80000f76:	0014f793          	andi	a5,s1,1
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f7a:	80a9                	srli	s1,s1,0xa
    80000f7c:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_V) {
    80000f7e:	e395                	bnez	a5,80000fa2 <walk+0x62>
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000f80:	040b0a63          	beqz	s6,80000fd4 <walk+0x94>
    80000f84:	b9bff0ef          	jal	80000b1e <kalloc>
    80000f88:	84aa                	mv	s1,a0
    80000f8a:	c50d                	beqz	a0,80000fb4 <walk+0x74>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f8c:	6605                	lui	a2,0x1
    80000f8e:	4581                	li	a1,0
    80000f90:	d25ff0ef          	jal	80000cb4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f94:	00c4d793          	srli	a5,s1,0xc
    80000f98:	07aa                	slli	a5,a5,0xa
    80000f9a:	0017e793          	ori	a5,a5,1
    80000f9e:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000fa2:	3a5d                	addiw	s4,s4,-9
    80000fa4:	fd5a11e3          	bne	s4,s5,80000f66 <walk+0x26>
    }
  }
  return &pagetable[PX(0, va)];
    80000fa8:	00c9d513          	srli	a0,s3,0xc
    80000fac:	1ff57513          	andi	a0,a0,511
    80000fb0:	050e                	slli	a0,a0,0x3
    80000fb2:	9526                	add	a0,a0,s1
}
    80000fb4:	70e2                	ld	ra,56(sp)
    80000fb6:	7442                	ld	s0,48(sp)
    80000fb8:	74a2                	ld	s1,40(sp)
    80000fba:	7902                	ld	s2,32(sp)
    80000fbc:	69e2                	ld	s3,24(sp)
    80000fbe:	6a42                	ld	s4,16(sp)
    80000fc0:	6aa2                	ld	s5,8(sp)
    80000fc2:	6b02                	ld	s6,0(sp)
    80000fc4:	6121                	addi	sp,sp,64
    80000fc6:	8082                	ret
    panic("walk");
    80000fc8:	00006517          	auipc	a0,0x6
    80000fcc:	0e850513          	addi	a0,a0,232 # 800070b0 <etext+0xb0>
    80000fd0:	879ff0ef          	jal	80000848 <panic>
        return 0;
    80000fd4:	4501                	li	a0,0
    80000fd6:	bff9                	j	80000fb4 <walk+0x74>

0000000080000fd8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000fd8:	57fd                	li	a5,-1
    80000fda:	83e9                	srli	a5,a5,0x1a
    80000fdc:	00b7f463          	bgeu	a5,a1,80000fe4 <walkaddr+0xc>
    return 0;
    80000fe0:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe2:	8082                	ret
{
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e406                	sd	ra,8(sp)
    80000fe8:	e022                	sd	s0,0(sp)
    80000fea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fec:	4601                	li	a2,0
    80000fee:	f53ff0ef          	jal	80000f40 <walk>
  if (pte == 0)
    80000ff2:	c519                	beqz	a0,80001000 <walkaddr+0x28>
  if ((*pte & PTE_V) == 0)
    80000ff4:	6108                	ld	a0,0(a0)
  if ((*pte & PTE_U) == 0)
    80000ff6:	01157713          	andi	a4,a0,17
    80000ffa:	47c5                	li	a5,17
    80000ffc:	00f70763          	beq	a4,a5,8000100a <walkaddr+0x32>
    return 0;
    80001000:	4501                	li	a0,0
}
    80001002:	60a2                	ld	ra,8(sp)
    80001004:	6402                	ld	s0,0(sp)
    80001006:	0141                	addi	sp,sp,16
    80001008:	8082                	ret
  pa = PTE2PA(*pte);
    8000100a:	8129                	srli	a0,a0,0xa
    8000100c:	0532                	slli	a0,a0,0xc
  return pa;
    8000100e:	bfd5                	j	80001002 <walkaddr+0x2a>

0000000080001010 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001010:	715d                	addi	sp,sp,-80
    80001012:	e486                	sd	ra,72(sp)
    80001014:	e0a2                	sd	s0,64(sp)
    80001016:	fc26                	sd	s1,56(sp)
    80001018:	f84a                	sd	s2,48(sp)
    8000101a:	f44e                	sd	s3,40(sp)
    8000101c:	f052                	sd	s4,32(sp)
    8000101e:	ec56                	sd	s5,24(sp)
    80001020:	e85a                	sd	s6,16(sp)
    80001022:	e45e                	sd	s7,8(sp)
    80001024:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001026:	03459793          	slli	a5,a1,0x34
    8000102a:	e7b1                	bnez	a5,80001076 <mappages+0x66>
    8000102c:	8a2a                	mv	s4,a0
    8000102e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001030:	03461793          	slli	a5,a2,0x34
    80001034:	e7b9                	bnez	a5,80001082 <mappages+0x72>
    panic("mappages: size not aligned");

  if (size == 0)
    80001036:	ce21                	beqz	a2,8000108e <mappages+0x7e>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001038:	77fd                	lui	a5,0xfffff
    8000103a:	963e                	add	a2,a2,a5
    8000103c:	00b60933          	add	s2,a2,a1
  a = va;
    80001040:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001042:	4b05                	li	s6,1
    80001044:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001048:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000104a:	865a                	mv	a2,s6
    8000104c:	85a6                	mv	a1,s1
    8000104e:	8552                	mv	a0,s4
    80001050:	ef1ff0ef          	jal	80000f40 <walk>
    80001054:	c929                	beqz	a0,800010a6 <mappages+0x96>
    if (*pte & PTE_V)
    80001056:	611c                	ld	a5,0(a0)
    80001058:	8b85                	andi	a5,a5,1
    8000105a:	e3a1                	bnez	a5,8000109a <mappages+0x8a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000105c:	013487b3          	add	a5,s1,s3
    80001060:	83b1                	srli	a5,a5,0xc
    80001062:	07aa                	slli	a5,a5,0xa
    80001064:	0157e7b3          	or	a5,a5,s5
    80001068:	0017e793          	ori	a5,a5,1
    8000106c:	e11c                	sd	a5,0(a0)
    if (a == last)
    8000106e:	05248863          	beq	s1,s2,800010be <mappages+0xae>
    a += PGSIZE;
    80001072:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001074:	bfd9                	j	8000104a <mappages+0x3a>
    panic("mappages: va not aligned");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	04250513          	addi	a0,a0,66 # 800070b8 <etext+0xb8>
    8000107e:	fcaff0ef          	jal	80000848 <panic>
    panic("mappages: size not aligned");
    80001082:	00006517          	auipc	a0,0x6
    80001086:	05650513          	addi	a0,a0,86 # 800070d8 <etext+0xd8>
    8000108a:	fbeff0ef          	jal	80000848 <panic>
    panic("mappages: size");
    8000108e:	00006517          	auipc	a0,0x6
    80001092:	06a50513          	addi	a0,a0,106 # 800070f8 <etext+0xf8>
    80001096:	fb2ff0ef          	jal	80000848 <panic>
      panic("mappages: remap");
    8000109a:	00006517          	auipc	a0,0x6
    8000109e:	06e50513          	addi	a0,a0,110 # 80007108 <etext+0x108>
    800010a2:	fa6ff0ef          	jal	80000848 <panic>
      return -1;
    800010a6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010a8:	60a6                	ld	ra,72(sp)
    800010aa:	6406                	ld	s0,64(sp)
    800010ac:	74e2                	ld	s1,56(sp)
    800010ae:	7942                	ld	s2,48(sp)
    800010b0:	79a2                	ld	s3,40(sp)
    800010b2:	7a02                	ld	s4,32(sp)
    800010b4:	6ae2                	ld	s5,24(sp)
    800010b6:	6b42                	ld	s6,16(sp)
    800010b8:	6ba2                	ld	s7,8(sp)
    800010ba:	6161                	addi	sp,sp,80
    800010bc:	8082                	ret
  return 0;
    800010be:	4501                	li	a0,0
    800010c0:	b7e5                	j	800010a8 <mappages+0x98>

00000000800010c2 <kvmmap>:
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
    800010ca:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010cc:	86b2                	mv	a3,a2
    800010ce:	863e                	mv	a2,a5
    800010d0:	f41ff0ef          	jal	80001010 <mappages>
    800010d4:	e509                	bnez	a0,800010de <kvmmap+0x1c>
}
    800010d6:	60a2                	ld	ra,8(sp)
    800010d8:	6402                	ld	s0,0(sp)
    800010da:	0141                	addi	sp,sp,16
    800010dc:	8082                	ret
    panic("kvmmap");
    800010de:	00006517          	auipc	a0,0x6
    800010e2:	03a50513          	addi	a0,a0,58 # 80007118 <etext+0x118>
    800010e6:	f62ff0ef          	jal	80000848 <panic>

00000000800010ea <kvmmake>:
{
    800010ea:	1101                	addi	sp,sp,-32
    800010ec:	ec06                	sd	ra,24(sp)
    800010ee:	e822                	sd	s0,16(sp)
    800010f0:	e426                	sd	s1,8(sp)
    800010f2:	e04a                	sd	s2,0(sp)
    800010f4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800010f6:	a29ff0ef          	jal	80000b1e <kalloc>
    800010fa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fc:	6605                	lui	a2,0x1
    800010fe:	4581                	li	a1,0
    80001100:	bb5ff0ef          	jal	80000cb4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001104:	4719                	li	a4,6
    80001106:	6685                	lui	a3,0x1
    80001108:	10000637          	lui	a2,0x10000
    8000110c:	85b2                	mv	a1,a2
    8000110e:	8526                	mv	a0,s1
    80001110:	fb3ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001114:	4719                	li	a4,6
    80001116:	6685                	lui	a3,0x1
    80001118:	10001637          	lui	a2,0x10001
    8000111c:	85b2                	mv	a1,a2
    8000111e:	8526                	mv	a0,s1
    80001120:	fa3ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001124:	4719                	li	a4,6
    80001126:	040006b7          	lui	a3,0x4000
    8000112a:	0c000637          	lui	a2,0xc000
    8000112e:	85b2                	mv	a1,a2
    80001130:	8526                	mv	a0,s1
    80001132:	f91ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001136:	00006917          	auipc	s2,0x6
    8000113a:	eca90913          	addi	s2,s2,-310 # 80007000 <etext>
    8000113e:	4729                	li	a4,10
    80001140:	800006b7          	lui	a3,0x80000
    80001144:	96ca                	add	a3,a3,s2
    80001146:	4605                	li	a2,1
    80001148:	067e                	slli	a2,a2,0x1f
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	f75ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001152:	4719                	li	a4,6
    80001154:	46c5                	li	a3,17
    80001156:	06ee                	slli	a3,a3,0x1b
    80001158:	412686b3          	sub	a3,a3,s2
    8000115c:	864a                	mv	a2,s2
    8000115e:	85ca                	mv	a1,s2
    80001160:	8526                	mv	a0,s1
    80001162:	f61ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001166:	4729                	li	a4,10
    80001168:	6685                	lui	a3,0x1
    8000116a:	00005617          	auipc	a2,0x5
    8000116e:	e9660613          	addi	a2,a2,-362 # 80006000 <_trampoline>
    80001172:	040005b7          	lui	a1,0x4000
    80001176:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001178:	05b2                	slli	a1,a1,0xc
    8000117a:	8526                	mv	a0,s1
    8000117c:	f47ff0ef          	jal	800010c2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001180:	8526                	mv	a0,s1
    80001182:	5e0000ef          	jal	80001762 <proc_mapstacks>
}
    80001186:	8526                	mv	a0,s1
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6902                	ld	s2,0(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret

0000000080001194 <kvminit>:
{
    80001194:	1141                	addi	sp,sp,-16
    80001196:	e406                	sd	ra,8(sp)
    80001198:	e022                	sd	s0,0(sp)
    8000119a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000119c:	f4fff0ef          	jal	800010ea <kvmmake>
    800011a0:	00006797          	auipc	a5,0x6
    800011a4:	6ca7b823          	sd	a0,1744(a5) # 80007870 <kernel_pagetable>
}
    800011a8:	60a2                	ld	ra,8(sp)
    800011aa:	6402                	ld	s0,0(sp)
    800011ac:	0141                	addi	sp,sp,16
    800011ae:	8082                	ret

00000000800011b0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011b0:	1101                	addi	sp,sp,-32
    800011b2:	ec06                	sd	ra,24(sp)
    800011b4:	e822                	sd	s0,16(sp)
    800011b6:	e426                	sd	s1,8(sp)
    800011b8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011ba:	965ff0ef          	jal	80000b1e <kalloc>
    800011be:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011c0:	c509                	beqz	a0,800011ca <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011c2:	6605                	lui	a2,0x1
    800011c4:	4581                	li	a1,0
    800011c6:	aefff0ef          	jal	80000cb4 <memset>
  return pagetable;
}
    800011ca:	8526                	mv	a0,s1
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011d6:	7139                	addi	sp,sp,-64
    800011d8:	fc06                	sd	ra,56(sp)
    800011da:	f822                	sd	s0,48(sp)
    800011dc:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011de:	03459793          	slli	a5,a1,0x34
    800011e2:	e38d                	bnez	a5,80001204 <uvmunmap+0x2e>
    800011e4:	f04a                	sd	s2,32(sp)
    800011e6:	ec4e                	sd	s3,24(sp)
    800011e8:	e852                	sd	s4,16(sp)
    800011ea:	e456                	sd	s5,8(sp)
    800011ec:	e05a                	sd	s6,0(sp)
    800011ee:	8a2a                	mv	s4,a0
    800011f0:	892e                	mv	s2,a1
    800011f2:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800011f4:	0632                	slli	a2,a2,0xc
    800011f6:	00b609b3          	add	s3,a2,a1
    800011fa:	6b05                	lui	s6,0x1
    800011fc:	0535f963          	bgeu	a1,s3,8000124e <uvmunmap+0x78>
    80001200:	f426                	sd	s1,40(sp)
    80001202:	a015                	j	80001226 <uvmunmap+0x50>
    80001204:	f426                	sd	s1,40(sp)
    80001206:	f04a                	sd	s2,32(sp)
    80001208:	ec4e                	sd	s3,24(sp)
    8000120a:	e852                	sd	s4,16(sp)
    8000120c:	e456                	sd	s5,8(sp)
    8000120e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001210:	00006517          	auipc	a0,0x6
    80001214:	f1050513          	addi	a0,a0,-240 # 80007120 <etext+0x120>
    80001218:	e30ff0ef          	jal	80000848 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    8000121c:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001220:	995a                	add	s2,s2,s6
    80001222:	03397563          	bgeu	s2,s3,8000124c <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001226:	4601                	li	a2,0
    80001228:	85ca                	mv	a1,s2
    8000122a:	8552                	mv	a0,s4
    8000122c:	d15ff0ef          	jal	80000f40 <walk>
    80001230:	84aa                	mv	s1,a0
    80001232:	d57d                	beqz	a0,80001220 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001234:	611c                	ld	a5,0(a0)
    80001236:	0017f713          	andi	a4,a5,1
    8000123a:	d37d                	beqz	a4,80001220 <uvmunmap+0x4a>
    if (do_free) {
    8000123c:	fe0a80e3          	beqz	s5,8000121c <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001240:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001242:	00c79513          	slli	a0,a5,0xc
    80001246:	ff0ff0ef          	jal	80000a36 <kfree>
    8000124a:	bfc9                	j	8000121c <uvmunmap+0x46>
    8000124c:	74a2                	ld	s1,40(sp)
    8000124e:	7902                	ld	s2,32(sp)
    80001250:	69e2                	ld	s3,24(sp)
    80001252:	6a42                	ld	s4,16(sp)
    80001254:	6aa2                	ld	s5,8(sp)
    80001256:	6b02                	ld	s6,0(sp)
  }
}
    80001258:	70e2                	ld	ra,56(sp)
    8000125a:	7442                	ld	s0,48(sp)
    8000125c:	6121                	addi	sp,sp,64
    8000125e:	8082                	ret

0000000080001260 <uvmdealloc>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    80001260:	04b67163          	bgeu	a2,a1,800012a2 <uvmdealloc+0x42>
{
    80001264:	1101                	addi	sp,sp,-32
    80001266:	ec06                	sd	ra,24(sp)
    80001268:	e822                	sd	s0,16(sp)
    8000126a:	e426                	sd	s1,8(sp)
    8000126c:	1000                	addi	s0,sp,32
    8000126e:	84b2                	mv	s1,a2
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80001270:	6785                	lui	a5,0x1
    80001272:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001274:	00f60733          	add	a4,a2,a5
    80001278:	76fd                	lui	a3,0xfffff
    8000127a:	8f75                	and	a4,a4,a3
    8000127c:	97ae                	add	a5,a5,a1
    8000127e:	8ff5                	and	a5,a5,a3
    80001280:	00f76863          	bltu	a4,a5,80001290 <uvmdealloc+0x30>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    80001284:	8526                	mv	a0,s1
}
    80001286:	60e2                	ld	ra,24(sp)
    80001288:	6442                	ld	s0,16(sp)
    8000128a:	64a2                	ld	s1,8(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001290:	8f99                	sub	a5,a5,a4
    80001292:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001294:	4685                	li	a3,1
    80001296:	0007861b          	sext.w	a2,a5
    8000129a:	85ba                	mv	a1,a4
    8000129c:	f3bff0ef          	jal	800011d6 <uvmunmap>
    800012a0:	b7d5                	j	80001284 <uvmdealloc+0x24>
    return oldsz;
    800012a2:	852e                	mv	a0,a1
}
    800012a4:	8082                	ret

00000000800012a6 <uvmalloc>:
  if (newsz < oldsz)
    800012a6:	08b66e63          	bltu	a2,a1,80001342 <uvmalloc+0x9c>
{
    800012aa:	715d                	addi	sp,sp,-80
    800012ac:	e486                	sd	ra,72(sp)
    800012ae:	e0a2                	sd	s0,64(sp)
    800012b0:	f052                	sd	s4,32(sp)
    800012b2:	ec56                	sd	s5,24(sp)
    800012b4:	e45e                	sd	s7,8(sp)
    800012b6:	0880                	addi	s0,sp,80
    800012b8:	8aaa                	mv	s5,a0
    800012ba:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012bc:	6785                	lui	a5,0x1
    800012be:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012c0:	95be                	add	a1,a1,a5
    800012c2:	77fd                	lui	a5,0xfffff
    800012c4:	8fed                	and	a5,a5,a1
    800012c6:	8bbe                	mv	s7,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012c8:	04c7f163          	bgeu	a5,a2,8000130a <uvmalloc+0x64>
    800012cc:	fc26                	sd	s1,56(sp)
    800012ce:	f84a                	sd	s2,48(sp)
    800012d0:	f44e                	sd	s3,40(sp)
    800012d2:	e85a                	sd	s6,16(sp)
    800012d4:	893e                	mv	s2,a5
    memset(mem, 0, PGSIZE);
    800012d6:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012d8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012dc:	843ff0ef          	jal	80000b1e <kalloc>
    800012e0:	84aa                	mv	s1,a0
    if (mem == 0) {
    800012e2:	c515                	beqz	a0,8000130e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800012e4:	864e                	mv	a2,s3
    800012e6:	4581                	li	a1,0
    800012e8:	9cdff0ef          	jal	80000cb4 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012ec:	875a                	mv	a4,s6
    800012ee:	86a6                	mv	a3,s1
    800012f0:	864e                	mv	a2,s3
    800012f2:	85ca                	mv	a1,s2
    800012f4:	8556                	mv	a0,s5
    800012f6:	d1bff0ef          	jal	80001010 <mappages>
    800012fa:	e91d                	bnez	a0,80001330 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012fc:	994e                	add	s2,s2,s3
    800012fe:	fd496fe3          	bltu	s2,s4,800012dc <uvmalloc+0x36>
    80001302:	74e2                	ld	s1,56(sp)
    80001304:	7942                	ld	s2,48(sp)
    80001306:	79a2                	ld	s3,40(sp)
    80001308:	6b42                	ld	s6,16(sp)
  return newsz;
    8000130a:	8552                	mv	a0,s4
    8000130c:	a819                	j	80001322 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000130e:	865e                	mv	a2,s7
    80001310:	85ca                	mv	a1,s2
    80001312:	8556                	mv	a0,s5
    80001314:	f4dff0ef          	jal	80001260 <uvmdealloc>
      return 0;
    80001318:	4501                	li	a0,0
    8000131a:	74e2                	ld	s1,56(sp)
    8000131c:	7942                	ld	s2,48(sp)
    8000131e:	79a2                	ld	s3,40(sp)
    80001320:	6b42                	ld	s6,16(sp)
}
    80001322:	60a6                	ld	ra,72(sp)
    80001324:	6406                	ld	s0,64(sp)
    80001326:	7a02                	ld	s4,32(sp)
    80001328:	6ae2                	ld	s5,24(sp)
    8000132a:	6ba2                	ld	s7,8(sp)
    8000132c:	6161                	addi	sp,sp,80
    8000132e:	8082                	ret
      kfree(mem);
    80001330:	8526                	mv	a0,s1
    80001332:	f04ff0ef          	jal	80000a36 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001336:	865e                	mv	a2,s7
    80001338:	85ca                	mv	a1,s2
    8000133a:	8556                	mv	a0,s5
    8000133c:	f25ff0ef          	jal	80001260 <uvmdealloc>
      return 0;
    80001340:	bfe1                	j	80001318 <uvmalloc+0x72>
    return oldsz;
    80001342:	852e                	mv	a0,a1
}
    80001344:	8082                	ret

0000000080001346 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001346:	7179                	addi	sp,sp,-48
    80001348:	f406                	sd	ra,40(sp)
    8000134a:	f022                	sd	s0,32(sp)
    8000134c:	ec26                	sd	s1,24(sp)
    8000134e:	e84a                	sd	s2,16(sp)
    80001350:	e44e                	sd	s3,8(sp)
    80001352:	1800                	addi	s0,sp,48
    80001354:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001356:	84aa                	mv	s1,a0
    80001358:	6905                	lui	s2,0x1
    8000135a:	992a                	add	s2,s2,a0
    8000135c:	a811                	j	80001370 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    8000135e:	00006517          	auipc	a0,0x6
    80001362:	dda50513          	addi	a0,a0,-550 # 80007138 <etext+0x138>
    80001366:	ce2ff0ef          	jal	80000848 <panic>
  for (int i = 0; i < 512; i++) {
    8000136a:	04a1                	addi	s1,s1,8
    8000136c:	03248163          	beq	s1,s2,8000138e <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001370:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001372:	0017f713          	andi	a4,a5,1
    80001376:	db75                	beqz	a4,8000136a <freewalk+0x24>
    80001378:	00e7f713          	andi	a4,a5,14
    8000137c:	f36d                	bnez	a4,8000135e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000137e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001380:	00c79513          	slli	a0,a5,0xc
    80001384:	fc3ff0ef          	jal	80001346 <freewalk>
      pagetable[i] = 0;
    80001388:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000138c:	bff9                	j	8000136a <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    8000138e:	854e                	mv	a0,s3
    80001390:	ea6ff0ef          	jal	80000a36 <kfree>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6145                	addi	sp,sp,48
    800013a0:	8082                	ret

00000000800013a2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013a2:	1101                	addi	sp,sp,-32
    800013a4:	ec06                	sd	ra,24(sp)
    800013a6:	e822                	sd	s0,16(sp)
    800013a8:	e426                	sd	s1,8(sp)
    800013aa:	1000                	addi	s0,sp,32
    800013ac:	84aa                	mv	s1,a0
  if (sz > 0)
    800013ae:	e989                	bnez	a1,800013c0 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013b0:	8526                	mv	a0,s1
    800013b2:	f95ff0ef          	jal	80001346 <freewalk>
}
    800013b6:	60e2                	ld	ra,24(sp)
    800013b8:	6442                	ld	s0,16(sp)
    800013ba:	64a2                	ld	s1,8(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013c0:	6785                	lui	a5,0x1
    800013c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013c4:	95be                	add	a1,a1,a5
    800013c6:	4685                	li	a3,1
    800013c8:	00c5d613          	srli	a2,a1,0xc
    800013cc:	4581                	li	a1,0
    800013ce:	e09ff0ef          	jal	800011d6 <uvmunmap>
    800013d2:	bff9                	j	800013b0 <uvmfree+0xe>

00000000800013d4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013d4:	ca59                	beqz	a2,8000146a <uvmcopy+0x96>
{
    800013d6:	715d                	addi	sp,sp,-80
    800013d8:	e486                	sd	ra,72(sp)
    800013da:	e0a2                	sd	s0,64(sp)
    800013dc:	fc26                	sd	s1,56(sp)
    800013de:	f84a                	sd	s2,48(sp)
    800013e0:	f44e                	sd	s3,40(sp)
    800013e2:	f052                	sd	s4,32(sp)
    800013e4:	ec56                	sd	s5,24(sp)
    800013e6:	e85a                	sd	s6,16(sp)
    800013e8:	e45e                	sd	s7,8(sp)
    800013ea:	0880                	addi	s0,sp,80
    800013ec:	8b2a                	mv	s6,a0
    800013ee:	8bae                	mv	s7,a1
    800013f0:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    800013f2:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    800013f4:	6a05                	lui	s4,0x1
    800013f6:	a021                	j	800013fe <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    800013f8:	94d2                	add	s1,s1,s4
    800013fa:	0554fc63          	bgeu	s1,s5,80001452 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    800013fe:	4601                	li	a2,0
    80001400:	85a6                	mv	a1,s1
    80001402:	855a                	mv	a0,s6
    80001404:	b3dff0ef          	jal	80000f40 <walk>
    80001408:	d965                	beqz	a0,800013f8 <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000140a:	00053983          	ld	s3,0(a0)
    8000140e:	0019f793          	andi	a5,s3,1
    80001412:	d3fd                	beqz	a5,800013f8 <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001414:	f0aff0ef          	jal	80000b1e <kalloc>
    80001418:	892a                	mv	s2,a0
    8000141a:	c11d                	beqz	a0,80001440 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000141c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001420:	8652                	mv	a2,s4
    80001422:	05b2                	slli	a1,a1,0xc
    80001424:	8edff0ef          	jal	80000d10 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80001428:	3ff9f713          	andi	a4,s3,1023
    8000142c:	86ca                	mv	a3,s2
    8000142e:	8652                	mv	a2,s4
    80001430:	85a6                	mv	a1,s1
    80001432:	855e                	mv	a0,s7
    80001434:	bddff0ef          	jal	80001010 <mappages>
    80001438:	d161                	beqz	a0,800013f8 <uvmcopy+0x24>
      kfree(mem);
    8000143a:	854a                	mv	a0,s2
    8000143c:	dfaff0ef          	jal	80000a36 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001440:	4685                	li	a3,1
    80001442:	00c4d613          	srli	a2,s1,0xc
    80001446:	4581                	li	a1,0
    80001448:	855e                	mv	a0,s7
    8000144a:	d8dff0ef          	jal	800011d6 <uvmunmap>
  return -1;
    8000144e:	557d                	li	a0,-1
    80001450:	a011                	j	80001454 <uvmcopy+0x80>
  return 0;
    80001452:	4501                	li	a0,0
}
    80001454:	60a6                	ld	ra,72(sp)
    80001456:	6406                	ld	s0,64(sp)
    80001458:	74e2                	ld	s1,56(sp)
    8000145a:	7942                	ld	s2,48(sp)
    8000145c:	79a2                	ld	s3,40(sp)
    8000145e:	7a02                	ld	s4,32(sp)
    80001460:	6ae2                	ld	s5,24(sp)
    80001462:	6b42                	ld	s6,16(sp)
    80001464:	6ba2                	ld	s7,8(sp)
    80001466:	6161                	addi	sp,sp,80
    80001468:	8082                	ret
  return 0;
    8000146a:	4501                	li	a0,0
}
    8000146c:	8082                	ret

000000008000146e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000146e:	1141                	addi	sp,sp,-16
    80001470:	e406                	sd	ra,8(sp)
    80001472:	e022                	sd	s0,0(sp)
    80001474:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001476:	4601                	li	a2,0
    80001478:	ac9ff0ef          	jal	80000f40 <walk>
  if (pte == 0)
    8000147c:	c901                	beqz	a0,8000148c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000147e:	611c                	ld	a5,0(a0)
    80001480:	9bbd                	andi	a5,a5,-17
    80001482:	e11c                	sd	a5,0(a0)
}
    80001484:	60a2                	ld	ra,8(sp)
    80001486:	6402                	ld	s0,0(sp)
    80001488:	0141                	addi	sp,sp,16
    8000148a:	8082                	ret
    panic("uvmclear");
    8000148c:	00006517          	auipc	a0,0x6
    80001490:	cbc50513          	addi	a0,a0,-836 # 80007148 <etext+0x148>
    80001494:	bb4ff0ef          	jal	80000848 <panic>

0000000080001498 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001498:	1141                	addi	sp,sp,-16
    8000149a:	e406                	sd	ra,8(sp)
    8000149c:	e022                	sd	s0,0(sp)
    8000149e:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014a0:	4601                	li	a2,0
    800014a2:	a9fff0ef          	jal	80000f40 <walk>
  if (pte == 0) {
    800014a6:	c119                	beqz	a0,800014ac <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014a8:	6108                	ld	a0,0(a0)
    800014aa:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014ac:	60a2                	ld	ra,8(sp)
    800014ae:	6402                	ld	s0,0(sp)
    800014b0:	0141                	addi	sp,sp,16
    800014b2:	8082                	ret

00000000800014b4 <vmfault>:
{
    800014b4:	7179                	addi	sp,sp,-48
    800014b6:	f406                	sd	ra,40(sp)
    800014b8:	f022                	sd	s0,32(sp)
    800014ba:	e052                	sd	s4,0(sp)
    800014bc:	1800                	addi	s0,sp,48
  if (va >= psz)
    800014be:	00b66d63          	bltu	a2,a1,800014d8 <vmfault+0x24>
    return 0;
    800014c2:	4a01                	li	s4,0
}
    800014c4:	8552                	mv	a0,s4
    800014c6:	70a2                	ld	ra,40(sp)
    800014c8:	7402                	ld	s0,32(sp)
    800014ca:	6a02                	ld	s4,0(sp)
    800014cc:	6145                	addi	sp,sp,48
    800014ce:	8082                	ret
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	b7f5                	j	800014c2 <vmfault+0xe>
    800014d8:	e84a                	sd	s2,16(sp)
    800014da:	e44e                	sd	s3,8(sp)
  va = PGROUNDDOWN(va);
    800014dc:	77fd                	lui	a5,0xfffff
    800014de:	00f67933          	and	s2,a2,a5
  if (ismapped(pagetable, va)) {
    800014e2:	85ca                	mv	a1,s2
    800014e4:	89aa                	mv	s3,a0
    800014e6:	fb3ff0ef          	jal	80001498 <ismapped>
    800014ea:	c501                	beqz	a0,800014f2 <vmfault+0x3e>
    800014ec:	6942                	ld	s2,16(sp)
    800014ee:	69a2                	ld	s3,8(sp)
    800014f0:	bfc9                	j	800014c2 <vmfault+0xe>
    800014f2:	ec26                	sd	s1,24(sp)
  mem = (uint64)kalloc();
    800014f4:	e2aff0ef          	jal	80000b1e <kalloc>
    800014f8:	84aa                	mv	s1,a0
  if (mem == 0)
    800014fa:	d979                	beqz	a0,800014d0 <vmfault+0x1c>
  mem = (uint64)kalloc();
    800014fc:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    800014fe:	6605                	lui	a2,0x1
    80001500:	4581                	li	a1,0
    80001502:	fb2ff0ef          	jal	80000cb4 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001506:	4759                	li	a4,22
    80001508:	86a6                	mv	a3,s1
    8000150a:	6605                	lui	a2,0x1
    8000150c:	85ca                	mv	a1,s2
    8000150e:	854e                	mv	a0,s3
    80001510:	b01ff0ef          	jal	80001010 <mappages>
    80001514:	e509                	bnez	a0,8000151e <vmfault+0x6a>
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	b765                	j	800014c4 <vmfault+0x10>
    kfree((void *)mem);
    8000151e:	8526                	mv	a0,s1
    80001520:	d16ff0ef          	jal	80000a36 <kfree>
    return 0;
    80001524:	64e2                	ld	s1,24(sp)
    80001526:	6942                	ld	s2,16(sp)
    80001528:	69a2                	ld	s3,8(sp)
    8000152a:	bf61                	j	800014c2 <vmfault+0xe>

000000008000152c <copyout>:
  while (len > 0) {
    8000152c:	cf55                	beqz	a4,800015e8 <copyout+0xbc>
{
    8000152e:	7159                	addi	sp,sp,-112
    80001530:	f486                	sd	ra,104(sp)
    80001532:	f0a2                	sd	s0,96(sp)
    80001534:	eca6                	sd	s1,88(sp)
    80001536:	e8ca                	sd	s2,80(sp)
    80001538:	e4ce                	sd	s3,72(sp)
    8000153a:	e0d2                	sd	s4,64(sp)
    8000153c:	fc56                	sd	s5,56(sp)
    8000153e:	f85a                	sd	s6,48(sp)
    80001540:	f45e                	sd	s7,40(sp)
    80001542:	f062                	sd	s8,32(sp)
    80001544:	ec66                	sd	s9,24(sp)
    80001546:	e86a                	sd	s10,16(sp)
    80001548:	e46e                	sd	s11,8(sp)
    8000154a:	1880                	addi	s0,sp,112
    8000154c:	8baa                	mv	s7,a0
    8000154e:	8dae                	mv	s11,a1
    80001550:	84b2                	mv	s1,a2
    80001552:	8b36                	mv	s6,a3
    80001554:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    80001556:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001558:	5cfd                	li	s9,-1
    8000155a:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    8000155e:	6c05                	lui	s8,0x1
    80001560:	a089                	j	800015a2 <copyout+0x76>
      return -1;
    80001562:	557d                	li	a0,-1
}
    80001564:	70a6                	ld	ra,104(sp)
    80001566:	7406                	ld	s0,96(sp)
    80001568:	64e6                	ld	s1,88(sp)
    8000156a:	6946                	ld	s2,80(sp)
    8000156c:	69a6                	ld	s3,72(sp)
    8000156e:	6a06                	ld	s4,64(sp)
    80001570:	7ae2                	ld	s5,56(sp)
    80001572:	7b42                	ld	s6,48(sp)
    80001574:	7ba2                	ld	s7,40(sp)
    80001576:	7c02                	ld	s8,32(sp)
    80001578:	6ce2                	ld	s9,24(sp)
    8000157a:	6d42                	ld	s10,16(sp)
    8000157c:	6da2                	ld	s11,8(sp)
    8000157e:	6165                	addi	sp,sp,112
    80001580:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001582:	03449513          	slli	a0,s1,0x34
    80001586:	9151                	srli	a0,a0,0x34
    80001588:	0009061b          	sext.w	a2,s2
    8000158c:	85da                	mv	a1,s6
    8000158e:	954e                	add	a0,a0,s3
    80001590:	f80ff0ef          	jal	80000d10 <memmove>
    len -= n;
    80001594:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001598:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000159a:	018a04b3          	add	s1,s4,s8
  while (len > 0) {
    8000159e:	040a8363          	beqz	s5,800015e4 <copyout+0xb8>
    va0 = PGROUNDDOWN(dstva);
    800015a2:	01a4fa33          	and	s4,s1,s10
    if (va0 >= MAXVA)
    800015a6:	fb4ceee3          	bltu	s9,s4,80001562 <copyout+0x36>
    pa0 = walkaddr(pagetable, va0);
    800015aa:	85d2                	mv	a1,s4
    800015ac:	855e                	mv	a0,s7
    800015ae:	a2bff0ef          	jal	80000fd8 <walkaddr>
    800015b2:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015b4:	e909                	bnez	a0,800015c6 <copyout+0x9a>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015b6:	4681                	li	a3,0
    800015b8:	8652                	mv	a2,s4
    800015ba:	85ee                	mv	a1,s11
    800015bc:	855e                	mv	a0,s7
    800015be:	ef7ff0ef          	jal	800014b4 <vmfault>
    800015c2:	89aa                	mv	s3,a0
    800015c4:	dd59                	beqz	a0,80001562 <copyout+0x36>
    pte = walk(pagetable, va0, 0);
    800015c6:	4601                	li	a2,0
    800015c8:	85d2                	mv	a1,s4
    800015ca:	855e                	mv	a0,s7
    800015cc:	975ff0ef          	jal	80000f40 <walk>
    if ((*pte & PTE_W) == 0)
    800015d0:	611c                	ld	a5,0(a0)
    800015d2:	8b91                	andi	a5,a5,4
    800015d4:	d7d9                	beqz	a5,80001562 <copyout+0x36>
    n = PGSIZE - (dstva - va0);
    800015d6:	409a0933          	sub	s2,s4,s1
    800015da:	9962                	add	s2,s2,s8
    if (n > len)
    800015dc:	fb2af3e3          	bgeu	s5,s2,80001582 <copyout+0x56>
    800015e0:	8956                	mv	s2,s5
    800015e2:	b745                	j	80001582 <copyout+0x56>
  return 0;
    800015e4:	4501                	li	a0,0
    800015e6:	bfbd                	j	80001564 <copyout+0x38>
    800015e8:	4501                	li	a0,0
}
    800015ea:	8082                	ret

00000000800015ec <copyin>:
  while (len > 0) {
    800015ec:	cf49                	beqz	a4,80001686 <copyin+0x9a>
{
    800015ee:	711d                	addi	sp,sp,-96
    800015f0:	ec86                	sd	ra,88(sp)
    800015f2:	e8a2                	sd	s0,80(sp)
    800015f4:	e4a6                	sd	s1,72(sp)
    800015f6:	e0ca                	sd	s2,64(sp)
    800015f8:	fc4e                	sd	s3,56(sp)
    800015fa:	f852                	sd	s4,48(sp)
    800015fc:	f456                	sd	s5,40(sp)
    800015fe:	f05a                	sd	s6,32(sp)
    80001600:	ec5e                	sd	s7,24(sp)
    80001602:	e862                	sd	s8,16(sp)
    80001604:	e466                	sd	s9,8(sp)
    80001606:	e06a                	sd	s10,0(sp)
    80001608:	1080                	addi	s0,sp,96
    8000160a:	8baa                	mv	s7,a0
    8000160c:	8cae                	mv	s9,a1
    8000160e:	8ab2                	mv	s5,a2
    80001610:	84b6                	mv	s1,a3
    80001612:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    80001614:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001616:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80001618:	6b05                	lui	s6,0x1
    8000161a:	a03d                	j	80001648 <copyin+0x5c>
    8000161c:	409a0933          	sub	s2,s4,s1
    80001620:	995a                	add	s2,s2,s6
    if (n > len)
    80001622:	0129f363          	bgeu	s3,s2,80001628 <copyin+0x3c>
    80001626:	894e                	mv	s2,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001628:	03449593          	slli	a1,s1,0x34
    8000162c:	91d1                	srli	a1,a1,0x34
    8000162e:	0009061b          	sext.w	a2,s2
    80001632:	95aa                	add	a1,a1,a0
    80001634:	8556                	mv	a0,s5
    80001636:	edaff0ef          	jal	80000d10 <memmove>
    len -= n;
    8000163a:	412989b3          	sub	s3,s3,s2
    dst += n;
    8000163e:	9aca                	add	s5,s5,s2
    srcva = va0 + PGSIZE;
    80001640:	016a04b3          	add	s1,s4,s6
  while (len > 0) {
    80001644:	02098263          	beqz	s3,80001668 <copyin+0x7c>
    va0 = PGROUNDDOWN(srcva);
    80001648:	0184fa33          	and	s4,s1,s8
    pa0 = walkaddr(pagetable, va0);
    8000164c:	85d2                	mv	a1,s4
    8000164e:	855e                	mv	a0,s7
    80001650:	989ff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    80001654:	f561                	bnez	a0,8000161c <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001656:	86ea                	mv	a3,s10
    80001658:	8652                	mv	a2,s4
    8000165a:	85e6                	mv	a1,s9
    8000165c:	855e                	mv	a0,s7
    8000165e:	e57ff0ef          	jal	800014b4 <vmfault>
    80001662:	fd4d                	bnez	a0,8000161c <copyin+0x30>
        return -1;
    80001664:	557d                	li	a0,-1
    80001666:	a011                	j	8000166a <copyin+0x7e>
  return 0;
    80001668:	4501                	li	a0,0
}
    8000166a:	60e6                	ld	ra,88(sp)
    8000166c:	6446                	ld	s0,80(sp)
    8000166e:	64a6                	ld	s1,72(sp)
    80001670:	6906                	ld	s2,64(sp)
    80001672:	79e2                	ld	s3,56(sp)
    80001674:	7a42                	ld	s4,48(sp)
    80001676:	7aa2                	ld	s5,40(sp)
    80001678:	7b02                	ld	s6,32(sp)
    8000167a:	6be2                	ld	s7,24(sp)
    8000167c:	6c42                	ld	s8,16(sp)
    8000167e:	6ca2                	ld	s9,8(sp)
    80001680:	6d02                	ld	s10,0(sp)
    80001682:	6125                	addi	sp,sp,96
    80001684:	8082                	ret
  return 0;
    80001686:	4501                	li	a0,0
}
    80001688:	8082                	ret

000000008000168a <copyinstr>:
  while (got_null == 0 && max > 0) {
    8000168a:	c771                	beqz	a4,80001756 <copyinstr+0xcc>
{
    8000168c:	711d                	addi	sp,sp,-96
    8000168e:	ec86                	sd	ra,88(sp)
    80001690:	e8a2                	sd	s0,80(sp)
    80001692:	e4a6                	sd	s1,72(sp)
    80001694:	e0ca                	sd	s2,64(sp)
    80001696:	fc4e                	sd	s3,56(sp)
    80001698:	f852                	sd	s4,48(sp)
    8000169a:	f456                	sd	s5,40(sp)
    8000169c:	f05a                	sd	s6,32(sp)
    8000169e:	ec5e                	sd	s7,24(sp)
    800016a0:	e862                	sd	s8,16(sp)
    800016a2:	e466                	sd	s9,8(sp)
    800016a4:	1080                	addi	s0,sp,96
    800016a6:	8b2a                	mv	s6,a0
    800016a8:	8c2e                	mv	s8,a1
    800016aa:	8932                	mv	s2,a2
    800016ac:	84b6                	mv	s1,a3
    800016ae:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016b0:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016b2:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016b4:	6a85                	lui	s5,0x1
    800016b6:	a881                	j	80001706 <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016b8:	86e6                	mv	a3,s9
    800016ba:	864e                	mv	a2,s3
    800016bc:	85e2                	mv	a1,s8
    800016be:	855a                	mv	a0,s6
    800016c0:	df5ff0ef          	jal	800014b4 <vmfault>
    800016c4:	e921                	bnez	a0,80001714 <copyinstr+0x8a>
        return -1;
    800016c6:	557d                	li	a0,-1
    800016c8:	a801                	j	800016d8 <copyinstr+0x4e>
        *dst = '\0';
    800016ca:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffde450>
        got_null = 1;
    800016ce:	4785                	li	a5,1
  if (got_null) {
    800016d0:	0017c793          	xori	a5,a5,1
    800016d4:	40f0053b          	negw	a0,a5
}
    800016d8:	60e6                	ld	ra,88(sp)
    800016da:	6446                	ld	s0,80(sp)
    800016dc:	64a6                	ld	s1,72(sp)
    800016de:	6906                	ld	s2,64(sp)
    800016e0:	79e2                	ld	s3,56(sp)
    800016e2:	7a42                	ld	s4,48(sp)
    800016e4:	7aa2                	ld	s5,40(sp)
    800016e6:	7b02                	ld	s6,32(sp)
    800016e8:	6be2                	ld	s7,24(sp)
    800016ea:	6c42                	ld	s8,16(sp)
    800016ec:	6ca2                	ld	s9,8(sp)
    800016ee:	6125                	addi	sp,sp,96
    800016f0:	8082                	ret
    800016f2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800016f6:	974a                	add	a4,a4,s2
      --max;
    800016f8:	40a70a33          	sub	s4,a4,a0
    srcva = va0 + PGSIZE;
    800016fc:	015984b3          	add	s1,s3,s5
  while (got_null == 0 && max > 0) {
    80001700:	04e50563          	beq	a0,a4,8000174a <copyinstr+0xc0>
{
    80001704:	893e                	mv	s2,a5
    va0 = PGROUNDDOWN(srcva);
    80001706:	0174f9b3          	and	s3,s1,s7
    pa0 = walkaddr(pagetable, va0);
    8000170a:	85ce                	mv	a1,s3
    8000170c:	855a                	mv	a0,s6
    8000170e:	8cbff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    80001712:	d15d                	beqz	a0,800016b8 <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    80001714:	40998633          	sub	a2,s3,s1
    80001718:	9656                	add	a2,a2,s5
    if (n > max)
    8000171a:	00ca7363          	bgeu	s4,a2,80001720 <copyinstr+0x96>
    8000171e:	8652                	mv	a2,s4
    while (n > 0) {
    80001720:	c61d                	beqz	a2,8000174e <copyinstr+0xc4>
    char *p = (char *)(pa0 + (srcva - va0));
    80001722:	03449593          	slli	a1,s1,0x34
    80001726:	91d1                	srli	a1,a1,0x34
    80001728:	95aa                	add	a1,a1,a0
    8000172a:	87ca                	mv	a5,s2
      if (*p == '\0') {
    8000172c:	412585b3          	sub	a1,a1,s2
    while (n > 0) {
    80001730:	964a                	add	a2,a2,s2
    80001732:	853e                	mv	a0,a5
      if (*p == '\0') {
    80001734:	00f58733          	add	a4,a1,a5
    80001738:	00074683          	lbu	a3,0(a4)
    8000173c:	d6d9                	beqz	a3,800016ca <copyinstr+0x40>
        *dst = *p;
    8000173e:	00d78023          	sb	a3,0(a5)
      dst++;
    80001742:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001744:	fec797e3          	bne	a5,a2,80001732 <copyinstr+0xa8>
    80001748:	b76d                	j	800016f2 <copyinstr+0x68>
    srcva = va0 + PGSIZE;
    8000174a:	4781                	li	a5,0
    8000174c:	b751                	j	800016d0 <copyinstr+0x46>
    8000174e:	6485                	lui	s1,0x1
    80001750:	94ce                	add	s1,s1,s3
    80001752:	87ca                	mv	a5,s2
    80001754:	bf45                	j	80001704 <copyinstr+0x7a>
    80001756:	4781                	li	a5,0
  if (got_null) {
    80001758:	0017c793          	xori	a5,a5,1
    8000175c:	40f0053b          	negw	a0,a5
}
    80001760:	8082                	ret

0000000080001762 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001762:	715d                	addi	sp,sp,-80
    80001764:	e486                	sd	ra,72(sp)
    80001766:	e0a2                	sd	s0,64(sp)
    80001768:	fc26                	sd	s1,56(sp)
    8000176a:	f84a                	sd	s2,48(sp)
    8000176c:	f44e                	sd	s3,40(sp)
    8000176e:	f052                	sd	s4,32(sp)
    80001770:	ec56                	sd	s5,24(sp)
    80001772:	e85a                	sd	s6,16(sp)
    80001774:	e45e                	sd	s7,8(sp)
    80001776:	0880                	addi	s0,sp,80
    80001778:	8aaa                	mv	s5,a0
    8000177a:	4481                	li	s1,0

  for (p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    8000177c:	000a57b7          	lui	a5,0xa5
    80001780:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80001784:	07b2                	slli	a5,a5,0xc
    80001786:	fa578793          	addi	a5,a5,-91
    8000178a:	4fa50937          	lui	s2,0x4fa50
    8000178e:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80001792:	1902                	slli	s2,s2,0x20
    80001794:	993e                	add	s2,s2,a5
    80001796:	040009b7          	lui	s3,0x4000
    8000179a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000179c:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000179e:	4b99                	li	s7,6
    800017a0:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017a2:	6a19                	lui	s4,0x6
    800017a4:	a00a0a13          	addi	s4,s4,-1536 # 5a00 <_entry-0x7fffa600>
    char *pa = kalloc();
    800017a8:	b76ff0ef          	jal	80000b1e <kalloc>
    800017ac:	862a                	mv	a2,a0
    if (pa == 0)
    800017ae:	cd15                	beqz	a0,800017ea <proc_mapstacks+0x88>
    uint64 va = KSTACK((int)(p - proc));
    800017b0:	4034d593          	srai	a1,s1,0x3
    800017b4:	032585b3          	mul	a1,a1,s2
    800017b8:	05b6                	slli	a1,a1,0xd
    800017ba:	6789                	lui	a5,0x2
    800017bc:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017be:	875e                	mv	a4,s7
    800017c0:	86da                	mv	a3,s6
    800017c2:	40b985b3          	sub	a1,s3,a1
    800017c6:	8556                	mv	a0,s5
    800017c8:	8fbff0ef          	jal	800010c2 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017cc:	16848493          	addi	s1,s1,360 # 1168 <_entry-0x7fffee98>
    800017d0:	fd449ce3          	bne	s1,s4,800017a8 <proc_mapstacks+0x46>
  }
}
    800017d4:	60a6                	ld	ra,72(sp)
    800017d6:	6406                	ld	s0,64(sp)
    800017d8:	74e2                	ld	s1,56(sp)
    800017da:	7942                	ld	s2,48(sp)
    800017dc:	79a2                	ld	s3,40(sp)
    800017de:	7a02                	ld	s4,32(sp)
    800017e0:	6ae2                	ld	s5,24(sp)
    800017e2:	6b42                	ld	s6,16(sp)
    800017e4:	6ba2                	ld	s7,8(sp)
    800017e6:	6161                	addi	sp,sp,80
    800017e8:	8082                	ret
      panic("kalloc");
    800017ea:	00006517          	auipc	a0,0x6
    800017ee:	96e50513          	addi	a0,a0,-1682 # 80007158 <etext+0x158>
    800017f2:	856ff0ef          	jal	80000848 <panic>

00000000800017f6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017f6:	7139                	addi	sp,sp,-64
    800017f8:	fc06                	sd	ra,56(sp)
    800017fa:	f822                	sd	s0,48(sp)
    800017fc:	f426                	sd	s1,40(sp)
    800017fe:	f04a                	sd	s2,32(sp)
    80001800:	ec4e                	sd	s3,24(sp)
    80001802:	e852                	sd	s4,16(sp)
    80001804:	e456                	sd	s5,8(sp)
    80001806:	e05a                	sd	s6,0(sp)
    80001808:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000180a:	00006597          	auipc	a1,0x6
    8000180e:	95658593          	addi	a1,a1,-1706 # 80007160 <etext+0x160>
    80001812:	0000e517          	auipc	a0,0xe
    80001816:	18e50513          	addi	a0,a0,398 # 8000f9a0 <pid_lock>
    8000181a:	b5eff0ef          	jal	80000b78 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000181e:	00006597          	auipc	a1,0x6
    80001822:	94a58593          	addi	a1,a1,-1718 # 80007168 <etext+0x168>
    80001826:	0000e517          	auipc	a0,0xe
    8000182a:	19250513          	addi	a0,a0,402 # 8000f9b8 <wait_lock>
    8000182e:	b4aff0ef          	jal	80000b78 <initlock>
    80001832:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001834:	0000e497          	auipc	s1,0xe
    80001838:	59c48493          	addi	s1,s1,1436 # 8000fdd0 <proc>
    initlock(&p->lock, "proc");
    8000183c:	00006a97          	auipc	s5,0x6
    80001840:	93ca8a93          	addi	s5,s5,-1732 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001844:	000a57b7          	lui	a5,0xa5
    80001848:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    8000184c:	07b2                	slli	a5,a5,0xc
    8000184e:	fa578793          	addi	a5,a5,-91
    80001852:	4fa509b7          	lui	s3,0x4fa50
    80001856:	a4f98993          	addi	s3,s3,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    8000185a:	1982                	slli	s3,s3,0x20
    8000185c:	99be                	add	s3,s3,a5
    8000185e:	04000a37          	lui	s4,0x4000
    80001862:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    80001864:	0a32                	slli	s4,s4,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001866:	00014b17          	auipc	s6,0x14
    8000186a:	f6ab0b13          	addi	s6,s6,-150 # 800157d0 <tickslock>
    initlock(&p->lock, "proc");
    8000186e:	85d6                	mv	a1,s5
    80001870:	8526                	mv	a0,s1
    80001872:	b06ff0ef          	jal	80000b78 <initlock>
    p->state = UNUSED;
    80001876:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000187a:	40395793          	srai	a5,s2,0x3
    8000187e:	033787b3          	mul	a5,a5,s3
    80001882:	07b6                	slli	a5,a5,0xd
    80001884:	6709                	lui	a4,0x2
    80001886:	9fb9                	addw	a5,a5,a4
    80001888:	40fa07b3          	sub	a5,s4,a5
    8000188c:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000188e:	16848493          	addi	s1,s1,360
    80001892:	16890913          	addi	s2,s2,360
    80001896:	fd649ce3          	bne	s1,s6,8000186e <procinit+0x78>
  }
}
    8000189a:	70e2                	ld	ra,56(sp)
    8000189c:	7442                	ld	s0,48(sp)
    8000189e:	74a2                	ld	s1,40(sp)
    800018a0:	7902                	ld	s2,32(sp)
    800018a2:	69e2                	ld	s3,24(sp)
    800018a4:	6a42                	ld	s4,16(sp)
    800018a6:	6aa2                	ld	s5,8(sp)
    800018a8:	6b02                	ld	s6,0(sp)
    800018aa:	6121                	addi	sp,sp,64
    800018ac:	8082                	ret

00000000800018ae <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018ae:	1141                	addi	sp,sp,-16
    800018b0:	e406                	sd	ra,8(sp)
    800018b2:	e022                	sd	s0,0(sp)
    800018b4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018b6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b8:	2501                	sext.w	a0,a0
    800018ba:	60a2                	ld	ra,8(sp)
    800018bc:	6402                	ld	s0,0(sp)
    800018be:	0141                	addi	sp,sp,16
    800018c0:	8082                	ret

00000000800018c2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800018c2:	1141                	addi	sp,sp,-16
    800018c4:	e406                	sd	ra,8(sp)
    800018c6:	e022                	sd	s0,0(sp)
    800018c8:	0800                	addi	s0,sp,16
    800018ca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018cc:	2781                	sext.w	a5,a5
    800018ce:	079e                	slli	a5,a5,0x7
  return c;
}
    800018d0:	0000e517          	auipc	a0,0xe
    800018d4:	10050513          	addi	a0,a0,256 # 8000f9d0 <cpus>
    800018d8:	953e                	add	a0,a0,a5
    800018da:	60a2                	ld	ra,8(sp)
    800018dc:	6402                	ld	s0,0(sp)
    800018de:	0141                	addi	sp,sp,16
    800018e0:	8082                	ret

00000000800018e2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800018e2:	1101                	addi	sp,sp,-32
    800018e4:	ec06                	sd	ra,24(sp)
    800018e6:	e822                	sd	s0,16(sp)
    800018e8:	e426                	sd	s1,8(sp)
    800018ea:	1000                	addi	s0,sp,32
  push_off();
    800018ec:	ad2ff0ef          	jal	80000bbe <push_off>
    800018f0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018f2:	2781                	sext.w	a5,a5
    800018f4:	079e                	slli	a5,a5,0x7
    800018f6:	0000e717          	auipc	a4,0xe
    800018fa:	0aa70713          	addi	a4,a4,170 # 8000f9a0 <pid_lock>
    800018fe:	97ba                	add	a5,a5,a4
    80001900:	7b9c                	ld	a5,48(a5)
    80001902:	84be                	mv	s1,a5
  pop_off();
    80001904:	b30ff0ef          	jal	80000c34 <pop_off>
  return p;
}
    80001908:	8526                	mv	a0,s1
    8000190a:	60e2                	ld	ra,24(sp)
    8000190c:	6442                	ld	s0,16(sp)
    8000190e:	64a2                	ld	s1,8(sp)
    80001910:	6105                	addi	sp,sp,32
    80001912:	8082                	ret

0000000080001914 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001914:	7179                	addi	sp,sp,-48
    80001916:	f406                	sd	ra,40(sp)
    80001918:	f022                	sd	s0,32(sp)
    8000191a:	ec26                	sd	s1,24(sp)
    8000191c:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000191e:	fc5ff0ef          	jal	800018e2 <myproc>
    80001922:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001924:	b58ff0ef          	jal	80000c7c <release>

  if (__atomic_load_n(&first, __ATOMIC_ACQUIRE)) {
    80001928:	00006797          	auipc	a5,0x6
    8000192c:	f2878793          	addi	a5,a5,-216 # 80007850 <first.1>
    80001930:	439c                	lw	a5,0(a5)
    80001932:	0230000f          	fence	r,rw
    80001936:	2781                	sext.w	a5,a5
    80001938:	c3a1                	beqz	a5,80001978 <forkret+0x64>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000193a:	4505                	li	a0,1
    8000193c:	3f9010ef          	jal	80003534 <fsinit>

    // ensure other cores see first=0.
    __atomic_store_n(&first, 0, __ATOMIC_RELEASE);
    80001940:	00006797          	auipc	a5,0x6
    80001944:	f1078793          	addi	a5,a5,-240 # 80007850 <first.1>
    80001948:	0310000f          	fence	rw,w
    8000194c:	0007a023          	sw	zero,0(a5)

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001950:	00006797          	auipc	a5,0x6
    80001954:	83078793          	addi	a5,a5,-2000 # 80007180 <etext+0x180>
    80001958:	fcf43823          	sd	a5,-48(s0)
    8000195c:	fc043c23          	sd	zero,-40(s0)
    80001960:	fd040593          	addi	a1,s0,-48
    80001964:	853e                	mv	a0,a5
    80001966:	647020ef          	jal	800047ac <kexec>
    8000196a:	6cbc                	ld	a5,88(s1)
    8000196c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000196e:	6cbc                	ld	a5,88(s1)
    80001970:	7bb8                	ld	a4,112(a5)
    80001972:	57fd                	li	a5,-1
    80001974:	02f70d63          	beq	a4,a5,800019ae <forkret+0x9a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001978:	2df000ef          	jal	80002456 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000197c:	68a8                	ld	a0,80(s1)
    8000197e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001980:	04000737          	lui	a4,0x4000
    80001984:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001986:	0732                	slli	a4,a4,0xc
    80001988:	00004797          	auipc	a5,0x4
    8000198c:	71478793          	addi	a5,a5,1812 # 8000609c <userret>
    80001990:	00004697          	auipc	a3,0x4
    80001994:	67068693          	addi	a3,a3,1648 # 80006000 <_trampoline>
    80001998:	8f95                	sub	a5,a5,a3
    8000199a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000199c:	577d                	li	a4,-1
    8000199e:	177e                	slli	a4,a4,0x3f
    800019a0:	8d59                	or	a0,a0,a4
    800019a2:	9782                	jalr	a5
}
    800019a4:	70a2                	ld	ra,40(sp)
    800019a6:	7402                	ld	s0,32(sp)
    800019a8:	64e2                	ld	s1,24(sp)
    800019aa:	6145                	addi	sp,sp,48
    800019ac:	8082                	ret
      panic("exec");
    800019ae:	00005517          	auipc	a0,0x5
    800019b2:	7da50513          	addi	a0,a0,2010 # 80007188 <etext+0x188>
    800019b6:	e93fe0ef          	jal	80000848 <panic>

00000000800019ba <allocpid>:
{
    800019ba:	1101                	addi	sp,sp,-32
    800019bc:	ec06                	sd	ra,24(sp)
    800019be:	e822                	sd	s0,16(sp)
    800019c0:	e426                	sd	s1,8(sp)
    800019c2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019c4:	0000e517          	auipc	a0,0xe
    800019c8:	fdc50513          	addi	a0,a0,-36 # 8000f9a0 <pid_lock>
    800019cc:	a2cff0ef          	jal	80000bf8 <acquire>
  pid = nextpid;
    800019d0:	00006797          	auipc	a5,0x6
    800019d4:	e8478793          	addi	a5,a5,-380 # 80007854 <nextpid>
    800019d8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019da:	0014871b          	addiw	a4,s1,1
    800019de:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019e0:	0000e517          	auipc	a0,0xe
    800019e4:	fc050513          	addi	a0,a0,-64 # 8000f9a0 <pid_lock>
    800019e8:	a94ff0ef          	jal	80000c7c <release>
}
    800019ec:	8526                	mv	a0,s1
    800019ee:	60e2                	ld	ra,24(sp)
    800019f0:	6442                	ld	s0,16(sp)
    800019f2:	64a2                	ld	s1,8(sp)
    800019f4:	6105                	addi	sp,sp,32
    800019f6:	8082                	ret

00000000800019f8 <proc_pagetable>:
{
    800019f8:	1101                	addi	sp,sp,-32
    800019fa:	ec06                	sd	ra,24(sp)
    800019fc:	e822                	sd	s0,16(sp)
    800019fe:	e426                	sd	s1,8(sp)
    80001a00:	e04a                	sd	s2,0(sp)
    80001a02:	1000                	addi	s0,sp,32
    80001a04:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a06:	faaff0ef          	jal	800011b0 <uvmcreate>
    80001a0a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a0c:	cd05                	beqz	a0,80001a44 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a0e:	4729                	li	a4,10
    80001a10:	00004697          	auipc	a3,0x4
    80001a14:	5f068693          	addi	a3,a3,1520 # 80006000 <_trampoline>
    80001a18:	6605                	lui	a2,0x1
    80001a1a:	040005b7          	lui	a1,0x4000
    80001a1e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a20:	05b2                	slli	a1,a1,0xc
    80001a22:	deeff0ef          	jal	80001010 <mappages>
    80001a26:	02054663          	bltz	a0,80001a52 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a2a:	4719                	li	a4,6
    80001a2c:	05893683          	ld	a3,88(s2)
    80001a30:	6605                	lui	a2,0x1
    80001a32:	020005b7          	lui	a1,0x2000
    80001a36:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a38:	05b6                	slli	a1,a1,0xd
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	dd4ff0ef          	jal	80001010 <mappages>
    80001a40:	00054f63          	bltz	a0,80001a5e <proc_pagetable+0x66>
}
    80001a44:	8526                	mv	a0,s1
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6902                	ld	s2,0(sp)
    80001a4e:	6105                	addi	sp,sp,32
    80001a50:	8082                	ret
    uvmfree(pagetable, 0);
    80001a52:	4581                	li	a1,0
    80001a54:	8526                	mv	a0,s1
    80001a56:	94dff0ef          	jal	800013a2 <uvmfree>
    return 0;
    80001a5a:	4481                	li	s1,0
    80001a5c:	b7e5                	j	80001a44 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a5e:	4681                	li	a3,0
    80001a60:	4605                	li	a2,1
    80001a62:	040005b7          	lui	a1,0x4000
    80001a66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a68:	05b2                	slli	a1,a1,0xc
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	f6aff0ef          	jal	800011d6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a70:	4581                	li	a1,0
    80001a72:	8526                	mv	a0,s1
    80001a74:	92fff0ef          	jal	800013a2 <uvmfree>
    return 0;
    80001a78:	b7cd                	j	80001a5a <proc_pagetable+0x62>

0000000080001a7a <proc_freepagetable>:
{
    80001a7a:	1101                	addi	sp,sp,-32
    80001a7c:	ec06                	sd	ra,24(sp)
    80001a7e:	e822                	sd	s0,16(sp)
    80001a80:	e426                	sd	s1,8(sp)
    80001a82:	e04a                	sd	s2,0(sp)
    80001a84:	1000                	addi	s0,sp,32
    80001a86:	84aa                	mv	s1,a0
    80001a88:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a8a:	4681                	li	a3,0
    80001a8c:	4605                	li	a2,1
    80001a8e:	040005b7          	lui	a1,0x4000
    80001a92:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a94:	05b2                	slli	a1,a1,0xc
    80001a96:	f40ff0ef          	jal	800011d6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a9a:	4681                	li	a3,0
    80001a9c:	4605                	li	a2,1
    80001a9e:	020005b7          	lui	a1,0x2000
    80001aa2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aa4:	05b6                	slli	a1,a1,0xd
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	f2eff0ef          	jal	800011d6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001aac:	85ca                	mv	a1,s2
    80001aae:	8526                	mv	a0,s1
    80001ab0:	8f3ff0ef          	jal	800013a2 <uvmfree>
}
    80001ab4:	60e2                	ld	ra,24(sp)
    80001ab6:	6442                	ld	s0,16(sp)
    80001ab8:	64a2                	ld	s1,8(sp)
    80001aba:	6902                	ld	s2,0(sp)
    80001abc:	6105                	addi	sp,sp,32
    80001abe:	8082                	ret

0000000080001ac0 <freeproc>:
{
    80001ac0:	1101                	addi	sp,sp,-32
    80001ac2:	ec06                	sd	ra,24(sp)
    80001ac4:	e822                	sd	s0,16(sp)
    80001ac6:	e426                	sd	s1,8(sp)
    80001ac8:	1000                	addi	s0,sp,32
    80001aca:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001acc:	6d28                	ld	a0,88(a0)
    80001ace:	c119                	beqz	a0,80001ad4 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001ad0:	f67fe0ef          	jal	80000a36 <kfree>
  p->trapframe = 0;
    80001ad4:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001ad8:	68a8                	ld	a0,80(s1)
    80001ada:	c501                	beqz	a0,80001ae2 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001adc:	64ac                	ld	a1,72(s1)
    80001ade:	f9dff0ef          	jal	80001a7a <proc_freepagetable>
  p->pagetable = 0;
    80001ae2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ae6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001aea:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001aee:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001af2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001af6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001afa:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001afe:	0004ac23          	sw	zero,24(s1)
}
    80001b02:	60e2                	ld	ra,24(sp)
    80001b04:	6442                	ld	s0,16(sp)
    80001b06:	64a2                	ld	s1,8(sp)
    80001b08:	6105                	addi	sp,sp,32
    80001b0a:	8082                	ret

0000000080001b0c <allocproc>:
{
    80001b0c:	1101                	addi	sp,sp,-32
    80001b0e:	ec06                	sd	ra,24(sp)
    80001b10:	e822                	sd	s0,16(sp)
    80001b12:	e426                	sd	s1,8(sp)
    80001b14:	e04a                	sd	s2,0(sp)
    80001b16:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b18:	0000e497          	auipc	s1,0xe
    80001b1c:	2b848493          	addi	s1,s1,696 # 8000fdd0 <proc>
    80001b20:	00014917          	auipc	s2,0x14
    80001b24:	cb090913          	addi	s2,s2,-848 # 800157d0 <tickslock>
    acquire(&p->lock);
    80001b28:	8526                	mv	a0,s1
    80001b2a:	8ceff0ef          	jal	80000bf8 <acquire>
    if (p->state == UNUSED) {
    80001b2e:	4c9c                	lw	a5,24(s1)
    80001b30:	cb91                	beqz	a5,80001b44 <allocproc+0x38>
      release(&p->lock);
    80001b32:	8526                	mv	a0,s1
    80001b34:	948ff0ef          	jal	80000c7c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b38:	16848493          	addi	s1,s1,360
    80001b3c:	ff2496e3          	bne	s1,s2,80001b28 <allocproc+0x1c>
  return 0;
    80001b40:	4481                	li	s1,0
    80001b42:	a089                	j	80001b84 <allocproc+0x78>
  p->pid = allocpid();
    80001b44:	e77ff0ef          	jal	800019ba <allocpid>
    80001b48:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b4a:	4785                	li	a5,1
    80001b4c:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b4e:	fd1fe0ef          	jal	80000b1e <kalloc>
    80001b52:	892a                	mv	s2,a0
    80001b54:	eca8                	sd	a0,88(s1)
    80001b56:	cd15                	beqz	a0,80001b92 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b58:	8526                	mv	a0,s1
    80001b5a:	e9fff0ef          	jal	800019f8 <proc_pagetable>
    80001b5e:	892a                	mv	s2,a0
    80001b60:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b62:	c121                	beqz	a0,80001ba2 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b64:	07000613          	li	a2,112
    80001b68:	4581                	li	a1,0
    80001b6a:	06048513          	addi	a0,s1,96
    80001b6e:	946ff0ef          	jal	80000cb4 <memset>
  p->context.ra = (uint64)forkret;
    80001b72:	00000797          	auipc	a5,0x0
    80001b76:	da278793          	addi	a5,a5,-606 # 80001914 <forkret>
    80001b7a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b7c:	60bc                	ld	a5,64(s1)
    80001b7e:	6705                	lui	a4,0x1
    80001b80:	97ba                	add	a5,a5,a4
    80001b82:	f4bc                	sd	a5,104(s1)
}
    80001b84:	8526                	mv	a0,s1
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6902                	ld	s2,0(sp)
    80001b8e:	6105                	addi	sp,sp,32
    80001b90:	8082                	ret
    freeproc(p);
    80001b92:	8526                	mv	a0,s1
    80001b94:	f2dff0ef          	jal	80001ac0 <freeproc>
    release(&p->lock);
    80001b98:	8526                	mv	a0,s1
    80001b9a:	8e2ff0ef          	jal	80000c7c <release>
    return 0;
    80001b9e:	84ca                	mv	s1,s2
    80001ba0:	b7d5                	j	80001b84 <allocproc+0x78>
    freeproc(p);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	f1dff0ef          	jal	80001ac0 <freeproc>
    release(&p->lock);
    80001ba8:	8526                	mv	a0,s1
    80001baa:	8d2ff0ef          	jal	80000c7c <release>
    return 0;
    80001bae:	84ca                	mv	s1,s2
    80001bb0:	bfd1                	j	80001b84 <allocproc+0x78>

0000000080001bb2 <userinit>:
{
    80001bb2:	1101                	addi	sp,sp,-32
    80001bb4:	ec06                	sd	ra,24(sp)
    80001bb6:	e822                	sd	s0,16(sp)
    80001bb8:	e426                	sd	s1,8(sp)
    80001bba:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bbc:	f51ff0ef          	jal	80001b0c <allocproc>
    80001bc0:	84aa                	mv	s1,a0
  initproc = p;
    80001bc2:	00006797          	auipc	a5,0x6
    80001bc6:	caa7bb23          	sd	a0,-842(a5) # 80007878 <initproc>
  p->cwd = namei("/");
    80001bca:	00005517          	auipc	a0,0x5
    80001bce:	5c650513          	addi	a0,a0,1478 # 80007190 <etext+0x190>
    80001bd2:	6bb010ef          	jal	80003a8c <namei>
    80001bd6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bda:	478d                	li	a5,3
    80001bdc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bde:	8526                	mv	a0,s1
    80001be0:	89cff0ef          	jal	80000c7c <release>
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret

0000000080001bee <growproc>:
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	e04a                	sd	s2,0(sp)
    80001bf8:	1000                	addi	s0,sp,32
    80001bfa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bfc:	ce7ff0ef          	jal	800018e2 <myproc>
    80001c00:	892a                	mv	s2,a0
  sz = p->sz;
    80001c02:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c04:	02905b63          	blez	s1,80001c3a <growproc+0x4c>
    if (sz + n > TRAPFRAME) {
    80001c08:	00b48633          	add	a2,s1,a1
    80001c0c:	020007b7          	lui	a5,0x2000
    80001c10:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c12:	07b6                	slli	a5,a5,0xd
    80001c14:	02c7e163          	bltu	a5,a2,80001c36 <growproc+0x48>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c18:	4691                	li	a3,4
    80001c1a:	6928                	ld	a0,80(a0)
    80001c1c:	e8aff0ef          	jal	800012a6 <uvmalloc>
    80001c20:	85aa                	mv	a1,a0
    80001c22:	c911                	beqz	a0,80001c36 <growproc+0x48>
  p->sz = sz;
    80001c24:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c28:	4501                	li	a0,0
}
    80001c2a:	60e2                	ld	ra,24(sp)
    80001c2c:	6442                	ld	s0,16(sp)
    80001c2e:	64a2                	ld	s1,8(sp)
    80001c30:	6902                	ld	s2,0(sp)
    80001c32:	6105                	addi	sp,sp,32
    80001c34:	8082                	ret
      return -1;
    80001c36:	557d                	li	a0,-1
    80001c38:	bfcd                	j	80001c2a <growproc+0x3c>
  } else if (n < 0) {
    80001c3a:	fe04d5e3          	bgez	s1,80001c24 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c3e:	00b48633          	add	a2,s1,a1
    80001c42:	6928                	ld	a0,80(a0)
    80001c44:	e1cff0ef          	jal	80001260 <uvmdealloc>
    80001c48:	85aa                	mv	a1,a0
    80001c4a:	bfe9                	j	80001c24 <growproc+0x36>

0000000080001c4c <kfork>:
{
    80001c4c:	7139                	addi	sp,sp,-64
    80001c4e:	fc06                	sd	ra,56(sp)
    80001c50:	f822                	sd	s0,48(sp)
    80001c52:	f426                	sd	s1,40(sp)
    80001c54:	e456                	sd	s5,8(sp)
    80001c56:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c58:	c8bff0ef          	jal	800018e2 <myproc>
    80001c5c:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c5e:	eafff0ef          	jal	80001b0c <allocproc>
    80001c62:	c92d                	beqz	a0,80001cd4 <kfork+0x88>
    80001c64:	e852                	sd	s4,16(sp)
    80001c66:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c68:	048ab603          	ld	a2,72(s5)
    80001c6c:	692c                	ld	a1,80(a0)
    80001c6e:	050ab503          	ld	a0,80(s5)
    80001c72:	f62ff0ef          	jal	800013d4 <uvmcopy>
    80001c76:	04054863          	bltz	a0,80001cc6 <kfork+0x7a>
    80001c7a:	f04a                	sd	s2,32(sp)
    80001c7c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c7e:	048ab783          	ld	a5,72(s5)
    80001c82:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c86:	058ab683          	ld	a3,88(s5)
    80001c8a:	87b6                	mv	a5,a3
    80001c8c:	058a3703          	ld	a4,88(s4)
    80001c90:	12068693          	addi	a3,a3,288
    80001c94:	6388                	ld	a0,0(a5)
    80001c96:	678c                	ld	a1,8(a5)
    80001c98:	6b90                	ld	a2,16(a5)
    80001c9a:	e308                	sd	a0,0(a4)
    80001c9c:	e70c                	sd	a1,8(a4)
    80001c9e:	eb10                	sd	a2,16(a4)
    80001ca0:	6f90                	ld	a2,24(a5)
    80001ca2:	ef10                	sd	a2,24(a4)
    80001ca4:	02078793          	addi	a5,a5,32
    80001ca8:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001cac:	fed794e3          	bne	a5,a3,80001c94 <kfork+0x48>
  np->trapframe->a0 = 0;
    80001cb0:	058a3783          	ld	a5,88(s4)
    80001cb4:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001cb8:	0d0a8493          	addi	s1,s5,208
    80001cbc:	0d0a0913          	addi	s2,s4,208
    80001cc0:	150a8993          	addi	s3,s5,336
    80001cc4:	a831                	j	80001ce0 <kfork+0x94>
    freeproc(np);
    80001cc6:	8552                	mv	a0,s4
    80001cc8:	df9ff0ef          	jal	80001ac0 <freeproc>
    release(&np->lock);
    80001ccc:	8552                	mv	a0,s4
    80001cce:	faffe0ef          	jal	80000c7c <release>
    return -1;
    80001cd2:	6a42                	ld	s4,16(sp)
    return -1;
    80001cd4:	54fd                	li	s1,-1
    80001cd6:	a885                	j	80001d46 <kfork+0xfa>
  for (i = 0; i < NOFILE; i++)
    80001cd8:	04a1                	addi	s1,s1,8
    80001cda:	0921                	addi	s2,s2,8
    80001cdc:	01348963          	beq	s1,s3,80001cee <kfork+0xa2>
    if (p->ofile[i])
    80001ce0:	6088                	ld	a0,0(s1)
    80001ce2:	d97d                	beqz	a0,80001cd8 <kfork+0x8c>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ce4:	3f6020ef          	jal	800040da <filedup>
    80001ce8:	00a93023          	sd	a0,0(s2)
    80001cec:	b7f5                	j	80001cd8 <kfork+0x8c>
  np->cwd = idup(p->cwd);
    80001cee:	150ab503          	ld	a0,336(s5)
    80001cf2:	4d0010ef          	jal	800031c2 <idup>
    80001cf6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cfa:	4641                	li	a2,16
    80001cfc:	158a8593          	addi	a1,s5,344
    80001d00:	158a0513          	addi	a0,s4,344
    80001d04:	8faff0ef          	jal	80000dfe <safestrcpy>
  pid = np->pid;
    80001d08:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001d0c:	8552                	mv	a0,s4
    80001d0e:	f6ffe0ef          	jal	80000c7c <release>
  acquire(&wait_lock);
    80001d12:	0000e517          	auipc	a0,0xe
    80001d16:	ca650513          	addi	a0,a0,-858 # 8000f9b8 <wait_lock>
    80001d1a:	edffe0ef          	jal	80000bf8 <acquire>
  np->parent = p;
    80001d1e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d22:	0000e517          	auipc	a0,0xe
    80001d26:	c9650513          	addi	a0,a0,-874 # 8000f9b8 <wait_lock>
    80001d2a:	f53fe0ef          	jal	80000c7c <release>
  acquire(&np->lock);
    80001d2e:	8552                	mv	a0,s4
    80001d30:	ec9fe0ef          	jal	80000bf8 <acquire>
  np->state = RUNNABLE;
    80001d34:	478d                	li	a5,3
    80001d36:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d3a:	8552                	mv	a0,s4
    80001d3c:	f41fe0ef          	jal	80000c7c <release>
    80001d40:	7902                	ld	s2,32(sp)
    80001d42:	69e2                	ld	s3,24(sp)
    80001d44:	6a42                	ld	s4,16(sp)
}
    80001d46:	8526                	mv	a0,s1
    80001d48:	70e2                	ld	ra,56(sp)
    80001d4a:	7442                	ld	s0,48(sp)
    80001d4c:	74a2                	ld	s1,40(sp)
    80001d4e:	6aa2                	ld	s5,8(sp)
    80001d50:	6121                	addi	sp,sp,64
    80001d52:	8082                	ret

0000000080001d54 <scheduler>:
{
    80001d54:	711d                	addi	sp,sp,-96
    80001d56:	ec86                	sd	ra,88(sp)
    80001d58:	e8a2                	sd	s0,80(sp)
    80001d5a:	e4a6                	sd	s1,72(sp)
    80001d5c:	e0ca                	sd	s2,64(sp)
    80001d5e:	fc4e                	sd	s3,56(sp)
    80001d60:	f852                	sd	s4,48(sp)
    80001d62:	f456                	sd	s5,40(sp)
    80001d64:	f05a                	sd	s6,32(sp)
    80001d66:	ec5e                	sd	s7,24(sp)
    80001d68:	e862                	sd	s8,16(sp)
    80001d6a:	e466                	sd	s9,8(sp)
    80001d6c:	1080                	addi	s0,sp,96
    80001d6e:	8792                	mv	a5,tp
  int id = r_tp();
    80001d70:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d72:	00779693          	slli	a3,a5,0x7
    80001d76:	0000e717          	auipc	a4,0xe
    80001d7a:	c2a70713          	addi	a4,a4,-982 # 8000f9a0 <pid_lock>
    80001d7e:	9736                	add	a4,a4,a3
    80001d80:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d84:	0000ea97          	auipc	s5,0xe
    80001d88:	c54a8a93          	addi	s5,s5,-940 # 8000f9d8 <cpus+0x8>
    80001d8c:	9ab6                	add	s5,s5,a3
        p->state = RUNNING;
    80001d8e:	4c11                	li	s8,4
        c->proc = p;
    80001d90:	0000eb17          	auipc	s6,0xe
    80001d94:	c10b0b13          	addi	s6,s6,-1008 # 8000f9a0 <pid_lock>
    80001d98:	8a3a                	mv	s4,a4
        found = 1;
    80001d9a:	4b85                	li	s7,1
    80001d9c:	a0a9                	j	80001de6 <scheduler+0x92>
      release(&p->lock);
    80001d9e:	8526                	mv	a0,s1
    80001da0:	eddfe0ef          	jal	80000c7c <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001da4:	16848493          	addi	s1,s1,360
    80001da8:	03248b63          	beq	s1,s2,80001dde <scheduler+0x8a>
      acquire(&p->lock);
    80001dac:	8526                	mv	a0,s1
    80001dae:	e4bfe0ef          	jal	80000bf8 <acquire>
      if (p->state == RUNNABLE) {
    80001db2:	4c9c                	lw	a5,24(s1)
    80001db4:	ff3795e3          	bne	a5,s3,80001d9e <scheduler+0x4a>
        p->state = RUNNING;
    80001db8:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dbc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001dc0:	06048593          	addi	a1,s1,96
    80001dc4:	8556                	mv	a0,s5
    80001dc6:	5e6000ef          	jal	800023ac <swtch>
    80001dca:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001dcc:	2781                	sext.w	a5,a5
    80001dce:	079e                	slli	a5,a5,0x7
    80001dd0:	97da                	add	a5,a5,s6
    80001dd2:	0a07a623          	sw	zero,172(a5)
        c->proc = 0;
    80001dd6:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001dda:	8cde                	mv	s9,s7
    80001ddc:	b7c9                	j	80001d9e <scheduler+0x4a>
    if (found == 0) {
    80001dde:	000c9463          	bnez	s9,80001de6 <scheduler+0x92>
      asm volatile("wfi");
    80001de2:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001de6:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001dea:	10017073          	csrci	sstatus,2
    int found = 0;
    80001dee:	4c81                	li	s9,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001df0:	0000e497          	auipc	s1,0xe
    80001df4:	fe048493          	addi	s1,s1,-32 # 8000fdd0 <proc>
      if (p->state == RUNNABLE) {
    80001df8:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001dfa:	00014917          	auipc	s2,0x14
    80001dfe:	9d690913          	addi	s2,s2,-1578 # 800157d0 <tickslock>
    80001e02:	b76d                	j	80001dac <scheduler+0x58>

0000000080001e04 <sched>:
{
    80001e04:	7179                	addi	sp,sp,-48
    80001e06:	f406                	sd	ra,40(sp)
    80001e08:	f022                	sd	s0,32(sp)
    80001e0a:	ec26                	sd	s1,24(sp)
    80001e0c:	e84a                	sd	s2,16(sp)
    80001e0e:	e44e                	sd	s3,8(sp)
    80001e10:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e12:	ad1ff0ef          	jal	800018e2 <myproc>
    80001e16:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e18:	d7bfe0ef          	jal	80000b92 <holding>
    80001e1c:	c92d                	beqz	a0,80001e8e <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e1e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e20:	2781                	sext.w	a5,a5
    80001e22:	079e                	slli	a5,a5,0x7
    80001e24:	0000e717          	auipc	a4,0xe
    80001e28:	b7c70713          	addi	a4,a4,-1156 # 8000f9a0 <pid_lock>
    80001e2c:	97ba                	add	a5,a5,a4
    80001e2e:	0a87a703          	lw	a4,168(a5)
    80001e32:	4785                	li	a5,1
    80001e34:	06f71363          	bne	a4,a5,80001e9a <sched+0x96>
  if (p->state == RUNNING)
    80001e38:	4c98                	lw	a4,24(s1)
    80001e3a:	4791                	li	a5,4
    80001e3c:	06f70563          	beq	a4,a5,80001ea6 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e40:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e44:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e46:	e7b5                	bnez	a5,80001eb2 <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e48:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e4a:	0000e917          	auipc	s2,0xe
    80001e4e:	b5690913          	addi	s2,s2,-1194 # 8000f9a0 <pid_lock>
    80001e52:	2781                	sext.w	a5,a5
    80001e54:	079e                	slli	a5,a5,0x7
    80001e56:	97ca                	add	a5,a5,s2
    80001e58:	0ac7a983          	lw	s3,172(a5)
    80001e5c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e5e:	2781                	sext.w	a5,a5
    80001e60:	079e                	slli	a5,a5,0x7
    80001e62:	0000e597          	auipc	a1,0xe
    80001e66:	b7658593          	addi	a1,a1,-1162 # 8000f9d8 <cpus+0x8>
    80001e6a:	95be                	add	a1,a1,a5
    80001e6c:	06048513          	addi	a0,s1,96
    80001e70:	53c000ef          	jal	800023ac <swtch>
    80001e74:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e76:	2781                	sext.w	a5,a5
    80001e78:	079e                	slli	a5,a5,0x7
    80001e7a:	993e                	add	s2,s2,a5
    80001e7c:	0b392623          	sw	s3,172(s2)
}
    80001e80:	70a2                	ld	ra,40(sp)
    80001e82:	7402                	ld	s0,32(sp)
    80001e84:	64e2                	ld	s1,24(sp)
    80001e86:	6942                	ld	s2,16(sp)
    80001e88:	69a2                	ld	s3,8(sp)
    80001e8a:	6145                	addi	sp,sp,48
    80001e8c:	8082                	ret
    panic("sched p->lock");
    80001e8e:	00005517          	auipc	a0,0x5
    80001e92:	30a50513          	addi	a0,a0,778 # 80007198 <etext+0x198>
    80001e96:	9b3fe0ef          	jal	80000848 <panic>
    panic("sched locks");
    80001e9a:	00005517          	auipc	a0,0x5
    80001e9e:	30e50513          	addi	a0,a0,782 # 800071a8 <etext+0x1a8>
    80001ea2:	9a7fe0ef          	jal	80000848 <panic>
    panic("sched RUNNING");
    80001ea6:	00005517          	auipc	a0,0x5
    80001eaa:	31250513          	addi	a0,a0,786 # 800071b8 <etext+0x1b8>
    80001eae:	99bfe0ef          	jal	80000848 <panic>
    panic("sched interruptible");
    80001eb2:	00005517          	auipc	a0,0x5
    80001eb6:	31650513          	addi	a0,a0,790 # 800071c8 <etext+0x1c8>
    80001eba:	98ffe0ef          	jal	80000848 <panic>

0000000080001ebe <yield>:
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	e426                	sd	s1,8(sp)
    80001ec6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001ec8:	a1bff0ef          	jal	800018e2 <myproc>
    80001ecc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ece:	d2bfe0ef          	jal	80000bf8 <acquire>
  p->state = RUNNABLE;
    80001ed2:	478d                	li	a5,3
    80001ed4:	cc9c                	sw	a5,24(s1)
  sched();
    80001ed6:	f2fff0ef          	jal	80001e04 <sched>
  release(&p->lock);
    80001eda:	8526                	mv	a0,s1
    80001edc:	da1fe0ef          	jal	80000c7c <release>
}
    80001ee0:	60e2                	ld	ra,24(sp)
    80001ee2:	6442                	ld	s0,16(sp)
    80001ee4:	64a2                	ld	s1,8(sp)
    80001ee6:	6105                	addi	sp,sp,32
    80001ee8:	8082                	ret

0000000080001eea <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80001eea:	1101                	addi	sp,sp,-32
    80001eec:	ec06                	sd	ra,24(sp)
    80001eee:	e822                	sd	s0,16(sp)
    80001ef0:	e426                	sd	s1,8(sp)
    80001ef2:	e04a                	sd	s2,0(sp)
    80001ef4:	1000                	addi	s0,sp,32
    80001ef6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef8:	9ebff0ef          	jal	800018e2 <myproc>
    80001efc:	892a                	mv	s2,a0

  acquire(&p->lock);
    80001efe:	cfbfe0ef          	jal	80000bf8 <acquire>
  if (chan == 0)
    80001f02:	cc81                	beqz	s1,80001f1a <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80001f04:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80001f08:	854a                	mv	a0,s2
    80001f0a:	d73fe0ef          	jal	80000c7c <release>
}
    80001f0e:	60e2                	ld	ra,24(sp)
    80001f10:	6442                	ld	s0,16(sp)
    80001f12:	64a2                	ld	s1,8(sp)
    80001f14:	6902                	ld	s2,0(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret
    panic("sleep_prepare: zero chan");
    80001f1a:	00005517          	auipc	a0,0x5
    80001f1e:	2c650513          	addi	a0,a0,710 # 800071e0 <etext+0x1e0>
    80001f22:	927fe0ef          	jal	80000848 <panic>

0000000080001f26 <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    80001f26:	1101                	addi	sp,sp,-32
    80001f28:	ec06                	sd	ra,24(sp)
    80001f2a:	e822                	sd	s0,16(sp)
    80001f2c:	e426                	sd	s1,8(sp)
    80001f2e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f30:	9b3ff0ef          	jal	800018e2 <myproc>
    80001f34:	84aa                	mv	s1,a0

  acquire(&p->lock);
    80001f36:	cc3fe0ef          	jal	80000bf8 <acquire>
  if (p->chan != 0) {
    80001f3a:	709c                	ld	a5,32(s1)
    80001f3c:	c789                	beqz	a5,80001f46 <sleep+0x20>
    p->state = SLEEPING;
    80001f3e:	4789                	li	a5,2
    80001f40:	cc9c                	sw	a5,24(s1)
    sched();
    80001f42:	ec3ff0ef          	jal	80001e04 <sched>
  }
  release(&p->lock);
    80001f46:	8526                	mv	a0,s1
    80001f48:	d35fe0ef          	jal	80000c7c <release>
}
    80001f4c:	60e2                	ld	ra,24(sp)
    80001f4e:	6442                	ld	s0,16(sp)
    80001f50:	64a2                	ld	s1,8(sp)
    80001f52:	6105                	addi	sp,sp,32
    80001f54:	8082                	ret

0000000080001f56 <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    80001f56:	7139                	addi	sp,sp,-64
    80001f58:	fc06                	sd	ra,56(sp)
    80001f5a:	f822                	sd	s0,48(sp)
    80001f5c:	f426                	sd	s1,40(sp)
    80001f5e:	f04a                	sd	s2,32(sp)
    80001f60:	ec4e                	sd	s3,24(sp)
    80001f62:	e852                	sd	s4,16(sp)
    80001f64:	e456                	sd	s5,8(sp)
    80001f66:	0080                	addi	s0,sp,64
    80001f68:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001f6a:	0000e497          	auipc	s1,0xe
    80001f6e:	e6648493          	addi	s1,s1,-410 # 8000fdd0 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    80001f72:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80001f74:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f76:	00014997          	auipc	s3,0x14
    80001f7a:	85a98993          	addi	s3,s3,-1958 # 800157d0 <tickslock>
    80001f7e:	a801                	j	80001f8e <wakeup+0x38>
      }
    }
    release(&p->lock);
    80001f80:	8526                	mv	a0,s1
    80001f82:	cfbfe0ef          	jal	80000c7c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f86:	16848493          	addi	s1,s1,360
    80001f8a:	03348063          	beq	s1,s3,80001faa <wakeup+0x54>
    acquire(&p->lock);
    80001f8e:	8526                	mv	a0,s1
    80001f90:	c69fe0ef          	jal	80000bf8 <acquire>
    if (p->chan == chan) {
    80001f94:	709c                	ld	a5,32(s1)
    80001f96:	ff2795e3          	bne	a5,s2,80001f80 <wakeup+0x2a>
      p->chan = 0;
    80001f9a:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    80001f9e:	4c9c                	lw	a5,24(s1)
    80001fa0:	ff4790e3          	bne	a5,s4,80001f80 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fa4:	0154ac23          	sw	s5,24(s1)
    80001fa8:	bfe1                	j	80001f80 <wakeup+0x2a>
  }
}
    80001faa:	70e2                	ld	ra,56(sp)
    80001fac:	7442                	ld	s0,48(sp)
    80001fae:	74a2                	ld	s1,40(sp)
    80001fb0:	7902                	ld	s2,32(sp)
    80001fb2:	69e2                	ld	s3,24(sp)
    80001fb4:	6a42                	ld	s4,16(sp)
    80001fb6:	6aa2                	ld	s5,8(sp)
    80001fb8:	6121                	addi	sp,sp,64
    80001fba:	8082                	ret

0000000080001fbc <reparent>:
{
    80001fbc:	7179                	addi	sp,sp,-48
    80001fbe:	f406                	sd	ra,40(sp)
    80001fc0:	f022                	sd	s0,32(sp)
    80001fc2:	ec26                	sd	s1,24(sp)
    80001fc4:	e84a                	sd	s2,16(sp)
    80001fc6:	e44e                	sd	s3,8(sp)
    80001fc8:	e052                	sd	s4,0(sp)
    80001fca:	1800                	addi	s0,sp,48
    80001fcc:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001fce:	0000e497          	auipc	s1,0xe
    80001fd2:	e0248493          	addi	s1,s1,-510 # 8000fdd0 <proc>
      pp->parent = initproc;
    80001fd6:	00006a17          	auipc	s4,0x6
    80001fda:	8a2a0a13          	addi	s4,s4,-1886 # 80007878 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001fde:	00013997          	auipc	s3,0x13
    80001fe2:	7f298993          	addi	s3,s3,2034 # 800157d0 <tickslock>
    80001fe6:	a029                	j	80001ff0 <reparent+0x34>
    80001fe8:	16848493          	addi	s1,s1,360
    80001fec:	01348b63          	beq	s1,s3,80002002 <reparent+0x46>
    if (pp->parent == p) {
    80001ff0:	7c9c                	ld	a5,56(s1)
    80001ff2:	ff279be3          	bne	a5,s2,80001fe8 <reparent+0x2c>
      pp->parent = initproc;
    80001ff6:	000a3503          	ld	a0,0(s4)
    80001ffa:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001ffc:	f5bff0ef          	jal	80001f56 <wakeup>
    80002000:	b7e5                	j	80001fe8 <reparent+0x2c>
}
    80002002:	70a2                	ld	ra,40(sp)
    80002004:	7402                	ld	s0,32(sp)
    80002006:	64e2                	ld	s1,24(sp)
    80002008:	6942                	ld	s2,16(sp)
    8000200a:	69a2                	ld	s3,8(sp)
    8000200c:	6a02                	ld	s4,0(sp)
    8000200e:	6145                	addi	sp,sp,48
    80002010:	8082                	ret

0000000080002012 <kexit>:
{
    80002012:	7179                	addi	sp,sp,-48
    80002014:	f406                	sd	ra,40(sp)
    80002016:	f022                	sd	s0,32(sp)
    80002018:	ec26                	sd	s1,24(sp)
    8000201a:	e84a                	sd	s2,16(sp)
    8000201c:	e44e                	sd	s3,8(sp)
    8000201e:	e052                	sd	s4,0(sp)
    80002020:	1800                	addi	s0,sp,48
    80002022:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002024:	8bfff0ef          	jal	800018e2 <myproc>
    80002028:	89aa                	mv	s3,a0
  if (p == initproc)
    8000202a:	00006797          	auipc	a5,0x6
    8000202e:	84e7b783          	ld	a5,-1970(a5) # 80007878 <initproc>
    80002032:	0d050493          	addi	s1,a0,208
    80002036:	15050913          	addi	s2,a0,336
    8000203a:	00a79b63          	bne	a5,a0,80002050 <kexit+0x3e>
    panic("init exiting");
    8000203e:	00005517          	auipc	a0,0x5
    80002042:	1c250513          	addi	a0,a0,450 # 80007200 <etext+0x200>
    80002046:	803fe0ef          	jal	80000848 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    8000204a:	04a1                	addi	s1,s1,8
    8000204c:	01248963          	beq	s1,s2,8000205e <kexit+0x4c>
    if (p->ofile[fd]) {
    80002050:	6088                	ld	a0,0(s1)
    80002052:	dd65                	beqz	a0,8000204a <kexit+0x38>
      fileclose(f);
    80002054:	0cc020ef          	jal	80004120 <fileclose>
      p->ofile[fd] = 0;
    80002058:	0004b023          	sd	zero,0(s1)
    8000205c:	b7fd                	j	8000204a <kexit+0x38>
  begin_op();
    8000205e:	40d010ef          	jal	80003c6a <begin_op>
  iput(p->cwd);
    80002062:	1509b503          	ld	a0,336(s3)
    80002066:	314010ef          	jal	8000337a <iput>
  end_op();
    8000206a:	48d010ef          	jal	80003cf6 <end_op>
  p->cwd = 0;
    8000206e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002072:	0000e517          	auipc	a0,0xe
    80002076:	94650513          	addi	a0,a0,-1722 # 8000f9b8 <wait_lock>
    8000207a:	b7ffe0ef          	jal	80000bf8 <acquire>
  reparent(p);
    8000207e:	854e                	mv	a0,s3
    80002080:	f3dff0ef          	jal	80001fbc <reparent>
  wakeup(p->parent);
    80002084:	0389b503          	ld	a0,56(s3)
    80002088:	ecfff0ef          	jal	80001f56 <wakeup>
  acquire(&p->lock);
    8000208c:	854e                	mv	a0,s3
    8000208e:	b6bfe0ef          	jal	80000bf8 <acquire>
  p->xstate = status;
    80002092:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002096:	4795                	li	a5,5
    80002098:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000209c:	0000e517          	auipc	a0,0xe
    800020a0:	91c50513          	addi	a0,a0,-1764 # 8000f9b8 <wait_lock>
    800020a4:	bd9fe0ef          	jal	80000c7c <release>
  sched();
    800020a8:	d5dff0ef          	jal	80001e04 <sched>
  panic("zombie exit");
    800020ac:	00005517          	auipc	a0,0x5
    800020b0:	16450513          	addi	a0,a0,356 # 80007210 <etext+0x210>
    800020b4:	f94fe0ef          	jal	80000848 <panic>

00000000800020b8 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020b8:	7179                	addi	sp,sp,-48
    800020ba:	f406                	sd	ra,40(sp)
    800020bc:	f022                	sd	s0,32(sp)
    800020be:	ec26                	sd	s1,24(sp)
    800020c0:	e84a                	sd	s2,16(sp)
    800020c2:	e44e                	sd	s3,8(sp)
    800020c4:	1800                	addi	s0,sp,48
    800020c6:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800020c8:	0000e497          	auipc	s1,0xe
    800020cc:	d0848493          	addi	s1,s1,-760 # 8000fdd0 <proc>
    800020d0:	00013997          	auipc	s3,0x13
    800020d4:	70098993          	addi	s3,s3,1792 # 800157d0 <tickslock>
    acquire(&p->lock);
    800020d8:	8526                	mv	a0,s1
    800020da:	b1ffe0ef          	jal	80000bf8 <acquire>
    if (p->pid == pid) {
    800020de:	589c                	lw	a5,48(s1)
    800020e0:	01278b63          	beq	a5,s2,800020f6 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020e4:	8526                	mv	a0,s1
    800020e6:	b97fe0ef          	jal	80000c7c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020ea:	16848493          	addi	s1,s1,360
    800020ee:	ff3495e3          	bne	s1,s3,800020d8 <kkill+0x20>
  }
  return -1;
    800020f2:	557d                	li	a0,-1
    800020f4:	a819                	j	8000210a <kkill+0x52>
      p->killed = 1;
    800020f6:	4785                	li	a5,1
    800020f8:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800020fa:	4c98                	lw	a4,24(s1)
    800020fc:	4789                	li	a5,2
    800020fe:	00f70d63          	beq	a4,a5,80002118 <kkill+0x60>
      release(&p->lock);
    80002102:	8526                	mv	a0,s1
    80002104:	b79fe0ef          	jal	80000c7c <release>
      return 0;
    80002108:	4501                	li	a0,0
}
    8000210a:	70a2                	ld	ra,40(sp)
    8000210c:	7402                	ld	s0,32(sp)
    8000210e:	64e2                	ld	s1,24(sp)
    80002110:	6942                	ld	s2,16(sp)
    80002112:	69a2                	ld	s3,8(sp)
    80002114:	6145                	addi	sp,sp,48
    80002116:	8082                	ret
        p->state = RUNNABLE;
    80002118:	478d                	li	a5,3
    8000211a:	cc9c                	sw	a5,24(s1)
    8000211c:	b7dd                	j	80002102 <kkill+0x4a>

000000008000211e <setkilled>:

void
setkilled(struct proc *p)
{
    8000211e:	1101                	addi	sp,sp,-32
    80002120:	ec06                	sd	ra,24(sp)
    80002122:	e822                	sd	s0,16(sp)
    80002124:	e426                	sd	s1,8(sp)
    80002126:	1000                	addi	s0,sp,32
    80002128:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000212a:	acffe0ef          	jal	80000bf8 <acquire>
  p->killed = 1;
    8000212e:	4785                	li	a5,1
    80002130:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002132:	8526                	mv	a0,s1
    80002134:	b49fe0ef          	jal	80000c7c <release>
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <killed>:

int
killed(struct proc *p)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	e04a                	sd	s2,0(sp)
    8000214c:	1000                	addi	s0,sp,32
    8000214e:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002150:	aa9fe0ef          	jal	80000bf8 <acquire>
  k = p->killed;
    80002154:	549c                	lw	a5,40(s1)
    80002156:	893e                	mv	s2,a5
  release(&p->lock);
    80002158:	8526                	mv	a0,s1
    8000215a:	b23fe0ef          	jal	80000c7c <release>
  return k;
}
    8000215e:	854a                	mv	a0,s2
    80002160:	60e2                	ld	ra,24(sp)
    80002162:	6442                	ld	s0,16(sp)
    80002164:	64a2                	ld	s1,8(sp)
    80002166:	6902                	ld	s2,0(sp)
    80002168:	6105                	addi	sp,sp,32
    8000216a:	8082                	ret

000000008000216c <kwait>:
{
    8000216c:	715d                	addi	sp,sp,-80
    8000216e:	e486                	sd	ra,72(sp)
    80002170:	e0a2                	sd	s0,64(sp)
    80002172:	fc26                	sd	s1,56(sp)
    80002174:	f84a                	sd	s2,48(sp)
    80002176:	f44e                	sd	s3,40(sp)
    80002178:	f052                	sd	s4,32(sp)
    8000217a:	ec56                	sd	s5,24(sp)
    8000217c:	e85a                	sd	s6,16(sp)
    8000217e:	e45e                	sd	s7,8(sp)
    80002180:	0880                	addi	s0,sp,80
    80002182:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002184:	f5eff0ef          	jal	800018e2 <myproc>
    80002188:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000218a:	0000e517          	auipc	a0,0xe
    8000218e:	82e50513          	addi	a0,a0,-2002 # 8000f9b8 <wait_lock>
    80002192:	a67fe0ef          	jal	80000bf8 <acquire>
        if (pp->state == ZOMBIE) {
    80002196:	4a15                	li	s4,5
        havekids = 1;
    80002198:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000219a:	00013997          	auipc	s3,0x13
    8000219e:	63698993          	addi	s3,s3,1590 # 800157d0 <tickslock>
    release(&wait_lock);
    800021a2:	0000eb17          	auipc	s6,0xe
    800021a6:	816b0b13          	addi	s6,s6,-2026 # 8000f9b8 <wait_lock>
    800021aa:	a07d                	j	80002258 <kwait+0xec>
          pid = pp->pid;
    800021ac:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    800021b0:	000b8e63          	beqz	s7,800021cc <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    800021b4:	4711                	li	a4,4
    800021b6:	02c48693          	addi	a3,s1,44
    800021ba:	865e                	mv	a2,s7
    800021bc:	04893583          	ld	a1,72(s2)
    800021c0:	05093503          	ld	a0,80(s2)
    800021c4:	b68ff0ef          	jal	8000152c <copyout>
          if (addr != 0 &&
    800021c8:	02054c63          	bltz	a0,80002200 <kwait+0x94>
          pp->parent = 0;
    800021cc:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    800021d0:	8526                	mv	a0,s1
    800021d2:	8efff0ef          	jal	80001ac0 <freeproc>
          release(&pp->lock);
    800021d6:	8526                	mv	a0,s1
    800021d8:	aa5fe0ef          	jal	80000c7c <release>
          release(&wait_lock);
    800021dc:	0000d517          	auipc	a0,0xd
    800021e0:	7dc50513          	addi	a0,a0,2012 # 8000f9b8 <wait_lock>
    800021e4:	a99fe0ef          	jal	80000c7c <release>
}
    800021e8:	854e                	mv	a0,s3
    800021ea:	60a6                	ld	ra,72(sp)
    800021ec:	6406                	ld	s0,64(sp)
    800021ee:	74e2                	ld	s1,56(sp)
    800021f0:	7942                	ld	s2,48(sp)
    800021f2:	79a2                	ld	s3,40(sp)
    800021f4:	7a02                	ld	s4,32(sp)
    800021f6:	6ae2                	ld	s5,24(sp)
    800021f8:	6b42                	ld	s6,16(sp)
    800021fa:	6ba2                	ld	s7,8(sp)
    800021fc:	6161                	addi	sp,sp,80
    800021fe:	8082                	ret
            release(&pp->lock);
    80002200:	8526                	mv	a0,s1
    80002202:	a7bfe0ef          	jal	80000c7c <release>
            release(&wait_lock);
    80002206:	0000d517          	auipc	a0,0xd
    8000220a:	7b250513          	addi	a0,a0,1970 # 8000f9b8 <wait_lock>
    8000220e:	a6ffe0ef          	jal	80000c7c <release>
            return -1;
    80002212:	a8b9                	j	80002270 <kwait+0x104>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002214:	16848493          	addi	s1,s1,360
    80002218:	03348063          	beq	s1,s3,80002238 <kwait+0xcc>
      if (pp->parent == p) {
    8000221c:	7c9c                	ld	a5,56(s1)
    8000221e:	ff279be3          	bne	a5,s2,80002214 <kwait+0xa8>
        acquire(&pp->lock);
    80002222:	8526                	mv	a0,s1
    80002224:	9d5fe0ef          	jal	80000bf8 <acquire>
        if (pp->state == ZOMBIE) {
    80002228:	4c9c                	lw	a5,24(s1)
    8000222a:	f94781e3          	beq	a5,s4,800021ac <kwait+0x40>
        release(&pp->lock);
    8000222e:	8526                	mv	a0,s1
    80002230:	a4dfe0ef          	jal	80000c7c <release>
        havekids = 1;
    80002234:	8756                	mv	a4,s5
    80002236:	bff9                	j	80002214 <kwait+0xa8>
    if (!havekids || killed(p)) {
    80002238:	c715                	beqz	a4,80002264 <kwait+0xf8>
    8000223a:	854a                	mv	a0,s2
    8000223c:	f07ff0ef          	jal	80002142 <killed>
    80002240:	e115                	bnez	a0,80002264 <kwait+0xf8>
    sleep_prepare(p); //DOC: wait-sleep
    80002242:	854a                	mv	a0,s2
    80002244:	ca7ff0ef          	jal	80001eea <sleep_prepare>
    release(&wait_lock);
    80002248:	855a                	mv	a0,s6
    8000224a:	a33fe0ef          	jal	80000c7c <release>
    sleep();
    8000224e:	cd9ff0ef          	jal	80001f26 <sleep>
    acquire(&wait_lock);
    80002252:	855a                	mv	a0,s6
    80002254:	9a5fe0ef          	jal	80000bf8 <acquire>
    havekids = 0;
    80002258:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000225a:	0000e497          	auipc	s1,0xe
    8000225e:	b7648493          	addi	s1,s1,-1162 # 8000fdd0 <proc>
    80002262:	bf6d                	j	8000221c <kwait+0xb0>
      release(&wait_lock);
    80002264:	0000d517          	auipc	a0,0xd
    80002268:	75450513          	addi	a0,a0,1876 # 8000f9b8 <wait_lock>
    8000226c:	a11fe0ef          	jal	80000c7c <release>
            return -1;
    80002270:	59fd                	li	s3,-1
    80002272:	bf9d                	j	800021e8 <kwait+0x7c>

0000000080002274 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002274:	7179                	addi	sp,sp,-48
    80002276:	f406                	sd	ra,40(sp)
    80002278:	f022                	sd	s0,32(sp)
    8000227a:	ec26                	sd	s1,24(sp)
    8000227c:	e84a                	sd	s2,16(sp)
    8000227e:	e44e                	sd	s3,8(sp)
    80002280:	e052                	sd	s4,0(sp)
    80002282:	1800                	addi	s0,sp,48
    80002284:	84aa                	mv	s1,a0
    80002286:	8a2e                	mv	s4,a1
    80002288:	89b2                	mv	s3,a2
    8000228a:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000228c:	e56ff0ef          	jal	800018e2 <myproc>
  if (user_dst) {
    80002290:	c085                	beqz	s1,800022b0 <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    80002292:	874a                	mv	a4,s2
    80002294:	86ce                	mv	a3,s3
    80002296:	8652                	mv	a2,s4
    80002298:	652c                	ld	a1,72(a0)
    8000229a:	6928                	ld	a0,80(a0)
    8000229c:	a90ff0ef          	jal	8000152c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022a0:	70a2                	ld	ra,40(sp)
    800022a2:	7402                	ld	s0,32(sp)
    800022a4:	64e2                	ld	s1,24(sp)
    800022a6:	6942                	ld	s2,16(sp)
    800022a8:	69a2                	ld	s3,8(sp)
    800022aa:	6a02                	ld	s4,0(sp)
    800022ac:	6145                	addi	sp,sp,48
    800022ae:	8082                	ret
    memmove((char *)dst, src, len);
    800022b0:	0009061b          	sext.w	a2,s2
    800022b4:	85ce                	mv	a1,s3
    800022b6:	8552                	mv	a0,s4
    800022b8:	a59fe0ef          	jal	80000d10 <memmove>
    return 0;
    800022bc:	8526                	mv	a0,s1
    800022be:	b7cd                	j	800022a0 <either_copyout+0x2c>

00000000800022c0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022c0:	7179                	addi	sp,sp,-48
    800022c2:	f406                	sd	ra,40(sp)
    800022c4:	f022                	sd	s0,32(sp)
    800022c6:	ec26                	sd	s1,24(sp)
    800022c8:	e84a                	sd	s2,16(sp)
    800022ca:	e44e                	sd	s3,8(sp)
    800022cc:	e052                	sd	s4,0(sp)
    800022ce:	1800                	addi	s0,sp,48
    800022d0:	8a2a                	mv	s4,a0
    800022d2:	84ae                	mv	s1,a1
    800022d4:	89b2                	mv	s3,a2
    800022d6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022d8:	e0aff0ef          	jal	800018e2 <myproc>
  if (user_src) {
    800022dc:	c085                	beqz	s1,800022fc <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    800022de:	874a                	mv	a4,s2
    800022e0:	86ce                	mv	a3,s3
    800022e2:	8652                	mv	a2,s4
    800022e4:	652c                	ld	a1,72(a0)
    800022e6:	6928                	ld	a0,80(a0)
    800022e8:	b04ff0ef          	jal	800015ec <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800022ec:	70a2                	ld	ra,40(sp)
    800022ee:	7402                	ld	s0,32(sp)
    800022f0:	64e2                	ld	s1,24(sp)
    800022f2:	6942                	ld	s2,16(sp)
    800022f4:	69a2                	ld	s3,8(sp)
    800022f6:	6a02                	ld	s4,0(sp)
    800022f8:	6145                	addi	sp,sp,48
    800022fa:	8082                	ret
    memmove(dst, (char *)src, len);
    800022fc:	0009061b          	sext.w	a2,s2
    80002300:	85ce                	mv	a1,s3
    80002302:	8552                	mv	a0,s4
    80002304:	a0dfe0ef          	jal	80000d10 <memmove>
    return 0;
    80002308:	8526                	mv	a0,s1
    8000230a:	b7cd                	j	800022ec <either_copyin+0x2c>

000000008000230c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000230c:	715d                	addi	sp,sp,-80
    8000230e:	e486                	sd	ra,72(sp)
    80002310:	e0a2                	sd	s0,64(sp)
    80002312:	fc26                	sd	s1,56(sp)
    80002314:	f84a                	sd	s2,48(sp)
    80002316:	f44e                	sd	s3,40(sp)
    80002318:	f052                	sd	s4,32(sp)
    8000231a:	ec56                	sd	s5,24(sp)
    8000231c:	e85a                	sd	s6,16(sp)
    8000231e:	e45e                	sd	s7,8(sp)
    80002320:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    80002322:	00005517          	auipc	a0,0x5
    80002326:	d5650513          	addi	a0,a0,-682 # 80007078 <etext+0x78>
    8000232a:	9e6fe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000232e:	0000e497          	auipc	s1,0xe
    80002332:	bfa48493          	addi	s1,s1,-1030 # 8000ff28 <proc+0x158>
    80002336:	00013917          	auipc	s2,0x13
    8000233a:	5f290913          	addi	s2,s2,1522 # 80015928 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000233e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002340:	00005a97          	auipc	s5,0x5
    80002344:	ee0a8a93          	addi	s5,s5,-288 # 80007220 <etext+0x220>
    printk("%d %s %s", p->pid, state, p->name);
    80002348:	00005a17          	auipc	s4,0x5
    8000234c:	ee0a0a13          	addi	s4,s4,-288 # 80007228 <etext+0x228>
    printk("\n");
    80002350:	00005997          	auipc	s3,0x5
    80002354:	d2898993          	addi	s3,s3,-728 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002358:	00005b97          	auipc	s7,0x5
    8000235c:	3f0b8b93          	addi	s7,s7,1008 # 80007748 <states.0>
    80002360:	a829                	j	8000237a <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    80002362:	ed86a583          	lw	a1,-296(a3)
    80002366:	8552                	mv	a0,s4
    80002368:	9a8fe0ef          	jal	80000510 <printk>
    printk("\n");
    8000236c:	854e                	mv	a0,s3
    8000236e:	9a2fe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002372:	16848493          	addi	s1,s1,360
    80002376:	03248063          	beq	s1,s2,80002396 <procdump+0x8a>
    if (p->state == UNUSED)
    8000237a:	86a6                	mv	a3,s1
    8000237c:	ec04a783          	lw	a5,-320(s1)
    80002380:	dbed                	beqz	a5,80002372 <procdump+0x66>
      state = "???";
    80002382:	8656                	mv	a2,s5
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002384:	fcfb6fe3          	bltu	s6,a5,80002362 <procdump+0x56>
    80002388:	02079713          	slli	a4,a5,0x20
    8000238c:	01d75793          	srli	a5,a4,0x1d
    80002390:	97de                	add	a5,a5,s7
    80002392:	6390                	ld	a2,0(a5)
      state = states[p->state];
    80002394:	b7f9                	j	80002362 <procdump+0x56>
  }
}
    80002396:	60a6                	ld	ra,72(sp)
    80002398:	6406                	ld	s0,64(sp)
    8000239a:	74e2                	ld	s1,56(sp)
    8000239c:	7942                	ld	s2,48(sp)
    8000239e:	79a2                	ld	s3,40(sp)
    800023a0:	7a02                	ld	s4,32(sp)
    800023a2:	6ae2                	ld	s5,24(sp)
    800023a4:	6b42                	ld	s6,16(sp)
    800023a6:	6ba2                	ld	s7,8(sp)
    800023a8:	6161                	addi	sp,sp,80
    800023aa:	8082                	ret

00000000800023ac <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023ac:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023b0:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023b4:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023b6:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023b8:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023bc:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023c0:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023c4:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023c8:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023cc:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023d0:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800023d4:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800023d8:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800023dc:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800023e0:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800023e4:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023e8:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800023ea:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023ec:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800023f0:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800023f4:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800023f8:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800023fc:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002400:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002404:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002408:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000240c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002410:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002414:	8082                	ret

0000000080002416 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002416:	1141                	addi	sp,sp,-16
    80002418:	e406                	sd	ra,8(sp)
    8000241a:	e022                	sd	s0,0(sp)
    8000241c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000241e:	00005597          	auipc	a1,0x5
    80002422:	e4a58593          	addi	a1,a1,-438 # 80007268 <etext+0x268>
    80002426:	00013517          	auipc	a0,0x13
    8000242a:	3aa50513          	addi	a0,a0,938 # 800157d0 <tickslock>
    8000242e:	f4afe0ef          	jal	80000b78 <initlock>
}
    80002432:	60a2                	ld	ra,8(sp)
    80002434:	6402                	ld	s0,0(sp)
    80002436:	0141                	addi	sp,sp,16
    80002438:	8082                	ret

000000008000243a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000243a:	1141                	addi	sp,sp,-16
    8000243c:	e406                	sd	ra,8(sp)
    8000243e:	e022                	sd	s0,0(sp)
    80002440:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002442:	00003797          	auipc	a5,0x3
    80002446:	0ae78793          	addi	a5,a5,174 # 800054f0 <kernelvec>
    8000244a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000244e:	60a2                	ld	ra,8(sp)
    80002450:	6402                	ld	s0,0(sp)
    80002452:	0141                	addi	sp,sp,16
    80002454:	8082                	ret

0000000080002456 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002456:	1141                	addi	sp,sp,-16
    80002458:	e406                	sd	ra,8(sp)
    8000245a:	e022                	sd	s0,0(sp)
    8000245c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000245e:	c84ff0ef          	jal	800018e2 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002462:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002466:	04000737          	lui	a4,0x4000
    8000246a:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000246c:	0732                	slli	a4,a4,0xc
    8000246e:	00004797          	auipc	a5,0x4
    80002472:	b9278793          	addi	a5,a5,-1134 # 80006000 <_trampoline>
    80002476:	00004697          	auipc	a3,0x4
    8000247a:	b8a68693          	addi	a3,a3,-1142 # 80006000 <_trampoline>
    8000247e:	8f95                	sub	a5,a5,a3
    80002480:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002482:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002486:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002488:	18002773          	csrr	a4,satp
    8000248c:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000248e:	6d38                	ld	a4,88(a0)
    80002490:	613c                	ld	a5,64(a0)
    80002492:	6685                	lui	a3,0x1
    80002494:	97b6                	add	a5,a5,a3
    80002496:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002498:	6d3c                	ld	a5,88(a0)
    8000249a:	00000717          	auipc	a4,0x0
    8000249e:	0f470713          	addi	a4,a4,244 # 8000258e <usertrap>
    800024a2:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    800024a4:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800024a6:	8712                	mv	a4,tp
    800024a8:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800024aa:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024ae:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024b2:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800024b6:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024ba:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800024bc:	6f9c                	ld	a5,24(a5)
    800024be:	14179073          	csrw	sepc,a5
}
    800024c2:	60a2                	ld	ra,8(sp)
    800024c4:	6402                	ld	s0,0(sp)
    800024c6:	0141                	addi	sp,sp,16
    800024c8:	8082                	ret

00000000800024ca <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024ca:	1141                	addi	sp,sp,-16
    800024cc:	e406                	sd	ra,8(sp)
    800024ce:	e022                	sd	s0,0(sp)
    800024d0:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800024d2:	bdcff0ef          	jal	800018ae <cpuid>
    800024d6:	cd11                	beqz	a0,800024f2 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    800024d8:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024dc:	000f4737          	lui	a4,0xf4
    800024e0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024e4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    800024e6:	14d79073          	csrw	stimecmp,a5
}
    800024ea:	60a2                	ld	ra,8(sp)
    800024ec:	6402                	ld	s0,0(sp)
    800024ee:	0141                	addi	sp,sp,16
    800024f0:	8082                	ret
    acquire(&tickslock);
    800024f2:	00013517          	auipc	a0,0x13
    800024f6:	2de50513          	addi	a0,a0,734 # 800157d0 <tickslock>
    800024fa:	efefe0ef          	jal	80000bf8 <acquire>
    ticks++;
    800024fe:	00005717          	auipc	a4,0x5
    80002502:	38270713          	addi	a4,a4,898 # 80007880 <ticks>
    80002506:	431c                	lw	a5,0(a4)
    80002508:	2785                	addiw	a5,a5,1
    8000250a:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    8000250c:	853a                	mv	a0,a4
    8000250e:	a49ff0ef          	jal	80001f56 <wakeup>
    release(&tickslock);
    80002512:	00013517          	auipc	a0,0x13
    80002516:	2be50513          	addi	a0,a0,702 # 800157d0 <tickslock>
    8000251a:	f62fe0ef          	jal	80000c7c <release>
    8000251e:	bf6d                	j	800024d8 <clockintr+0xe>

0000000080002520 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002520:	1101                	addi	sp,sp,-32
    80002522:	ec06                	sd	ra,24(sp)
    80002524:	e822                	sd	s0,16(sp)
    80002526:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002528:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    8000252c:	57fd                	li	a5,-1
    8000252e:	17fe                	slli	a5,a5,0x3f
    80002530:	07a5                	addi	a5,a5,9
    80002532:	00f70c63          	beq	a4,a5,8000254a <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002536:	57fd                	li	a5,-1
    80002538:	17fe                	slli	a5,a5,0x3f
    8000253a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000253c:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    8000253e:	04f70463          	beq	a4,a5,80002586 <devintr+0x66>
  }
}
    80002542:	60e2                	ld	ra,24(sp)
    80002544:	6442                	ld	s0,16(sp)
    80002546:	6105                	addi	sp,sp,32
    80002548:	8082                	ret
    8000254a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000254c:	050030ef          	jal	8000559c <plic_claim>
    80002550:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002552:	47a9                	li	a5,10
    80002554:	02f50363          	beq	a0,a5,8000257a <devintr+0x5a>
    } else if (irq == VIRTIO0_IRQ) {
    80002558:	4785                	li	a5,1
    8000255a:	02f50363          	beq	a0,a5,80002580 <devintr+0x60>
    } else if (irq) {
    8000255e:	c919                	beqz	a0,80002574 <devintr+0x54>
      printk("unexpected interrupt irq=%d\n", irq);
    80002560:	85aa                	mv	a1,a0
    80002562:	00005517          	auipc	a0,0x5
    80002566:	d0e50513          	addi	a0,a0,-754 # 80007270 <etext+0x270>
    8000256a:	fa7fd0ef          	jal	80000510 <printk>
      plic_complete(irq);
    8000256e:	8526                	mv	a0,s1
    80002570:	04c030ef          	jal	800055bc <plic_complete>
    return 1;
    80002574:	4505                	li	a0,1
    80002576:	64a2                	ld	s1,8(sp)
    80002578:	b7e9                	j	80002542 <devintr+0x22>
      uartintr();
    8000257a:	c64fe0ef          	jal	800009de <uartintr>
    if (irq)
    8000257e:	bfc5                	j	8000256e <devintr+0x4e>
      virtio_disk_intr();
    80002580:	4c2030ef          	jal	80005a42 <virtio_disk_intr>
    if (irq)
    80002584:	b7ed                	j	8000256e <devintr+0x4e>
    clockintr();
    80002586:	f45ff0ef          	jal	800024ca <clockintr>
    return 2;
    8000258a:	4509                	li	a0,2
    8000258c:	bf5d                	j	80002542 <devintr+0x22>

000000008000258e <usertrap>:
{
    8000258e:	1101                	addi	sp,sp,-32
    80002590:	ec06                	sd	ra,24(sp)
    80002592:	e822                	sd	s0,16(sp)
    80002594:	e426                	sd	s1,8(sp)
    80002596:	e04a                	sd	s2,0(sp)
    80002598:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000259a:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    8000259e:	1007f793          	andi	a5,a5,256
    800025a2:	eba5                	bnez	a5,80002612 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    800025a4:	00003797          	auipc	a5,0x3
    800025a8:	f4c78793          	addi	a5,a5,-180 # 800054f0 <kernelvec>
    800025ac:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025b0:	b32ff0ef          	jal	800018e2 <myproc>
    800025b4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025b6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025b8:	14102773          	csrr	a4,sepc
    800025bc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    800025be:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    800025c2:	47a1                	li	a5,8
    800025c4:	04f70d63          	beq	a4,a5,8000261e <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    800025c8:	f59ff0ef          	jal	80002520 <devintr>
    800025cc:	892a                	mv	s2,a0
    800025ce:	e54d                	bnez	a0,80002678 <usertrap+0xea>
    800025d0:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800025d4:	47bd                	li	a5,15
    800025d6:	08f70463          	beq	a4,a5,8000265e <usertrap+0xd0>
    800025da:	14202773          	csrr	a4,scause
    800025de:	47b5                	li	a5,13
    800025e0:	06f70f63          	beq	a4,a5,8000265e <usertrap+0xd0>
    800025e4:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800025e8:	5890                	lw	a2,48(s1)
    800025ea:	00005517          	auipc	a0,0x5
    800025ee:	cc650513          	addi	a0,a0,-826 # 800072b0 <etext+0x2b0>
    800025f2:	f1ffd0ef          	jal	80000510 <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025f6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800025fa:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800025fe:	00005517          	auipc	a0,0x5
    80002602:	ce250513          	addi	a0,a0,-798 # 800072e0 <etext+0x2e0>
    80002606:	f0bfd0ef          	jal	80000510 <printk>
    setkilled(p);
    8000260a:	8526                	mv	a0,s1
    8000260c:	b13ff0ef          	jal	8000211e <setkilled>
    80002610:	a015                	j	80002634 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80002612:	00005517          	auipc	a0,0x5
    80002616:	c7e50513          	addi	a0,a0,-898 # 80007290 <etext+0x290>
    8000261a:	a2efe0ef          	jal	80000848 <panic>
    if (killed(p))
    8000261e:	b25ff0ef          	jal	80002142 <killed>
    80002622:	e915                	bnez	a0,80002656 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002624:	6cb8                	ld	a4,88(s1)
    80002626:	6f1c                	ld	a5,24(a4)
    80002628:	0791                	addi	a5,a5,4
    8000262a:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    8000262c:	10016073          	csrsi	sstatus,2
    syscall();
    80002630:	240000ef          	jal	80002870 <syscall>
  if (killed(p))
    80002634:	8526                	mv	a0,s1
    80002636:	b0dff0ef          	jal	80002142 <killed>
    8000263a:	e521                	bnez	a0,80002682 <usertrap+0xf4>
  prepare_return();
    8000263c:	e1bff0ef          	jal	80002456 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002640:	68a8                	ld	a0,80(s1)
    80002642:	8131                	srli	a0,a0,0xc
    80002644:	57fd                	li	a5,-1
    80002646:	17fe                	slli	a5,a5,0x3f
    80002648:	8d5d                	or	a0,a0,a5
}
    8000264a:	60e2                	ld	ra,24(sp)
    8000264c:	6442                	ld	s0,16(sp)
    8000264e:	64a2                	ld	s1,8(sp)
    80002650:	6902                	ld	s2,0(sp)
    80002652:	6105                	addi	sp,sp,32
    80002654:	8082                	ret
      kexit(-1);
    80002656:	557d                	li	a0,-1
    80002658:	9bbff0ef          	jal	80002012 <kexit>
    8000265c:	b7e1                	j	80002624 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    8000265e:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002662:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80002666:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80002668:	0016b693          	seqz	a3,a3
    8000266c:	64ac                	ld	a1,72(s1)
    8000266e:	68a8                	ld	a0,80(s1)
    80002670:	e45fe0ef          	jal	800014b4 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002674:	f161                	bnez	a0,80002634 <usertrap+0xa6>
    80002676:	b7bd                	j	800025e4 <usertrap+0x56>
  if (killed(p))
    80002678:	8526                	mv	a0,s1
    8000267a:	ac9ff0ef          	jal	80002142 <killed>
    8000267e:	c511                	beqz	a0,8000268a <usertrap+0xfc>
    80002680:	a011                	j	80002684 <usertrap+0xf6>
    80002682:	4901                	li	s2,0
    kexit(-1);
    80002684:	557d                	li	a0,-1
    80002686:	98dff0ef          	jal	80002012 <kexit>
  if (which_dev == 2)
    8000268a:	4789                	li	a5,2
    8000268c:	faf918e3          	bne	s2,a5,8000263c <usertrap+0xae>
    yield();
    80002690:	82fff0ef          	jal	80001ebe <yield>
    80002694:	b765                	j	8000263c <usertrap+0xae>

0000000080002696 <kerneltrap>:
{
    80002696:	7179                	addi	sp,sp,-48
    80002698:	f406                	sd	ra,40(sp)
    8000269a:	f022                	sd	s0,32(sp)
    8000269c:	ec26                	sd	s1,24(sp)
    8000269e:	e84a                	sd	s2,16(sp)
    800026a0:	e44e                	sd	s3,8(sp)
    800026a2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026a4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026a8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800026ac:	142027f3          	csrr	a5,scause
    800026b0:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    800026b2:	1004f793          	andi	a5,s1,256
    800026b6:	c795                	beqz	a5,800026e2 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026bc:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800026be:	eb85                	bnez	a5,800026ee <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    800026c0:	e61ff0ef          	jal	80002520 <devintr>
    800026c4:	c91d                	beqz	a0,800026fa <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    800026c6:	4789                	li	a5,2
    800026c8:	04f50a63          	beq	a0,a5,8000271c <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800026cc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800026d0:	10049073          	csrw	sstatus,s1
}
    800026d4:	70a2                	ld	ra,40(sp)
    800026d6:	7402                	ld	s0,32(sp)
    800026d8:	64e2                	ld	s1,24(sp)
    800026da:	6942                	ld	s2,16(sp)
    800026dc:	69a2                	ld	s3,8(sp)
    800026de:	6145                	addi	sp,sp,48
    800026e0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800026e2:	00005517          	auipc	a0,0x5
    800026e6:	c2650513          	addi	a0,a0,-986 # 80007308 <etext+0x308>
    800026ea:	95efe0ef          	jal	80000848 <panic>
    panic("kerneltrap: interrupts enabled");
    800026ee:	00005517          	auipc	a0,0x5
    800026f2:	c4250513          	addi	a0,a0,-958 # 80007330 <etext+0x330>
    800026f6:	952fe0ef          	jal	80000848 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026fa:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800026fe:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002702:	85ce                	mv	a1,s3
    80002704:	00005517          	auipc	a0,0x5
    80002708:	c4c50513          	addi	a0,a0,-948 # 80007350 <etext+0x350>
    8000270c:	e05fd0ef          	jal	80000510 <printk>
    panic("kerneltrap");
    80002710:	00005517          	auipc	a0,0x5
    80002714:	c6850513          	addi	a0,a0,-920 # 80007378 <etext+0x378>
    80002718:	930fe0ef          	jal	80000848 <panic>
  if (which_dev == 2 && myproc() != 0)
    8000271c:	9c6ff0ef          	jal	800018e2 <myproc>
    80002720:	d555                	beqz	a0,800026cc <kerneltrap+0x36>
    yield();
    80002722:	f9cff0ef          	jal	80001ebe <yield>
    80002726:	b75d                	j	800026cc <kerneltrap+0x36>

0000000080002728 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002728:	1101                	addi	sp,sp,-32
    8000272a:	ec06                	sd	ra,24(sp)
    8000272c:	e822                	sd	s0,16(sp)
    8000272e:	e426                	sd	s1,8(sp)
    80002730:	1000                	addi	s0,sp,32
    80002732:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002734:	9aeff0ef          	jal	800018e2 <myproc>
  switch (n) {
    80002738:	4795                	li	a5,5
    8000273a:	0497e163          	bltu	a5,s1,8000277c <argraw+0x54>
    8000273e:	048a                	slli	s1,s1,0x2
    80002740:	00005717          	auipc	a4,0x5
    80002744:	03870713          	addi	a4,a4,56 # 80007778 <states.0+0x30>
    80002748:	94ba                	add	s1,s1,a4
    8000274a:	409c                	lw	a5,0(s1)
    8000274c:	97ba                	add	a5,a5,a4
    8000274e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002750:	6d3c                	ld	a5,88(a0)
    80002752:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002754:	60e2                	ld	ra,24(sp)
    80002756:	6442                	ld	s0,16(sp)
    80002758:	64a2                	ld	s1,8(sp)
    8000275a:	6105                	addi	sp,sp,32
    8000275c:	8082                	ret
    return p->trapframe->a1;
    8000275e:	6d3c                	ld	a5,88(a0)
    80002760:	7fa8                	ld	a0,120(a5)
    80002762:	bfcd                	j	80002754 <argraw+0x2c>
    return p->trapframe->a2;
    80002764:	6d3c                	ld	a5,88(a0)
    80002766:	63c8                	ld	a0,128(a5)
    80002768:	b7f5                	j	80002754 <argraw+0x2c>
    return p->trapframe->a3;
    8000276a:	6d3c                	ld	a5,88(a0)
    8000276c:	67c8                	ld	a0,136(a5)
    8000276e:	b7dd                	j	80002754 <argraw+0x2c>
    return p->trapframe->a4;
    80002770:	6d3c                	ld	a5,88(a0)
    80002772:	6bc8                	ld	a0,144(a5)
    80002774:	b7c5                	j	80002754 <argraw+0x2c>
    return p->trapframe->a5;
    80002776:	6d3c                	ld	a5,88(a0)
    80002778:	6fc8                	ld	a0,152(a5)
    8000277a:	bfe9                	j	80002754 <argraw+0x2c>
  panic("argraw");
    8000277c:	00005517          	auipc	a0,0x5
    80002780:	c0c50513          	addi	a0,a0,-1012 # 80007388 <etext+0x388>
    80002784:	8c4fe0ef          	jal	80000848 <panic>

0000000080002788 <fetchaddr>:
{
    80002788:	1101                	addi	sp,sp,-32
    8000278a:	ec06                	sd	ra,24(sp)
    8000278c:	e822                	sd	s0,16(sp)
    8000278e:	e426                	sd	s1,8(sp)
    80002790:	e04a                	sd	s2,0(sp)
    80002792:	1000                	addi	s0,sp,32
    80002794:	84aa                	mv	s1,a0
    80002796:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002798:	94aff0ef          	jal	800018e2 <myproc>
  if (addr >= p->sz ||
    8000279c:	652c                	ld	a1,72(a0)
    8000279e:	02b4f663          	bgeu	s1,a1,800027ca <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027a2:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    800027a6:	02f5e263          	bltu	a1,a5,800027ca <fetchaddr+0x42>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    800027aa:	4721                	li	a4,8
    800027ac:	86a6                	mv	a3,s1
    800027ae:	864a                	mv	a2,s2
    800027b0:	6928                	ld	a0,80(a0)
    800027b2:	e3bfe0ef          	jal	800015ec <copyin>
    800027b6:	00a03533          	snez	a0,a0
    800027ba:	40a0053b          	negw	a0,a0
}
    800027be:	60e2                	ld	ra,24(sp)
    800027c0:	6442                	ld	s0,16(sp)
    800027c2:	64a2                	ld	s1,8(sp)
    800027c4:	6902                	ld	s2,0(sp)
    800027c6:	6105                	addi	sp,sp,32
    800027c8:	8082                	ret
    return -1;
    800027ca:	557d                	li	a0,-1
    800027cc:	bfcd                	j	800027be <fetchaddr+0x36>

00000000800027ce <fetchstr>:
{
    800027ce:	7179                	addi	sp,sp,-48
    800027d0:	f406                	sd	ra,40(sp)
    800027d2:	f022                	sd	s0,32(sp)
    800027d4:	ec26                	sd	s1,24(sp)
    800027d6:	e84a                	sd	s2,16(sp)
    800027d8:	e44e                	sd	s3,8(sp)
    800027da:	1800                	addi	s0,sp,48
    800027dc:	89aa                	mv	s3,a0
    800027de:	84ae                	mv	s1,a1
    800027e0:	8932                	mv	s2,a2
  struct proc *p = myproc();
    800027e2:	900ff0ef          	jal	800018e2 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    800027e6:	874a                	mv	a4,s2
    800027e8:	86ce                	mv	a3,s3
    800027ea:	8626                	mv	a2,s1
    800027ec:	652c                	ld	a1,72(a0)
    800027ee:	6928                	ld	a0,80(a0)
    800027f0:	e9bfe0ef          	jal	8000168a <copyinstr>
    800027f4:	00054c63          	bltz	a0,8000280c <fetchstr+0x3e>
  return strlen(buf);
    800027f8:	8526                	mv	a0,s1
    800027fa:	e3afe0ef          	jal	80000e34 <strlen>
}
    800027fe:	70a2                	ld	ra,40(sp)
    80002800:	7402                	ld	s0,32(sp)
    80002802:	64e2                	ld	s1,24(sp)
    80002804:	6942                	ld	s2,16(sp)
    80002806:	69a2                	ld	s3,8(sp)
    80002808:	6145                	addi	sp,sp,48
    8000280a:	8082                	ret
    return -1;
    8000280c:	557d                	li	a0,-1
    8000280e:	bfc5                	j	800027fe <fetchstr+0x30>

0000000080002810 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002810:	1101                	addi	sp,sp,-32
    80002812:	ec06                	sd	ra,24(sp)
    80002814:	e822                	sd	s0,16(sp)
    80002816:	e426                	sd	s1,8(sp)
    80002818:	1000                	addi	s0,sp,32
    8000281a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000281c:	f0dff0ef          	jal	80002728 <argraw>
    80002820:	c088                	sw	a0,0(s1)
}
    80002822:	60e2                	ld	ra,24(sp)
    80002824:	6442                	ld	s0,16(sp)
    80002826:	64a2                	ld	s1,8(sp)
    80002828:	6105                	addi	sp,sp,32
    8000282a:	8082                	ret

000000008000282c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000282c:	1101                	addi	sp,sp,-32
    8000282e:	ec06                	sd	ra,24(sp)
    80002830:	e822                	sd	s0,16(sp)
    80002832:	e426                	sd	s1,8(sp)
    80002834:	1000                	addi	s0,sp,32
    80002836:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002838:	ef1ff0ef          	jal	80002728 <argraw>
    8000283c:	e088                	sd	a0,0(s1)
}
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	64a2                	ld	s1,8(sp)
    80002844:	6105                	addi	sp,sp,32
    80002846:	8082                	ret

0000000080002848 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002848:	1101                	addi	sp,sp,-32
    8000284a:	ec06                	sd	ra,24(sp)
    8000284c:	e822                	sd	s0,16(sp)
    8000284e:	e426                	sd	s1,8(sp)
    80002850:	e04a                	sd	s2,0(sp)
    80002852:	1000                	addi	s0,sp,32
    80002854:	892e                	mv	s2,a1
    80002856:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002858:	ed1ff0ef          	jal	80002728 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    8000285c:	8626                	mv	a2,s1
    8000285e:	85ca                	mv	a1,s2
    80002860:	f6fff0ef          	jal	800027ce <fetchstr>
}
    80002864:	60e2                	ld	ra,24(sp)
    80002866:	6442                	ld	s0,16(sp)
    80002868:	64a2                	ld	s1,8(sp)
    8000286a:	6902                	ld	s2,0(sp)
    8000286c:	6105                	addi	sp,sp,32
    8000286e:	8082                	ret

0000000080002870 <syscall>:
  // clang-format on
};

void
syscall(void)
{
    80002870:	1101                	addi	sp,sp,-32
    80002872:	ec06                	sd	ra,24(sp)
    80002874:	e822                	sd	s0,16(sp)
    80002876:	e426                	sd	s1,8(sp)
    80002878:	e04a                	sd	s2,0(sp)
    8000287a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000287c:	866ff0ef          	jal	800018e2 <myproc>
    80002880:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002882:	05853903          	ld	s2,88(a0)
    80002886:	0a893783          	ld	a5,168(s2)
    8000288a:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000288e:	37fd                	addiw	a5,a5,-1
    80002890:	4755                	li	a4,21
    80002892:	00f76f63          	bltu	a4,a5,800028b0 <syscall+0x40>
    80002896:	00369713          	slli	a4,a3,0x3
    8000289a:	00005797          	auipc	a5,0x5
    8000289e:	ef678793          	addi	a5,a5,-266 # 80007790 <syscalls>
    800028a2:	97ba                	add	a5,a5,a4
    800028a4:	639c                	ld	a5,0(a5)
    800028a6:	c789                	beqz	a5,800028b0 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028a8:	9782                	jalr	a5
    800028aa:	06a93823          	sd	a0,112(s2)
    800028ae:	a829                	j	800028c8 <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800028b0:	15848613          	addi	a2,s1,344
    800028b4:	588c                	lw	a1,48(s1)
    800028b6:	00005517          	auipc	a0,0x5
    800028ba:	ada50513          	addi	a0,a0,-1318 # 80007390 <etext+0x390>
    800028be:	c53fd0ef          	jal	80000510 <printk>
    p->trapframe->a0 = -1;
    800028c2:	6cbc                	ld	a5,88(s1)
    800028c4:	577d                	li	a4,-1
    800028c6:	fbb8                	sd	a4,112(a5)
  }
}
    800028c8:	60e2                	ld	ra,24(sp)
    800028ca:	6442                	ld	s0,16(sp)
    800028cc:	64a2                	ld	s1,8(sp)
    800028ce:	6902                	ld	s2,0(sp)
    800028d0:	6105                	addi	sp,sp,32
    800028d2:	8082                	ret

00000000800028d4 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    800028d4:	1101                	addi	sp,sp,-32
    800028d6:	ec06                	sd	ra,24(sp)
    800028d8:	e822                	sd	s0,16(sp)
    800028da:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800028dc:	fec40593          	addi	a1,s0,-20
    800028e0:	4501                	li	a0,0
    800028e2:	f2fff0ef          	jal	80002810 <argint>
  kexit(n);
    800028e6:	fec42503          	lw	a0,-20(s0)
    800028ea:	f28ff0ef          	jal	80002012 <kexit>
  return 0; // not reached
}
    800028ee:	4501                	li	a0,0
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	6105                	addi	sp,sp,32
    800028f6:	8082                	ret

00000000800028f8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800028f8:	1141                	addi	sp,sp,-16
    800028fa:	e406                	sd	ra,8(sp)
    800028fc:	e022                	sd	s0,0(sp)
    800028fe:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002900:	fe3fe0ef          	jal	800018e2 <myproc>
}
    80002904:	5908                	lw	a0,48(a0)
    80002906:	60a2                	ld	ra,8(sp)
    80002908:	6402                	ld	s0,0(sp)
    8000290a:	0141                	addi	sp,sp,16
    8000290c:	8082                	ret

000000008000290e <sys_fork>:

uint64
sys_fork(void)
{
    8000290e:	1141                	addi	sp,sp,-16
    80002910:	e406                	sd	ra,8(sp)
    80002912:	e022                	sd	s0,0(sp)
    80002914:	0800                	addi	s0,sp,16
  return kfork();
    80002916:	b36ff0ef          	jal	80001c4c <kfork>
}
    8000291a:	60a2                	ld	ra,8(sp)
    8000291c:	6402                	ld	s0,0(sp)
    8000291e:	0141                	addi	sp,sp,16
    80002920:	8082                	ret

0000000080002922 <sys_wait>:

uint64
sys_wait(void)
{
    80002922:	1101                	addi	sp,sp,-32
    80002924:	ec06                	sd	ra,24(sp)
    80002926:	e822                	sd	s0,16(sp)
    80002928:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000292a:	fe840593          	addi	a1,s0,-24
    8000292e:	4501                	li	a0,0
    80002930:	efdff0ef          	jal	8000282c <argaddr>
  return kwait(p);
    80002934:	fe843503          	ld	a0,-24(s0)
    80002938:	835ff0ef          	jal	8000216c <kwait>
}
    8000293c:	60e2                	ld	ra,24(sp)
    8000293e:	6442                	ld	s0,16(sp)
    80002940:	6105                	addi	sp,sp,32
    80002942:	8082                	ret

0000000080002944 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002944:	7179                	addi	sp,sp,-48
    80002946:	f406                	sd	ra,40(sp)
    80002948:	f022                	sd	s0,32(sp)
    8000294a:	ec26                	sd	s1,24(sp)
    8000294c:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    8000294e:	fd840593          	addi	a1,s0,-40
    80002952:	4501                	li	a0,0
    80002954:	ebdff0ef          	jal	80002810 <argint>
  argint(1, &t);
    80002958:	fdc40593          	addi	a1,s0,-36
    8000295c:	4505                	li	a0,1
    8000295e:	eb3ff0ef          	jal	80002810 <argint>
  addr = myproc()->sz;
    80002962:	f81fe0ef          	jal	800018e2 <myproc>
    80002966:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002968:	fdc42703          	lw	a4,-36(s0)
    8000296c:	4785                	li	a5,1
    8000296e:	02f70a63          	beq	a4,a5,800029a2 <sys_sbrk+0x5e>
    80002972:	fd842783          	lw	a5,-40(s0)
    80002976:	0207c663          	bltz	a5,800029a2 <sys_sbrk+0x5e>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    8000297a:	00978733          	add	a4,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    8000297e:	020007b7          	lui	a5,0x2000
    80002982:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002984:	07b6                	slli	a5,a5,0xd
    80002986:	00e7b7b3          	sltu	a5,a5,a4
    if (addr + n < addr)
    8000298a:	00973733          	sltu	a4,a4,s1
    if (addr + n > TRAPFRAME)
    8000298e:	8fd9                	or	a5,a5,a4
    80002990:	e79d                	bnez	a5,800029be <sys_sbrk+0x7a>
      return -1;
    myproc()->sz += n;
    80002992:	f51fe0ef          	jal	800018e2 <myproc>
    80002996:	fd842703          	lw	a4,-40(s0)
    8000299a:	653c                	ld	a5,72(a0)
    8000299c:	97ba                	add	a5,a5,a4
    8000299e:	e53c                	sd	a5,72(a0)
    800029a0:	a039                	j	800029ae <sys_sbrk+0x6a>
    if (growproc(n) < 0) {
    800029a2:	fd842503          	lw	a0,-40(s0)
    800029a6:	a48ff0ef          	jal	80001bee <growproc>
    800029aa:	00054863          	bltz	a0,800029ba <sys_sbrk+0x76>
  }
  return addr;
}
    800029ae:	8526                	mv	a0,s1
    800029b0:	70a2                	ld	ra,40(sp)
    800029b2:	7402                	ld	s0,32(sp)
    800029b4:	64e2                	ld	s1,24(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret
      return -1;
    800029ba:	54fd                	li	s1,-1
    800029bc:	bfcd                	j	800029ae <sys_sbrk+0x6a>
      return -1;
    800029be:	54fd                	li	s1,-1
    800029c0:	b7fd                	j	800029ae <sys_sbrk+0x6a>

00000000800029c2 <sys_pause>:

uint64
sys_pause(void)
{
    800029c2:	7139                	addi	sp,sp,-64
    800029c4:	fc06                	sd	ra,56(sp)
    800029c6:	f822                	sd	s0,48(sp)
    800029c8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029ca:	fcc40593          	addi	a1,s0,-52
    800029ce:	4501                	li	a0,0
    800029d0:	e41ff0ef          	jal	80002810 <argint>
  if (n < 0)
    800029d4:	fcc42783          	lw	a5,-52(s0)
    800029d8:	0807c063          	bltz	a5,80002a58 <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    800029dc:	00013517          	auipc	a0,0x13
    800029e0:	df450513          	addi	a0,a0,-524 # 800157d0 <tickslock>
    800029e4:	a14fe0ef          	jal	80000bf8 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    800029e8:	fcc42783          	lw	a5,-52(s0)
    800029ec:	cbb9                	beqz	a5,80002a42 <sys_pause+0x80>
    800029ee:	f426                	sd	s1,40(sp)
    800029f0:	f04a                	sd	s2,32(sp)
    800029f2:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    800029f4:	00005997          	auipc	s3,0x5
    800029f8:	e8c9a983          	lw	s3,-372(s3) # 80007880 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    800029fc:	00005917          	auipc	s2,0x5
    80002a00:	e8490913          	addi	s2,s2,-380 # 80007880 <ticks>
    release(&tickslock);
    80002a04:	00013497          	auipc	s1,0x13
    80002a08:	dcc48493          	addi	s1,s1,-564 # 800157d0 <tickslock>
    if (killed(myproc())) {
    80002a0c:	ed7fe0ef          	jal	800018e2 <myproc>
    80002a10:	f32ff0ef          	jal	80002142 <killed>
    80002a14:	e529                	bnez	a0,80002a5e <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002a16:	854a                	mv	a0,s2
    80002a18:	cd2ff0ef          	jal	80001eea <sleep_prepare>
    release(&tickslock);
    80002a1c:	8526                	mv	a0,s1
    80002a1e:	a5efe0ef          	jal	80000c7c <release>
    sleep();
    80002a22:	d04ff0ef          	jal	80001f26 <sleep>
    acquire(&tickslock);
    80002a26:	8526                	mv	a0,s1
    80002a28:	9d0fe0ef          	jal	80000bf8 <acquire>
  while (ticks - ticks0 < n) {
    80002a2c:	00092783          	lw	a5,0(s2)
    80002a30:	413787bb          	subw	a5,a5,s3
    80002a34:	fcc42703          	lw	a4,-52(s0)
    80002a38:	fce7eae3          	bltu	a5,a4,80002a0c <sys_pause+0x4a>
    80002a3c:	74a2                	ld	s1,40(sp)
    80002a3e:	7902                	ld	s2,32(sp)
    80002a40:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a42:	00013517          	auipc	a0,0x13
    80002a46:	d8e50513          	addi	a0,a0,-626 # 800157d0 <tickslock>
    80002a4a:	a32fe0ef          	jal	80000c7c <release>
  return 0;
    80002a4e:	4501                	li	a0,0
}
    80002a50:	70e2                	ld	ra,56(sp)
    80002a52:	7442                	ld	s0,48(sp)
    80002a54:	6121                	addi	sp,sp,64
    80002a56:	8082                	ret
    n = 0;
    80002a58:	fc042623          	sw	zero,-52(s0)
    80002a5c:	b741                	j	800029dc <sys_pause+0x1a>
      release(&tickslock);
    80002a5e:	00013517          	auipc	a0,0x13
    80002a62:	d7250513          	addi	a0,a0,-654 # 800157d0 <tickslock>
    80002a66:	a16fe0ef          	jal	80000c7c <release>
      return -1;
    80002a6a:	557d                	li	a0,-1
    80002a6c:	74a2                	ld	s1,40(sp)
    80002a6e:	7902                	ld	s2,32(sp)
    80002a70:	69e2                	ld	s3,24(sp)
    80002a72:	bff9                	j	80002a50 <sys_pause+0x8e>

0000000080002a74 <sys_kill>:

uint64
sys_kill(void)
{
    80002a74:	1101                	addi	sp,sp,-32
    80002a76:	ec06                	sd	ra,24(sp)
    80002a78:	e822                	sd	s0,16(sp)
    80002a7a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a7c:	fec40593          	addi	a1,s0,-20
    80002a80:	4501                	li	a0,0
    80002a82:	d8fff0ef          	jal	80002810 <argint>
  return kkill(pid);
    80002a86:	fec42503          	lw	a0,-20(s0)
    80002a8a:	e2eff0ef          	jal	800020b8 <kkill>
}
    80002a8e:	60e2                	ld	ra,24(sp)
    80002a90:	6442                	ld	s0,16(sp)
    80002a92:	6105                	addi	sp,sp,32
    80002a94:	8082                	ret

0000000080002a96 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a96:	1101                	addi	sp,sp,-32
    80002a98:	ec06                	sd	ra,24(sp)
    80002a9a:	e822                	sd	s0,16(sp)
    80002a9c:	e426                	sd	s1,8(sp)
    80002a9e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002aa0:	00013517          	auipc	a0,0x13
    80002aa4:	d3050513          	addi	a0,a0,-720 # 800157d0 <tickslock>
    80002aa8:	950fe0ef          	jal	80000bf8 <acquire>
  xticks = ticks;
    80002aac:	00005797          	auipc	a5,0x5
    80002ab0:	dd47a783          	lw	a5,-556(a5) # 80007880 <ticks>
    80002ab4:	84be                	mv	s1,a5
  release(&tickslock);
    80002ab6:	00013517          	auipc	a0,0x13
    80002aba:	d1a50513          	addi	a0,a0,-742 # 800157d0 <tickslock>
    80002abe:	9befe0ef          	jal	80000c7c <release>
  return xticks;
}
    80002ac2:	02049513          	slli	a0,s1,0x20
    80002ac6:	9101                	srli	a0,a0,0x20
    80002ac8:	60e2                	ld	ra,24(sp)
    80002aca:	6442                	ld	s0,16(sp)
    80002acc:	64a2                	ld	s1,8(sp)
    80002ace:	6105                	addi	sp,sp,32
    80002ad0:	8082                	ret

0000000080002ad2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ad2:	7179                	addi	sp,sp,-48
    80002ad4:	f406                	sd	ra,40(sp)
    80002ad6:	f022                	sd	s0,32(sp)
    80002ad8:	ec26                	sd	s1,24(sp)
    80002ada:	e84a                	sd	s2,16(sp)
    80002adc:	e44e                	sd	s3,8(sp)
    80002ade:	e052                	sd	s4,0(sp)
    80002ae0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ae2:	00005597          	auipc	a1,0x5
    80002ae6:	8ce58593          	addi	a1,a1,-1842 # 800073b0 <etext+0x3b0>
    80002aea:	00013517          	auipc	a0,0x13
    80002aee:	cfe50513          	addi	a0,a0,-770 # 800157e8 <bcache>
    80002af2:	886fe0ef          	jal	80000b78 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002af6:	0001b797          	auipc	a5,0x1b
    80002afa:	cf278793          	addi	a5,a5,-782 # 8001d7e8 <bcache+0x8000>
    80002afe:	0001b717          	auipc	a4,0x1b
    80002b02:	f5270713          	addi	a4,a4,-174 # 8001da50 <bcache+0x8268>
    80002b06:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b0a:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002b0e:	00013497          	auipc	s1,0x13
    80002b12:	cf248493          	addi	s1,s1,-782 # 80015800 <bcache+0x18>
    b->next = bcache.head.next;
    80002b16:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b18:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b1a:	00005a17          	auipc	s4,0x5
    80002b1e:	89ea0a13          	addi	s4,s4,-1890 # 800073b8 <etext+0x3b8>
    b->next = bcache.head.next;
    80002b22:	2b893783          	ld	a5,696(s2)
    80002b26:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b28:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b2c:	85d2                	mv	a1,s4
    80002b2e:	01048513          	addi	a0,s1,16
    80002b32:	41a010ef          	jal	80003f4c <initsleeplock>
    bcache.head.next->prev = b;
    80002b36:	2b893783          	ld	a5,696(s2)
    80002b3a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b3c:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002b40:	45848493          	addi	s1,s1,1112
    80002b44:	fd349fe3          	bne	s1,s3,80002b22 <binit+0x50>
  }
}
    80002b48:	70a2                	ld	ra,40(sp)
    80002b4a:	7402                	ld	s0,32(sp)
    80002b4c:	64e2                	ld	s1,24(sp)
    80002b4e:	6942                	ld	s2,16(sp)
    80002b50:	69a2                	ld	s3,8(sp)
    80002b52:	6a02                	ld	s4,0(sp)
    80002b54:	6145                	addi	sp,sp,48
    80002b56:	8082                	ret

0000000080002b58 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002b58:	7179                	addi	sp,sp,-48
    80002b5a:	f406                	sd	ra,40(sp)
    80002b5c:	f022                	sd	s0,32(sp)
    80002b5e:	ec26                	sd	s1,24(sp)
    80002b60:	e84a                	sd	s2,16(sp)
    80002b62:	e44e                	sd	s3,8(sp)
    80002b64:	1800                	addi	s0,sp,48
    80002b66:	892a                	mv	s2,a0
    80002b68:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b6a:	00013517          	auipc	a0,0x13
    80002b6e:	c7e50513          	addi	a0,a0,-898 # 800157e8 <bcache>
    80002b72:	886fe0ef          	jal	80000bf8 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002b76:	0001b497          	auipc	s1,0x1b
    80002b7a:	f2a4b483          	ld	s1,-214(s1) # 8001daa0 <bcache+0x82b8>
    80002b7e:	0001b797          	auipc	a5,0x1b
    80002b82:	ed278793          	addi	a5,a5,-302 # 8001da50 <bcache+0x8268>
    80002b86:	02f48b63          	beq	s1,a5,80002bbc <bread+0x64>
    80002b8a:	873e                	mv	a4,a5
    80002b8c:	a021                	j	80002b94 <bread+0x3c>
    80002b8e:	68a4                	ld	s1,80(s1)
    80002b90:	02e48663          	beq	s1,a4,80002bbc <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002b94:	449c                	lw	a5,8(s1)
    80002b96:	ff279ce3          	bne	a5,s2,80002b8e <bread+0x36>
    80002b9a:	44dc                	lw	a5,12(s1)
    80002b9c:	ff3799e3          	bne	a5,s3,80002b8e <bread+0x36>
      b->refcnt++;
    80002ba0:	40bc                	lw	a5,64(s1)
    80002ba2:	2785                	addiw	a5,a5,1
    80002ba4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ba6:	00013517          	auipc	a0,0x13
    80002baa:	c4250513          	addi	a0,a0,-958 # 800157e8 <bcache>
    80002bae:	8cefe0ef          	jal	80000c7c <release>
      acquiresleep(&b->lock);
    80002bb2:	01048513          	addi	a0,s1,16
    80002bb6:	3cc010ef          	jal	80003f82 <acquiresleep>
      return b;
    80002bba:	a889                	j	80002c0c <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002bbc:	0001b497          	auipc	s1,0x1b
    80002bc0:	edc4b483          	ld	s1,-292(s1) # 8001da98 <bcache+0x82b0>
    80002bc4:	0001b797          	auipc	a5,0x1b
    80002bc8:	e8c78793          	addi	a5,a5,-372 # 8001da50 <bcache+0x8268>
    80002bcc:	00f48863          	beq	s1,a5,80002bdc <bread+0x84>
    80002bd0:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002bd2:	40bc                	lw	a5,64(s1)
    80002bd4:	cb91                	beqz	a5,80002be8 <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002bd6:	64a4                	ld	s1,72(s1)
    80002bd8:	fee49de3          	bne	s1,a4,80002bd2 <bread+0x7a>
  panic("bget: no buffers");
    80002bdc:	00004517          	auipc	a0,0x4
    80002be0:	7e450513          	addi	a0,a0,2020 # 800073c0 <etext+0x3c0>
    80002be4:	c65fd0ef          	jal	80000848 <panic>
      b->dev = dev;
    80002be8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002bec:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002bf0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002bf4:	4785                	li	a5,1
    80002bf6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bf8:	00013517          	auipc	a0,0x13
    80002bfc:	bf050513          	addi	a0,a0,-1040 # 800157e8 <bcache>
    80002c00:	87cfe0ef          	jal	80000c7c <release>
      acquiresleep(&b->lock);
    80002c04:	01048513          	addi	a0,s1,16
    80002c08:	37a010ef          	jal	80003f82 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002c0c:	409c                	lw	a5,0(s1)
    80002c0e:	cb89                	beqz	a5,80002c20 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c10:	8526                	mv	a0,s1
    80002c12:	70a2                	ld	ra,40(sp)
    80002c14:	7402                	ld	s0,32(sp)
    80002c16:	64e2                	ld	s1,24(sp)
    80002c18:	6942                	ld	s2,16(sp)
    80002c1a:	69a2                	ld	s3,8(sp)
    80002c1c:	6145                	addi	sp,sp,48
    80002c1e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c20:	4581                	li	a1,0
    80002c22:	8526                	mv	a0,s1
    80002c24:	3ef020ef          	jal	80005812 <virtio_disk_rw>
    b->valid = 1;
    80002c28:	4785                	li	a5,1
    80002c2a:	c09c                	sw	a5,0(s1)
  return b;
    80002c2c:	b7d5                	j	80002c10 <bread+0xb8>

0000000080002c2e <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002c2e:	1101                	addi	sp,sp,-32
    80002c30:	ec06                	sd	ra,24(sp)
    80002c32:	e822                	sd	s0,16(sp)
    80002c34:	e426                	sd	s1,8(sp)
    80002c36:	1000                	addi	s0,sp,32
    80002c38:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002c3a:	0541                	addi	a0,a0,16
    80002c3c:	3d2010ef          	jal	8000400e <holdingsleep>
    80002c40:	c911                	beqz	a0,80002c54 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c42:	4585                	li	a1,1
    80002c44:	8526                	mv	a0,s1
    80002c46:	3cd020ef          	jal	80005812 <virtio_disk_rw>
}
    80002c4a:	60e2                	ld	ra,24(sp)
    80002c4c:	6442                	ld	s0,16(sp)
    80002c4e:	64a2                	ld	s1,8(sp)
    80002c50:	6105                	addi	sp,sp,32
    80002c52:	8082                	ret
    panic("bwrite");
    80002c54:	00004517          	auipc	a0,0x4
    80002c58:	78450513          	addi	a0,a0,1924 # 800073d8 <etext+0x3d8>
    80002c5c:	bedfd0ef          	jal	80000848 <panic>

0000000080002c60 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	e04a                	sd	s2,0(sp)
    80002c6a:	1000                	addi	s0,sp,32
    80002c6c:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002c6e:	01050913          	addi	s2,a0,16
    80002c72:	854a                	mv	a0,s2
    80002c74:	39a010ef          	jal	8000400e <holdingsleep>
    80002c78:	c125                	beqz	a0,80002cd8 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	35a010ef          	jal	80003fd6 <releasesleep>

  acquire(&bcache.lock);
    80002c80:	00013517          	auipc	a0,0x13
    80002c84:	b6850513          	addi	a0,a0,-1176 # 800157e8 <bcache>
    80002c88:	f71fd0ef          	jal	80000bf8 <acquire>
  b->refcnt--;
    80002c8c:	40bc                	lw	a5,64(s1)
    80002c8e:	37fd                	addiw	a5,a5,-1
    80002c90:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002c92:	e79d                	bnez	a5,80002cc0 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002c94:	68b8                	ld	a4,80(s1)
    80002c96:	64bc                	ld	a5,72(s1)
    80002c98:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002c9a:	68b8                	ld	a4,80(s1)
    80002c9c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002c9e:	0001b797          	auipc	a5,0x1b
    80002ca2:	b4a78793          	addi	a5,a5,-1206 # 8001d7e8 <bcache+0x8000>
    80002ca6:	2b87b703          	ld	a4,696(a5)
    80002caa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002cac:	0001b717          	auipc	a4,0x1b
    80002cb0:	da470713          	addi	a4,a4,-604 # 8001da50 <bcache+0x8268>
    80002cb4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cb6:	2b87b703          	ld	a4,696(a5)
    80002cba:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002cbc:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002cc0:	00013517          	auipc	a0,0x13
    80002cc4:	b2850513          	addi	a0,a0,-1240 # 800157e8 <bcache>
    80002cc8:	fb5fd0ef          	jal	80000c7c <release>
}
    80002ccc:	60e2                	ld	ra,24(sp)
    80002cce:	6442                	ld	s0,16(sp)
    80002cd0:	64a2                	ld	s1,8(sp)
    80002cd2:	6902                	ld	s2,0(sp)
    80002cd4:	6105                	addi	sp,sp,32
    80002cd6:	8082                	ret
    panic("brelse");
    80002cd8:	00004517          	auipc	a0,0x4
    80002cdc:	70850513          	addi	a0,a0,1800 # 800073e0 <etext+0x3e0>
    80002ce0:	b69fd0ef          	jal	80000848 <panic>

0000000080002ce4 <bpin>:

void
bpin(struct buf *b)
{
    80002ce4:	1101                	addi	sp,sp,-32
    80002ce6:	ec06                	sd	ra,24(sp)
    80002ce8:	e822                	sd	s0,16(sp)
    80002cea:	e426                	sd	s1,8(sp)
    80002cec:	1000                	addi	s0,sp,32
    80002cee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cf0:	00013517          	auipc	a0,0x13
    80002cf4:	af850513          	addi	a0,a0,-1288 # 800157e8 <bcache>
    80002cf8:	f01fd0ef          	jal	80000bf8 <acquire>
  b->refcnt++;
    80002cfc:	40bc                	lw	a5,64(s1)
    80002cfe:	2785                	addiw	a5,a5,1
    80002d00:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d02:	00013517          	auipc	a0,0x13
    80002d06:	ae650513          	addi	a0,a0,-1306 # 800157e8 <bcache>
    80002d0a:	f73fd0ef          	jal	80000c7c <release>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret

0000000080002d18 <bunpin>:

void
bunpin(struct buf *b)
{
    80002d18:	1101                	addi	sp,sp,-32
    80002d1a:	ec06                	sd	ra,24(sp)
    80002d1c:	e822                	sd	s0,16(sp)
    80002d1e:	e426                	sd	s1,8(sp)
    80002d20:	1000                	addi	s0,sp,32
    80002d22:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d24:	00013517          	auipc	a0,0x13
    80002d28:	ac450513          	addi	a0,a0,-1340 # 800157e8 <bcache>
    80002d2c:	ecdfd0ef          	jal	80000bf8 <acquire>
  b->refcnt--;
    80002d30:	40bc                	lw	a5,64(s1)
    80002d32:	37fd                	addiw	a5,a5,-1
    80002d34:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d36:	00013517          	auipc	a0,0x13
    80002d3a:	ab250513          	addi	a0,a0,-1358 # 800157e8 <bcache>
    80002d3e:	f3ffd0ef          	jal	80000c7c <release>
}
    80002d42:	60e2                	ld	ra,24(sp)
    80002d44:	6442                	ld	s0,16(sp)
    80002d46:	64a2                	ld	s1,8(sp)
    80002d48:	6105                	addi	sp,sp,32
    80002d4a:	8082                	ret

0000000080002d4c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	e426                	sd	s1,8(sp)
    80002d54:	e04a                	sd	s2,0(sp)
    80002d56:	1000                	addi	s0,sp,32
    80002d58:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d5a:	00d5d79b          	srliw	a5,a1,0xd
    80002d5e:	0001b597          	auipc	a1,0x1b
    80002d62:	1665a583          	lw	a1,358(a1) # 8001dec4 <sb+0x1c>
    80002d66:	9dbd                	addw	a1,a1,a5
    80002d68:	df1ff0ef          	jal	80002b58 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d6c:	0074f713          	andi	a4,s1,7
    80002d70:	4785                	li	a5,1
    80002d72:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002d76:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002d78:	90d9                	srli	s1,s1,0x36
    80002d7a:	00950733          	add	a4,a0,s1
    80002d7e:	05874703          	lbu	a4,88(a4)
    80002d82:	00e7f6b3          	and	a3,a5,a4
    80002d86:	c29d                	beqz	a3,80002dac <bfree+0x60>
    80002d88:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002d8a:	94aa                	add	s1,s1,a0
    80002d8c:	fff7c793          	not	a5,a5
    80002d90:	8f7d                	and	a4,a4,a5
    80002d92:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002d96:	082010ef          	jal	80003e18 <log_write>
  brelse(bp);
    80002d9a:	854a                	mv	a0,s2
    80002d9c:	ec5ff0ef          	jal	80002c60 <brelse>
}
    80002da0:	60e2                	ld	ra,24(sp)
    80002da2:	6442                	ld	s0,16(sp)
    80002da4:	64a2                	ld	s1,8(sp)
    80002da6:	6902                	ld	s2,0(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret
    panic("freeing free block");
    80002dac:	00004517          	auipc	a0,0x4
    80002db0:	63c50513          	addi	a0,a0,1596 # 800073e8 <etext+0x3e8>
    80002db4:	a95fd0ef          	jal	80000848 <panic>

0000000080002db8 <balloc>:
{
    80002db8:	715d                	addi	sp,sp,-80
    80002dba:	e486                	sd	ra,72(sp)
    80002dbc:	e0a2                	sd	s0,64(sp)
    80002dbe:	fc26                	sd	s1,56(sp)
    80002dc0:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002dc2:	0001b797          	auipc	a5,0x1b
    80002dc6:	0ea7a783          	lw	a5,234(a5) # 8001deac <sb+0x4>
    80002dca:	0e078263          	beqz	a5,80002eae <balloc+0xf6>
    80002dce:	f84a                	sd	s2,48(sp)
    80002dd0:	f44e                	sd	s3,40(sp)
    80002dd2:	f052                	sd	s4,32(sp)
    80002dd4:	ec56                	sd	s5,24(sp)
    80002dd6:	e85a                	sd	s6,16(sp)
    80002dd8:	e45e                	sd	s7,8(sp)
    80002dda:	e062                	sd	s8,0(sp)
    80002ddc:	8baa                	mv	s7,a0
    80002dde:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002de0:	0001bb17          	auipc	s6,0x1b
    80002de4:	0c8b0b13          	addi	s6,s6,200 # 8001dea8 <sb>
      m = 1 << (bi % 8);
    80002de8:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002dea:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002dec:	6c09                	lui	s8,0x2
    80002dee:	a09d                	j	80002e54 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002df0:	97ca                	add	a5,a5,s2
    80002df2:	8e55                	or	a2,a2,a3
    80002df4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002df8:	854a                	mv	a0,s2
    80002dfa:	01e010ef          	jal	80003e18 <log_write>
        brelse(bp);
    80002dfe:	854a                	mv	a0,s2
    80002e00:	e61ff0ef          	jal	80002c60 <brelse>
  bp = bread(dev, bno);
    80002e04:	85a6                	mv	a1,s1
    80002e06:	855e                	mv	a0,s7
    80002e08:	d51ff0ef          	jal	80002b58 <bread>
    80002e0c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e0e:	40000613          	li	a2,1024
    80002e12:	4581                	li	a1,0
    80002e14:	05850513          	addi	a0,a0,88
    80002e18:	e9dfd0ef          	jal	80000cb4 <memset>
  log_write(bp);
    80002e1c:	854a                	mv	a0,s2
    80002e1e:	7fb000ef          	jal	80003e18 <log_write>
  brelse(bp);
    80002e22:	854a                	mv	a0,s2
    80002e24:	e3dff0ef          	jal	80002c60 <brelse>
        return b + bi;
    80002e28:	7942                	ld	s2,48(sp)
    80002e2a:	79a2                	ld	s3,40(sp)
    80002e2c:	7a02                	ld	s4,32(sp)
    80002e2e:	6ae2                	ld	s5,24(sp)
    80002e30:	6b42                	ld	s6,16(sp)
    80002e32:	6ba2                	ld	s7,8(sp)
    80002e34:	6c02                	ld	s8,0(sp)
}
    80002e36:	8526                	mv	a0,s1
    80002e38:	60a6                	ld	ra,72(sp)
    80002e3a:	6406                	ld	s0,64(sp)
    80002e3c:	74e2                	ld	s1,56(sp)
    80002e3e:	6161                	addi	sp,sp,80
    80002e40:	8082                	ret
    brelse(bp);
    80002e42:	854a                	mv	a0,s2
    80002e44:	e1dff0ef          	jal	80002c60 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002e48:	015c0abb          	addw	s5,s8,s5
    80002e4c:	004b2783          	lw	a5,4(s6)
    80002e50:	04faf863          	bgeu	s5,a5,80002ea0 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002e54:	40dad59b          	sraiw	a1,s5,0xd
    80002e58:	01cb2783          	lw	a5,28(s6)
    80002e5c:	9dbd                	addw	a1,a1,a5
    80002e5e:	855e                	mv	a0,s7
    80002e60:	cf9ff0ef          	jal	80002b58 <bread>
    80002e64:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002e66:	004b2503          	lw	a0,4(s6)
    80002e6a:	84d6                	mv	s1,s5
    80002e6c:	4701                	li	a4,0
    80002e6e:	fca4fae3          	bgeu	s1,a0,80002e42 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002e72:	00777693          	andi	a3,a4,7
    80002e76:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80002e7a:	41f7579b          	sraiw	a5,a4,0x1f
    80002e7e:	01d7d79b          	srliw	a5,a5,0x1d
    80002e82:	9fb9                	addw	a5,a5,a4
    80002e84:	4037d79b          	sraiw	a5,a5,0x3
    80002e88:	00f90633          	add	a2,s2,a5
    80002e8c:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002e90:	00c6f5b3          	and	a1,a3,a2
    80002e94:	ddb1                	beqz	a1,80002df0 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002e96:	2705                	addiw	a4,a4,1
    80002e98:	2485                	addiw	s1,s1,1
    80002e9a:	fd471ae3          	bne	a4,s4,80002e6e <balloc+0xb6>
    80002e9e:	b755                	j	80002e42 <balloc+0x8a>
    80002ea0:	7942                	ld	s2,48(sp)
    80002ea2:	79a2                	ld	s3,40(sp)
    80002ea4:	7a02                	ld	s4,32(sp)
    80002ea6:	6ae2                	ld	s5,24(sp)
    80002ea8:	6b42                	ld	s6,16(sp)
    80002eaa:	6ba2                	ld	s7,8(sp)
    80002eac:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80002eae:	00004517          	auipc	a0,0x4
    80002eb2:	55250513          	addi	a0,a0,1362 # 80007400 <etext+0x400>
    80002eb6:	e5afd0ef          	jal	80000510 <printk>
  return 0;
    80002eba:	4481                	li	s1,0
    80002ebc:	bfad                	j	80002e36 <balloc+0x7e>

0000000080002ebe <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ebe:	7179                	addi	sp,sp,-48
    80002ec0:	f406                	sd	ra,40(sp)
    80002ec2:	f022                	sd	s0,32(sp)
    80002ec4:	ec26                	sd	s1,24(sp)
    80002ec6:	e84a                	sd	s2,16(sp)
    80002ec8:	e44e                	sd	s3,8(sp)
    80002eca:	1800                	addi	s0,sp,48
    80002ecc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002ece:	47ad                	li	a5,11
    80002ed0:	02b7e363          	bltu	a5,a1,80002ef6 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80002ed4:	02059793          	slli	a5,a1,0x20
    80002ed8:	01e7d593          	srli	a1,a5,0x1e
    80002edc:	00b509b3          	add	s3,a0,a1
    80002ee0:	0509a483          	lw	s1,80(s3)
    80002ee4:	e0b5                	bnez	s1,80002f48 <bmap+0x8a>
      addr = balloc(ip->dev);
    80002ee6:	4108                	lw	a0,0(a0)
    80002ee8:	ed1ff0ef          	jal	80002db8 <balloc>
    80002eec:	84aa                	mv	s1,a0
      if (addr == 0)
    80002eee:	cd29                	beqz	a0,80002f48 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002ef0:	04a9a823          	sw	a0,80(s3)
    80002ef4:	a891                	j	80002f48 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002ef6:	ff45879b          	addiw	a5,a1,-12
    80002efa:	873e                	mv	a4,a5
    80002efc:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80002efe:	0ff00793          	li	a5,255
    80002f02:	06e7e763          	bltu	a5,a4,80002f70 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002f06:	08052483          	lw	s1,128(a0)
    80002f0a:	e891                	bnez	s1,80002f1e <bmap+0x60>
      addr = balloc(ip->dev);
    80002f0c:	4108                	lw	a0,0(a0)
    80002f0e:	eabff0ef          	jal	80002db8 <balloc>
    80002f12:	84aa                	mv	s1,a0
      if (addr == 0)
    80002f14:	c915                	beqz	a0,80002f48 <bmap+0x8a>
    80002f16:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f18:	08a92023          	sw	a0,128(s2)
    80002f1c:	a011                	j	80002f20 <bmap+0x62>
    80002f1e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f20:	85a6                	mv	a1,s1
    80002f22:	00092503          	lw	a0,0(s2)
    80002f26:	c33ff0ef          	jal	80002b58 <bread>
    80002f2a:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002f2c:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002f30:	02099713          	slli	a4,s3,0x20
    80002f34:	01e75593          	srli	a1,a4,0x1e
    80002f38:	97ae                	add	a5,a5,a1
    80002f3a:	89be                	mv	s3,a5
    80002f3c:	4384                	lw	s1,0(a5)
    80002f3e:	cc89                	beqz	s1,80002f58 <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f40:	8552                	mv	a0,s4
    80002f42:	d1fff0ef          	jal	80002c60 <brelse>
    return addr;
    80002f46:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f48:	8526                	mv	a0,s1
    80002f4a:	70a2                	ld	ra,40(sp)
    80002f4c:	7402                	ld	s0,32(sp)
    80002f4e:	64e2                	ld	s1,24(sp)
    80002f50:	6942                	ld	s2,16(sp)
    80002f52:	69a2                	ld	s3,8(sp)
    80002f54:	6145                	addi	sp,sp,48
    80002f56:	8082                	ret
      addr = balloc(ip->dev);
    80002f58:	00092503          	lw	a0,0(s2)
    80002f5c:	e5dff0ef          	jal	80002db8 <balloc>
    80002f60:	84aa                	mv	s1,a0
      if (addr) {
    80002f62:	dd79                	beqz	a0,80002f40 <bmap+0x82>
        a[bn] = addr;
    80002f64:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002f68:	8552                	mv	a0,s4
    80002f6a:	6af000ef          	jal	80003e18 <log_write>
    80002f6e:	bfc9                	j	80002f40 <bmap+0x82>
    80002f70:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002f72:	00004517          	auipc	a0,0x4
    80002f76:	4a650513          	addi	a0,a0,1190 # 80007418 <etext+0x418>
    80002f7a:	8cffd0ef          	jal	80000848 <panic>

0000000080002f7e <iget>:
{
    80002f7e:	7179                	addi	sp,sp,-48
    80002f80:	f406                	sd	ra,40(sp)
    80002f82:	f022                	sd	s0,32(sp)
    80002f84:	ec26                	sd	s1,24(sp)
    80002f86:	e84a                	sd	s2,16(sp)
    80002f88:	e44e                	sd	s3,8(sp)
    80002f8a:	e052                	sd	s4,0(sp)
    80002f8c:	1800                	addi	s0,sp,48
    80002f8e:	89aa                	mv	s3,a0
    80002f90:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f92:	0001b517          	auipc	a0,0x1b
    80002f96:	f3650513          	addi	a0,a0,-202 # 8001dec8 <itable>
    80002f9a:	c5ffd0ef          	jal	80000bf8 <acquire>
  empty = 0;
    80002f9e:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002fa0:	0001b497          	auipc	s1,0x1b
    80002fa4:	f4048493          	addi	s1,s1,-192 # 8001dee0 <itable+0x18>
    80002fa8:	0001d697          	auipc	a3,0x1d
    80002fac:	9c868693          	addi	a3,a3,-1592 # 8001f970 <log>
    80002fb0:	a819                	j	80002fc6 <iget+0x48>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002fb2:	0017b793          	seqz	a5,a5
    80002fb6:	00193713          	seqz	a4,s2
    80002fba:	8ff9                	and	a5,a5,a4
    80002fbc:	eb85                	bnez	a5,80002fec <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002fbe:	08848493          	addi	s1,s1,136
    80002fc2:	02d48763          	beq	s1,a3,80002ff0 <iget+0x72>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002fc6:	449c                	lw	a5,8(s1)
    80002fc8:	fef055e3          	blez	a5,80002fb2 <iget+0x34>
    80002fcc:	4098                	lw	a4,0(s1)
    80002fce:	ff3718e3          	bne	a4,s3,80002fbe <iget+0x40>
    80002fd2:	40d8                	lw	a4,4(s1)
    80002fd4:	ff4715e3          	bne	a4,s4,80002fbe <iget+0x40>
      ip->ref++;
    80002fd8:	2785                	addiw	a5,a5,1
    80002fda:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002fdc:	0001b517          	auipc	a0,0x1b
    80002fe0:	eec50513          	addi	a0,a0,-276 # 8001dec8 <itable>
    80002fe4:	c99fd0ef          	jal	80000c7c <release>
      return ip;
    80002fe8:	8926                	mv	s2,s1
    80002fea:	a025                	j	80003012 <iget+0x94>
      empty = ip;
    80002fec:	8926                	mv	s2,s1
    80002fee:	bfc1                	j	80002fbe <iget+0x40>
  if (empty == 0)
    80002ff0:	02090a63          	beqz	s2,80003024 <iget+0xa6>
  ip->dev = dev;
    80002ff4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ff8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ffc:	4785                	li	a5,1
    80002ffe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003002:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003006:	0001b517          	auipc	a0,0x1b
    8000300a:	ec250513          	addi	a0,a0,-318 # 8001dec8 <itable>
    8000300e:	c6ffd0ef          	jal	80000c7c <release>
}
    80003012:	854a                	mv	a0,s2
    80003014:	70a2                	ld	ra,40(sp)
    80003016:	7402                	ld	s0,32(sp)
    80003018:	64e2                	ld	s1,24(sp)
    8000301a:	6942                	ld	s2,16(sp)
    8000301c:	69a2                	ld	s3,8(sp)
    8000301e:	6a02                	ld	s4,0(sp)
    80003020:	6145                	addi	sp,sp,48
    80003022:	8082                	ret
    panic("iget: no inodes");
    80003024:	00004517          	auipc	a0,0x4
    80003028:	40c50513          	addi	a0,a0,1036 # 80007430 <etext+0x430>
    8000302c:	81dfd0ef          	jal	80000848 <panic>

0000000080003030 <iinit>:
{
    80003030:	7179                	addi	sp,sp,-48
    80003032:	f406                	sd	ra,40(sp)
    80003034:	f022                	sd	s0,32(sp)
    80003036:	ec26                	sd	s1,24(sp)
    80003038:	e84a                	sd	s2,16(sp)
    8000303a:	e44e                	sd	s3,8(sp)
    8000303c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000303e:	00004597          	auipc	a1,0x4
    80003042:	40258593          	addi	a1,a1,1026 # 80007440 <etext+0x440>
    80003046:	0001b517          	auipc	a0,0x1b
    8000304a:	e8250513          	addi	a0,a0,-382 # 8001dec8 <itable>
    8000304e:	b2bfd0ef          	jal	80000b78 <initlock>
  for (i = 0; i < NINODE; i++) {
    80003052:	0001b497          	auipc	s1,0x1b
    80003056:	e9e48493          	addi	s1,s1,-354 # 8001def0 <itable+0x28>
    8000305a:	0001d997          	auipc	s3,0x1d
    8000305e:	92698993          	addi	s3,s3,-1754 # 8001f980 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003062:	00004917          	auipc	s2,0x4
    80003066:	3e690913          	addi	s2,s2,998 # 80007448 <etext+0x448>
    8000306a:	85ca                	mv	a1,s2
    8000306c:	8526                	mv	a0,s1
    8000306e:	6df000ef          	jal	80003f4c <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80003072:	08848493          	addi	s1,s1,136
    80003076:	ff349ae3          	bne	s1,s3,8000306a <iinit+0x3a>
}
    8000307a:	70a2                	ld	ra,40(sp)
    8000307c:	7402                	ld	s0,32(sp)
    8000307e:	64e2                	ld	s1,24(sp)
    80003080:	6942                	ld	s2,16(sp)
    80003082:	69a2                	ld	s3,8(sp)
    80003084:	6145                	addi	sp,sp,48
    80003086:	8082                	ret

0000000080003088 <ialloc>:
{
    80003088:	7139                	addi	sp,sp,-64
    8000308a:	fc06                	sd	ra,56(sp)
    8000308c:	f822                	sd	s0,48(sp)
    8000308e:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003090:	0001b717          	auipc	a4,0x1b
    80003094:	e2472703          	lw	a4,-476(a4) # 8001deb4 <sb+0xc>
    80003098:	4785                	li	a5,1
    8000309a:	06e7f063          	bgeu	a5,a4,800030fa <ialloc+0x72>
    8000309e:	f426                	sd	s1,40(sp)
    800030a0:	f04a                	sd	s2,32(sp)
    800030a2:	ec4e                	sd	s3,24(sp)
    800030a4:	e852                	sd	s4,16(sp)
    800030a6:	e456                	sd	s5,8(sp)
    800030a8:	e05a                	sd	s6,0(sp)
    800030aa:	8aaa                	mv	s5,a0
    800030ac:	8b2e                	mv	s6,a1
    800030ae:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800030b0:	0001ba17          	auipc	s4,0x1b
    800030b4:	df8a0a13          	addi	s4,s4,-520 # 8001dea8 <sb>
    800030b8:	00495593          	srli	a1,s2,0x4
    800030bc:	018a2783          	lw	a5,24(s4)
    800030c0:	9dbd                	addw	a1,a1,a5
    800030c2:	8556                	mv	a0,s5
    800030c4:	a95ff0ef          	jal	80002b58 <bread>
    800030c8:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    800030ca:	05850993          	addi	s3,a0,88
    800030ce:	00f97793          	andi	a5,s2,15
    800030d2:	079a                	slli	a5,a5,0x6
    800030d4:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    800030d6:	00099783          	lh	a5,0(s3)
    800030da:	cb9d                	beqz	a5,80003110 <ialloc+0x88>
    brelse(bp);
    800030dc:	b85ff0ef          	jal	80002c60 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    800030e0:	0905                	addi	s2,s2,1
    800030e2:	00ca2703          	lw	a4,12(s4)
    800030e6:	0009079b          	sext.w	a5,s2
    800030ea:	fce7e7e3          	bltu	a5,a4,800030b8 <ialloc+0x30>
    800030ee:	74a2                	ld	s1,40(sp)
    800030f0:	7902                	ld	s2,32(sp)
    800030f2:	69e2                	ld	s3,24(sp)
    800030f4:	6a42                	ld	s4,16(sp)
    800030f6:	6aa2                	ld	s5,8(sp)
    800030f8:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    800030fa:	00004517          	auipc	a0,0x4
    800030fe:	35650513          	addi	a0,a0,854 # 80007450 <etext+0x450>
    80003102:	c0efd0ef          	jal	80000510 <printk>
  return 0;
    80003106:	4501                	li	a0,0
}
    80003108:	70e2                	ld	ra,56(sp)
    8000310a:	7442                	ld	s0,48(sp)
    8000310c:	6121                	addi	sp,sp,64
    8000310e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003110:	04000613          	li	a2,64
    80003114:	4581                	li	a1,0
    80003116:	854e                	mv	a0,s3
    80003118:	b9dfd0ef          	jal	80000cb4 <memset>
      dip->type = type;
    8000311c:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80003120:	8526                	mv	a0,s1
    80003122:	4f7000ef          	jal	80003e18 <log_write>
      brelse(bp);
    80003126:	8526                	mv	a0,s1
    80003128:	b39ff0ef          	jal	80002c60 <brelse>
      return iget(dev, inum);
    8000312c:	0009059b          	sext.w	a1,s2
    80003130:	8556                	mv	a0,s5
    80003132:	e4dff0ef          	jal	80002f7e <iget>
    80003136:	74a2                	ld	s1,40(sp)
    80003138:	7902                	ld	s2,32(sp)
    8000313a:	69e2                	ld	s3,24(sp)
    8000313c:	6a42                	ld	s4,16(sp)
    8000313e:	6aa2                	ld	s5,8(sp)
    80003140:	6b02                	ld	s6,0(sp)
    80003142:	b7d9                	j	80003108 <ialloc+0x80>

0000000080003144 <iupdate>:
{
    80003144:	1101                	addi	sp,sp,-32
    80003146:	ec06                	sd	ra,24(sp)
    80003148:	e822                	sd	s0,16(sp)
    8000314a:	e426                	sd	s1,8(sp)
    8000314c:	e04a                	sd	s2,0(sp)
    8000314e:	1000                	addi	s0,sp,32
    80003150:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003152:	415c                	lw	a5,4(a0)
    80003154:	0047d79b          	srliw	a5,a5,0x4
    80003158:	0001b597          	auipc	a1,0x1b
    8000315c:	d685a583          	lw	a1,-664(a1) # 8001dec0 <sb+0x18>
    80003160:	9dbd                	addw	a1,a1,a5
    80003162:	4108                	lw	a0,0(a0)
    80003164:	9f5ff0ef          	jal	80002b58 <bread>
    80003168:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000316a:	05850793          	addi	a5,a0,88
    8000316e:	40d8                	lw	a4,4(s1)
    80003170:	8b3d                	andi	a4,a4,15
    80003172:	071a                	slli	a4,a4,0x6
    80003174:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003176:	04449703          	lh	a4,68(s1)
    8000317a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000317e:	04649703          	lh	a4,70(s1)
    80003182:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003186:	04849703          	lh	a4,72(s1)
    8000318a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000318e:	04a49703          	lh	a4,74(s1)
    80003192:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003196:	44f8                	lw	a4,76(s1)
    80003198:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000319a:	03400613          	li	a2,52
    8000319e:	05048593          	addi	a1,s1,80
    800031a2:	00c78513          	addi	a0,a5,12
    800031a6:	b6bfd0ef          	jal	80000d10 <memmove>
  log_write(bp);
    800031aa:	854a                	mv	a0,s2
    800031ac:	46d000ef          	jal	80003e18 <log_write>
  brelse(bp);
    800031b0:	854a                	mv	a0,s2
    800031b2:	aafff0ef          	jal	80002c60 <brelse>
}
    800031b6:	60e2                	ld	ra,24(sp)
    800031b8:	6442                	ld	s0,16(sp)
    800031ba:	64a2                	ld	s1,8(sp)
    800031bc:	6902                	ld	s2,0(sp)
    800031be:	6105                	addi	sp,sp,32
    800031c0:	8082                	ret

00000000800031c2 <idup>:
{
    800031c2:	1101                	addi	sp,sp,-32
    800031c4:	ec06                	sd	ra,24(sp)
    800031c6:	e822                	sd	s0,16(sp)
    800031c8:	e426                	sd	s1,8(sp)
    800031ca:	1000                	addi	s0,sp,32
    800031cc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800031ce:	0001b517          	auipc	a0,0x1b
    800031d2:	cfa50513          	addi	a0,a0,-774 # 8001dec8 <itable>
    800031d6:	a23fd0ef          	jal	80000bf8 <acquire>
  ip->ref++;
    800031da:	449c                	lw	a5,8(s1)
    800031dc:	2785                	addiw	a5,a5,1
    800031de:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800031e0:	0001b517          	auipc	a0,0x1b
    800031e4:	ce850513          	addi	a0,a0,-792 # 8001dec8 <itable>
    800031e8:	a95fd0ef          	jal	80000c7c <release>
}
    800031ec:	8526                	mv	a0,s1
    800031ee:	60e2                	ld	ra,24(sp)
    800031f0:	6442                	ld	s0,16(sp)
    800031f2:	64a2                	ld	s1,8(sp)
    800031f4:	6105                	addi	sp,sp,32
    800031f6:	8082                	ret

00000000800031f8 <ilock>:
{
    800031f8:	1101                	addi	sp,sp,-32
    800031fa:	ec06                	sd	ra,24(sp)
    800031fc:	e822                	sd	s0,16(sp)
    800031fe:	e426                	sd	s1,8(sp)
    80003200:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003202:	cd19                	beqz	a0,80003220 <ilock+0x28>
    80003204:	84aa                	mv	s1,a0
    80003206:	451c                	lw	a5,8(a0)
    80003208:	00f05c63          	blez	a5,80003220 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000320c:	0541                	addi	a0,a0,16
    8000320e:	575000ef          	jal	80003f82 <acquiresleep>
  if (ip->valid == 0) {
    80003212:	40bc                	lw	a5,64(s1)
    80003214:	cf89                	beqz	a5,8000322e <ilock+0x36>
}
    80003216:	60e2                	ld	ra,24(sp)
    80003218:	6442                	ld	s0,16(sp)
    8000321a:	64a2                	ld	s1,8(sp)
    8000321c:	6105                	addi	sp,sp,32
    8000321e:	8082                	ret
    80003220:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003222:	00004517          	auipc	a0,0x4
    80003226:	24650513          	addi	a0,a0,582 # 80007468 <etext+0x468>
    8000322a:	e1efd0ef          	jal	80000848 <panic>
    8000322e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003230:	40dc                	lw	a5,4(s1)
    80003232:	0047d79b          	srliw	a5,a5,0x4
    80003236:	0001b597          	auipc	a1,0x1b
    8000323a:	c8a5a583          	lw	a1,-886(a1) # 8001dec0 <sb+0x18>
    8000323e:	9dbd                	addw	a1,a1,a5
    80003240:	4088                	lw	a0,0(s1)
    80003242:	917ff0ef          	jal	80002b58 <bread>
    80003246:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003248:	05850593          	addi	a1,a0,88
    8000324c:	40dc                	lw	a5,4(s1)
    8000324e:	8bbd                	andi	a5,a5,15
    80003250:	079a                	slli	a5,a5,0x6
    80003252:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003254:	00059783          	lh	a5,0(a1)
    80003258:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000325c:	00259783          	lh	a5,2(a1)
    80003260:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003264:	00459783          	lh	a5,4(a1)
    80003268:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000326c:	00659783          	lh	a5,6(a1)
    80003270:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003274:	459c                	lw	a5,8(a1)
    80003276:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003278:	03400613          	li	a2,52
    8000327c:	05b1                	addi	a1,a1,12
    8000327e:	05048513          	addi	a0,s1,80
    80003282:	a8ffd0ef          	jal	80000d10 <memmove>
    brelse(bp);
    80003286:	854a                	mv	a0,s2
    80003288:	9d9ff0ef          	jal	80002c60 <brelse>
    ip->valid = 1;
    8000328c:	4785                	li	a5,1
    8000328e:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003290:	04449783          	lh	a5,68(s1)
    80003294:	c399                	beqz	a5,8000329a <ilock+0xa2>
    80003296:	6902                	ld	s2,0(sp)
    80003298:	bfbd                	j	80003216 <ilock+0x1e>
      panic("ilock: no type");
    8000329a:	00004517          	auipc	a0,0x4
    8000329e:	1d650513          	addi	a0,a0,470 # 80007470 <etext+0x470>
    800032a2:	da6fd0ef          	jal	80000848 <panic>

00000000800032a6 <iunlock>:
{
    800032a6:	1101                	addi	sp,sp,-32
    800032a8:	ec06                	sd	ra,24(sp)
    800032aa:	e822                	sd	s0,16(sp)
    800032ac:	e426                	sd	s1,8(sp)
    800032ae:	e04a                	sd	s2,0(sp)
    800032b0:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032b2:	c505                	beqz	a0,800032da <iunlock+0x34>
    800032b4:	84aa                	mv	s1,a0
    800032b6:	01050913          	addi	s2,a0,16
    800032ba:	854a                	mv	a0,s2
    800032bc:	553000ef          	jal	8000400e <holdingsleep>
    800032c0:	cd09                	beqz	a0,800032da <iunlock+0x34>
    800032c2:	449c                	lw	a5,8(s1)
    800032c4:	00f05b63          	blez	a5,800032da <iunlock+0x34>
  releasesleep(&ip->lock);
    800032c8:	854a                	mv	a0,s2
    800032ca:	50d000ef          	jal	80003fd6 <releasesleep>
}
    800032ce:	60e2                	ld	ra,24(sp)
    800032d0:	6442                	ld	s0,16(sp)
    800032d2:	64a2                	ld	s1,8(sp)
    800032d4:	6902                	ld	s2,0(sp)
    800032d6:	6105                	addi	sp,sp,32
    800032d8:	8082                	ret
    panic("iunlock");
    800032da:	00004517          	auipc	a0,0x4
    800032de:	1a650513          	addi	a0,a0,422 # 80007480 <etext+0x480>
    800032e2:	d66fd0ef          	jal	80000848 <panic>

00000000800032e6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800032e6:	7179                	addi	sp,sp,-48
    800032e8:	f406                	sd	ra,40(sp)
    800032ea:	f022                	sd	s0,32(sp)
    800032ec:	ec26                	sd	s1,24(sp)
    800032ee:	e84a                	sd	s2,16(sp)
    800032f0:	e44e                	sd	s3,8(sp)
    800032f2:	1800                	addi	s0,sp,48
    800032f4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    800032f6:	05050493          	addi	s1,a0,80
    800032fa:	08050913          	addi	s2,a0,128
    800032fe:	a021                	j	80003306 <itrunc+0x20>
    80003300:	0491                	addi	s1,s1,4
    80003302:	01248b63          	beq	s1,s2,80003318 <itrunc+0x32>
    if (ip->addrs[i]) {
    80003306:	408c                	lw	a1,0(s1)
    80003308:	dde5                	beqz	a1,80003300 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000330a:	0009a503          	lw	a0,0(s3)
    8000330e:	a3fff0ef          	jal	80002d4c <bfree>
      ip->addrs[i] = 0;
    80003312:	0004a023          	sw	zero,0(s1)
    80003316:	b7ed                	j	80003300 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80003318:	0809a583          	lw	a1,128(s3)
    8000331c:	ed89                	bnez	a1,80003336 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000331e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003322:	854e                	mv	a0,s3
    80003324:	e21ff0ef          	jal	80003144 <iupdate>
}
    80003328:	70a2                	ld	ra,40(sp)
    8000332a:	7402                	ld	s0,32(sp)
    8000332c:	64e2                	ld	s1,24(sp)
    8000332e:	6942                	ld	s2,16(sp)
    80003330:	69a2                	ld	s3,8(sp)
    80003332:	6145                	addi	sp,sp,48
    80003334:	8082                	ret
    80003336:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003338:	0009a503          	lw	a0,0(s3)
    8000333c:	81dff0ef          	jal	80002b58 <bread>
    80003340:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80003342:	05850493          	addi	s1,a0,88
    80003346:	45850913          	addi	s2,a0,1112
    8000334a:	a021                	j	80003352 <itrunc+0x6c>
    8000334c:	0491                	addi	s1,s1,4
    8000334e:	01248963          	beq	s1,s2,80003360 <itrunc+0x7a>
      if (a[j])
    80003352:	408c                	lw	a1,0(s1)
    80003354:	dde5                	beqz	a1,8000334c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003356:	0009a503          	lw	a0,0(s3)
    8000335a:	9f3ff0ef          	jal	80002d4c <bfree>
    8000335e:	b7fd                	j	8000334c <itrunc+0x66>
    brelse(bp);
    80003360:	8552                	mv	a0,s4
    80003362:	8ffff0ef          	jal	80002c60 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003366:	0809a583          	lw	a1,128(s3)
    8000336a:	0009a503          	lw	a0,0(s3)
    8000336e:	9dfff0ef          	jal	80002d4c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003372:	0809a023          	sw	zero,128(s3)
    80003376:	6a02                	ld	s4,0(sp)
    80003378:	b75d                	j	8000331e <itrunc+0x38>

000000008000337a <iput>:
{
    8000337a:	7179                	addi	sp,sp,-48
    8000337c:	f406                	sd	ra,40(sp)
    8000337e:	f022                	sd	s0,32(sp)
    80003380:	ec26                	sd	s1,24(sp)
    80003382:	1800                	addi	s0,sp,48
    80003384:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003386:	0001b517          	auipc	a0,0x1b
    8000338a:	b4250513          	addi	a0,a0,-1214 # 8001dec8 <itable>
    8000338e:	86bfd0ef          	jal	80000bf8 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80003392:	449c                	lw	a5,8(s1)
    80003394:	4705                	li	a4,1
    80003396:	00e78f63          	beq	a5,a4,800033b4 <iput+0x3a>
  ip->ref--;
    8000339a:	37fd                	addiw	a5,a5,-1
    8000339c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000339e:	0001b517          	auipc	a0,0x1b
    800033a2:	b2a50513          	addi	a0,a0,-1238 # 8001dec8 <itable>
    800033a6:	8d7fd0ef          	jal	80000c7c <release>
}
    800033aa:	70a2                	ld	ra,40(sp)
    800033ac:	7402                	ld	s0,32(sp)
    800033ae:	64e2                	ld	s1,24(sp)
    800033b0:	6145                	addi	sp,sp,48
    800033b2:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800033b4:	40b8                	lw	a4,64(s1)
    800033b6:	d375                	beqz	a4,8000339a <iput+0x20>
    800033b8:	e84a                	sd	s2,16(sp)
    800033ba:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    800033bc:	0004aa03          	lw	s4,0(s1)
    800033c0:	0044a903          	lw	s2,4(s1)
  if (last) {
    800033c4:	04a49703          	lh	a4,74(s1)
    800033c8:	ef3d                	bnez	a4,80003446 <iput+0xcc>
    800033ca:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    800033cc:	01048793          	addi	a5,s1,16
    800033d0:	89be                	mv	s3,a5
    800033d2:	853e                	mv	a0,a5
    800033d4:	3af000ef          	jal	80003f82 <acquiresleep>
    release(&itable.lock);
    800033d8:	0001b517          	auipc	a0,0x1b
    800033dc:	af050513          	addi	a0,a0,-1296 # 8001dec8 <itable>
    800033e0:	89dfd0ef          	jal	80000c7c <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    800033e4:	8526                	mv	a0,s1
    800033e6:	f01ff0ef          	jal	800032e6 <itrunc>
    ip->valid = 0;
    800033ea:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800033ee:	854e                	mv	a0,s3
    800033f0:	3e7000ef          	jal	80003fd6 <releasesleep>
    acquire(&itable.lock);
    800033f4:	0001b517          	auipc	a0,0x1b
    800033f8:	ad450513          	addi	a0,a0,-1324 # 8001dec8 <itable>
    800033fc:	ffcfd0ef          	jal	80000bf8 <acquire>
  ip->ref--;
    80003400:	449c                	lw	a5,8(s1)
    80003402:	37fd                	addiw	a5,a5,-1
    80003404:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003406:	0001b517          	auipc	a0,0x1b
    8000340a:	ac250513          	addi	a0,a0,-1342 # 8001dec8 <itable>
    8000340e:	86ffd0ef          	jal	80000c7c <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003412:	0049579b          	srliw	a5,s2,0x4
    80003416:	0001b597          	auipc	a1,0x1b
    8000341a:	aaa5a583          	lw	a1,-1366(a1) # 8001dec0 <sb+0x18>
    8000341e:	9dbd                	addw	a1,a1,a5
    80003420:	8552                	mv	a0,s4
    80003422:	f36ff0ef          	jal	80002b58 <bread>
    80003426:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003428:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    8000342c:	079a                	slli	a5,a5,0x6
    8000342e:	97aa                	add	a5,a5,a0
    80003430:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    80003434:	1e5000ef          	jal	80003e18 <log_write>
  brelse(bp);
    80003438:	8526                	mv	a0,s1
    8000343a:	827ff0ef          	jal	80002c60 <brelse>
}
    8000343e:	6942                	ld	s2,16(sp)
    80003440:	69a2                	ld	s3,8(sp)
    80003442:	6a02                	ld	s4,0(sp)
    80003444:	b79d                	j	800033aa <iput+0x30>
    80003446:	6942                	ld	s2,16(sp)
    80003448:	6a02                	ld	s4,0(sp)
    8000344a:	bf81                	j	8000339a <iput+0x20>

000000008000344c <iunlockput>:
{
    8000344c:	1101                	addi	sp,sp,-32
    8000344e:	ec06                	sd	ra,24(sp)
    80003450:	e822                	sd	s0,16(sp)
    80003452:	e426                	sd	s1,8(sp)
    80003454:	1000                	addi	s0,sp,32
    80003456:	84aa                	mv	s1,a0
  iunlock(ip);
    80003458:	e4fff0ef          	jal	800032a6 <iunlock>
  iput(ip);
    8000345c:	8526                	mv	a0,s1
    8000345e:	f1dff0ef          	jal	8000337a <iput>
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	64a2                	ld	s1,8(sp)
    80003468:	6105                	addi	sp,sp,32
    8000346a:	8082                	ret

000000008000346c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000346c:	0001b717          	auipc	a4,0x1b
    80003470:	a4872703          	lw	a4,-1464(a4) # 8001deb4 <sb+0xc>
    80003474:	4785                	li	a5,1
    80003476:	0ae7fe63          	bgeu	a5,a4,80003532 <ireclaim+0xc6>
{
    8000347a:	7139                	addi	sp,sp,-64
    8000347c:	fc06                	sd	ra,56(sp)
    8000347e:	f822                	sd	s0,48(sp)
    80003480:	f426                	sd	s1,40(sp)
    80003482:	f04a                	sd	s2,32(sp)
    80003484:	ec4e                	sd	s3,24(sp)
    80003486:	e852                	sd	s4,16(sp)
    80003488:	e456                	sd	s5,8(sp)
    8000348a:	e05a                	sd	s6,0(sp)
    8000348c:	0080                	addi	s0,sp,64
    8000348e:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003490:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003492:	0001ba17          	auipc	s4,0x1b
    80003496:	a16a0a13          	addi	s4,s4,-1514 # 8001dea8 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    8000349a:	00004b17          	auipc	s6,0x4
    8000349e:	feeb0b13          	addi	s6,s6,-18 # 80007488 <etext+0x488>
    800034a2:	a099                	j	800034e8 <ireclaim+0x7c>
    800034a4:	85ce                	mv	a1,s3
    800034a6:	855a                	mv	a0,s6
    800034a8:	868fd0ef          	jal	80000510 <printk>
      ip = iget(dev, inum);
    800034ac:	85ce                	mv	a1,s3
    800034ae:	8556                	mv	a0,s5
    800034b0:	acfff0ef          	jal	80002f7e <iget>
    800034b4:	89aa                	mv	s3,a0
    brelse(bp);
    800034b6:	854a                	mv	a0,s2
    800034b8:	fa8ff0ef          	jal	80002c60 <brelse>
    if (ip) {
    800034bc:	00098f63          	beqz	s3,800034da <ireclaim+0x6e>
      begin_op();
    800034c0:	7aa000ef          	jal	80003c6a <begin_op>
      ilock(ip);
    800034c4:	854e                	mv	a0,s3
    800034c6:	d33ff0ef          	jal	800031f8 <ilock>
      iunlock(ip);
    800034ca:	854e                	mv	a0,s3
    800034cc:	ddbff0ef          	jal	800032a6 <iunlock>
      iput(ip);
    800034d0:	854e                	mv	a0,s3
    800034d2:	ea9ff0ef          	jal	8000337a <iput>
      end_op();
    800034d6:	021000ef          	jal	80003cf6 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034da:	0485                	addi	s1,s1,1
    800034dc:	00ca2703          	lw	a4,12(s4)
    800034e0:	0004879b          	sext.w	a5,s1
    800034e4:	02e7fd63          	bgeu	a5,a4,8000351e <ireclaim+0xb2>
    800034e8:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034ec:	0044d593          	srli	a1,s1,0x4
    800034f0:	018a2783          	lw	a5,24(s4)
    800034f4:	9dbd                	addw	a1,a1,a5
    800034f6:	8556                	mv	a0,s5
    800034f8:	e60ff0ef          	jal	80002b58 <bread>
    800034fc:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800034fe:	05850793          	addi	a5,a0,88
    80003502:	00f9f713          	andi	a4,s3,15
    80003506:	071a                	slli	a4,a4,0x6
    80003508:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    8000350a:	00079703          	lh	a4,0(a5)
    8000350e:	c701                	beqz	a4,80003516 <ireclaim+0xaa>
    80003510:	00679783          	lh	a5,6(a5)
    80003514:	dbc1                	beqz	a5,800034a4 <ireclaim+0x38>
    brelse(bp);
    80003516:	854a                	mv	a0,s2
    80003518:	f48ff0ef          	jal	80002c60 <brelse>
    if (ip) {
    8000351c:	bf7d                	j	800034da <ireclaim+0x6e>
}
    8000351e:	70e2                	ld	ra,56(sp)
    80003520:	7442                	ld	s0,48(sp)
    80003522:	74a2                	ld	s1,40(sp)
    80003524:	7902                	ld	s2,32(sp)
    80003526:	69e2                	ld	s3,24(sp)
    80003528:	6a42                	ld	s4,16(sp)
    8000352a:	6aa2                	ld	s5,8(sp)
    8000352c:	6b02                	ld	s6,0(sp)
    8000352e:	6121                	addi	sp,sp,64
    80003530:	8082                	ret
    80003532:	8082                	ret

0000000080003534 <fsinit>:
{
    80003534:	1101                	addi	sp,sp,-32
    80003536:	ec06                	sd	ra,24(sp)
    80003538:	e822                	sd	s0,16(sp)
    8000353a:	e426                	sd	s1,8(sp)
    8000353c:	e04a                	sd	s2,0(sp)
    8000353e:	1000                	addi	s0,sp,32
    80003540:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003542:	4585                	li	a1,1
    80003544:	e14ff0ef          	jal	80002b58 <bread>
    80003548:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000354a:	02000613          	li	a2,32
    8000354e:	05850593          	addi	a1,a0,88
    80003552:	0001b517          	auipc	a0,0x1b
    80003556:	95650513          	addi	a0,a0,-1706 # 8001dea8 <sb>
    8000355a:	fb6fd0ef          	jal	80000d10 <memmove>
  brelse(bp);
    8000355e:	8526                	mv	a0,s1
    80003560:	f00ff0ef          	jal	80002c60 <brelse>
  if (sb.magic != FSMAGIC)
    80003564:	0001b717          	auipc	a4,0x1b
    80003568:	94472703          	lw	a4,-1724(a4) # 8001dea8 <sb>
    8000356c:	102037b7          	lui	a5,0x10203
    80003570:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003574:	02f71263          	bne	a4,a5,80003598 <fsinit+0x64>
  initlog(dev, &sb);
    80003578:	0001b597          	auipc	a1,0x1b
    8000357c:	93058593          	addi	a1,a1,-1744 # 8001dea8 <sb>
    80003580:	854a                	mv	a0,s2
    80003582:	666000ef          	jal	80003be8 <initlog>
  ireclaim(dev);
    80003586:	854a                	mv	a0,s2
    80003588:	ee5ff0ef          	jal	8000346c <ireclaim>
}
    8000358c:	60e2                	ld	ra,24(sp)
    8000358e:	6442                	ld	s0,16(sp)
    80003590:	64a2                	ld	s1,8(sp)
    80003592:	6902                	ld	s2,0(sp)
    80003594:	6105                	addi	sp,sp,32
    80003596:	8082                	ret
    panic("invalid file system");
    80003598:	00004517          	auipc	a0,0x4
    8000359c:	f1050513          	addi	a0,a0,-240 # 800074a8 <etext+0x4a8>
    800035a0:	aa8fd0ef          	jal	80000848 <panic>

00000000800035a4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800035a4:	1141                	addi	sp,sp,-16
    800035a6:	e406                	sd	ra,8(sp)
    800035a8:	e022                	sd	s0,0(sp)
    800035aa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800035ac:	411c                	lw	a5,0(a0)
    800035ae:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800035b0:	415c                	lw	a5,4(a0)
    800035b2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800035b4:	04451783          	lh	a5,68(a0)
    800035b8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800035bc:	04a51783          	lh	a5,74(a0)
    800035c0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800035c4:	04c56783          	lwu	a5,76(a0)
    800035c8:	e99c                	sd	a5,16(a1)
}
    800035ca:	60a2                	ld	ra,8(sp)
    800035cc:	6402                	ld	s0,0(sp)
    800035ce:	0141                	addi	sp,sp,16
    800035d0:	8082                	ret

00000000800035d2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800035d2:	457c                	lw	a5,76(a0)
    800035d4:	0ed7e663          	bltu	a5,a3,800036c0 <readi+0xee>
{
    800035d8:	7159                	addi	sp,sp,-112
    800035da:	f486                	sd	ra,104(sp)
    800035dc:	f0a2                	sd	s0,96(sp)
    800035de:	eca6                	sd	s1,88(sp)
    800035e0:	e0d2                	sd	s4,64(sp)
    800035e2:	fc56                	sd	s5,56(sp)
    800035e4:	f85a                	sd	s6,48(sp)
    800035e6:	f45e                	sd	s7,40(sp)
    800035e8:	1880                	addi	s0,sp,112
    800035ea:	8b2a                	mv	s6,a0
    800035ec:	8bae                	mv	s7,a1
    800035ee:	8a32                	mv	s4,a2
    800035f0:	84b6                	mv	s1,a3
    800035f2:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    800035f4:	9f35                	addw	a4,a4,a3
    return 0;
    800035f6:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    800035f8:	0ad76b63          	bltu	a4,a3,800036ae <readi+0xdc>
    800035fc:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    800035fe:	00e7f463          	bgeu	a5,a4,80003606 <readi+0x34>
    n = ip->size - off;
    80003602:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003606:	080a8b63          	beqz	s5,8000369c <readi+0xca>
    8000360a:	e8ca                	sd	s2,80(sp)
    8000360c:	f062                	sd	s8,32(sp)
    8000360e:	ec66                	sd	s9,24(sp)
    80003610:	e86a                	sd	s10,16(sp)
    80003612:	e46e                	sd	s11,8(sp)
    80003614:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003616:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000361a:	5c7d                	li	s8,-1
    8000361c:	a80d                	j	8000364e <readi+0x7c>
    8000361e:	020d1d93          	slli	s11,s10,0x20
    80003622:	020ddd93          	srli	s11,s11,0x20
    80003626:	05890613          	addi	a2,s2,88
    8000362a:	86ee                	mv	a3,s11
    8000362c:	963e                	add	a2,a2,a5
    8000362e:	85d2                	mv	a1,s4
    80003630:	855e                	mv	a0,s7
    80003632:	c43fe0ef          	jal	80002274 <either_copyout>
    80003636:	05850363          	beq	a0,s8,8000367c <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000363a:	854a                	mv	a0,s2
    8000363c:	e24ff0ef          	jal	80002c60 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003640:	013d09bb          	addw	s3,s10,s3
    80003644:	009d04bb          	addw	s1,s10,s1
    80003648:	9a6e                	add	s4,s4,s11
    8000364a:	0559f363          	bgeu	s3,s5,80003690 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    8000364e:	00a4d59b          	srliw	a1,s1,0xa
    80003652:	855a                	mv	a0,s6
    80003654:	86bff0ef          	jal	80002ebe <bmap>
    80003658:	85aa                	mv	a1,a0
    if (addr == 0)
    8000365a:	c139                	beqz	a0,800036a0 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000365c:	000b2503          	lw	a0,0(s6)
    80003660:	cf8ff0ef          	jal	80002b58 <bread>
    80003664:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003666:	3ff4f793          	andi	a5,s1,1023
    8000366a:	40fc873b          	subw	a4,s9,a5
    8000366e:	413a86bb          	subw	a3,s5,s3
    80003672:	8d3a                	mv	s10,a4
    80003674:	fae6f5e3          	bgeu	a3,a4,8000361e <readi+0x4c>
    80003678:	8d36                	mv	s10,a3
    8000367a:	b755                	j	8000361e <readi+0x4c>
      brelse(bp);
    8000367c:	854a                	mv	a0,s2
    8000367e:	de2ff0ef          	jal	80002c60 <brelse>
      tot = -1;
    80003682:	59fd                	li	s3,-1
      break;
    80003684:	6946                	ld	s2,80(sp)
    80003686:	7c02                	ld	s8,32(sp)
    80003688:	6ce2                	ld	s9,24(sp)
    8000368a:	6d42                	ld	s10,16(sp)
    8000368c:	6da2                	ld	s11,8(sp)
    8000368e:	a831                	j	800036aa <readi+0xd8>
    80003690:	6946                	ld	s2,80(sp)
    80003692:	7c02                	ld	s8,32(sp)
    80003694:	6ce2                	ld	s9,24(sp)
    80003696:	6d42                	ld	s10,16(sp)
    80003698:	6da2                	ld	s11,8(sp)
    8000369a:	a801                	j	800036aa <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000369c:	89d6                	mv	s3,s5
    8000369e:	a031                	j	800036aa <readi+0xd8>
    800036a0:	6946                	ld	s2,80(sp)
    800036a2:	7c02                	ld	s8,32(sp)
    800036a4:	6ce2                	ld	s9,24(sp)
    800036a6:	6d42                	ld	s10,16(sp)
    800036a8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800036aa:	854e                	mv	a0,s3
    800036ac:	69a6                	ld	s3,72(sp)
}
    800036ae:	70a6                	ld	ra,104(sp)
    800036b0:	7406                	ld	s0,96(sp)
    800036b2:	64e6                	ld	s1,88(sp)
    800036b4:	6a06                	ld	s4,64(sp)
    800036b6:	7ae2                	ld	s5,56(sp)
    800036b8:	7b42                	ld	s6,48(sp)
    800036ba:	7ba2                	ld	s7,40(sp)
    800036bc:	6165                	addi	sp,sp,112
    800036be:	8082                	ret
    return 0;
    800036c0:	4501                	li	a0,0
}
    800036c2:	8082                	ret

00000000800036c4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800036c4:	457c                	lw	a5,76(a0)
    800036c6:	10d7e163          	bltu	a5,a3,800037c8 <writei+0x104>
{
    800036ca:	7159                	addi	sp,sp,-112
    800036cc:	f486                	sd	ra,104(sp)
    800036ce:	f0a2                	sd	s0,96(sp)
    800036d0:	e8ca                	sd	s2,80(sp)
    800036d2:	e0d2                	sd	s4,64(sp)
    800036d4:	fc56                	sd	s5,56(sp)
    800036d6:	f85a                	sd	s6,48(sp)
    800036d8:	f45e                	sd	s7,40(sp)
    800036da:	1880                	addi	s0,sp,112
    800036dc:	8aaa                	mv	s5,a0
    800036de:	8bae                	mv	s7,a1
    800036e0:	8a32                	mv	s4,a2
    800036e2:	8936                	mv	s2,a3
    800036e4:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    800036e6:	9f35                	addw	a4,a4,a3
    return -1;
  if (off + n > MAXFILE * BSIZE)
    800036e8:	000437b7          	lui	a5,0x43
    800036ec:	00e7b7b3          	sltu	a5,a5,a4
  if (off > ip->size || off + n < off)
    800036f0:	00d73733          	sltu	a4,a4,a3
  if (off + n > MAXFILE * BSIZE)
    800036f4:	8fd9                	or	a5,a5,a4
    800036f6:	ef91                	bnez	a5,80003712 <writei+0x4e>
    800036f8:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800036fa:	0a0b0f63          	beqz	s6,800037b8 <writei+0xf4>
    800036fe:	eca6                	sd	s1,88(sp)
    80003700:	f062                	sd	s8,32(sp)
    80003702:	ec66                	sd	s9,24(sp)
    80003704:	e86a                	sd	s10,16(sp)
    80003706:	e46e                	sd	s11,8(sp)
    80003708:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000370a:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000370e:	5c7d                	li	s8,-1
    80003710:	a835                	j	8000374c <writei+0x88>
    return -1;
    80003712:	557d                	li	a0,-1
    80003714:	a849                	j	800037a6 <writei+0xe2>
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003716:	020d1d93          	slli	s11,s10,0x20
    8000371a:	020ddd93          	srli	s11,s11,0x20
    8000371e:	05848513          	addi	a0,s1,88
    80003722:	86ee                	mv	a3,s11
    80003724:	8652                	mv	a2,s4
    80003726:	85de                	mv	a1,s7
    80003728:	953e                	add	a0,a0,a5
    8000372a:	b97fe0ef          	jal	800022c0 <either_copyin>
    8000372e:	05850663          	beq	a0,s8,8000377a <writei+0xb6>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80003732:	8526                	mv	a0,s1
    80003734:	6e4000ef          	jal	80003e18 <log_write>
    brelse(bp);
    80003738:	8526                	mv	a0,s1
    8000373a:	d26ff0ef          	jal	80002c60 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000373e:	013d09bb          	addw	s3,s10,s3
    80003742:	012d093b          	addw	s2,s10,s2
    80003746:	9a6e                	add	s4,s4,s11
    80003748:	0369ff63          	bgeu	s3,s6,80003786 <writei+0xc2>
    uint addr = bmap(ip, off / BSIZE);
    8000374c:	00a9559b          	srliw	a1,s2,0xa
    80003750:	8556                	mv	a0,s5
    80003752:	f6cff0ef          	jal	80002ebe <bmap>
    80003756:	85aa                	mv	a1,a0
    if (addr == 0)
    80003758:	c51d                	beqz	a0,80003786 <writei+0xc2>
    bp = bread(ip->dev, addr);
    8000375a:	000aa503          	lw	a0,0(s5)
    8000375e:	bfaff0ef          	jal	80002b58 <bread>
    80003762:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003764:	3ff97793          	andi	a5,s2,1023
    80003768:	40fc873b          	subw	a4,s9,a5
    8000376c:	413b06bb          	subw	a3,s6,s3
    80003770:	8d3a                	mv	s10,a4
    80003772:	fae6f2e3          	bgeu	a3,a4,80003716 <writei+0x52>
    80003776:	8d36                	mv	s10,a3
    80003778:	bf79                	j	80003716 <writei+0x52>
      log_write(bp);
    8000377a:	8526                	mv	a0,s1
    8000377c:	69c000ef          	jal	80003e18 <log_write>
      brelse(bp);
    80003780:	8526                	mv	a0,s1
    80003782:	cdeff0ef          	jal	80002c60 <brelse>
  }

  if (off > ip->size)
    80003786:	04caa783          	lw	a5,76(s5)
    8000378a:	0327f963          	bgeu	a5,s2,800037bc <writei+0xf8>
    ip->size = off;
    8000378e:	052aa623          	sw	s2,76(s5)
    80003792:	64e6                	ld	s1,88(sp)
    80003794:	7c02                	ld	s8,32(sp)
    80003796:	6ce2                	ld	s9,24(sp)
    80003798:	6d42                	ld	s10,16(sp)
    8000379a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000379c:	8556                	mv	a0,s5
    8000379e:	9a7ff0ef          	jal	80003144 <iupdate>

  return tot;
    800037a2:	854e                	mv	a0,s3
    800037a4:	69a6                	ld	s3,72(sp)
}
    800037a6:	70a6                	ld	ra,104(sp)
    800037a8:	7406                	ld	s0,96(sp)
    800037aa:	6946                	ld	s2,80(sp)
    800037ac:	6a06                	ld	s4,64(sp)
    800037ae:	7ae2                	ld	s5,56(sp)
    800037b0:	7b42                	ld	s6,48(sp)
    800037b2:	7ba2                	ld	s7,40(sp)
    800037b4:	6165                	addi	sp,sp,112
    800037b6:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800037b8:	89da                	mv	s3,s6
    800037ba:	b7cd                	j	8000379c <writei+0xd8>
    800037bc:	64e6                	ld	s1,88(sp)
    800037be:	7c02                	ld	s8,32(sp)
    800037c0:	6ce2                	ld	s9,24(sp)
    800037c2:	6d42                	ld	s10,16(sp)
    800037c4:	6da2                	ld	s11,8(sp)
    800037c6:	bfd9                	j	8000379c <writei+0xd8>
    return -1;
    800037c8:	557d                	li	a0,-1
}
    800037ca:	8082                	ret

00000000800037cc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800037cc:	1141                	addi	sp,sp,-16
    800037ce:	e406                	sd	ra,8(sp)
    800037d0:	e022                	sd	s0,0(sp)
    800037d2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800037d4:	4639                	li	a2,14
    800037d6:	daefd0ef          	jal	80000d84 <strncmp>
}
    800037da:	60a2                	ld	ra,8(sp)
    800037dc:	6402                	ld	s0,0(sp)
    800037de:	0141                	addi	sp,sp,16
    800037e0:	8082                	ret

00000000800037e2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037e2:	711d                	addi	sp,sp,-96
    800037e4:	ec86                	sd	ra,88(sp)
    800037e6:	e8a2                	sd	s0,80(sp)
    800037e8:	e4a6                	sd	s1,72(sp)
    800037ea:	e0ca                	sd	s2,64(sp)
    800037ec:	fc4e                	sd	s3,56(sp)
    800037ee:	f852                	sd	s4,48(sp)
    800037f0:	f456                	sd	s5,40(sp)
    800037f2:	f05a                	sd	s6,32(sp)
    800037f4:	ec5e                	sd	s7,24(sp)
    800037f6:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    800037f8:	04451703          	lh	a4,68(a0)
    800037fc:	4785                	li	a5,1
    800037fe:	02f71963          	bne	a4,a5,80003830 <dirlookup+0x4e>
    80003802:	892a                	mv	s2,a0
    80003804:	8aae                	mv	s5,a1
    80003806:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003808:	457c                	lw	a5,76(a0)
    8000380a:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000380c:	fa040a13          	addi	s4,s0,-96
    80003810:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80003812:	fa240b13          	addi	s6,s0,-94
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003816:	ef95                	bnez	a5,80003852 <dirlookup+0x70>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003818:	4501                	li	a0,0
}
    8000381a:	60e6                	ld	ra,88(sp)
    8000381c:	6446                	ld	s0,80(sp)
    8000381e:	64a6                	ld	s1,72(sp)
    80003820:	6906                	ld	s2,64(sp)
    80003822:	79e2                	ld	s3,56(sp)
    80003824:	7a42                	ld	s4,48(sp)
    80003826:	7aa2                	ld	s5,40(sp)
    80003828:	7b02                	ld	s6,32(sp)
    8000382a:	6be2                	ld	s7,24(sp)
    8000382c:	6125                	addi	sp,sp,96
    8000382e:	8082                	ret
    panic("dirlookup not DIR");
    80003830:	00004517          	auipc	a0,0x4
    80003834:	c9050513          	addi	a0,a0,-880 # 800074c0 <etext+0x4c0>
    80003838:	810fd0ef          	jal	80000848 <panic>
      panic("dirlookup read");
    8000383c:	00004517          	auipc	a0,0x4
    80003840:	c9c50513          	addi	a0,a0,-868 # 800074d8 <etext+0x4d8>
    80003844:	804fd0ef          	jal	80000848 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003848:	24c1                	addiw	s1,s1,16
    8000384a:	04c92783          	lw	a5,76(s2)
    8000384e:	fcf4f5e3          	bgeu	s1,a5,80003818 <dirlookup+0x36>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003852:	874e                	mv	a4,s3
    80003854:	86a6                	mv	a3,s1
    80003856:	8652                	mv	a2,s4
    80003858:	4581                	li	a1,0
    8000385a:	854a                	mv	a0,s2
    8000385c:	d77ff0ef          	jal	800035d2 <readi>
    80003860:	fd351ee3          	bne	a0,s3,8000383c <dirlookup+0x5a>
    if (de.inum == 0)
    80003864:	fa045783          	lhu	a5,-96(s0)
    80003868:	d3e5                	beqz	a5,80003848 <dirlookup+0x66>
    if (namecmp(name, de.name) == 0) {
    8000386a:	85da                	mv	a1,s6
    8000386c:	8556                	mv	a0,s5
    8000386e:	f5fff0ef          	jal	800037cc <namecmp>
    80003872:	f979                	bnez	a0,80003848 <dirlookup+0x66>
      if (poff)
    80003874:	000b8463          	beqz	s7,8000387c <dirlookup+0x9a>
        *poff = off;
    80003878:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000387c:	fa045583          	lhu	a1,-96(s0)
    80003880:	00092503          	lw	a0,0(s2)
    80003884:	efaff0ef          	jal	80002f7e <iget>
    80003888:	bf49                	j	8000381a <dirlookup+0x38>

000000008000388a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    8000388a:	711d                	addi	sp,sp,-96
    8000388c:	ec86                	sd	ra,88(sp)
    8000388e:	e8a2                	sd	s0,80(sp)
    80003890:	e4a6                	sd	s1,72(sp)
    80003892:	e0ca                	sd	s2,64(sp)
    80003894:	fc4e                	sd	s3,56(sp)
    80003896:	f852                	sd	s4,48(sp)
    80003898:	f456                	sd	s5,40(sp)
    8000389a:	f05a                	sd	s6,32(sp)
    8000389c:	ec5e                	sd	s7,24(sp)
    8000389e:	e862                	sd	s8,16(sp)
    800038a0:	e466                	sd	s9,8(sp)
    800038a2:	e06a                	sd	s10,0(sp)
    800038a4:	1080                	addi	s0,sp,96
    800038a6:	84aa                	mv	s1,a0
    800038a8:	8b2e                	mv	s6,a1
    800038aa:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800038ac:	00054703          	lbu	a4,0(a0)
    800038b0:	02f00793          	li	a5,47
    800038b4:	00f70f63          	beq	a4,a5,800038d2 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038b8:	82afe0ef          	jal	800018e2 <myproc>
    800038bc:	15053503          	ld	a0,336(a0)
    800038c0:	903ff0ef          	jal	800031c2 <idup>
    800038c4:	8a2a                	mv	s4,a0
  while (*path == '/')
    800038c6:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    800038ca:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800038cc:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800038ce:	4b85                	li	s7,1
    800038d0:	a075                	j	8000397c <namex+0xf2>
    ip = iget(ROOTDEV, ROOTINO);
    800038d2:	4585                	li	a1,1
    800038d4:	852e                	mv	a0,a1
    800038d6:	ea8ff0ef          	jal	80002f7e <iget>
    800038da:	8a2a                	mv	s4,a0
    800038dc:	b7ed                	j	800038c6 <namex+0x3c>
      iunlockput(ip);
    800038de:	8552                	mv	a0,s4
    800038e0:	b6dff0ef          	jal	8000344c <iunlockput>
      return 0;
    800038e4:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800038e6:	8552                	mv	a0,s4
    800038e8:	60e6                	ld	ra,88(sp)
    800038ea:	6446                	ld	s0,80(sp)
    800038ec:	64a6                	ld	s1,72(sp)
    800038ee:	6906                	ld	s2,64(sp)
    800038f0:	79e2                	ld	s3,56(sp)
    800038f2:	7a42                	ld	s4,48(sp)
    800038f4:	7aa2                	ld	s5,40(sp)
    800038f6:	7b02                	ld	s6,32(sp)
    800038f8:	6be2                	ld	s7,24(sp)
    800038fa:	6c42                	ld	s8,16(sp)
    800038fc:	6ca2                	ld	s9,8(sp)
    800038fe:	6d02                	ld	s10,0(sp)
    80003900:	6125                	addi	sp,sp,96
    80003902:	8082                	ret
      iunlockput(ip);
    80003904:	8552                	mv	a0,s4
    80003906:	b47ff0ef          	jal	8000344c <iunlockput>
      return 0;
    8000390a:	bfe9                	j	800038e4 <namex+0x5a>
      iunlock(ip);
    8000390c:	8552                	mv	a0,s4
    8000390e:	999ff0ef          	jal	800032a6 <iunlock>
      return ip;
    80003912:	bfd1                	j	800038e6 <namex+0x5c>
      iunlockput(ip);
    80003914:	8552                	mv	a0,s4
    80003916:	b37ff0ef          	jal	8000344c <iunlockput>
      return 0;
    8000391a:	8a4a                	mv	s4,s2
    8000391c:	b7e9                	j	800038e6 <namex+0x5c>
  while (*path != '/' && *path != 0)
    8000391e:	8926                	mv	s2,s1
  len = path - s;
    80003920:	4d01                	li	s10,0
    80003922:	4601                	li	a2,0
    memmove(name, s, len);
    80003924:	2601                	sext.w	a2,a2
    80003926:	85a6                	mv	a1,s1
    80003928:	8556                	mv	a0,s5
    8000392a:	be6fd0ef          	jal	80000d10 <memmove>
    name[len] = 0;
    8000392e:	9d56                	add	s10,s10,s5
    80003930:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde450>
    80003934:	84ca                	mv	s1,s2
  while (*path == '/')
    80003936:	0004c783          	lbu	a5,0(s1)
    8000393a:	01379763          	bne	a5,s3,80003948 <namex+0xbe>
    path++;
    8000393e:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003940:	0004c783          	lbu	a5,0(s1)
    80003944:	ff378de3          	beq	a5,s3,8000393e <namex+0xb4>
    ilock(ip);
    80003948:	8552                	mv	a0,s4
    8000394a:	8afff0ef          	jal	800031f8 <ilock>
    if (ip->type != T_DIR) {
    8000394e:	044a1783          	lh	a5,68(s4)
    80003952:	f97796e3          	bne	a5,s7,800038de <namex+0x54>
    if (ip->nlink == 0) {
    80003956:	04aa1783          	lh	a5,74(s4)
    8000395a:	d7cd                	beqz	a5,80003904 <namex+0x7a>
    if (nameiparent && *path == '\0') {
    8000395c:	000b0563          	beqz	s6,80003966 <namex+0xdc>
    80003960:	0004c783          	lbu	a5,0(s1)
    80003964:	d7c5                	beqz	a5,8000390c <namex+0x82>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003966:	4601                	li	a2,0
    80003968:	85d6                	mv	a1,s5
    8000396a:	8552                	mv	a0,s4
    8000396c:	e77ff0ef          	jal	800037e2 <dirlookup>
    80003970:	892a                	mv	s2,a0
    80003972:	d14d                	beqz	a0,80003914 <namex+0x8a>
    iunlockput(ip);
    80003974:	8552                	mv	a0,s4
    80003976:	ad7ff0ef          	jal	8000344c <iunlockput>
    ip = next;
    8000397a:	8a4a                	mv	s4,s2
  while (*path == '/')
    8000397c:	0004c783          	lbu	a5,0(s1)
    80003980:	01379763          	bne	a5,s3,8000398e <namex+0x104>
    path++;
    80003984:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003986:	0004c783          	lbu	a5,0(s1)
    8000398a:	ff378de3          	beq	a5,s3,80003984 <namex+0xfa>
  if (*path == 0)
    8000398e:	c7a1                	beqz	a5,800039d6 <namex+0x14c>
  while (*path != '/' && *path != 0)
    80003990:	0004c703          	lbu	a4,0(s1)
    80003994:	fd170793          	addi	a5,a4,-47
    80003998:	00f037b3          	snez	a5,a5
    8000399c:	00e03733          	snez	a4,a4
    800039a0:	8ff9                	and	a5,a5,a4
    800039a2:	dfb5                	beqz	a5,8000391e <namex+0x94>
    800039a4:	8926                	mv	s2,s1
    path++;
    800039a6:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    800039a8:	00094703          	lbu	a4,0(s2)
    800039ac:	fd170793          	addi	a5,a4,-47
    800039b0:	00f037b3          	snez	a5,a5
    800039b4:	00e03733          	snez	a4,a4
    800039b8:	8ff9                	and	a5,a5,a4
    800039ba:	f7f5                	bnez	a5,800039a6 <namex+0x11c>
  len = path - s;
    800039bc:	40990633          	sub	a2,s2,s1
    800039c0:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    800039c4:	f7ac50e3          	bge	s8,s10,80003924 <namex+0x9a>
    memmove(name, s, DIRSIZ);
    800039c8:	8666                	mv	a2,s9
    800039ca:	85a6                	mv	a1,s1
    800039cc:	8556                	mv	a0,s5
    800039ce:	b42fd0ef          	jal	80000d10 <memmove>
    800039d2:	84ca                	mv	s1,s2
    800039d4:	b78d                	j	80003936 <namex+0xac>
  if (nameiparent) {
    800039d6:	f00b08e3          	beqz	s6,800038e6 <namex+0x5c>
    iput(ip);
    800039da:	8552                	mv	a0,s4
    800039dc:	99fff0ef          	jal	8000337a <iput>
    return 0;
    800039e0:	b711                	j	800038e4 <namex+0x5a>

00000000800039e2 <dirlink>:
{
    800039e2:	715d                	addi	sp,sp,-80
    800039e4:	e486                	sd	ra,72(sp)
    800039e6:	e0a2                	sd	s0,64(sp)
    800039e8:	f84a                	sd	s2,48(sp)
    800039ea:	ec56                	sd	s5,24(sp)
    800039ec:	e85a                	sd	s6,16(sp)
    800039ee:	0880                	addi	s0,sp,80
    800039f0:	892a                	mv	s2,a0
    800039f2:	8aae                	mv	s5,a1
    800039f4:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800039f6:	4601                	li	a2,0
    800039f8:	debff0ef          	jal	800037e2 <dirlookup>
    800039fc:	ed1d                	bnez	a0,80003a3a <dirlink+0x58>
    800039fe:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a00:	04c92483          	lw	s1,76(s2)
    80003a04:	c4b9                	beqz	s1,80003a52 <dirlink+0x70>
    80003a06:	f44e                	sd	s3,40(sp)
    80003a08:	f052                	sd	s4,32(sp)
    80003a0a:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a0c:	fb040a13          	addi	s4,s0,-80
    80003a10:	49c1                	li	s3,16
    80003a12:	874e                	mv	a4,s3
    80003a14:	86a6                	mv	a3,s1
    80003a16:	8652                	mv	a2,s4
    80003a18:	4581                	li	a1,0
    80003a1a:	854a                	mv	a0,s2
    80003a1c:	bb7ff0ef          	jal	800035d2 <readi>
    80003a20:	03351163          	bne	a0,s3,80003a42 <dirlink+0x60>
    if (de.inum == 0)
    80003a24:	fb045783          	lhu	a5,-80(s0)
    80003a28:	c39d                	beqz	a5,80003a4e <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a2a:	24c1                	addiw	s1,s1,16
    80003a2c:	04c92783          	lw	a5,76(s2)
    80003a30:	fef4e1e3          	bltu	s1,a5,80003a12 <dirlink+0x30>
    80003a34:	79a2                	ld	s3,40(sp)
    80003a36:	7a02                	ld	s4,32(sp)
    80003a38:	a829                	j	80003a52 <dirlink+0x70>
    iput(ip);
    80003a3a:	941ff0ef          	jal	8000337a <iput>
    return -1;
    80003a3e:	557d                	li	a0,-1
    80003a40:	a83d                	j	80003a7e <dirlink+0x9c>
      panic("dirlink read");
    80003a42:	00004517          	auipc	a0,0x4
    80003a46:	aa650513          	addi	a0,a0,-1370 # 800074e8 <etext+0x4e8>
    80003a4a:	dfffc0ef          	jal	80000848 <panic>
    80003a4e:	79a2                	ld	s3,40(sp)
    80003a50:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003a52:	4639                	li	a2,14
    80003a54:	85d6                	mv	a1,s5
    80003a56:	fb240513          	addi	a0,s0,-78
    80003a5a:	b60fd0ef          	jal	80000dba <strncpy>
  de.inum = inum;
    80003a5e:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a62:	4741                	li	a4,16
    80003a64:	86a6                	mv	a3,s1
    80003a66:	fb040613          	addi	a2,s0,-80
    80003a6a:	4581                	li	a1,0
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	c57ff0ef          	jal	800036c4 <writei>
    80003a72:	1541                	addi	a0,a0,-16
    80003a74:	00a03533          	snez	a0,a0
    80003a78:	40a0053b          	negw	a0,a0
    80003a7c:	74e2                	ld	s1,56(sp)
}
    80003a7e:	60a6                	ld	ra,72(sp)
    80003a80:	6406                	ld	s0,64(sp)
    80003a82:	7942                	ld	s2,48(sp)
    80003a84:	6ae2                	ld	s5,24(sp)
    80003a86:	6b42                	ld	s6,16(sp)
    80003a88:	6161                	addi	sp,sp,80
    80003a8a:	8082                	ret

0000000080003a8c <namei>:

struct inode *
namei(char *path)
{
    80003a8c:	1101                	addi	sp,sp,-32
    80003a8e:	ec06                	sd	ra,24(sp)
    80003a90:	e822                	sd	s0,16(sp)
    80003a92:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a94:	fe040613          	addi	a2,s0,-32
    80003a98:	4581                	li	a1,0
    80003a9a:	df1ff0ef          	jal	8000388a <namex>
}
    80003a9e:	60e2                	ld	ra,24(sp)
    80003aa0:	6442                	ld	s0,16(sp)
    80003aa2:	6105                	addi	sp,sp,32
    80003aa4:	8082                	ret

0000000080003aa6 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003aa6:	1141                	addi	sp,sp,-16
    80003aa8:	e406                	sd	ra,8(sp)
    80003aaa:	e022                	sd	s0,0(sp)
    80003aac:	0800                	addi	s0,sp,16
    80003aae:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ab0:	4585                	li	a1,1
    80003ab2:	dd9ff0ef          	jal	8000388a <namex>
}
    80003ab6:	60a2                	ld	ra,8(sp)
    80003ab8:	6402                	ld	s0,0(sp)
    80003aba:	0141                	addi	sp,sp,16
    80003abc:	8082                	ret

0000000080003abe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003abe:	1101                	addi	sp,sp,-32
    80003ac0:	ec06                	sd	ra,24(sp)
    80003ac2:	e822                	sd	s0,16(sp)
    80003ac4:	e426                	sd	s1,8(sp)
    80003ac6:	e04a                	sd	s2,0(sp)
    80003ac8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003aca:	0001c917          	auipc	s2,0x1c
    80003ace:	ea690913          	addi	s2,s2,-346 # 8001f970 <log>
    80003ad2:	01892583          	lw	a1,24(s2)
    80003ad6:	02492503          	lw	a0,36(s2)
    80003ada:	87eff0ef          	jal	80002b58 <bread>
    80003ade:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003ae0:	02c92603          	lw	a2,44(s2)
    80003ae4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ae6:	00c05f63          	blez	a2,80003b04 <write_head+0x46>
    80003aea:	0001c717          	auipc	a4,0x1c
    80003aee:	eb670713          	addi	a4,a4,-330 # 8001f9a0 <log+0x30>
    80003af2:	87aa                	mv	a5,a0
    80003af4:	060a                	slli	a2,a2,0x2
    80003af6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003af8:	4314                	lw	a3,0(a4)
    80003afa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003afc:	0711                	addi	a4,a4,4
    80003afe:	0791                	addi	a5,a5,4 # 43004 <_entry-0x7ffbcffc>
    80003b00:	fec79ce3          	bne	a5,a2,80003af8 <write_head+0x3a>
  }
  bwrite(buf);
    80003b04:	8526                	mv	a0,s1
    80003b06:	928ff0ef          	jal	80002c2e <bwrite>
  brelse(buf);
    80003b0a:	8526                	mv	a0,s1
    80003b0c:	954ff0ef          	jal	80002c60 <brelse>
}
    80003b10:	60e2                	ld	ra,24(sp)
    80003b12:	6442                	ld	s0,16(sp)
    80003b14:	64a2                	ld	s1,8(sp)
    80003b16:	6902                	ld	s2,0(sp)
    80003b18:	6105                	addi	sp,sp,32
    80003b1a:	8082                	ret

0000000080003b1c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b1c:	0001c797          	auipc	a5,0x1c
    80003b20:	e807a783          	lw	a5,-384(a5) # 8001f99c <log+0x2c>
    80003b24:	0cf05163          	blez	a5,80003be6 <install_trans+0xca>
{
    80003b28:	715d                	addi	sp,sp,-80
    80003b2a:	e486                	sd	ra,72(sp)
    80003b2c:	e0a2                	sd	s0,64(sp)
    80003b2e:	fc26                	sd	s1,56(sp)
    80003b30:	f84a                	sd	s2,48(sp)
    80003b32:	f44e                	sd	s3,40(sp)
    80003b34:	f052                	sd	s4,32(sp)
    80003b36:	ec56                	sd	s5,24(sp)
    80003b38:	e85a                	sd	s6,16(sp)
    80003b3a:	e45e                	sd	s7,8(sp)
    80003b3c:	e062                	sd	s8,0(sp)
    80003b3e:	0880                	addi	s0,sp,80
    80003b40:	8b2a                	mv	s6,a0
    80003b42:	0001ca97          	auipc	s5,0x1c
    80003b46:	e5ea8a93          	addi	s5,s5,-418 # 8001f9a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b4a:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b4c:	00004c17          	auipc	s8,0x4
    80003b50:	9acc0c13          	addi	s8,s8,-1620 # 800074f8 <etext+0x4f8>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003b54:	0001ca17          	auipc	s4,0x1c
    80003b58:	e1ca0a13          	addi	s4,s4,-484 # 8001f970 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003b5c:	40000b93          	li	s7,1024
    80003b60:	a025                	j	80003b88 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b62:	000aa603          	lw	a2,0(s5)
    80003b66:	85ce                	mv	a1,s3
    80003b68:	8562                	mv	a0,s8
    80003b6a:	9a7fc0ef          	jal	80000510 <printk>
    80003b6e:	a839                	j	80003b8c <install_trans+0x70>
    brelse(lbuf);
    80003b70:	854a                	mv	a0,s2
    80003b72:	8eeff0ef          	jal	80002c60 <brelse>
    brelse(dbuf);
    80003b76:	8526                	mv	a0,s1
    80003b78:	8e8ff0ef          	jal	80002c60 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b7c:	2985                	addiw	s3,s3,1
    80003b7e:	0a91                	addi	s5,s5,4
    80003b80:	02ca2783          	lw	a5,44(s4)
    80003b84:	04f9d563          	bge	s3,a5,80003bce <install_trans+0xb2>
    if (recovering) {
    80003b88:	fc0b1de3          	bnez	s6,80003b62 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003b8c:	018a2583          	lw	a1,24(s4)
    80003b90:	013585bb          	addw	a1,a1,s3
    80003b94:	2585                	addiw	a1,a1,1
    80003b96:	024a2503          	lw	a0,36(s4)
    80003b9a:	fbffe0ef          	jal	80002b58 <bread>
    80003b9e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003ba0:	000aa583          	lw	a1,0(s5)
    80003ba4:	024a2503          	lw	a0,36(s4)
    80003ba8:	fb1fe0ef          	jal	80002b58 <bread>
    80003bac:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003bae:	865e                	mv	a2,s7
    80003bb0:	05890593          	addi	a1,s2,88
    80003bb4:	05850513          	addi	a0,a0,88
    80003bb8:	958fd0ef          	jal	80000d10 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003bbc:	8526                	mv	a0,s1
    80003bbe:	870ff0ef          	jal	80002c2e <bwrite>
    if (recovering == 0)
    80003bc2:	fa0b17e3          	bnez	s6,80003b70 <install_trans+0x54>
      bunpin(dbuf);
    80003bc6:	8526                	mv	a0,s1
    80003bc8:	950ff0ef          	jal	80002d18 <bunpin>
    80003bcc:	b755                	j	80003b70 <install_trans+0x54>
}
    80003bce:	60a6                	ld	ra,72(sp)
    80003bd0:	6406                	ld	s0,64(sp)
    80003bd2:	74e2                	ld	s1,56(sp)
    80003bd4:	7942                	ld	s2,48(sp)
    80003bd6:	79a2                	ld	s3,40(sp)
    80003bd8:	7a02                	ld	s4,32(sp)
    80003bda:	6ae2                	ld	s5,24(sp)
    80003bdc:	6b42                	ld	s6,16(sp)
    80003bde:	6ba2                	ld	s7,8(sp)
    80003be0:	6c02                	ld	s8,0(sp)
    80003be2:	6161                	addi	sp,sp,80
    80003be4:	8082                	ret
    80003be6:	8082                	ret

0000000080003be8 <initlog>:
{
    80003be8:	7179                	addi	sp,sp,-48
    80003bea:	f406                	sd	ra,40(sp)
    80003bec:	f022                	sd	s0,32(sp)
    80003bee:	ec26                	sd	s1,24(sp)
    80003bf0:	e84a                	sd	s2,16(sp)
    80003bf2:	e44e                	sd	s3,8(sp)
    80003bf4:	1800                	addi	s0,sp,48
    80003bf6:	84aa                	mv	s1,a0
    80003bf8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003bfa:	0001c917          	auipc	s2,0x1c
    80003bfe:	d7690913          	addi	s2,s2,-650 # 8001f970 <log>
    80003c02:	00004597          	auipc	a1,0x4
    80003c06:	91658593          	addi	a1,a1,-1770 # 80007518 <etext+0x518>
    80003c0a:	854a                	mv	a0,s2
    80003c0c:	f6dfc0ef          	jal	80000b78 <initlock>
  log.start = sb->logstart;
    80003c10:	0149a583          	lw	a1,20(s3)
    80003c14:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003c18:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003c1c:	8526                	mv	a0,s1
    80003c1e:	f3bfe0ef          	jal	80002b58 <bread>
  log.lh.n = lh->n;
    80003c22:	4d30                	lw	a2,88(a0)
    80003c24:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003c28:	00c05f63          	blez	a2,80003c46 <initlog+0x5e>
    80003c2c:	87aa                	mv	a5,a0
    80003c2e:	0001c717          	auipc	a4,0x1c
    80003c32:	d7270713          	addi	a4,a4,-654 # 8001f9a0 <log+0x30>
    80003c36:	060a                	slli	a2,a2,0x2
    80003c38:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c3a:	4ff4                	lw	a3,92(a5)
    80003c3c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c3e:	0791                	addi	a5,a5,4
    80003c40:	0711                	addi	a4,a4,4
    80003c42:	fec79ce3          	bne	a5,a2,80003c3a <initlog+0x52>
  brelse(buf);
    80003c46:	81aff0ef          	jal	80002c60 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c4a:	4505                	li	a0,1
    80003c4c:	ed1ff0ef          	jal	80003b1c <install_trans>
  log.lh.n = 0;
    80003c50:	0001c797          	auipc	a5,0x1c
    80003c54:	d407a623          	sw	zero,-692(a5) # 8001f99c <log+0x2c>
  write_head(); // clear the log
    80003c58:	e67ff0ef          	jal	80003abe <write_head>
}
    80003c5c:	70a2                	ld	ra,40(sp)
    80003c5e:	7402                	ld	s0,32(sp)
    80003c60:	64e2                	ld	s1,24(sp)
    80003c62:	6942                	ld	s2,16(sp)
    80003c64:	69a2                	ld	s3,8(sp)
    80003c66:	6145                	addi	sp,sp,48
    80003c68:	8082                	ret

0000000080003c6a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c6a:	1101                	addi	sp,sp,-32
    80003c6c:	ec06                	sd	ra,24(sp)
    80003c6e:	e822                	sd	s0,16(sp)
    80003c70:	e426                	sd	s1,8(sp)
    80003c72:	e04a                	sd	s2,0(sp)
    80003c74:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c76:	0001c517          	auipc	a0,0x1c
    80003c7a:	cfa50513          	addi	a0,a0,-774 # 8001f970 <log>
    80003c7e:	f7bfc0ef          	jal	80000bf8 <acquire>
  while (1) {
    if (log.committing) {
    80003c82:	0001c497          	auipc	s1,0x1c
    80003c86:	cee48493          	addi	s1,s1,-786 # 8001f970 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003c8a:	4979                	li	s2,30
    80003c8c:	a821                	j	80003ca4 <begin_op+0x3a>
      sleep_prepare(&log);
    80003c8e:	8526                	mv	a0,s1
    80003c90:	a5afe0ef          	jal	80001eea <sleep_prepare>
      release(&log.lock);
    80003c94:	8526                	mv	a0,s1
    80003c96:	fe7fc0ef          	jal	80000c7c <release>
      sleep();
    80003c9a:	a8cfe0ef          	jal	80001f26 <sleep>
      acquire(&log.lock);
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	f59fc0ef          	jal	80000bf8 <acquire>
    if (log.committing) {
    80003ca4:	509c                	lw	a5,32(s1)
    80003ca6:	f7e5                	bnez	a5,80003c8e <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003ca8:	4cd8                	lw	a4,28(s1)
    80003caa:	2705                	addiw	a4,a4,1
    80003cac:	0027179b          	slliw	a5,a4,0x2
    80003cb0:	9fb9                	addw	a5,a5,a4
    80003cb2:	0017979b          	slliw	a5,a5,0x1
    80003cb6:	54d4                	lw	a3,44(s1)
    80003cb8:	9fb5                	addw	a5,a5,a3
    80003cba:	00f95e63          	bge	s2,a5,80003cd6 <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80003cbe:	8526                	mv	a0,s1
    80003cc0:	a2afe0ef          	jal	80001eea <sleep_prepare>
      release(&log.lock);
    80003cc4:	8526                	mv	a0,s1
    80003cc6:	fb7fc0ef          	jal	80000c7c <release>
      sleep();
    80003cca:	a5cfe0ef          	jal	80001f26 <sleep>
      acquire(&log.lock);
    80003cce:	8526                	mv	a0,s1
    80003cd0:	f29fc0ef          	jal	80000bf8 <acquire>
    80003cd4:	bfc1                	j	80003ca4 <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80003cd6:	0001c797          	auipc	a5,0x1c
    80003cda:	cae7ab23          	sw	a4,-842(a5) # 8001f98c <log+0x1c>
      release(&log.lock);
    80003cde:	0001c517          	auipc	a0,0x1c
    80003ce2:	c9250513          	addi	a0,a0,-878 # 8001f970 <log>
    80003ce6:	f97fc0ef          	jal	80000c7c <release>
      break;
    }
  }
}
    80003cea:	60e2                	ld	ra,24(sp)
    80003cec:	6442                	ld	s0,16(sp)
    80003cee:	64a2                	ld	s1,8(sp)
    80003cf0:	6902                	ld	s2,0(sp)
    80003cf2:	6105                	addi	sp,sp,32
    80003cf4:	8082                	ret

0000000080003cf6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003cf6:	7139                	addi	sp,sp,-64
    80003cf8:	fc06                	sd	ra,56(sp)
    80003cfa:	f822                	sd	s0,48(sp)
    80003cfc:	f426                	sd	s1,40(sp)
    80003cfe:	f04a                	sd	s2,32(sp)
    80003d00:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d02:	0001c497          	auipc	s1,0x1c
    80003d06:	c6e48493          	addi	s1,s1,-914 # 8001f970 <log>
    80003d0a:	8526                	mv	a0,s1
    80003d0c:	eedfc0ef          	jal	80000bf8 <acquire>
  log.outstanding -= 1;
    80003d10:	4cdc                	lw	a5,28(s1)
    80003d12:	37fd                	addiw	a5,a5,-1
    80003d14:	893e                	mv	s2,a5
    80003d16:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003d18:	509c                	lw	a5,32(s1)
    80003d1a:	e7b9                	bnez	a5,80003d68 <end_op+0x72>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003d1c:	04091f63          	bnez	s2,80003d7a <end_op+0x84>
    do_commit = 1;
    log.committing = 1;
    80003d20:	0001c497          	auipc	s1,0x1c
    80003d24:	c5048493          	addi	s1,s1,-944 # 8001f970 <log>
    80003d28:	4785                	li	a5,1
    80003d2a:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003d2c:	8526                	mv	a0,s1
    80003d2e:	f4ffc0ef          	jal	80000c7c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003d32:	54dc                	lw	a5,44(s1)
    80003d34:	06f04063          	bgtz	a5,80003d94 <end_op+0x9e>
    acquire(&log.lock);
    80003d38:	0001c497          	auipc	s1,0x1c
    80003d3c:	c3848493          	addi	s1,s1,-968 # 8001f970 <log>
    80003d40:	8526                	mv	a0,s1
    80003d42:	eb7fc0ef          	jal	80000bf8 <acquire>
    log.committing = 0;
    80003d46:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003d4a:	549c                	lw	a5,40(s1)
    80003d4c:	2785                	addiw	a5,a5,1
    80003d4e:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003d50:	8526                	mv	a0,s1
    80003d52:	a04fe0ef          	jal	80001f56 <wakeup>
    release(&log.lock);
    80003d56:	8526                	mv	a0,s1
    80003d58:	f25fc0ef          	jal	80000c7c <release>
}
    80003d5c:	70e2                	ld	ra,56(sp)
    80003d5e:	7442                	ld	s0,48(sp)
    80003d60:	74a2                	ld	s1,40(sp)
    80003d62:	7902                	ld	s2,32(sp)
    80003d64:	6121                	addi	sp,sp,64
    80003d66:	8082                	ret
    80003d68:	ec4e                	sd	s3,24(sp)
    80003d6a:	e852                	sd	s4,16(sp)
    80003d6c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003d6e:	00003517          	auipc	a0,0x3
    80003d72:	7b250513          	addi	a0,a0,1970 # 80007520 <etext+0x520>
    80003d76:	ad3fc0ef          	jal	80000848 <panic>
    wakeup(&log);
    80003d7a:	0001c517          	auipc	a0,0x1c
    80003d7e:	bf650513          	addi	a0,a0,-1034 # 8001f970 <log>
    80003d82:	9d4fe0ef          	jal	80001f56 <wakeup>
  release(&log.lock);
    80003d86:	0001c517          	auipc	a0,0x1c
    80003d8a:	bea50513          	addi	a0,a0,-1046 # 8001f970 <log>
    80003d8e:	eeffc0ef          	jal	80000c7c <release>
  if (do_commit) {
    80003d92:	b7e9                	j	80003d5c <end_op+0x66>
    80003d94:	ec4e                	sd	s3,24(sp)
    80003d96:	e852                	sd	s4,16(sp)
    80003d98:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d9a:	0001ca97          	auipc	s5,0x1c
    80003d9e:	c06a8a93          	addi	s5,s5,-1018 # 8001f9a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003da2:	0001ca17          	auipc	s4,0x1c
    80003da6:	bcea0a13          	addi	s4,s4,-1074 # 8001f970 <log>
    80003daa:	018a2583          	lw	a1,24(s4)
    80003dae:	012585bb          	addw	a1,a1,s2
    80003db2:	2585                	addiw	a1,a1,1
    80003db4:	024a2503          	lw	a0,36(s4)
    80003db8:	da1fe0ef          	jal	80002b58 <bread>
    80003dbc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003dbe:	000aa583          	lw	a1,0(s5)
    80003dc2:	024a2503          	lw	a0,36(s4)
    80003dc6:	d93fe0ef          	jal	80002b58 <bread>
    80003dca:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003dcc:	40000613          	li	a2,1024
    80003dd0:	05850593          	addi	a1,a0,88
    80003dd4:	05848513          	addi	a0,s1,88
    80003dd8:	f39fc0ef          	jal	80000d10 <memmove>
    bwrite(to); // write the log
    80003ddc:	8526                	mv	a0,s1
    80003dde:	e51fe0ef          	jal	80002c2e <bwrite>
    brelse(from);
    80003de2:	854e                	mv	a0,s3
    80003de4:	e7dfe0ef          	jal	80002c60 <brelse>
    brelse(to);
    80003de8:	8526                	mv	a0,s1
    80003dea:	e77fe0ef          	jal	80002c60 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dee:	2905                	addiw	s2,s2,1
    80003df0:	0a91                	addi	s5,s5,4
    80003df2:	02ca2783          	lw	a5,44(s4)
    80003df6:	faf94ae3          	blt	s2,a5,80003daa <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003dfa:	cc5ff0ef          	jal	80003abe <write_head>
    install_trans(0); // Now install writes to home locations
    80003dfe:	4501                	li	a0,0
    80003e00:	d1dff0ef          	jal	80003b1c <install_trans>
    log.lh.n = 0;
    80003e04:	0001c797          	auipc	a5,0x1c
    80003e08:	b807ac23          	sw	zero,-1128(a5) # 8001f99c <log+0x2c>
    write_head(); // Erase the transaction from the log
    80003e0c:	cb3ff0ef          	jal	80003abe <write_head>
    80003e10:	69e2                	ld	s3,24(sp)
    80003e12:	6a42                	ld	s4,16(sp)
    80003e14:	6aa2                	ld	s5,8(sp)
    80003e16:	b70d                	j	80003d38 <end_op+0x42>

0000000080003e18 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e18:	1101                	addi	sp,sp,-32
    80003e1a:	ec06                	sd	ra,24(sp)
    80003e1c:	e822                	sd	s0,16(sp)
    80003e1e:	e426                	sd	s1,8(sp)
    80003e20:	1000                	addi	s0,sp,32
    80003e22:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003e24:	0001c517          	auipc	a0,0x1c
    80003e28:	b4c50513          	addi	a0,a0,-1204 # 8001f970 <log>
    80003e2c:	dcdfc0ef          	jal	80000bf8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003e30:	0001c617          	auipc	a2,0x1c
    80003e34:	b6c62603          	lw	a2,-1172(a2) # 8001f99c <log+0x2c>
    80003e38:	47f5                	li	a5,29
    80003e3a:	04c7cc63          	blt	a5,a2,80003e92 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003e3e:	0001c797          	auipc	a5,0x1c
    80003e42:	b4e7a783          	lw	a5,-1202(a5) # 8001f98c <log+0x1c>
    80003e46:	04f05c63          	blez	a5,80003e9e <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e4a:	4781                	li	a5,0
    80003e4c:	04c05f63          	blez	a2,80003eaa <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003e50:	44cc                	lw	a1,12(s1)
    80003e52:	0001c717          	auipc	a4,0x1c
    80003e56:	b4e70713          	addi	a4,a4,-1202 # 8001f9a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003e5a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003e5c:	4314                	lw	a3,0(a4)
    80003e5e:	04b68663          	beq	a3,a1,80003eaa <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003e62:	2785                	addiw	a5,a5,1
    80003e64:	0711                	addi	a4,a4,4
    80003e66:	fef61be3          	bne	a2,a5,80003e5c <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e6a:	0621                	addi	a2,a2,8
    80003e6c:	060a                	slli	a2,a2,0x2
    80003e6e:	0001c797          	auipc	a5,0x1c
    80003e72:	b0278793          	addi	a5,a5,-1278 # 8001f970 <log>
    80003e76:	97b2                	add	a5,a5,a2
    80003e78:	44d8                	lw	a4,12(s1)
    80003e7a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003e7c:	8526                	mv	a0,s1
    80003e7e:	e67fe0ef          	jal	80002ce4 <bpin>
    log.lh.n++;
    80003e82:	0001c717          	auipc	a4,0x1c
    80003e86:	aee70713          	addi	a4,a4,-1298 # 8001f970 <log>
    80003e8a:	575c                	lw	a5,44(a4)
    80003e8c:	2785                	addiw	a5,a5,1
    80003e8e:	d75c                	sw	a5,44(a4)
    80003e90:	a80d                	j	80003ec2 <log_write+0xaa>
    panic("too big a transaction");
    80003e92:	00003517          	auipc	a0,0x3
    80003e96:	69e50513          	addi	a0,a0,1694 # 80007530 <etext+0x530>
    80003e9a:	9affc0ef          	jal	80000848 <panic>
    panic("log_write outside of trans");
    80003e9e:	00003517          	auipc	a0,0x3
    80003ea2:	6aa50513          	addi	a0,a0,1706 # 80007548 <etext+0x548>
    80003ea6:	9a3fc0ef          	jal	80000848 <panic>
  log.lh.block[i] = b->blockno;
    80003eaa:	00878693          	addi	a3,a5,8
    80003eae:	068a                	slli	a3,a3,0x2
    80003eb0:	0001c717          	auipc	a4,0x1c
    80003eb4:	ac070713          	addi	a4,a4,-1344 # 8001f970 <log>
    80003eb8:	9736                	add	a4,a4,a3
    80003eba:	44d4                	lw	a3,12(s1)
    80003ebc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80003ebe:	faf60fe3          	beq	a2,a5,80003e7c <log_write+0x64>
  }
  release(&log.lock);
    80003ec2:	0001c517          	auipc	a0,0x1c
    80003ec6:	aae50513          	addi	a0,a0,-1362 # 8001f970 <log>
    80003eca:	db3fc0ef          	jal	80000c7c <release>
}
    80003ece:	60e2                	ld	ra,24(sp)
    80003ed0:	6442                	ld	s0,16(sp)
    80003ed2:	64a2                	ld	s1,8(sp)
    80003ed4:	6105                	addi	sp,sp,32
    80003ed6:	8082                	ret

0000000080003ed8 <sys_sync>:

uint64
sys_sync(void)
{
    80003ed8:	1101                	addi	sp,sp,-32
    80003eda:	ec06                	sd	ra,24(sp)
    80003edc:	e822                	sd	s0,16(sp)
    80003ede:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003ee0:	0001c517          	auipc	a0,0x1c
    80003ee4:	a9050513          	addi	a0,a0,-1392 # 8001f970 <log>
    80003ee8:	d11fc0ef          	jal	80000bf8 <acquire>
  if (log.committing || log.outstanding > 0) {
    80003eec:	0001c797          	auipc	a5,0x1c
    80003ef0:	aa47a783          	lw	a5,-1372(a5) # 8001f990 <log+0x20>
    80003ef4:	e799                	bnez	a5,80003f02 <sys_sync+0x2a>
    80003ef6:	0001c797          	auipc	a5,0x1c
    80003efa:	a967a783          	lw	a5,-1386(a5) # 8001f98c <log+0x1c>
    80003efe:	02f05c63          	blez	a5,80003f36 <sys_sync+0x5e>
    80003f02:	e426                	sd	s1,8(sp)
    80003f04:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80003f06:	0001c917          	auipc	s2,0x1c
    80003f0a:	a9292903          	lw	s2,-1390(s2) # 8001f998 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    80003f0e:	0001c497          	auipc	s1,0x1c
    80003f12:	a6248493          	addi	s1,s1,-1438 # 8001f970 <log>
    80003f16:	8526                	mv	a0,s1
    80003f18:	fd3fd0ef          	jal	80001eea <sleep_prepare>
      release(&log.lock);
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	d5ffc0ef          	jal	80000c7c <release>
      sleep();
    80003f22:	804fe0ef          	jal	80001f26 <sleep>
      acquire(&log.lock);
    80003f26:	8526                	mv	a0,s1
    80003f28:	cd1fc0ef          	jal	80000bf8 <acquire>
    while (log.ncommit < n) {
    80003f2c:	549c                	lw	a5,40(s1)
    80003f2e:	fef954e3          	bge	s2,a5,80003f16 <sys_sync+0x3e>
    80003f32:	64a2                	ld	s1,8(sp)
    80003f34:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80003f36:	0001c517          	auipc	a0,0x1c
    80003f3a:	a3a50513          	addi	a0,a0,-1478 # 8001f970 <log>
    80003f3e:	d3ffc0ef          	jal	80000c7c <release>
  return 0;
}
    80003f42:	4501                	li	a0,0
    80003f44:	60e2                	ld	ra,24(sp)
    80003f46:	6442                	ld	s0,16(sp)
    80003f48:	6105                	addi	sp,sp,32
    80003f4a:	8082                	ret

0000000080003f4c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003f4c:	1101                	addi	sp,sp,-32
    80003f4e:	ec06                	sd	ra,24(sp)
    80003f50:	e822                	sd	s0,16(sp)
    80003f52:	e426                	sd	s1,8(sp)
    80003f54:	e04a                	sd	s2,0(sp)
    80003f56:	1000                	addi	s0,sp,32
    80003f58:	84aa                	mv	s1,a0
    80003f5a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003f5c:	00003597          	auipc	a1,0x3
    80003f60:	60c58593          	addi	a1,a1,1548 # 80007568 <etext+0x568>
    80003f64:	0521                	addi	a0,a0,8
    80003f66:	c13fc0ef          	jal	80000b78 <initlock>
  lk->name = name;
    80003f6a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003f6e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f72:	0204a423          	sw	zero,40(s1)
}
    80003f76:	60e2                	ld	ra,24(sp)
    80003f78:	6442                	ld	s0,16(sp)
    80003f7a:	64a2                	ld	s1,8(sp)
    80003f7c:	6902                	ld	s2,0(sp)
    80003f7e:	6105                	addi	sp,sp,32
    80003f80:	8082                	ret

0000000080003f82 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003f82:	1101                	addi	sp,sp,-32
    80003f84:	ec06                	sd	ra,24(sp)
    80003f86:	e822                	sd	s0,16(sp)
    80003f88:	e426                	sd	s1,8(sp)
    80003f8a:	e04a                	sd	s2,0(sp)
    80003f8c:	1000                	addi	s0,sp,32
    80003f8e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f90:	00850913          	addi	s2,a0,8
    80003f94:	854a                	mv	a0,s2
    80003f96:	c63fc0ef          	jal	80000bf8 <acquire>
  while (lk->locked) {
    80003f9a:	409c                	lw	a5,0(s1)
    80003f9c:	cf91                	beqz	a5,80003fb8 <acquiresleep+0x36>
    sleep_prepare(lk);
    80003f9e:	8526                	mv	a0,s1
    80003fa0:	f4bfd0ef          	jal	80001eea <sleep_prepare>
    release(&lk->lk);
    80003fa4:	854a                	mv	a0,s2
    80003fa6:	cd7fc0ef          	jal	80000c7c <release>
    sleep();
    80003faa:	f7dfd0ef          	jal	80001f26 <sleep>
    acquire(&lk->lk);
    80003fae:	854a                	mv	a0,s2
    80003fb0:	c49fc0ef          	jal	80000bf8 <acquire>
  while (lk->locked) {
    80003fb4:	409c                	lw	a5,0(s1)
    80003fb6:	f7e5                	bnez	a5,80003f9e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003fb8:	4785                	li	a5,1
    80003fba:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003fbc:	927fd0ef          	jal	800018e2 <myproc>
    80003fc0:	591c                	lw	a5,48(a0)
    80003fc2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003fc4:	854a                	mv	a0,s2
    80003fc6:	cb7fc0ef          	jal	80000c7c <release>
}
    80003fca:	60e2                	ld	ra,24(sp)
    80003fcc:	6442                	ld	s0,16(sp)
    80003fce:	64a2                	ld	s1,8(sp)
    80003fd0:	6902                	ld	s2,0(sp)
    80003fd2:	6105                	addi	sp,sp,32
    80003fd4:	8082                	ret

0000000080003fd6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003fd6:	1101                	addi	sp,sp,-32
    80003fd8:	ec06                	sd	ra,24(sp)
    80003fda:	e822                	sd	s0,16(sp)
    80003fdc:	e426                	sd	s1,8(sp)
    80003fde:	e04a                	sd	s2,0(sp)
    80003fe0:	1000                	addi	s0,sp,32
    80003fe2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003fe4:	00850913          	addi	s2,a0,8
    80003fe8:	854a                	mv	a0,s2
    80003fea:	c0ffc0ef          	jal	80000bf8 <acquire>
  lk->locked = 0;
    80003fee:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ff2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	f5ffd0ef          	jal	80001f56 <wakeup>
  release(&lk->lk);
    80003ffc:	854a                	mv	a0,s2
    80003ffe:	c7ffc0ef          	jal	80000c7c <release>
}
    80004002:	60e2                	ld	ra,24(sp)
    80004004:	6442                	ld	s0,16(sp)
    80004006:	64a2                	ld	s1,8(sp)
    80004008:	6902                	ld	s2,0(sp)
    8000400a:	6105                	addi	sp,sp,32
    8000400c:	8082                	ret

000000008000400e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000400e:	7179                	addi	sp,sp,-48
    80004010:	f406                	sd	ra,40(sp)
    80004012:	f022                	sd	s0,32(sp)
    80004014:	ec26                	sd	s1,24(sp)
    80004016:	e84a                	sd	s2,16(sp)
    80004018:	1800                	addi	s0,sp,48
    8000401a:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000401c:	00850913          	addi	s2,a0,8
    80004020:	854a                	mv	a0,s2
    80004022:	bd7fc0ef          	jal	80000bf8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004026:	409c                	lw	a5,0(s1)
    80004028:	ef81                	bnez	a5,80004040 <holdingsleep+0x32>
    8000402a:	4481                	li	s1,0
  release(&lk->lk);
    8000402c:	854a                	mv	a0,s2
    8000402e:	c4ffc0ef          	jal	80000c7c <release>
  return r;
}
    80004032:	8526                	mv	a0,s1
    80004034:	70a2                	ld	ra,40(sp)
    80004036:	7402                	ld	s0,32(sp)
    80004038:	64e2                	ld	s1,24(sp)
    8000403a:	6942                	ld	s2,16(sp)
    8000403c:	6145                	addi	sp,sp,48
    8000403e:	8082                	ret
    80004040:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004042:	0284a983          	lw	s3,40(s1)
    80004046:	89dfd0ef          	jal	800018e2 <myproc>
    8000404a:	5904                	lw	s1,48(a0)
    8000404c:	413484b3          	sub	s1,s1,s3
    80004050:	0014b493          	seqz	s1,s1
    80004054:	69a2                	ld	s3,8(sp)
    80004056:	bfd9                	j	8000402c <holdingsleep+0x1e>

0000000080004058 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004058:	1141                	addi	sp,sp,-16
    8000405a:	e406                	sd	ra,8(sp)
    8000405c:	e022                	sd	s0,0(sp)
    8000405e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004060:	00003597          	auipc	a1,0x3
    80004064:	51858593          	addi	a1,a1,1304 # 80007578 <etext+0x578>
    80004068:	0001c517          	auipc	a0,0x1c
    8000406c:	a5050513          	addi	a0,a0,-1456 # 8001fab8 <ftable>
    80004070:	b09fc0ef          	jal	80000b78 <initlock>
}
    80004074:	60a2                	ld	ra,8(sp)
    80004076:	6402                	ld	s0,0(sp)
    80004078:	0141                	addi	sp,sp,16
    8000407a:	8082                	ret

000000008000407c <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    8000407c:	1101                	addi	sp,sp,-32
    8000407e:	ec06                	sd	ra,24(sp)
    80004080:	e822                	sd	s0,16(sp)
    80004082:	e426                	sd	s1,8(sp)
    80004084:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004086:	0001c517          	auipc	a0,0x1c
    8000408a:	a3250513          	addi	a0,a0,-1486 # 8001fab8 <ftable>
    8000408e:	b6bfc0ef          	jal	80000bf8 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004092:	0001c497          	auipc	s1,0x1c
    80004096:	a3e48493          	addi	s1,s1,-1474 # 8001fad0 <ftable+0x18>
    8000409a:	0001d717          	auipc	a4,0x1d
    8000409e:	9d670713          	addi	a4,a4,-1578 # 80020a70 <disk>
    if (f->ref == 0) {
    800040a2:	40dc                	lw	a5,4(s1)
    800040a4:	cf89                	beqz	a5,800040be <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800040a6:	02848493          	addi	s1,s1,40
    800040aa:	fee49ce3          	bne	s1,a4,800040a2 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800040ae:	0001c517          	auipc	a0,0x1c
    800040b2:	a0a50513          	addi	a0,a0,-1526 # 8001fab8 <ftable>
    800040b6:	bc7fc0ef          	jal	80000c7c <release>
  return 0;
    800040ba:	4481                	li	s1,0
    800040bc:	a809                	j	800040ce <filealloc+0x52>
      f->ref = 1;
    800040be:	4785                	li	a5,1
    800040c0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800040c2:	0001c517          	auipc	a0,0x1c
    800040c6:	9f650513          	addi	a0,a0,-1546 # 8001fab8 <ftable>
    800040ca:	bb3fc0ef          	jal	80000c7c <release>
}
    800040ce:	8526                	mv	a0,s1
    800040d0:	60e2                	ld	ra,24(sp)
    800040d2:	6442                	ld	s0,16(sp)
    800040d4:	64a2                	ld	s1,8(sp)
    800040d6:	6105                	addi	sp,sp,32
    800040d8:	8082                	ret

00000000800040da <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    800040da:	1101                	addi	sp,sp,-32
    800040dc:	ec06                	sd	ra,24(sp)
    800040de:	e822                	sd	s0,16(sp)
    800040e0:	e426                	sd	s1,8(sp)
    800040e2:	1000                	addi	s0,sp,32
    800040e4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800040e6:	0001c517          	auipc	a0,0x1c
    800040ea:	9d250513          	addi	a0,a0,-1582 # 8001fab8 <ftable>
    800040ee:	b0bfc0ef          	jal	80000bf8 <acquire>
  if (f->ref < 1)
    800040f2:	40dc                	lw	a5,4(s1)
    800040f4:	02f05063          	blez	a5,80004114 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800040f8:	2785                	addiw	a5,a5,1
    800040fa:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800040fc:	0001c517          	auipc	a0,0x1c
    80004100:	9bc50513          	addi	a0,a0,-1604 # 8001fab8 <ftable>
    80004104:	b79fc0ef          	jal	80000c7c <release>
  return f;
}
    80004108:	8526                	mv	a0,s1
    8000410a:	60e2                	ld	ra,24(sp)
    8000410c:	6442                	ld	s0,16(sp)
    8000410e:	64a2                	ld	s1,8(sp)
    80004110:	6105                	addi	sp,sp,32
    80004112:	8082                	ret
    panic("filedup");
    80004114:	00003517          	auipc	a0,0x3
    80004118:	46c50513          	addi	a0,a0,1132 # 80007580 <etext+0x580>
    8000411c:	f2cfc0ef          	jal	80000848 <panic>

0000000080004120 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004120:	7139                	addi	sp,sp,-64
    80004122:	fc06                	sd	ra,56(sp)
    80004124:	f822                	sd	s0,48(sp)
    80004126:	f426                	sd	s1,40(sp)
    80004128:	0080                	addi	s0,sp,64
    8000412a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000412c:	0001c517          	auipc	a0,0x1c
    80004130:	98c50513          	addi	a0,a0,-1652 # 8001fab8 <ftable>
    80004134:	ac5fc0ef          	jal	80000bf8 <acquire>
  if (f->ref < 1)
    80004138:	40dc                	lw	a5,4(s1)
    8000413a:	04f05a63          	blez	a5,8000418e <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    8000413e:	37fd                	addiw	a5,a5,-1
    80004140:	c0dc                	sw	a5,4(s1)
    80004142:	06f04063          	bgtz	a5,800041a2 <fileclose+0x82>
    80004146:	f04a                	sd	s2,32(sp)
    80004148:	ec4e                	sd	s3,24(sp)
    8000414a:	e852                	sd	s4,16(sp)
    8000414c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000414e:	0004a903          	lw	s2,0(s1)
    80004152:	0094c783          	lbu	a5,9(s1)
    80004156:	89be                	mv	s3,a5
    80004158:	689c                	ld	a5,16(s1)
    8000415a:	8a3e                	mv	s4,a5
    8000415c:	6c9c                	ld	a5,24(s1)
    8000415e:	8abe                	mv	s5,a5
  f->ref = 0;
    80004160:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004164:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004168:	0001c517          	auipc	a0,0x1c
    8000416c:	95050513          	addi	a0,a0,-1712 # 8001fab8 <ftable>
    80004170:	b0dfc0ef          	jal	80000c7c <release>

  if (ff.type == FD_PIPE) {
    80004174:	4785                	li	a5,1
    80004176:	04f90163          	beq	s2,a5,800041b8 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    8000417a:	ffe9079b          	addiw	a5,s2,-2
    8000417e:	4705                	li	a4,1
    80004180:	04f77563          	bgeu	a4,a5,800041ca <fileclose+0xaa>
    80004184:	7902                	ld	s2,32(sp)
    80004186:	69e2                	ld	s3,24(sp)
    80004188:	6a42                	ld	s4,16(sp)
    8000418a:	6aa2                	ld	s5,8(sp)
    8000418c:	a00d                	j	800041ae <fileclose+0x8e>
    8000418e:	f04a                	sd	s2,32(sp)
    80004190:	ec4e                	sd	s3,24(sp)
    80004192:	e852                	sd	s4,16(sp)
    80004194:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004196:	00003517          	auipc	a0,0x3
    8000419a:	3f250513          	addi	a0,a0,1010 # 80007588 <etext+0x588>
    8000419e:	eaafc0ef          	jal	80000848 <panic>
    release(&ftable.lock);
    800041a2:	0001c517          	auipc	a0,0x1c
    800041a6:	91650513          	addi	a0,a0,-1770 # 8001fab8 <ftable>
    800041aa:	ad3fc0ef          	jal	80000c7c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800041ae:	70e2                	ld	ra,56(sp)
    800041b0:	7442                	ld	s0,48(sp)
    800041b2:	74a2                	ld	s1,40(sp)
    800041b4:	6121                	addi	sp,sp,64
    800041b6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800041b8:	85ce                	mv	a1,s3
    800041ba:	8552                	mv	a0,s4
    800041bc:	348000ef          	jal	80004504 <pipeclose>
    800041c0:	7902                	ld	s2,32(sp)
    800041c2:	69e2                	ld	s3,24(sp)
    800041c4:	6a42                	ld	s4,16(sp)
    800041c6:	6aa2                	ld	s5,8(sp)
    800041c8:	b7dd                	j	800041ae <fileclose+0x8e>
    begin_op();
    800041ca:	aa1ff0ef          	jal	80003c6a <begin_op>
    iput(ff.ip);
    800041ce:	8556                	mv	a0,s5
    800041d0:	9aaff0ef          	jal	8000337a <iput>
    end_op();
    800041d4:	b23ff0ef          	jal	80003cf6 <end_op>
    800041d8:	7902                	ld	s2,32(sp)
    800041da:	69e2                	ld	s3,24(sp)
    800041dc:	6a42                	ld	s4,16(sp)
    800041de:	6aa2                	ld	s5,8(sp)
    800041e0:	b7f9                	j	800041ae <fileclose+0x8e>

00000000800041e2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800041e2:	715d                	addi	sp,sp,-80
    800041e4:	e486                	sd	ra,72(sp)
    800041e6:	e0a2                	sd	s0,64(sp)
    800041e8:	fc26                	sd	s1,56(sp)
    800041ea:	f052                	sd	s4,32(sp)
    800041ec:	0880                	addi	s0,sp,80
    800041ee:	84aa                	mv	s1,a0
    800041f0:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800041f2:	ef0fd0ef          	jal	800018e2 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    800041f6:	409c                	lw	a5,0(s1)
    800041f8:	37f9                	addiw	a5,a5,-2
    800041fa:	4705                	li	a4,1
    800041fc:	04f76463          	bltu	a4,a5,80004244 <filestat+0x62>
    80004200:	f84a                	sd	s2,48(sp)
    80004202:	f44e                	sd	s3,40(sp)
    80004204:	892a                	mv	s2,a0
    ilock(f->ip);
    80004206:	6c88                	ld	a0,24(s1)
    80004208:	ff1fe0ef          	jal	800031f8 <ilock>
    stati(f->ip, &st);
    8000420c:	fb840993          	addi	s3,s0,-72
    80004210:	85ce                	mv	a1,s3
    80004212:	6c88                	ld	a0,24(s1)
    80004214:	b90ff0ef          	jal	800035a4 <stati>
    iunlock(f->ip);
    80004218:	6c88                	ld	a0,24(s1)
    8000421a:	88cff0ef          	jal	800032a6 <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    8000421e:	4761                	li	a4,24
    80004220:	86ce                	mv	a3,s3
    80004222:	8652                	mv	a2,s4
    80004224:	04893583          	ld	a1,72(s2)
    80004228:	05093503          	ld	a0,80(s2)
    8000422c:	b00fd0ef          	jal	8000152c <copyout>
    80004230:	41f5551b          	sraiw	a0,a0,0x1f
    80004234:	7942                	ld	s2,48(sp)
    80004236:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004238:	60a6                	ld	ra,72(sp)
    8000423a:	6406                	ld	s0,64(sp)
    8000423c:	74e2                	ld	s1,56(sp)
    8000423e:	7a02                	ld	s4,32(sp)
    80004240:	6161                	addi	sp,sp,80
    80004242:	8082                	ret
  return -1;
    80004244:	557d                	li	a0,-1
    80004246:	bfcd                	j	80004238 <filestat+0x56>

0000000080004248 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004248:	7179                	addi	sp,sp,-48
    8000424a:	f406                	sd	ra,40(sp)
    8000424c:	f022                	sd	s0,32(sp)
    8000424e:	e84a                	sd	s2,16(sp)
    80004250:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    80004252:	00854783          	lbu	a5,8(a0)
    80004256:	0017b793          	seqz	a5,a5
    8000425a:	01f6571b          	srliw	a4,a2,0x1f
    8000425e:	8fd9                	or	a5,a5,a4
    80004260:	e3c5                	bnez	a5,80004300 <fileread+0xb8>
    80004262:	ec26                	sd	s1,24(sp)
    80004264:	e44e                	sd	s3,8(sp)
    80004266:	84aa                	mv	s1,a0
    80004268:	892e                	mv	s2,a1
    8000426a:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    8000426c:	411c                	lw	a5,0(a0)
    8000426e:	4705                	li	a4,1
    80004270:	04e78363          	beq	a5,a4,800042b6 <fileread+0x6e>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004274:	470d                	li	a4,3
    80004276:	04e78763          	beq	a5,a4,800042c4 <fileread+0x7c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000427a:	4709                	li	a4,2
    8000427c:	06e79a63          	bne	a5,a4,800042f0 <fileread+0xa8>
    ilock(f->ip);
    80004280:	6d08                	ld	a0,24(a0)
    80004282:	f77fe0ef          	jal	800031f8 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004286:	874e                	mv	a4,s3
    80004288:	5094                	lw	a3,32(s1)
    8000428a:	864a                	mv	a2,s2
    8000428c:	4585                	li	a1,1
    8000428e:	6c88                	ld	a0,24(s1)
    80004290:	b42ff0ef          	jal	800035d2 <readi>
    80004294:	892a                	mv	s2,a0
    80004296:	00a05563          	blez	a0,800042a0 <fileread+0x58>
      f->off += r;
    8000429a:	509c                	lw	a5,32(s1)
    8000429c:	9fa9                	addw	a5,a5,a0
    8000429e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800042a0:	6c88                	ld	a0,24(s1)
    800042a2:	804ff0ef          	jal	800032a6 <iunlock>
    800042a6:	64e2                	ld	s1,24(sp)
    800042a8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800042aa:	854a                	mv	a0,s2
    800042ac:	70a2                	ld	ra,40(sp)
    800042ae:	7402                	ld	s0,32(sp)
    800042b0:	6942                	ld	s2,16(sp)
    800042b2:	6145                	addi	sp,sp,48
    800042b4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800042b6:	6908                	ld	a0,16(a0)
    800042b8:	3c6000ef          	jal	8000467e <piperead>
    800042bc:	892a                	mv	s2,a0
    800042be:	64e2                	ld	s1,24(sp)
    800042c0:	69a2                	ld	s3,8(sp)
    800042c2:	b7e5                	j	800042aa <fileread+0x62>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800042c4:	02451783          	lh	a5,36(a0)
    800042c8:	03079693          	slli	a3,a5,0x30
    800042cc:	92c1                	srli	a3,a3,0x30
    800042ce:	4725                	li	a4,9
    800042d0:	02d76663          	bltu	a4,a3,800042fc <fileread+0xb4>
    800042d4:	0792                	slli	a5,a5,0x4
    800042d6:	0001b717          	auipc	a4,0x1b
    800042da:	74270713          	addi	a4,a4,1858 # 8001fa18 <devsw>
    800042de:	97ba                	add	a5,a5,a4
    800042e0:	639c                	ld	a5,0(a5)
    800042e2:	c395                	beqz	a5,80004306 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800042e4:	4505                	li	a0,1
    800042e6:	9782                	jalr	a5
    800042e8:	892a                	mv	s2,a0
    800042ea:	64e2                	ld	s1,24(sp)
    800042ec:	69a2                	ld	s3,8(sp)
    800042ee:	bf75                	j	800042aa <fileread+0x62>
    panic("fileread");
    800042f0:	00003517          	auipc	a0,0x3
    800042f4:	2a850513          	addi	a0,a0,680 # 80007598 <etext+0x598>
    800042f8:	d50fc0ef          	jal	80000848 <panic>
    800042fc:	64e2                	ld	s1,24(sp)
    800042fe:	69a2                	ld	s3,8(sp)
    return -1;
    80004300:	57fd                	li	a5,-1
    80004302:	893e                	mv	s2,a5
    80004304:	b75d                	j	800042aa <fileread+0x62>
    80004306:	64e2                	ld	s1,24(sp)
    80004308:	69a2                	ld	s3,8(sp)
    8000430a:	bfdd                	j	80004300 <fileread+0xb8>

000000008000430c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    8000430c:	00954783          	lbu	a5,9(a0)
    80004310:	0017b793          	seqz	a5,a5
    80004314:	01f6571b          	srliw	a4,a2,0x1f
    80004318:	8fd9                	or	a5,a5,a4
    8000431a:	12079363          	bnez	a5,80004440 <filewrite+0x134>
{
    8000431e:	711d                	addi	sp,sp,-96
    80004320:	ec86                	sd	ra,88(sp)
    80004322:	e8a2                	sd	s0,80(sp)
    80004324:	e0ca                	sd	s2,64(sp)
    80004326:	f456                	sd	s5,40(sp)
    80004328:	f05a                	sd	s6,32(sp)
    8000432a:	1080                	addi	s0,sp,96
    8000432c:	892a                	mv	s2,a0
    8000432e:	8b2e                	mv	s6,a1
    80004330:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    80004332:	411c                	lw	a5,0(a0)
    80004334:	4705                	li	a4,1
    80004336:	02e78a63          	beq	a5,a4,8000436a <filewrite+0x5e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    8000433a:	470d                	li	a4,3
    8000433c:	02e78b63          	beq	a5,a4,80004372 <filewrite+0x66>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004340:	4709                	li	a4,2
    80004342:	0ce79763          	bne	a5,a4,80004410 <filewrite+0x104>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80004346:	0ec05363          	blez	a2,8000442c <filewrite+0x120>
    8000434a:	e4a6                	sd	s1,72(sp)
    8000434c:	fc4e                	sd	s3,56(sp)
    8000434e:	f852                	sd	s4,48(sp)
    80004350:	ec5e                	sd	s7,24(sp)
    80004352:	e862                	sd	s8,16(sp)
    80004354:	e466                	sd	s9,8(sp)
    int i = 0;
    80004356:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    80004358:	6b85                	lui	s7,0x1
    8000435a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000435e:	6785                	lui	a5,0x1
    80004360:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004364:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004366:	4c05                	li	s8,1
    80004368:	a8ad                	j	800043e2 <filewrite+0xd6>
    ret = pipewrite(f->pipe, addr, n);
    8000436a:	6908                	ld	a0,16(a0)
    8000436c:	1f6000ef          	jal	80004562 <pipewrite>
    80004370:	a849                	j	80004402 <filewrite+0xf6>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004372:	02451783          	lh	a5,36(a0)
    80004376:	03079693          	slli	a3,a5,0x30
    8000437a:	92c1                	srli	a3,a3,0x30
    8000437c:	4725                	li	a4,9
    8000437e:	0ad76563          	bltu	a4,a3,80004428 <filewrite+0x11c>
    80004382:	0792                	slli	a5,a5,0x4
    80004384:	0001b717          	auipc	a4,0x1b
    80004388:	69470713          	addi	a4,a4,1684 # 8001fa18 <devsw>
    8000438c:	97ba                	add	a5,a5,a4
    8000438e:	679c                	ld	a5,8(a5)
    80004390:	cfc1                	beqz	a5,80004428 <filewrite+0x11c>
    ret = devsw[f->major].write(1, addr, n);
    80004392:	4505                	li	a0,1
    80004394:	9782                	jalr	a5
    80004396:	a0b5                	j	80004402 <filewrite+0xf6>
      if (n1 > max)
    80004398:	2981                	sext.w	s3,s3
      begin_op();
    8000439a:	8d1ff0ef          	jal	80003c6a <begin_op>
      ilock(f->ip);
    8000439e:	01893503          	ld	a0,24(s2)
    800043a2:	e57fe0ef          	jal	800031f8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043a6:	874e                	mv	a4,s3
    800043a8:	02092683          	lw	a3,32(s2)
    800043ac:	016a0633          	add	a2,s4,s6
    800043b0:	85e2                	mv	a1,s8
    800043b2:	01893503          	ld	a0,24(s2)
    800043b6:	b0eff0ef          	jal	800036c4 <writei>
    800043ba:	84aa                	mv	s1,a0
    800043bc:	00a05763          	blez	a0,800043ca <filewrite+0xbe>
        f->off += r;
    800043c0:	02092783          	lw	a5,32(s2)
    800043c4:	9fa9                	addw	a5,a5,a0
    800043c6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800043ca:	01893503          	ld	a0,24(s2)
    800043ce:	ed9fe0ef          	jal	800032a6 <iunlock>
      end_op();
    800043d2:	925ff0ef          	jal	80003cf6 <end_op>

      if (r != n1) {
    800043d6:	00999d63          	bne	s3,s1,800043f0 <filewrite+0xe4>
        // error from writei
        break;
      }
      i += r;
    800043da:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    800043de:	015a5963          	bge	s4,s5,800043f0 <filewrite+0xe4>
      int n1 = n - i;
    800043e2:	414a87bb          	subw	a5,s5,s4
    800043e6:	89be                	mv	s3,a5
      if (n1 > max)
    800043e8:	fafbd8e3          	bge	s7,a5,80004398 <filewrite+0x8c>
    800043ec:	89e6                	mv	s3,s9
    800043ee:	b76d                	j	80004398 <filewrite+0x8c>
    }
    ret = (i == n ? n : -1);
    800043f0:	054a9063          	bne	s5,s4,80004430 <filewrite+0x124>
    800043f4:	8556                	mv	a0,s5
    800043f6:	64a6                	ld	s1,72(sp)
    800043f8:	79e2                	ld	s3,56(sp)
    800043fa:	7a42                	ld	s4,48(sp)
    800043fc:	6be2                	ld	s7,24(sp)
    800043fe:	6c42                	ld	s8,16(sp)
    80004400:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004402:	60e6                	ld	ra,88(sp)
    80004404:	6446                	ld	s0,80(sp)
    80004406:	6906                	ld	s2,64(sp)
    80004408:	7aa2                	ld	s5,40(sp)
    8000440a:	7b02                	ld	s6,32(sp)
    8000440c:	6125                	addi	sp,sp,96
    8000440e:	8082                	ret
    80004410:	e4a6                	sd	s1,72(sp)
    80004412:	fc4e                	sd	s3,56(sp)
    80004414:	f852                	sd	s4,48(sp)
    80004416:	ec5e                	sd	s7,24(sp)
    80004418:	e862                	sd	s8,16(sp)
    8000441a:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000441c:	00003517          	auipc	a0,0x3
    80004420:	18c50513          	addi	a0,a0,396 # 800075a8 <etext+0x5a8>
    80004424:	c24fc0ef          	jal	80000848 <panic>
    return -1;
    80004428:	557d                	li	a0,-1
    8000442a:	bfe1                	j	80004402 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000442c:	8532                	mv	a0,a2
    8000442e:	bfd1                	j	80004402 <filewrite+0xf6>
    80004430:	557d                	li	a0,-1
    80004432:	64a6                	ld	s1,72(sp)
    80004434:	79e2                	ld	s3,56(sp)
    80004436:	7a42                	ld	s4,48(sp)
    80004438:	6be2                	ld	s7,24(sp)
    8000443a:	6c42                	ld	s8,16(sp)
    8000443c:	6ca2                	ld	s9,8(sp)
    8000443e:	b7d1                	j	80004402 <filewrite+0xf6>
    return -1;
    80004440:	557d                	li	a0,-1
}
    80004442:	8082                	ret

0000000080004444 <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004444:	7179                	addi	sp,sp,-48
    80004446:	f406                	sd	ra,40(sp)
    80004448:	f022                	sd	s0,32(sp)
    8000444a:	ec26                	sd	s1,24(sp)
    8000444c:	e052                	sd	s4,0(sp)
    8000444e:	1800                	addi	s0,sp,48
    80004450:	84aa                	mv	s1,a0
    80004452:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004454:	0005b023          	sd	zero,0(a1)
    80004458:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000445c:	c21ff0ef          	jal	8000407c <filealloc>
    80004460:	e088                	sd	a0,0(s1)
    80004462:	c549                	beqz	a0,800044ec <pipealloc+0xa8>
    80004464:	c19ff0ef          	jal	8000407c <filealloc>
    80004468:	00aa3023          	sd	a0,0(s4)
    8000446c:	cd25                	beqz	a0,800044e4 <pipealloc+0xa0>
    8000446e:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80004470:	eaefc0ef          	jal	80000b1e <kalloc>
    80004474:	892a                	mv	s2,a0
    80004476:	c12d                	beqz	a0,800044d8 <pipealloc+0x94>
    80004478:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000447a:	4985                	li	s3,1
    8000447c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004480:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004484:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004488:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000448c:	00003597          	auipc	a1,0x3
    80004490:	12c58593          	addi	a1,a1,300 # 800075b8 <etext+0x5b8>
    80004494:	ee4fc0ef          	jal	80000b78 <initlock>
  (*f0)->type = FD_PIPE;
    80004498:	609c                	ld	a5,0(s1)
    8000449a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000449e:	609c                	ld	a5,0(s1)
    800044a0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800044a4:	609c                	ld	a5,0(s1)
    800044a6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800044aa:	609c                	ld	a5,0(s1)
    800044ac:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800044b0:	000a3783          	ld	a5,0(s4)
    800044b4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800044b8:	000a3783          	ld	a5,0(s4)
    800044bc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800044c0:	000a3783          	ld	a5,0(s4)
    800044c4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800044c8:	000a3783          	ld	a5,0(s4)
    800044cc:	0127b823          	sd	s2,16(a5)
  return 0;
    800044d0:	4501                	li	a0,0
    800044d2:	6942                	ld	s2,16(sp)
    800044d4:	69a2                	ld	s3,8(sp)
    800044d6:	a00d                	j	800044f8 <pipealloc+0xb4>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    800044d8:	6088                	ld	a0,0(s1)
    800044da:	c119                	beqz	a0,800044e0 <pipealloc+0x9c>
    800044dc:	6942                	ld	s2,16(sp)
    800044de:	a029                	j	800044e8 <pipealloc+0xa4>
    800044e0:	6942                	ld	s2,16(sp)
    800044e2:	a029                	j	800044ec <pipealloc+0xa8>
    800044e4:	6088                	ld	a0,0(s1)
    800044e6:	c901                	beqz	a0,800044f6 <pipealloc+0xb2>
    fileclose(*f0);
    800044e8:	c39ff0ef          	jal	80004120 <fileclose>
  if (*f1)
    800044ec:	000a3503          	ld	a0,0(s4)
    800044f0:	c119                	beqz	a0,800044f6 <pipealloc+0xb2>
    fileclose(*f1);
    800044f2:	c2fff0ef          	jal	80004120 <fileclose>
  return -1;
    800044f6:	557d                	li	a0,-1
}
    800044f8:	70a2                	ld	ra,40(sp)
    800044fa:	7402                	ld	s0,32(sp)
    800044fc:	64e2                	ld	s1,24(sp)
    800044fe:	6a02                	ld	s4,0(sp)
    80004500:	6145                	addi	sp,sp,48
    80004502:	8082                	ret

0000000080004504 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004504:	1101                	addi	sp,sp,-32
    80004506:	ec06                	sd	ra,24(sp)
    80004508:	e822                	sd	s0,16(sp)
    8000450a:	e426                	sd	s1,8(sp)
    8000450c:	e04a                	sd	s2,0(sp)
    8000450e:	1000                	addi	s0,sp,32
    80004510:	84aa                	mv	s1,a0
    80004512:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004514:	ee4fc0ef          	jal	80000bf8 <acquire>
  if (writable) {
    80004518:	02090763          	beqz	s2,80004546 <pipeclose+0x42>
    pi->writeopen = 0;
    8000451c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004520:	21848513          	addi	a0,s1,536
    80004524:	a33fd0ef          	jal	80001f56 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004528:	2204a783          	lw	a5,544(s1)
    8000452c:	e781                	bnez	a5,80004534 <pipeclose+0x30>
    8000452e:	2244a783          	lw	a5,548(s1)
    80004532:	c38d                	beqz	a5,80004554 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    80004534:	8526                	mv	a0,s1
    80004536:	f46fc0ef          	jal	80000c7c <release>
}
    8000453a:	60e2                	ld	ra,24(sp)
    8000453c:	6442                	ld	s0,16(sp)
    8000453e:	64a2                	ld	s1,8(sp)
    80004540:	6902                	ld	s2,0(sp)
    80004542:	6105                	addi	sp,sp,32
    80004544:	8082                	ret
    pi->readopen = 0;
    80004546:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000454a:	21c48513          	addi	a0,s1,540
    8000454e:	a09fd0ef          	jal	80001f56 <wakeup>
    80004552:	bfd9                	j	80004528 <pipeclose+0x24>
    release(&pi->lock);
    80004554:	8526                	mv	a0,s1
    80004556:	f26fc0ef          	jal	80000c7c <release>
    kfree((char *)pi);
    8000455a:	8526                	mv	a0,s1
    8000455c:	cdafc0ef          	jal	80000a36 <kfree>
    80004560:	bfe9                	j	8000453a <pipeclose+0x36>

0000000080004562 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004562:	7159                	addi	sp,sp,-112
    80004564:	f486                	sd	ra,104(sp)
    80004566:	f0a2                	sd	s0,96(sp)
    80004568:	eca6                	sd	s1,88(sp)
    8000456a:	e8ca                	sd	s2,80(sp)
    8000456c:	e4ce                	sd	s3,72(sp)
    8000456e:	e0d2                	sd	s4,64(sp)
    80004570:	fc56                	sd	s5,56(sp)
    80004572:	1880                	addi	s0,sp,112
    80004574:	84aa                	mv	s1,a0
    80004576:	8aae                	mv	s5,a1
    80004578:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000457a:	b68fd0ef          	jal	800018e2 <myproc>
    8000457e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004580:	8526                	mv	a0,s1
    80004582:	e76fc0ef          	jal	80000bf8 <acquire>
  while (i < n) {
    80004586:	0f405a63          	blez	s4,8000467a <pipewrite+0x118>
    8000458a:	f85a                	sd	s6,48(sp)
    8000458c:	f45e                	sd	s7,40(sp)
    8000458e:	f062                	sd	s8,32(sp)
    80004590:	ec66                	sd	s9,24(sp)
    80004592:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004594:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80004596:	f9f40c13          	addi	s8,s0,-97
    8000459a:	4b85                	li	s7,1
    8000459c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000459e:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    800045a2:	21c48c93          	addi	s9,s1,540
    800045a6:	a0a1                	j	800045ee <pipewrite+0x8c>
      release(&pi->lock);
    800045a8:	8526                	mv	a0,s1
    800045aa:	ed2fc0ef          	jal	80000c7c <release>
      return -1;
    800045ae:	597d                	li	s2,-1
    800045b0:	7b42                	ld	s6,48(sp)
    800045b2:	7ba2                	ld	s7,40(sp)
    800045b4:	7c02                	ld	s8,32(sp)
    800045b6:	6ce2                	ld	s9,24(sp)
    800045b8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800045ba:	854a                	mv	a0,s2
    800045bc:	70a6                	ld	ra,104(sp)
    800045be:	7406                	ld	s0,96(sp)
    800045c0:	64e6                	ld	s1,88(sp)
    800045c2:	6946                	ld	s2,80(sp)
    800045c4:	69a6                	ld	s3,72(sp)
    800045c6:	6a06                	ld	s4,64(sp)
    800045c8:	7ae2                	ld	s5,56(sp)
    800045ca:	6165                	addi	sp,sp,112
    800045cc:	8082                	ret
      wakeup(&pi->nread);
    800045ce:	856a                	mv	a0,s10
    800045d0:	987fd0ef          	jal	80001f56 <wakeup>
      sleep_prepare(&pi->nwrite);
    800045d4:	8566                	mv	a0,s9
    800045d6:	915fd0ef          	jal	80001eea <sleep_prepare>
      release(&pi->lock);
    800045da:	8526                	mv	a0,s1
    800045dc:	ea0fc0ef          	jal	80000c7c <release>
      sleep();
    800045e0:	947fd0ef          	jal	80001f26 <sleep>
      acquire(&pi->lock);
    800045e4:	8526                	mv	a0,s1
    800045e6:	e12fc0ef          	jal	80000bf8 <acquire>
  while (i < n) {
    800045ea:	07495b63          	bge	s2,s4,80004660 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    800045ee:	2204a783          	lw	a5,544(s1)
    800045f2:	dbdd                	beqz	a5,800045a8 <pipewrite+0x46>
    800045f4:	854e                	mv	a0,s3
    800045f6:	b4dfd0ef          	jal	80002142 <killed>
    800045fa:	f55d                	bnez	a0,800045a8 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    800045fc:	2184a783          	lw	a5,536(s1)
    80004600:	21c4a703          	lw	a4,540(s1)
    80004604:	2007879b          	addiw	a5,a5,512
    80004608:	fcf703e3          	beq	a4,a5,800045ce <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    8000460c:	875e                	mv	a4,s7
    8000460e:	015906b3          	add	a3,s2,s5
    80004612:	8662                	mv	a2,s8
    80004614:	0489b583          	ld	a1,72(s3)
    80004618:	0509b503          	ld	a0,80(s3)
    8000461c:	fd1fc0ef          	jal	800015ec <copyin>
    80004620:	03650163          	beq	a0,s6,80004642 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004624:	21c4a783          	lw	a5,540(s1)
    80004628:	0017871b          	addiw	a4,a5,1
    8000462c:	20e4ae23          	sw	a4,540(s1)
    80004630:	1ff7f793          	andi	a5,a5,511
    80004634:	97a6                	add	a5,a5,s1
    80004636:	f9f44703          	lbu	a4,-97(s0)
    8000463a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000463e:	2905                	addiw	s2,s2,1
    80004640:	b76d                	j	800045ea <pipewrite+0x88>
        if (i == 0)
    80004642:	00090863          	beqz	s2,80004652 <pipewrite+0xf0>
    80004646:	7b42                	ld	s6,48(sp)
    80004648:	7ba2                	ld	s7,40(sp)
    8000464a:	7c02                	ld	s8,32(sp)
    8000464c:	6ce2                	ld	s9,24(sp)
    8000464e:	6d42                	ld	s10,16(sp)
    80004650:	a829                	j	8000466a <pipewrite+0x108>
          i = -1;
    80004652:	892a                	mv	s2,a0
        break;
    80004654:	7b42                	ld	s6,48(sp)
    80004656:	7ba2                	ld	s7,40(sp)
    80004658:	7c02                	ld	s8,32(sp)
    8000465a:	6ce2                	ld	s9,24(sp)
    8000465c:	6d42                	ld	s10,16(sp)
    8000465e:	a031                	j	8000466a <pipewrite+0x108>
    80004660:	7b42                	ld	s6,48(sp)
    80004662:	7ba2                	ld	s7,40(sp)
    80004664:	7c02                	ld	s8,32(sp)
    80004666:	6ce2                	ld	s9,24(sp)
    80004668:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000466a:	21848513          	addi	a0,s1,536
    8000466e:	8e9fd0ef          	jal	80001f56 <wakeup>
  release(&pi->lock);
    80004672:	8526                	mv	a0,s1
    80004674:	e08fc0ef          	jal	80000c7c <release>
  return i;
    80004678:	b789                	j	800045ba <pipewrite+0x58>
  int i = 0;
    8000467a:	4901                	li	s2,0
    8000467c:	b7fd                	j	8000466a <pipewrite+0x108>

000000008000467e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000467e:	711d                	addi	sp,sp,-96
    80004680:	ec86                	sd	ra,88(sp)
    80004682:	e8a2                	sd	s0,80(sp)
    80004684:	e4a6                	sd	s1,72(sp)
    80004686:	e0ca                	sd	s2,64(sp)
    80004688:	fc4e                	sd	s3,56(sp)
    8000468a:	f852                	sd	s4,48(sp)
    8000468c:	f456                	sd	s5,40(sp)
    8000468e:	1080                	addi	s0,sp,96
    80004690:	84aa                	mv	s1,a0
    80004692:	89ae                	mv	s3,a1
    80004694:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004696:	a4cfd0ef          	jal	800018e2 <myproc>
    8000469a:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    8000469c:	8526                	mv	a0,s1
    8000469e:	d5afc0ef          	jal	80000bf8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800046a2:	2184a703          	lw	a4,536(s1)
    800046a6:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800046aa:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800046ae:	02f71a63          	bne	a4,a5,800046e2 <piperead+0x64>
    800046b2:	2244a783          	lw	a5,548(s1)
    800046b6:	c795                	beqz	a5,800046e2 <piperead+0x64>
    if (killed(pr)) {
    800046b8:	854a                	mv	a0,s2
    800046ba:	a89fd0ef          	jal	80002142 <killed>
    800046be:	e149                	bnez	a0,80004740 <piperead+0xc2>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800046c0:	8552                	mv	a0,s4
    800046c2:	829fd0ef          	jal	80001eea <sleep_prepare>
    release(&pi->lock);
    800046c6:	8526                	mv	a0,s1
    800046c8:	db4fc0ef          	jal	80000c7c <release>
    sleep();
    800046cc:	85bfd0ef          	jal	80001f26 <sleep>
    acquire(&pi->lock);
    800046d0:	8526                	mv	a0,s1
    800046d2:	d26fc0ef          	jal	80000bf8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800046d6:	2184a703          	lw	a4,536(s1)
    800046da:	21c4a783          	lw	a5,540(s1)
    800046de:	fcf70ae3          	beq	a4,a5,800046b2 <piperead+0x34>
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800046e2:	07505a63          	blez	s5,80004756 <piperead+0xd8>
    800046e6:	f05a                	sd	s6,32(sp)
    800046e8:	ec5e                	sd	s7,24(sp)
    800046ea:	e862                	sd	s8,16(sp)
    800046ec:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    800046ee:	faf40c13          	addi	s8,s0,-81
    800046f2:	4b85                	li	s7,1
    800046f4:	5b7d                	li	s6,-1
    if (pi->nread == pi->nwrite)
    800046f6:	2184a783          	lw	a5,536(s1)
    800046fa:	21c4a703          	lw	a4,540(s1)
    800046fe:	06f70363          	beq	a4,a5,80004764 <piperead+0xe6>
    ch = pi->data[pi->nread % PIPESIZE];
    80004702:	1ff7f793          	andi	a5,a5,511
    80004706:	97a6                	add	a5,a5,s1
    80004708:	0187c783          	lbu	a5,24(a5)
    8000470c:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004710:	875e                	mv	a4,s7
    80004712:	86e2                	mv	a3,s8
    80004714:	864e                	mv	a2,s3
    80004716:	04893583          	ld	a1,72(s2)
    8000471a:	05093503          	ld	a0,80(s2)
    8000471e:	e0ffc0ef          	jal	8000152c <copyout>
    80004722:	03650463          	beq	a0,s6,8000474a <piperead+0xcc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004726:	2184a783          	lw	a5,536(s1)
    8000472a:	2785                	addiw	a5,a5,1
    8000472c:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004730:	2a05                	addiw	s4,s4,1
    80004732:	0985                	addi	s3,s3,1
    80004734:	fd4a91e3          	bne	s5,s4,800046f6 <piperead+0x78>
    80004738:	7b02                	ld	s6,32(sp)
    8000473a:	6be2                	ld	s7,24(sp)
    8000473c:	6c42                	ld	s8,16(sp)
    8000473e:	a035                	j	8000476a <piperead+0xec>
      release(&pi->lock);
    80004740:	8526                	mv	a0,s1
    80004742:	d3afc0ef          	jal	80000c7c <release>
      return -1;
    80004746:	5a7d                	li	s4,-1
    80004748:	a805                	j	80004778 <piperead+0xfa>
      if (i == 0)
    8000474a:	000a0863          	beqz	s4,8000475a <piperead+0xdc>
    8000474e:	7b02                	ld	s6,32(sp)
    80004750:	6be2                	ld	s7,24(sp)
    80004752:	6c42                	ld	s8,16(sp)
    80004754:	a819                	j	8000476a <piperead+0xec>
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004756:	4a01                	li	s4,0
    80004758:	a809                	j	8000476a <piperead+0xec>
        i = -1;
    8000475a:	8a2a                	mv	s4,a0
    8000475c:	7b02                	ld	s6,32(sp)
    8000475e:	6be2                	ld	s7,24(sp)
    80004760:	6c42                	ld	s8,16(sp)
    80004762:	a021                	j	8000476a <piperead+0xec>
    80004764:	7b02                	ld	s6,32(sp)
    80004766:	6be2                	ld	s7,24(sp)
    80004768:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    8000476a:	21c48513          	addi	a0,s1,540
    8000476e:	fe8fd0ef          	jal	80001f56 <wakeup>
  release(&pi->lock);
    80004772:	8526                	mv	a0,s1
    80004774:	d08fc0ef          	jal	80000c7c <release>
  return i;
}
    80004778:	8552                	mv	a0,s4
    8000477a:	60e6                	ld	ra,88(sp)
    8000477c:	6446                	ld	s0,80(sp)
    8000477e:	64a6                	ld	s1,72(sp)
    80004780:	6906                	ld	s2,64(sp)
    80004782:	79e2                	ld	s3,56(sp)
    80004784:	7a42                	ld	s4,48(sp)
    80004786:	7aa2                	ld	s5,40(sp)
    80004788:	6125                	addi	sp,sp,96
    8000478a:	8082                	ret

000000008000478c <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    8000478c:	1141                	addi	sp,sp,-16
    8000478e:	e406                	sd	ra,8(sp)
    80004790:	e022                	sd	s0,0(sp)
    80004792:	0800                	addi	s0,sp,16
    80004794:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004796:	0035151b          	slliw	a0,a0,0x3
    8000479a:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    8000479c:	8b89                	andi	a5,a5,2
    8000479e:	c399                	beqz	a5,800047a4 <flags2perm+0x18>
    perm |= PTE_W;
    800047a0:	00456513          	ori	a0,a0,4
  return perm;
}
    800047a4:	60a2                	ld	ra,8(sp)
    800047a6:	6402                	ld	s0,0(sp)
    800047a8:	0141                	addi	sp,sp,16
    800047aa:	8082                	ret

00000000800047ac <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800047ac:	df010113          	addi	sp,sp,-528
    800047b0:	20113423          	sd	ra,520(sp)
    800047b4:	20813023          	sd	s0,512(sp)
    800047b8:	ffa6                	sd	s1,504(sp)
    800047ba:	fbca                	sd	s2,496(sp)
    800047bc:	0c00                	addi	s0,sp,528
    800047be:	892a                	mv	s2,a0
    800047c0:	e0a43023          	sd	a0,-512(s0)
    800047c4:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800047c8:	91afd0ef          	jal	800018e2 <myproc>
    800047cc:	84aa                	mv	s1,a0

  begin_op();
    800047ce:	c9cff0ef          	jal	80003c6a <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    800047d2:	854a                	mv	a0,s2
    800047d4:	ab8ff0ef          	jal	80003a8c <namei>
    800047d8:	c931                	beqz	a0,8000482c <kexec+0x80>
    800047da:	f3d2                	sd	s4,480(sp)
    800047dc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800047de:	a1bfe0ef          	jal	800031f8 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800047e2:	04000713          	li	a4,64
    800047e6:	4681                	li	a3,0
    800047e8:	e5040613          	addi	a2,s0,-432
    800047ec:	4581                	li	a1,0
    800047ee:	8552                	mv	a0,s4
    800047f0:	de3fe0ef          	jal	800035d2 <readi>
    800047f4:	04000793          	li	a5,64
    800047f8:	00f51a63          	bne	a0,a5,8000480c <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    800047fc:	e5042703          	lw	a4,-432(s0)
    80004800:	464c47b7          	lui	a5,0x464c4
    80004804:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004808:	02f70563          	beq	a4,a5,80004832 <kexec+0x86>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    8000480c:	8552                	mv	a0,s4
    8000480e:	c3ffe0ef          	jal	8000344c <iunlockput>
    end_op();
    80004812:	ce4ff0ef          	jal	80003cf6 <end_op>
    80004816:	7a1e                	ld	s4,480(sp)
    return -1;
    80004818:	557d                	li	a0,-1
  }
  return -1;
}
    8000481a:	20813083          	ld	ra,520(sp)
    8000481e:	20013403          	ld	s0,512(sp)
    80004822:	74fe                	ld	s1,504(sp)
    80004824:	795e                	ld	s2,496(sp)
    80004826:	21010113          	addi	sp,sp,528
    8000482a:	8082                	ret
    end_op();
    8000482c:	ccaff0ef          	jal	80003cf6 <end_op>
    return -1;
    80004830:	b7e5                	j	80004818 <kexec+0x6c>
    80004832:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80004834:	8526                	mv	a0,s1
    80004836:	9c2fd0ef          	jal	800019f8 <proc_pagetable>
    8000483a:	8b2a                	mv	s6,a0
    8000483c:	26050263          	beqz	a0,80004aa0 <kexec+0x2f4>
    80004840:	f7ce                	sd	s3,488(sp)
    80004842:	efd6                	sd	s5,472(sp)
    80004844:	e7de                	sd	s7,456(sp)
    80004846:	e3e2                	sd	s8,448(sp)
    80004848:	ff66                	sd	s9,440(sp)
    8000484a:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000484c:	e8845783          	lhu	a5,-376(s0)
    80004850:	12078763          	beqz	a5,8000497e <kexec+0x1d2>
    80004854:	f76e                	sd	s11,424(sp)
    80004856:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000485a:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000485c:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000485e:	03800d93          	li	s11,56

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004862:	6c85                	lui	s9,0x1
    80004864:	6a85                	lui	s5,0x1
    80004866:	a085                	j	800048c6 <kexec+0x11a>
      panic("loadseg: address should exist");
    80004868:	00003517          	auipc	a0,0x3
    8000486c:	d5850513          	addi	a0,a0,-680 # 800075c0 <etext+0x5c0>
    80004870:	fd9fb0ef          	jal	80000848 <panic>
    if (sz - i < PGSIZE)
    80004874:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004876:	874a                	mv	a4,s2
    80004878:	009b86bb          	addw	a3,s7,s1
    8000487c:	4581                	li	a1,0
    8000487e:	8552                	mv	a0,s4
    80004880:	d53fe0ef          	jal	800035d2 <readi>
    80004884:	22a91263          	bne	s2,a0,80004aa8 <kexec+0x2fc>
  for (i = 0; i < sz; i += PGSIZE) {
    80004888:	009a84bb          	addw	s1,s5,s1
    8000488c:	0334f263          	bgeu	s1,s3,800048b0 <kexec+0x104>
    pa = walkaddr(pagetable, va + i);
    80004890:	02049593          	slli	a1,s1,0x20
    80004894:	9181                	srli	a1,a1,0x20
    80004896:	95e2                	add	a1,a1,s8
    80004898:	855a                	mv	a0,s6
    8000489a:	f3efc0ef          	jal	80000fd8 <walkaddr>
    8000489e:	862a                	mv	a2,a0
    if (pa == 0)
    800048a0:	d561                	beqz	a0,80004868 <kexec+0xbc>
    if (sz - i < PGSIZE)
    800048a2:	409987bb          	subw	a5,s3,s1
    800048a6:	893e                	mv	s2,a5
    800048a8:	fcfcf6e3          	bgeu	s9,a5,80004874 <kexec+0xc8>
    800048ac:	8956                	mv	s2,s5
    800048ae:	b7d9                	j	80004874 <kexec+0xc8>
    sz = sz1;
    800048b0:	df043903          	ld	s2,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800048b4:	2d05                	addiw	s10,s10,1
    800048b6:	e0843783          	ld	a5,-504(s0)
    800048ba:	0387869b          	addiw	a3,a5,56
    800048be:	e8845783          	lhu	a5,-376(s0)
    800048c2:	06fd5863          	bge	s10,a5,80004932 <kexec+0x186>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048c6:	e0d43423          	sd	a3,-504(s0)
    800048ca:	876e                	mv	a4,s11
    800048cc:	e1840613          	addi	a2,s0,-488
    800048d0:	4581                	li	a1,0
    800048d2:	8552                	mv	a0,s4
    800048d4:	cfffe0ef          	jal	800035d2 <readi>
    800048d8:	1db51663          	bne	a0,s11,80004aa4 <kexec+0x2f8>
    if (ph.type != ELF_PROG_LOAD)
    800048dc:	e1842783          	lw	a5,-488(s0)
    800048e0:	4705                	li	a4,1
    800048e2:	fce799e3          	bne	a5,a4,800048b4 <kexec+0x108>
    if (ph.memsz < ph.filesz)
    800048e6:	e4043483          	ld	s1,-448(s0)
    800048ea:	e3843783          	ld	a5,-456(s0)
    800048ee:	1af4eb63          	bltu	s1,a5,80004aa4 <kexec+0x2f8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800048f2:	e2843783          	ld	a5,-472(s0)
    800048f6:	94be                	add	s1,s1,a5
    800048f8:	1af4e663          	bltu	s1,a5,80004aa4 <kexec+0x2f8>
    if (ph.vaddr % PGSIZE != 0)
    800048fc:	17d2                	slli	a5,a5,0x34
    800048fe:	1a079363          	bnez	a5,80004aa4 <kexec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004902:	e1c42503          	lw	a0,-484(s0)
    80004906:	e87ff0ef          	jal	8000478c <flags2perm>
    8000490a:	86aa                	mv	a3,a0
    8000490c:	8626                	mv	a2,s1
    8000490e:	85ca                	mv	a1,s2
    80004910:	855a                	mv	a0,s6
    80004912:	995fc0ef          	jal	800012a6 <uvmalloc>
    80004916:	dea43823          	sd	a0,-528(s0)
    8000491a:	18050563          	beqz	a0,80004aa4 <kexec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000491e:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004922:	f80987e3          	beqz	s3,800048b0 <kexec+0x104>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004926:	e2843c03          	ld	s8,-472(s0)
    8000492a:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000492e:	4481                	li	s1,0
    80004930:	b785                	j	80004890 <kexec+0xe4>
    80004932:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004934:	8552                	mv	a0,s4
    80004936:	b17fe0ef          	jal	8000344c <iunlockput>
  end_op();
    8000493a:	bbcff0ef          	jal	80003cf6 <end_op>
  p = myproc();
    8000493e:	fa5fc0ef          	jal	800018e2 <myproc>
    80004942:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004944:	04853a03          	ld	s4,72(a0)
  sz = PGROUNDUP(sz);
    80004948:	6485                	lui	s1,0x1
    8000494a:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    8000494c:	94ca                	add	s1,s1,s2
    8000494e:	77fd                	lui	a5,0xfffff
    80004950:	8cfd                	and	s1,s1,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004952:	4691                	li	a3,4
    80004954:	6609                	lui	a2,0x2
    80004956:	9626                	add	a2,a2,s1
    80004958:	85a6                	mv	a1,s1
    8000495a:	855a                	mv	a0,s6
    8000495c:	94bfc0ef          	jal	800012a6 <uvmalloc>
    80004960:	8aaa                	mv	s5,a0
    80004962:	e105                	bnez	a0,80004982 <kexec+0x1d6>
    proc_freepagetable(pagetable, sz);
    80004964:	85a6                	mv	a1,s1
    80004966:	855a                	mv	a0,s6
    80004968:	912fd0ef          	jal	80001a7a <proc_freepagetable>
  if (ip) {
    8000496c:	79be                	ld	s3,488(sp)
    8000496e:	7a1e                	ld	s4,480(sp)
    80004970:	6afe                	ld	s5,472(sp)
    80004972:	6b5e                	ld	s6,464(sp)
    80004974:	6bbe                	ld	s7,456(sp)
    80004976:	6c1e                	ld	s8,448(sp)
    80004978:	7cfa                	ld	s9,440(sp)
    8000497a:	7d5a                	ld	s10,432(sp)
    8000497c:	bd71                	j	80004818 <kexec+0x6c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000497e:	4901                	li	s2,0
    80004980:	bf55                	j	80004934 <kexec+0x188>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004982:	75f9                	lui	a1,0xffffe
    80004984:	95aa                	add	a1,a1,a0
    80004986:	855a                	mv	a0,s6
    80004988:	ae7fc0ef          	jal	8000146e <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    8000498c:	7bfd                	lui	s7,0xfffff
    8000498e:	9bd6                	add	s7,s7,s5
  for (argc = 0; argv[argc]; argc++) {
    80004990:	df843783          	ld	a5,-520(s0)
    80004994:	6388                	ld	a0,0(a5)
    80004996:	cd3d                	beqz	a0,80004a14 <kexec+0x268>
  sp = sz;
    80004998:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    8000499a:	4481                	li	s1,0
    ustack[argc] = sp;
    8000499c:	e9040913          	addi	s2,s0,-368
    sp -= strlen(argv[argc]) + 1;
    800049a0:	c94fc0ef          	jal	80000e34 <strlen>
    800049a4:	0015079b          	addiw	a5,a0,1
    800049a8:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800049ac:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    800049b0:	077c6063          	bltu	s8,s7,80004a10 <kexec+0x264>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800049b4:	df843d03          	ld	s10,-520(s0)
    800049b8:	000d3c83          	ld	s9,0(s10)
    800049bc:	8566                	mv	a0,s9
    800049be:	c76fc0ef          	jal	80000e34 <strlen>
    800049c2:	0015071b          	addiw	a4,a0,1
    800049c6:	86e6                	mv	a3,s9
    800049c8:	8662                	mv	a2,s8
    800049ca:	85d6                	mv	a1,s5
    800049cc:	855a                	mv	a0,s6
    800049ce:	b5ffc0ef          	jal	8000152c <copyout>
    800049d2:	02054f63          	bltz	a0,80004a10 <kexec+0x264>
    ustack[argc] = sp;
    800049d6:	00349793          	slli	a5,s1,0x3
    800049da:	97ca                	add	a5,a5,s2
    800049dc:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffde450>
  for (argc = 0; argv[argc]; argc++) {
    800049e0:	0485                	addi	s1,s1,1
    800049e2:	008d0793          	addi	a5,s10,8
    800049e6:	def43c23          	sd	a5,-520(s0)
    800049ea:	008d3503          	ld	a0,8(s10)
    800049ee:	f94d                	bnez	a0,800049a0 <kexec+0x1f4>
  ustack[argc] = 0;
    800049f0:	00349793          	slli	a5,s1,0x3
    800049f4:	f9040713          	addi	a4,s0,-112
    800049f8:	97ba                	add	a5,a5,a4
    800049fa:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    800049fe:	00148713          	addi	a4,s1,1
    80004a02:	070e                	slli	a4,a4,0x3
    80004a04:	40ec0933          	sub	s2,s8,a4
  sp -= sp % 16;
    80004a08:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    80004a0c:	01797763          	bgeu	s2,s7,80004a1a <kexec+0x26e>
  sz = sz1;
    80004a10:	84d6                	mv	s1,s5
    80004a12:	bf89                	j	80004964 <kexec+0x1b8>
  sp = sz;
    80004a14:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004a16:	4481                	li	s1,0
    80004a18:	bfe1                	j	800049f0 <kexec+0x244>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004a1a:	e9040693          	addi	a3,s0,-368
    80004a1e:	864a                	mv	a2,s2
    80004a20:	85d6                	mv	a1,s5
    80004a22:	855a                	mv	a0,s6
    80004a24:	b09fc0ef          	jal	8000152c <copyout>
    80004a28:	fe0544e3          	bltz	a0,80004a10 <kexec+0x264>
  p->trapframe->a1 = sp;
    80004a2c:	0589b783          	ld	a5,88(s3)
    80004a30:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004a34:	e0043783          	ld	a5,-512(s0)
    80004a38:	0007c703          	lbu	a4,0(a5)
    80004a3c:	cf11                	beqz	a4,80004a58 <kexec+0x2ac>
    80004a3e:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004a40:	02f00693          	li	a3,47
    80004a44:	a029                	j	80004a4e <kexec+0x2a2>
  for (last = s = path; *s; s++)
    80004a46:	0785                	addi	a5,a5,1
    80004a48:	fff7c703          	lbu	a4,-1(a5)
    80004a4c:	c711                	beqz	a4,80004a58 <kexec+0x2ac>
    if (*s == '/')
    80004a4e:	fed71ce3          	bne	a4,a3,80004a46 <kexec+0x29a>
      last = s + 1;
    80004a52:	e0f43023          	sd	a5,-512(s0)
    80004a56:	bfc5                	j	80004a46 <kexec+0x29a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004a58:	4641                	li	a2,16
    80004a5a:	e0043583          	ld	a1,-512(s0)
    80004a5e:	15898513          	addi	a0,s3,344
    80004a62:	b9cfc0ef          	jal	80000dfe <safestrcpy>
  oldpagetable = p->pagetable;
    80004a66:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004a6a:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004a6e:	0559b423          	sd	s5,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004a72:	0589b783          	ld	a5,88(s3)
    80004a76:	e6843703          	ld	a4,-408(s0)
    80004a7a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004a7c:	0589b783          	ld	a5,88(s3)
    80004a80:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004a84:	85d2                	mv	a1,s4
    80004a86:	ff5fc0ef          	jal	80001a7a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004a8a:	0004851b          	sext.w	a0,s1
    80004a8e:	79be                	ld	s3,488(sp)
    80004a90:	7a1e                	ld	s4,480(sp)
    80004a92:	6afe                	ld	s5,472(sp)
    80004a94:	6b5e                	ld	s6,464(sp)
    80004a96:	6bbe                	ld	s7,456(sp)
    80004a98:	6c1e                	ld	s8,448(sp)
    80004a9a:	7cfa                	ld	s9,440(sp)
    80004a9c:	7d5a                	ld	s10,432(sp)
    80004a9e:	bbb5                	j	8000481a <kexec+0x6e>
    80004aa0:	6b5e                	ld	s6,464(sp)
    80004aa2:	b3ad                	j	8000480c <kexec+0x60>
    return -1;
    80004aa4:	df243823          	sd	s2,-528(s0)
    proc_freepagetable(pagetable, sz);
    80004aa8:	df043583          	ld	a1,-528(s0)
    80004aac:	855a                	mv	a0,s6
    80004aae:	fcdfc0ef          	jal	80001a7a <proc_freepagetable>
  if (ip) {
    80004ab2:	79be                	ld	s3,488(sp)
    80004ab4:	6afe                	ld	s5,472(sp)
    80004ab6:	6b5e                	ld	s6,464(sp)
    80004ab8:	6bbe                	ld	s7,456(sp)
    80004aba:	6c1e                	ld	s8,448(sp)
    80004abc:	7cfa                	ld	s9,440(sp)
    80004abe:	7d5a                	ld	s10,432(sp)
    80004ac0:	7dba                	ld	s11,424(sp)
    80004ac2:	b3a9                	j	8000480c <kexec+0x60>

0000000080004ac4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ac4:	7179                	addi	sp,sp,-48
    80004ac6:	f406                	sd	ra,40(sp)
    80004ac8:	f022                	sd	s0,32(sp)
    80004aca:	ec26                	sd	s1,24(sp)
    80004acc:	e84a                	sd	s2,16(sp)
    80004ace:	1800                	addi	s0,sp,48
    80004ad0:	892e                	mv	s2,a1
    80004ad2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004ad4:	fdc40593          	addi	a1,s0,-36
    80004ad8:	d39fd0ef          	jal	80002810 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004adc:	fdc42703          	lw	a4,-36(s0)
    80004ae0:	47bd                	li	a5,15
    80004ae2:	02e7e963          	bltu	a5,a4,80004b14 <argfd+0x50>
    80004ae6:	dfdfc0ef          	jal	800018e2 <myproc>
    80004aea:	fdc42703          	lw	a4,-36(s0)
    80004aee:	01a70793          	addi	a5,a4,26
    80004af2:	078e                	slli	a5,a5,0x3
    80004af4:	953e                	add	a0,a0,a5
    80004af6:	611c                	ld	a5,0(a0)
    80004af8:	cf91                	beqz	a5,80004b14 <argfd+0x50>
    return -1;
  if (pfd)
    80004afa:	00090463          	beqz	s2,80004b02 <argfd+0x3e>
    *pfd = fd;
    80004afe:	00e92023          	sw	a4,0(s2)
  if (pf)
    80004b02:	c091                	beqz	s1,80004b06 <argfd+0x42>
    *pf = f;
    80004b04:	e09c                	sd	a5,0(s1)
  return 0;
    80004b06:	4501                	li	a0,0
}
    80004b08:	70a2                	ld	ra,40(sp)
    80004b0a:	7402                	ld	s0,32(sp)
    80004b0c:	64e2                	ld	s1,24(sp)
    80004b0e:	6942                	ld	s2,16(sp)
    80004b10:	6145                	addi	sp,sp,48
    80004b12:	8082                	ret
    return -1;
    80004b14:	557d                	li	a0,-1
    80004b16:	bfcd                	j	80004b08 <argfd+0x44>

0000000080004b18 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004b18:	1101                	addi	sp,sp,-32
    80004b1a:	ec06                	sd	ra,24(sp)
    80004b1c:	e822                	sd	s0,16(sp)
    80004b1e:	e426                	sd	s1,8(sp)
    80004b20:	1000                	addi	s0,sp,32
    80004b22:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004b24:	dbffc0ef          	jal	800018e2 <myproc>
    80004b28:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004b2a:	0d050793          	addi	a5,a0,208
    80004b2e:	4501                	li	a0,0
    80004b30:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004b32:	6398                	ld	a4,0(a5)
    80004b34:	cb19                	beqz	a4,80004b4a <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004b36:	2505                	addiw	a0,a0,1
    80004b38:	07a1                	addi	a5,a5,8
    80004b3a:	fed51ce3          	bne	a0,a3,80004b32 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004b3e:	557d                	li	a0,-1
}
    80004b40:	60e2                	ld	ra,24(sp)
    80004b42:	6442                	ld	s0,16(sp)
    80004b44:	64a2                	ld	s1,8(sp)
    80004b46:	6105                	addi	sp,sp,32
    80004b48:	8082                	ret
      p->ofile[fd] = f;
    80004b4a:	01a50793          	addi	a5,a0,26
    80004b4e:	078e                	slli	a5,a5,0x3
    80004b50:	963e                	add	a2,a2,a5
    80004b52:	e204                	sd	s1,0(a2)
      return fd;
    80004b54:	b7f5                	j	80004b40 <fdalloc+0x28>

0000000080004b56 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004b56:	715d                	addi	sp,sp,-80
    80004b58:	e486                	sd	ra,72(sp)
    80004b5a:	e0a2                	sd	s0,64(sp)
    80004b5c:	fc26                	sd	s1,56(sp)
    80004b5e:	f84a                	sd	s2,48(sp)
    80004b60:	f44e                	sd	s3,40(sp)
    80004b62:	ec56                	sd	s5,24(sp)
    80004b64:	e85a                	sd	s6,16(sp)
    80004b66:	0880                	addi	s0,sp,80
    80004b68:	89ae                	mv	s3,a1
    80004b6a:	8ab2                	mv	s5,a2
    80004b6c:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004b6e:	fb040593          	addi	a1,s0,-80
    80004b72:	f35fe0ef          	jal	80003aa6 <nameiparent>
    80004b76:	84aa                	mv	s1,a0
    return 0;
    80004b78:	892a                	mv	s2,a0
  if ((dp = nameiparent(path, name)) == 0)
    80004b7a:	cd31                	beqz	a0,80004bd6 <create+0x80>

  ilock(dp);
    80004b7c:	e7cfe0ef          	jal	800031f8 <ilock>

  if (dp->nlink == 0) {
    80004b80:	04a49783          	lh	a5,74(s1)
    80004b84:	c3bd                	beqz	a5,80004bea <create+0x94>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004b86:	7761                	lui	a4,0xffff8
    80004b88:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd7451>
    80004b8a:	97ba                	add	a5,a5,a4
    80004b8c:	0017b793          	seqz	a5,a5
    80004b90:	fff98713          	addi	a4,s3,-1
    80004b94:	00173713          	seqz	a4,a4
    80004b98:	8ff9                	and	a5,a5,a4
    80004b9a:	efa1                	bnez	a5,80004bf2 <create+0x9c>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004b9c:	4601                	li	a2,0
    80004b9e:	fb040593          	addi	a1,s0,-80
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	c3ffe0ef          	jal	800037e2 <dirlookup>
    80004ba8:	892a                	mv	s2,a0
    80004baa:	c921                	beqz	a0,80004bfa <create+0xa4>
    iunlockput(dp);
    80004bac:	8526                	mv	a0,s1
    80004bae:	89ffe0ef          	jal	8000344c <iunlockput>
    ilock(ip);
    80004bb2:	854a                	mv	a0,s2
    80004bb4:	e44fe0ef          	jal	800031f8 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004bb8:	4789                	li	a5,2
    80004bba:	00f99a63          	bne	s3,a5,80004bce <create+0x78>
    80004bbe:	04495783          	lhu	a5,68(s2)
    80004bc2:	37f9                	addiw	a5,a5,-2
    80004bc4:	17c2                	slli	a5,a5,0x30
    80004bc6:	93c1                	srli	a5,a5,0x30
    80004bc8:	4705                	li	a4,1
    80004bca:	00f77663          	bgeu	a4,a5,80004bd6 <create+0x80>
      return ip;
    iunlockput(ip);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	87dfe0ef          	jal	8000344c <iunlockput>
    return 0;
    80004bd4:	4901                	li	s2,0
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004bd6:	854a                	mv	a0,s2
    80004bd8:	60a6                	ld	ra,72(sp)
    80004bda:	6406                	ld	s0,64(sp)
    80004bdc:	74e2                	ld	s1,56(sp)
    80004bde:	7942                	ld	s2,48(sp)
    80004be0:	79a2                	ld	s3,40(sp)
    80004be2:	6ae2                	ld	s5,24(sp)
    80004be4:	6b42                	ld	s6,16(sp)
    80004be6:	6161                	addi	sp,sp,80
    80004be8:	8082                	ret
    iunlockput(dp);
    80004bea:	8526                	mv	a0,s1
    80004bec:	861fe0ef          	jal	8000344c <iunlockput>
    return 0;
    80004bf0:	b7d5                	j	80004bd4 <create+0x7e>
    iunlockput(dp);
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	859fe0ef          	jal	8000344c <iunlockput>
    return 0;
    80004bf8:	bff1                	j	80004bd4 <create+0x7e>
    80004bfa:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004bfc:	85ce                	mv	a1,s3
    80004bfe:	4088                	lw	a0,0(s1)
    80004c00:	c88fe0ef          	jal	80003088 <ialloc>
    80004c04:	8a2a                	mv	s4,a0
    80004c06:	cd1d                	beqz	a0,80004c44 <create+0xee>
  ilock(ip);
    80004c08:	df0fe0ef          	jal	800031f8 <ilock>
  ip->major = major;
    80004c0c:	055a1323          	sh	s5,70(s4)
  ip->minor = minor;
    80004c10:	056a1423          	sh	s6,72(s4)
  ip->nlink = 1;
    80004c14:	4705                	li	a4,1
    80004c16:	04ea1523          	sh	a4,74(s4)
  iupdate(ip);
    80004c1a:	8552                	mv	a0,s4
    80004c1c:	d28fe0ef          	jal	80003144 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004c20:	4785                	li	a5,1
    80004c22:	02f98563          	beq	s3,a5,80004c4c <create+0xf6>
  if (dirlink(dp, name, ip->inum) < 0)
    80004c26:	004a2603          	lw	a2,4(s4)
    80004c2a:	fb040593          	addi	a1,s0,-80
    80004c2e:	8526                	mv	a0,s1
    80004c30:	db3fe0ef          	jal	800039e2 <dirlink>
    80004c34:	06054363          	bltz	a0,80004c9a <create+0x144>
  iunlockput(dp);
    80004c38:	8526                	mv	a0,s1
    80004c3a:	813fe0ef          	jal	8000344c <iunlockput>
    return 0;
    80004c3e:	8952                	mv	s2,s4
    80004c40:	7a02                	ld	s4,32(sp)
    80004c42:	bf51                	j	80004bd6 <create+0x80>
    iunlockput(dp);
    80004c44:	8526                	mv	a0,s1
    80004c46:	807fe0ef          	jal	8000344c <iunlockput>
    return 0;
    80004c4a:	bfd5                	j	80004c3e <create+0xe8>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004c4c:	004a2603          	lw	a2,4(s4)
    80004c50:	00003597          	auipc	a1,0x3
    80004c54:	99058593          	addi	a1,a1,-1648 # 800075e0 <etext+0x5e0>
    80004c58:	8552                	mv	a0,s4
    80004c5a:	d89fe0ef          	jal	800039e2 <dirlink>
    80004c5e:	02054e63          	bltz	a0,80004c9a <create+0x144>
    80004c62:	40d0                	lw	a2,4(s1)
    80004c64:	00003597          	auipc	a1,0x3
    80004c68:	98458593          	addi	a1,a1,-1660 # 800075e8 <etext+0x5e8>
    80004c6c:	8552                	mv	a0,s4
    80004c6e:	d75fe0ef          	jal	800039e2 <dirlink>
    80004c72:	02054463          	bltz	a0,80004c9a <create+0x144>
  if (dirlink(dp, name, ip->inum) < 0)
    80004c76:	004a2603          	lw	a2,4(s4)
    80004c7a:	fb040593          	addi	a1,s0,-80
    80004c7e:	8526                	mv	a0,s1
    80004c80:	d63fe0ef          	jal	800039e2 <dirlink>
    80004c84:	00054b63          	bltz	a0,80004c9a <create+0x144>
    dp->nlink++; // for ".."
    80004c88:	04a4d783          	lhu	a5,74(s1)
    80004c8c:	2785                	addiw	a5,a5,1
    80004c8e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c92:	8526                	mv	a0,s1
    80004c94:	cb0fe0ef          	jal	80003144 <iupdate>
    80004c98:	b745                	j	80004c38 <create+0xe2>
  ip->nlink = 0;
    80004c9a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004c9e:	8552                	mv	a0,s4
    80004ca0:	ca4fe0ef          	jal	80003144 <iupdate>
  iunlockput(ip);
    80004ca4:	8552                	mv	a0,s4
    80004ca6:	fa6fe0ef          	jal	8000344c <iunlockput>
  iunlockput(dp);
    80004caa:	8526                	mv	a0,s1
    80004cac:	fa0fe0ef          	jal	8000344c <iunlockput>
  return 0;
    80004cb0:	7a02                	ld	s4,32(sp)
    80004cb2:	b715                	j	80004bd6 <create+0x80>

0000000080004cb4 <sys_dup>:
{
    80004cb4:	7179                	addi	sp,sp,-48
    80004cb6:	f406                	sd	ra,40(sp)
    80004cb8:	f022                	sd	s0,32(sp)
    80004cba:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004cbc:	fd840613          	addi	a2,s0,-40
    80004cc0:	4581                	li	a1,0
    80004cc2:	4501                	li	a0,0
    80004cc4:	e01ff0ef          	jal	80004ac4 <argfd>
    80004cc8:	02054863          	bltz	a0,80004cf8 <sys_dup+0x44>
    80004ccc:	ec26                	sd	s1,24(sp)
    80004cce:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004cd0:	fd843483          	ld	s1,-40(s0)
    80004cd4:	8526                	mv	a0,s1
    80004cd6:	e43ff0ef          	jal	80004b18 <fdalloc>
    80004cda:	892a                	mv	s2,a0
    80004cdc:	00054c63          	bltz	a0,80004cf4 <sys_dup+0x40>
  filedup(f);
    80004ce0:	8526                	mv	a0,s1
    80004ce2:	bf8ff0ef          	jal	800040da <filedup>
  return fd;
    80004ce6:	854a                	mv	a0,s2
    80004ce8:	64e2                	ld	s1,24(sp)
    80004cea:	6942                	ld	s2,16(sp)
}
    80004cec:	70a2                	ld	ra,40(sp)
    80004cee:	7402                	ld	s0,32(sp)
    80004cf0:	6145                	addi	sp,sp,48
    80004cf2:	8082                	ret
    80004cf4:	64e2                	ld	s1,24(sp)
    80004cf6:	6942                	ld	s2,16(sp)
    return -1;
    80004cf8:	557d                	li	a0,-1
    80004cfa:	bfcd                	j	80004cec <sys_dup+0x38>

0000000080004cfc <sys_read>:
{
    80004cfc:	7179                	addi	sp,sp,-48
    80004cfe:	f406                	sd	ra,40(sp)
    80004d00:	f022                	sd	s0,32(sp)
    80004d02:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d04:	fd840593          	addi	a1,s0,-40
    80004d08:	4505                	li	a0,1
    80004d0a:	b23fd0ef          	jal	8000282c <argaddr>
  argint(2, &n);
    80004d0e:	fe440593          	addi	a1,s0,-28
    80004d12:	4509                	li	a0,2
    80004d14:	afdfd0ef          	jal	80002810 <argint>
  if (argfd(0, 0, &f) < 0)
    80004d18:	fe840613          	addi	a2,s0,-24
    80004d1c:	4581                	li	a1,0
    80004d1e:	4501                	li	a0,0
    80004d20:	da5ff0ef          	jal	80004ac4 <argfd>
    80004d24:	87aa                	mv	a5,a0
    return -1;
    80004d26:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004d28:	0007ca63          	bltz	a5,80004d3c <sys_read+0x40>
  return fileread(f, p, n);
    80004d2c:	fe442603          	lw	a2,-28(s0)
    80004d30:	fd843583          	ld	a1,-40(s0)
    80004d34:	fe843503          	ld	a0,-24(s0)
    80004d38:	d10ff0ef          	jal	80004248 <fileread>
}
    80004d3c:	70a2                	ld	ra,40(sp)
    80004d3e:	7402                	ld	s0,32(sp)
    80004d40:	6145                	addi	sp,sp,48
    80004d42:	8082                	ret

0000000080004d44 <sys_write>:
{
    80004d44:	7179                	addi	sp,sp,-48
    80004d46:	f406                	sd	ra,40(sp)
    80004d48:	f022                	sd	s0,32(sp)
    80004d4a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d4c:	fd840593          	addi	a1,s0,-40
    80004d50:	4505                	li	a0,1
    80004d52:	adbfd0ef          	jal	8000282c <argaddr>
  argint(2, &n);
    80004d56:	fe440593          	addi	a1,s0,-28
    80004d5a:	4509                	li	a0,2
    80004d5c:	ab5fd0ef          	jal	80002810 <argint>
  if (argfd(0, 0, &f) < 0)
    80004d60:	fe840613          	addi	a2,s0,-24
    80004d64:	4581                	li	a1,0
    80004d66:	4501                	li	a0,0
    80004d68:	d5dff0ef          	jal	80004ac4 <argfd>
    80004d6c:	87aa                	mv	a5,a0
    return -1;
    80004d6e:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004d70:	0007ca63          	bltz	a5,80004d84 <sys_write+0x40>
  return filewrite(f, p, n);
    80004d74:	fe442603          	lw	a2,-28(s0)
    80004d78:	fd843583          	ld	a1,-40(s0)
    80004d7c:	fe843503          	ld	a0,-24(s0)
    80004d80:	d8cff0ef          	jal	8000430c <filewrite>
}
    80004d84:	70a2                	ld	ra,40(sp)
    80004d86:	7402                	ld	s0,32(sp)
    80004d88:	6145                	addi	sp,sp,48
    80004d8a:	8082                	ret

0000000080004d8c <sys_close>:
{
    80004d8c:	1101                	addi	sp,sp,-32
    80004d8e:	ec06                	sd	ra,24(sp)
    80004d90:	e822                	sd	s0,16(sp)
    80004d92:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004d94:	fe040613          	addi	a2,s0,-32
    80004d98:	fec40593          	addi	a1,s0,-20
    80004d9c:	4501                	li	a0,0
    80004d9e:	d27ff0ef          	jal	80004ac4 <argfd>
    return -1;
    80004da2:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004da4:	02054063          	bltz	a0,80004dc4 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004da8:	b3bfc0ef          	jal	800018e2 <myproc>
    80004dac:	fec42783          	lw	a5,-20(s0)
    80004db0:	07e9                	addi	a5,a5,26
    80004db2:	078e                	slli	a5,a5,0x3
    80004db4:	953e                	add	a0,a0,a5
    80004db6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004dba:	fe043503          	ld	a0,-32(s0)
    80004dbe:	b62ff0ef          	jal	80004120 <fileclose>
  return 0;
    80004dc2:	4781                	li	a5,0
}
    80004dc4:	853e                	mv	a0,a5
    80004dc6:	60e2                	ld	ra,24(sp)
    80004dc8:	6442                	ld	s0,16(sp)
    80004dca:	6105                	addi	sp,sp,32
    80004dcc:	8082                	ret

0000000080004dce <sys_fstat>:
{
    80004dce:	1101                	addi	sp,sp,-32
    80004dd0:	ec06                	sd	ra,24(sp)
    80004dd2:	e822                	sd	s0,16(sp)
    80004dd4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004dd6:	fe040593          	addi	a1,s0,-32
    80004dda:	4505                	li	a0,1
    80004ddc:	a51fd0ef          	jal	8000282c <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004de0:	fe840613          	addi	a2,s0,-24
    80004de4:	4581                	li	a1,0
    80004de6:	4501                	li	a0,0
    80004de8:	cddff0ef          	jal	80004ac4 <argfd>
    80004dec:	87aa                	mv	a5,a0
    return -1;
    80004dee:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004df0:	0007c863          	bltz	a5,80004e00 <sys_fstat+0x32>
  return filestat(f, st);
    80004df4:	fe043583          	ld	a1,-32(s0)
    80004df8:	fe843503          	ld	a0,-24(s0)
    80004dfc:	be6ff0ef          	jal	800041e2 <filestat>
}
    80004e00:	60e2                	ld	ra,24(sp)
    80004e02:	6442                	ld	s0,16(sp)
    80004e04:	6105                	addi	sp,sp,32
    80004e06:	8082                	ret

0000000080004e08 <sys_link>:
{
    80004e08:	7169                	addi	sp,sp,-304
    80004e0a:	f606                	sd	ra,296(sp)
    80004e0c:	f222                	sd	s0,288(sp)
    80004e0e:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e10:	08000613          	li	a2,128
    80004e14:	ed040593          	addi	a1,s0,-304
    80004e18:	4501                	li	a0,0
    80004e1a:	a2ffd0ef          	jal	80002848 <argstr>
    80004e1e:	0e054c63          	bltz	a0,80004f16 <sys_link+0x10e>
    80004e22:	08000613          	li	a2,128
    80004e26:	f5040593          	addi	a1,s0,-176
    80004e2a:	4505                	li	a0,1
    80004e2c:	a1dfd0ef          	jal	80002848 <argstr>
    80004e30:	0e054363          	bltz	a0,80004f16 <sys_link+0x10e>
    80004e34:	ee26                	sd	s1,280(sp)
  begin_op();
    80004e36:	e35fe0ef          	jal	80003c6a <begin_op>
  if ((ip = namei(old)) == 0) {
    80004e3a:	ed040513          	addi	a0,s0,-304
    80004e3e:	c4ffe0ef          	jal	80003a8c <namei>
    80004e42:	84aa                	mv	s1,a0
    80004e44:	cd35                	beqz	a0,80004ec0 <sys_link+0xb8>
  ilock(ip);
    80004e46:	bb2fe0ef          	jal	800031f8 <ilock>
  if (ip->type == T_DIR) {
    80004e4a:	04449703          	lh	a4,68(s1)
    80004e4e:	4785                	li	a5,1
    80004e50:	06f70c63          	beq	a4,a5,80004ec8 <sys_link+0xc0>
  if (ip->nlink >= NLINK_MAX) {
    80004e54:	04a49783          	lh	a5,74(s1)
    80004e58:	6721                	lui	a4,0x8
    80004e5a:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80004e5c:	06e78d63          	beq	a5,a4,80004ed6 <sys_link+0xce>
    80004e60:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004e62:	2785                	addiw	a5,a5,1
    80004e64:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e68:	8526                	mv	a0,s1
    80004e6a:	adafe0ef          	jal	80003144 <iupdate>
  iunlock(ip);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	c36fe0ef          	jal	800032a6 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004e74:	fd040593          	addi	a1,s0,-48
    80004e78:	f5040513          	addi	a0,s0,-176
    80004e7c:	c2bfe0ef          	jal	80003aa6 <nameiparent>
    80004e80:	892a                	mv	s2,a0
    80004e82:	c925                	beqz	a0,80004ef2 <sys_link+0xea>
  ilock(dp);
    80004e84:	b74fe0ef          	jal	800031f8 <ilock>
  if (dp->nlink == 0) {
    80004e88:	04a91783          	lh	a5,74(s2)
    80004e8c:	cfa1                	beqz	a5,80004ee4 <sys_link+0xdc>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004e8e:	854a                	mv	a0,s2
    80004e90:	00092703          	lw	a4,0(s2)
    80004e94:	409c                	lw	a5,0(s1)
    80004e96:	04f71b63          	bne	a4,a5,80004eec <sys_link+0xe4>
    80004e9a:	40d0                	lw	a2,4(s1)
    80004e9c:	fd040593          	addi	a1,s0,-48
    80004ea0:	b43fe0ef          	jal	800039e2 <dirlink>
    80004ea4:	04054463          	bltz	a0,80004eec <sys_link+0xe4>
  iunlockput(dp);
    80004ea8:	854a                	mv	a0,s2
    80004eaa:	da2fe0ef          	jal	8000344c <iunlockput>
  iput(ip);
    80004eae:	8526                	mv	a0,s1
    80004eb0:	ccafe0ef          	jal	8000337a <iput>
  end_op();
    80004eb4:	e43fe0ef          	jal	80003cf6 <end_op>
  return 0;
    80004eb8:	4501                	li	a0,0
    80004eba:	64f2                	ld	s1,280(sp)
    80004ebc:	6952                	ld	s2,272(sp)
    80004ebe:	a8a9                	j	80004f18 <sys_link+0x110>
    end_op();
    80004ec0:	e37fe0ef          	jal	80003cf6 <end_op>
    return -1;
    80004ec4:	64f2                	ld	s1,280(sp)
    80004ec6:	a881                	j	80004f16 <sys_link+0x10e>
    iunlockput(ip);
    80004ec8:	8526                	mv	a0,s1
    80004eca:	d82fe0ef          	jal	8000344c <iunlockput>
    end_op();
    80004ece:	e29fe0ef          	jal	80003cf6 <end_op>
    return -1;
    80004ed2:	64f2                	ld	s1,280(sp)
    80004ed4:	a089                	j	80004f16 <sys_link+0x10e>
    iunlockput(ip);
    80004ed6:	8526                	mv	a0,s1
    80004ed8:	d74fe0ef          	jal	8000344c <iunlockput>
    end_op();
    80004edc:	e1bfe0ef          	jal	80003cf6 <end_op>
    return -1;
    80004ee0:	64f2                	ld	s1,280(sp)
    80004ee2:	a815                	j	80004f16 <sys_link+0x10e>
    iunlockput(dp);
    80004ee4:	854a                	mv	a0,s2
    80004ee6:	d66fe0ef          	jal	8000344c <iunlockput>
    goto bad;
    80004eea:	a021                	j	80004ef2 <sys_link+0xea>
    iunlockput(dp);
    80004eec:	854a                	mv	a0,s2
    80004eee:	d5efe0ef          	jal	8000344c <iunlockput>
  ilock(ip);
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	b04fe0ef          	jal	800031f8 <ilock>
  ip->nlink--;
    80004ef8:	04a4d783          	lhu	a5,74(s1)
    80004efc:	37fd                	addiw	a5,a5,-1
    80004efe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f02:	8526                	mv	a0,s1
    80004f04:	a40fe0ef          	jal	80003144 <iupdate>
  iunlockput(ip);
    80004f08:	8526                	mv	a0,s1
    80004f0a:	d42fe0ef          	jal	8000344c <iunlockput>
  end_op();
    80004f0e:	de9fe0ef          	jal	80003cf6 <end_op>
  return -1;
    80004f12:	64f2                	ld	s1,280(sp)
    80004f14:	6952                	ld	s2,272(sp)
    return -1;
    80004f16:	557d                	li	a0,-1
}
    80004f18:	70b2                	ld	ra,296(sp)
    80004f1a:	7412                	ld	s0,288(sp)
    80004f1c:	6155                	addi	sp,sp,304
    80004f1e:	8082                	ret

0000000080004f20 <sys_unlink>:
{
    80004f20:	7151                	addi	sp,sp,-240
    80004f22:	f586                	sd	ra,232(sp)
    80004f24:	f1a2                	sd	s0,224(sp)
    80004f26:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004f28:	08000613          	li	a2,128
    80004f2c:	f3040593          	addi	a1,s0,-208
    80004f30:	4501                	li	a0,0
    80004f32:	917fd0ef          	jal	80002848 <argstr>
    80004f36:	14054763          	bltz	a0,80005084 <sys_unlink+0x164>
    80004f3a:	eda6                	sd	s1,216(sp)
  begin_op();
    80004f3c:	d2ffe0ef          	jal	80003c6a <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004f40:	fb040593          	addi	a1,s0,-80
    80004f44:	f3040513          	addi	a0,s0,-208
    80004f48:	b5ffe0ef          	jal	80003aa6 <nameiparent>
    80004f4c:	84aa                	mv	s1,a0
    80004f4e:	c955                	beqz	a0,80005002 <sys_unlink+0xe2>
  ilock(dp);
    80004f50:	aa8fe0ef          	jal	800031f8 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f54:	00002597          	auipc	a1,0x2
    80004f58:	68c58593          	addi	a1,a1,1676 # 800075e0 <etext+0x5e0>
    80004f5c:	fb040513          	addi	a0,s0,-80
    80004f60:	86dfe0ef          	jal	800037cc <namecmp>
    80004f64:	10050a63          	beqz	a0,80005078 <sys_unlink+0x158>
    80004f68:	00002597          	auipc	a1,0x2
    80004f6c:	68058593          	addi	a1,a1,1664 # 800075e8 <etext+0x5e8>
    80004f70:	fb040513          	addi	a0,s0,-80
    80004f74:	859fe0ef          	jal	800037cc <namecmp>
    80004f78:	10050063          	beqz	a0,80005078 <sys_unlink+0x158>
    80004f7c:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004f7e:	f2c40613          	addi	a2,s0,-212
    80004f82:	fb040593          	addi	a1,s0,-80
    80004f86:	8526                	mv	a0,s1
    80004f88:	85bfe0ef          	jal	800037e2 <dirlookup>
    80004f8c:	892a                	mv	s2,a0
    80004f8e:	0e050463          	beqz	a0,80005076 <sys_unlink+0x156>
    80004f92:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004f94:	a64fe0ef          	jal	800031f8 <ilock>
  if (ip->nlink < 1)
    80004f98:	04a91783          	lh	a5,74(s2)
    80004f9c:	06f05763          	blez	a5,8000500a <sys_unlink+0xea>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004fa0:	04491703          	lh	a4,68(s2)
    80004fa4:	4785                	li	a5,1
    80004fa6:	06f70863          	beq	a4,a5,80005016 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004faa:	fc040993          	addi	s3,s0,-64
    80004fae:	4641                	li	a2,16
    80004fb0:	4581                	li	a1,0
    80004fb2:	854e                	mv	a0,s3
    80004fb4:	d01fb0ef          	jal	80000cb4 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004fb8:	4741                	li	a4,16
    80004fba:	f2c42683          	lw	a3,-212(s0)
    80004fbe:	864e                	mv	a2,s3
    80004fc0:	4581                	li	a1,0
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	f00fe0ef          	jal	800036c4 <writei>
    80004fc8:	47c1                	li	a5,16
    80004fca:	08f51763          	bne	a0,a5,80005058 <sys_unlink+0x138>
  if (ip->type == T_DIR) {
    80004fce:	04491703          	lh	a4,68(s2)
    80004fd2:	4785                	li	a5,1
    80004fd4:	08f70863          	beq	a4,a5,80005064 <sys_unlink+0x144>
  iunlockput(dp);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	c72fe0ef          	jal	8000344c <iunlockput>
  ip->nlink--;
    80004fde:	04a95783          	lhu	a5,74(s2)
    80004fe2:	37fd                	addiw	a5,a5,-1
    80004fe4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004fe8:	854a                	mv	a0,s2
    80004fea:	95afe0ef          	jal	80003144 <iupdate>
  iunlockput(ip);
    80004fee:	854a                	mv	a0,s2
    80004ff0:	c5cfe0ef          	jal	8000344c <iunlockput>
  end_op();
    80004ff4:	d03fe0ef          	jal	80003cf6 <end_op>
  return 0;
    80004ff8:	4501                	li	a0,0
    80004ffa:	64ee                	ld	s1,216(sp)
    80004ffc:	694e                	ld	s2,208(sp)
    80004ffe:	69ae                	ld	s3,200(sp)
    80005000:	a059                	j	80005086 <sys_unlink+0x166>
    end_op();
    80005002:	cf5fe0ef          	jal	80003cf6 <end_op>
    return -1;
    80005006:	64ee                	ld	s1,216(sp)
    80005008:	a8b5                	j	80005084 <sys_unlink+0x164>
    panic("unlink: nlink < 1");
    8000500a:	00002517          	auipc	a0,0x2
    8000500e:	5e650513          	addi	a0,a0,1510 # 800075f0 <etext+0x5f0>
    80005012:	837fb0ef          	jal	80000848 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005016:	04c92703          	lw	a4,76(s2)
    8000501a:	02000793          	li	a5,32
    8000501e:	f8e7f6e3          	bgeu	a5,a4,80004faa <sys_unlink+0x8a>
    80005022:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005024:	4741                	li	a4,16
    80005026:	86ce                	mv	a3,s3
    80005028:	f1840613          	addi	a2,s0,-232
    8000502c:	4581                	li	a1,0
    8000502e:	854a                	mv	a0,s2
    80005030:	da2fe0ef          	jal	800035d2 <readi>
    80005034:	47c1                	li	a5,16
    80005036:	00f51b63          	bne	a0,a5,8000504c <sys_unlink+0x12c>
    if (de.inum != 0)
    8000503a:	f1845783          	lhu	a5,-232(s0)
    8000503e:	eba1                	bnez	a5,8000508e <sys_unlink+0x16e>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005040:	29c1                	addiw	s3,s3,16
    80005042:	04c92783          	lw	a5,76(s2)
    80005046:	fcf9efe3          	bltu	s3,a5,80005024 <sys_unlink+0x104>
    8000504a:	b785                	j	80004faa <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000504c:	00002517          	auipc	a0,0x2
    80005050:	5bc50513          	addi	a0,a0,1468 # 80007608 <etext+0x608>
    80005054:	ff4fb0ef          	jal	80000848 <panic>
    panic("unlink: writei");
    80005058:	00002517          	auipc	a0,0x2
    8000505c:	5c850513          	addi	a0,a0,1480 # 80007620 <etext+0x620>
    80005060:	fe8fb0ef          	jal	80000848 <panic>
    dp->nlink--;
    80005064:	04a4d783          	lhu	a5,74(s1)
    80005068:	37fd                	addiw	a5,a5,-1
    8000506a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000506e:	8526                	mv	a0,s1
    80005070:	8d4fe0ef          	jal	80003144 <iupdate>
    80005074:	b795                	j	80004fd8 <sys_unlink+0xb8>
    80005076:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005078:	8526                	mv	a0,s1
    8000507a:	bd2fe0ef          	jal	8000344c <iunlockput>
  end_op();
    8000507e:	c79fe0ef          	jal	80003cf6 <end_op>
  return -1;
    80005082:	64ee                	ld	s1,216(sp)
    return -1;
    80005084:	557d                	li	a0,-1
}
    80005086:	70ae                	ld	ra,232(sp)
    80005088:	740e                	ld	s0,224(sp)
    8000508a:	616d                	addi	sp,sp,240
    8000508c:	8082                	ret
    iunlockput(ip);
    8000508e:	854a                	mv	a0,s2
    80005090:	bbcfe0ef          	jal	8000344c <iunlockput>
    goto bad;
    80005094:	694e                	ld	s2,208(sp)
    80005096:	69ae                	ld	s3,200(sp)
    80005098:	b7c5                	j	80005078 <sys_unlink+0x158>

000000008000509a <sys_open>:

uint64
sys_open(void)
{
    8000509a:	7131                	addi	sp,sp,-192
    8000509c:	fd06                	sd	ra,184(sp)
    8000509e:	f922                	sd	s0,176(sp)
    800050a0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800050a2:	f4c40593          	addi	a1,s0,-180
    800050a6:	4505                	li	a0,1
    800050a8:	f68fd0ef          	jal	80002810 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800050ac:	08000613          	li	a2,128
    800050b0:	f5040593          	addi	a1,s0,-176
    800050b4:	4501                	li	a0,0
    800050b6:	f92fd0ef          	jal	80002848 <argstr>
    800050ba:	10054563          	bltz	a0,800051c4 <sys_open+0x12a>
    800050be:	f526                	sd	s1,168(sp)
    return -1;

  begin_op();
    800050c0:	babfe0ef          	jal	80003c6a <begin_op>

  if (omode & O_CREATE) {
    800050c4:	f4c42783          	lw	a5,-180(s0)
    800050c8:	2007f793          	andi	a5,a5,512
    800050cc:	cfd9                	beqz	a5,8000516a <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
    800050ce:	4681                	li	a3,0
    800050d0:	4601                	li	a2,0
    800050d2:	4589                	li	a1,2
    800050d4:	f5040513          	addi	a0,s0,-176
    800050d8:	a7fff0ef          	jal	80004b56 <create>
    800050dc:	84aa                	mv	s1,a0
    if (ip == 0) {
    800050de:	c151                	beqz	a0,80005162 <sys_open+0xc8>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    800050e0:	04449703          	lh	a4,68(s1)
    800050e4:	478d                	li	a5,3
    800050e6:	00f71763          	bne	a4,a5,800050f4 <sys_open+0x5a>
    800050ea:	0464d703          	lhu	a4,70(s1)
    800050ee:	47a5                	li	a5,9
    800050f0:	0ae7e863          	bltu	a5,a4,800051a0 <sys_open+0x106>
    800050f4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    800050f6:	f87fe0ef          	jal	8000407c <filealloc>
    800050fa:	892a                	mv	s2,a0
    800050fc:	cd4d                	beqz	a0,800051b6 <sys_open+0x11c>
    800050fe:	ed4e                	sd	s3,152(sp)
    80005100:	a19ff0ef          	jal	80004b18 <fdalloc>
    80005104:	89aa                	mv	s3,a0
    80005106:	0a054463          	bltz	a0,800051ae <sys_open+0x114>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    8000510a:	04449703          	lh	a4,68(s1)
    8000510e:	478d                	li	a5,3
    80005110:	0af70f63          	beq	a4,a5,800051ce <sys_open+0x134>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005114:	4789                	li	a5,2
    80005116:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000511a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000511e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005122:	f4c42783          	lw	a5,-180(s0)
    80005126:	0017f713          	andi	a4,a5,1
    8000512a:	00174713          	xori	a4,a4,1
    8000512e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005132:	0037f713          	andi	a4,a5,3
    80005136:	00e03733          	snez	a4,a4
    8000513a:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    8000513e:	4007f793          	andi	a5,a5,1024
    80005142:	c791                	beqz	a5,8000514e <sys_open+0xb4>
    80005144:	04449703          	lh	a4,68(s1)
    80005148:	4789                	li	a5,2
    8000514a:	08f70963          	beq	a4,a5,800051dc <sys_open+0x142>
    itrunc(ip);
  }

  iunlock(ip);
    8000514e:	8526                	mv	a0,s1
    80005150:	956fe0ef          	jal	800032a6 <iunlock>
  end_op();
    80005154:	ba3fe0ef          	jal	80003cf6 <end_op>

  return fd;
    80005158:	854e                	mv	a0,s3
    8000515a:	74aa                	ld	s1,168(sp)
    8000515c:	790a                	ld	s2,160(sp)
    8000515e:	69ea                	ld	s3,152(sp)
    80005160:	a09d                	j	800051c6 <sys_open+0x12c>
      end_op();
    80005162:	b95fe0ef          	jal	80003cf6 <end_op>
      return -1;
    80005166:	74aa                	ld	s1,168(sp)
    80005168:	a8b1                	j	800051c4 <sys_open+0x12a>
    if ((ip = namei(path)) == 0) {
    8000516a:	f5040513          	addi	a0,s0,-176
    8000516e:	91ffe0ef          	jal	80003a8c <namei>
    80005172:	84aa                	mv	s1,a0
    80005174:	c115                	beqz	a0,80005198 <sys_open+0xfe>
    ilock(ip);
    80005176:	882fe0ef          	jal	800031f8 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    8000517a:	04449703          	lh	a4,68(s1)
    8000517e:	4785                	li	a5,1
    80005180:	f6f710e3          	bne	a4,a5,800050e0 <sys_open+0x46>
    80005184:	f4c42783          	lw	a5,-180(s0)
    80005188:	d7b5                	beqz	a5,800050f4 <sys_open+0x5a>
      iunlockput(ip);
    8000518a:	8526                	mv	a0,s1
    8000518c:	ac0fe0ef          	jal	8000344c <iunlockput>
      end_op();
    80005190:	b67fe0ef          	jal	80003cf6 <end_op>
      return -1;
    80005194:	74aa                	ld	s1,168(sp)
    80005196:	a03d                	j	800051c4 <sys_open+0x12a>
      end_op();
    80005198:	b5ffe0ef          	jal	80003cf6 <end_op>
      return -1;
    8000519c:	74aa                	ld	s1,168(sp)
    8000519e:	a01d                	j	800051c4 <sys_open+0x12a>
    iunlockput(ip);
    800051a0:	8526                	mv	a0,s1
    800051a2:	aaafe0ef          	jal	8000344c <iunlockput>
    end_op();
    800051a6:	b51fe0ef          	jal	80003cf6 <end_op>
    return -1;
    800051aa:	74aa                	ld	s1,168(sp)
    800051ac:	a821                	j	800051c4 <sys_open+0x12a>
      fileclose(f);
    800051ae:	854a                	mv	a0,s2
    800051b0:	f71fe0ef          	jal	80004120 <fileclose>
    800051b4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800051b6:	8526                	mv	a0,s1
    800051b8:	a94fe0ef          	jal	8000344c <iunlockput>
    end_op();
    800051bc:	b3bfe0ef          	jal	80003cf6 <end_op>
    return -1;
    800051c0:	74aa                	ld	s1,168(sp)
    800051c2:	790a                	ld	s2,160(sp)
    return -1;
    800051c4:	557d                	li	a0,-1
}
    800051c6:	70ea                	ld	ra,184(sp)
    800051c8:	744a                	ld	s0,176(sp)
    800051ca:	6129                	addi	sp,sp,192
    800051cc:	8082                	ret
    f->type = FD_DEVICE;
    800051ce:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800051d2:	04649783          	lh	a5,70(s1)
    800051d6:	02f91223          	sh	a5,36(s2)
    800051da:	b791                	j	8000511e <sys_open+0x84>
    itrunc(ip);
    800051dc:	8526                	mv	a0,s1
    800051de:	908fe0ef          	jal	800032e6 <itrunc>
    800051e2:	b7b5                	j	8000514e <sys_open+0xb4>

00000000800051e4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800051e4:	7175                	addi	sp,sp,-144
    800051e6:	e506                	sd	ra,136(sp)
    800051e8:	e122                	sd	s0,128(sp)
    800051ea:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800051ec:	a7ffe0ef          	jal	80003c6a <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    800051f0:	08000613          	li	a2,128
    800051f4:	f7040593          	addi	a1,s0,-144
    800051f8:	4501                	li	a0,0
    800051fa:	e4efd0ef          	jal	80002848 <argstr>
    800051fe:	02054363          	bltz	a0,80005224 <sys_mkdir+0x40>
    80005202:	4681                	li	a3,0
    80005204:	4601                	li	a2,0
    80005206:	4585                	li	a1,1
    80005208:	f7040513          	addi	a0,s0,-144
    8000520c:	94bff0ef          	jal	80004b56 <create>
    80005210:	c911                	beqz	a0,80005224 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005212:	a3afe0ef          	jal	8000344c <iunlockput>
  end_op();
    80005216:	ae1fe0ef          	jal	80003cf6 <end_op>
  return 0;
    8000521a:	4501                	li	a0,0
}
    8000521c:	60aa                	ld	ra,136(sp)
    8000521e:	640a                	ld	s0,128(sp)
    80005220:	6149                	addi	sp,sp,144
    80005222:	8082                	ret
    end_op();
    80005224:	ad3fe0ef          	jal	80003cf6 <end_op>
    return -1;
    80005228:	557d                	li	a0,-1
    8000522a:	bfcd                	j	8000521c <sys_mkdir+0x38>

000000008000522c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000522c:	7135                	addi	sp,sp,-160
    8000522e:	ed06                	sd	ra,152(sp)
    80005230:	e922                	sd	s0,144(sp)
    80005232:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005234:	a37fe0ef          	jal	80003c6a <begin_op>
  argint(1, &major);
    80005238:	f6c40593          	addi	a1,s0,-148
    8000523c:	4505                	li	a0,1
    8000523e:	dd2fd0ef          	jal	80002810 <argint>
  argint(2, &minor);
    80005242:	f6840593          	addi	a1,s0,-152
    80005246:	4509                	li	a0,2
    80005248:	dc8fd0ef          	jal	80002810 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000524c:	08000613          	li	a2,128
    80005250:	f7040593          	addi	a1,s0,-144
    80005254:	4501                	li	a0,0
    80005256:	df2fd0ef          	jal	80002848 <argstr>
    8000525a:	02054563          	bltz	a0,80005284 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    8000525e:	f6841683          	lh	a3,-152(s0)
    80005262:	f6c41603          	lh	a2,-148(s0)
    80005266:	458d                	li	a1,3
    80005268:	f7040513          	addi	a0,s0,-144
    8000526c:	8ebff0ef          	jal	80004b56 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005270:	c911                	beqz	a0,80005284 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005272:	9dafe0ef          	jal	8000344c <iunlockput>
  end_op();
    80005276:	a81fe0ef          	jal	80003cf6 <end_op>
  return 0;
    8000527a:	4501                	li	a0,0
}
    8000527c:	60ea                	ld	ra,152(sp)
    8000527e:	644a                	ld	s0,144(sp)
    80005280:	610d                	addi	sp,sp,160
    80005282:	8082                	ret
    end_op();
    80005284:	a73fe0ef          	jal	80003cf6 <end_op>
    return -1;
    80005288:	557d                	li	a0,-1
    8000528a:	bfcd                	j	8000527c <sys_mknod+0x50>

000000008000528c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000528c:	7135                	addi	sp,sp,-160
    8000528e:	ed06                	sd	ra,152(sp)
    80005290:	e922                	sd	s0,144(sp)
    80005292:	e14a                	sd	s2,128(sp)
    80005294:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005296:	e4cfc0ef          	jal	800018e2 <myproc>
    8000529a:	892a                	mv	s2,a0

  begin_op();
    8000529c:	9cffe0ef          	jal	80003c6a <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    800052a0:	08000613          	li	a2,128
    800052a4:	f6040593          	addi	a1,s0,-160
    800052a8:	4501                	li	a0,0
    800052aa:	d9efd0ef          	jal	80002848 <argstr>
    800052ae:	02054f63          	bltz	a0,800052ec <sys_chdir+0x60>
    800052b2:	e526                	sd	s1,136(sp)
    800052b4:	f6040513          	addi	a0,s0,-160
    800052b8:	fd4fe0ef          	jal	80003a8c <namei>
    800052bc:	84aa                	mv	s1,a0
    800052be:	c515                	beqz	a0,800052ea <sys_chdir+0x5e>
    end_op();
    return -1;
  }
  ilock(ip);
    800052c0:	f39fd0ef          	jal	800031f8 <ilock>
  if (ip->type != T_DIR) {
    800052c4:	04449703          	lh	a4,68(s1)
    800052c8:	4785                	li	a5,1
    800052ca:	02f71963          	bne	a4,a5,800052fc <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800052ce:	8526                	mv	a0,s1
    800052d0:	fd7fd0ef          	jal	800032a6 <iunlock>
  iput(p->cwd);
    800052d4:	15093503          	ld	a0,336(s2)
    800052d8:	8a2fe0ef          	jal	8000337a <iput>
  end_op();
    800052dc:	a1bfe0ef          	jal	80003cf6 <end_op>
  p->cwd = ip;
    800052e0:	14993823          	sd	s1,336(s2)
  return 0;
    800052e4:	4501                	li	a0,0
    800052e6:	64aa                	ld	s1,136(sp)
    800052e8:	a029                	j	800052f2 <sys_chdir+0x66>
    800052ea:	64aa                	ld	s1,136(sp)
    end_op();
    800052ec:	a0bfe0ef          	jal	80003cf6 <end_op>
    return -1;
    800052f0:	557d                	li	a0,-1
}
    800052f2:	60ea                	ld	ra,152(sp)
    800052f4:	644a                	ld	s0,144(sp)
    800052f6:	690a                	ld	s2,128(sp)
    800052f8:	610d                	addi	sp,sp,160
    800052fa:	8082                	ret
    iunlockput(ip);
    800052fc:	8526                	mv	a0,s1
    800052fe:	94efe0ef          	jal	8000344c <iunlockput>
    end_op();
    80005302:	9f5fe0ef          	jal	80003cf6 <end_op>
    return -1;
    80005306:	64aa                	ld	s1,136(sp)
    80005308:	b7e5                	j	800052f0 <sys_chdir+0x64>

000000008000530a <sys_exec>:

uint64
sys_exec(void)
{
    8000530a:	7105                	addi	sp,sp,-480
    8000530c:	ef86                	sd	ra,472(sp)
    8000530e:	eba2                	sd	s0,464(sp)
    80005310:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005312:	e2840593          	addi	a1,s0,-472
    80005316:	4505                	li	a0,1
    80005318:	d14fd0ef          	jal	8000282c <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    8000531c:	08000613          	li	a2,128
    80005320:	f3040593          	addi	a1,s0,-208
    80005324:	4501                	li	a0,0
    80005326:	d22fd0ef          	jal	80002848 <argstr>
    8000532a:	0c054e63          	bltz	a0,80005406 <sys_exec+0xfc>
    8000532e:	e7a6                	sd	s1,456(sp)
    80005330:	e3ca                	sd	s2,448(sp)
    80005332:	ff4e                	sd	s3,440(sp)
    80005334:	fb52                	sd	s4,432(sp)
    80005336:	f756                	sd	s5,424(sp)
    80005338:	f35a                	sd	s6,416(sp)
    8000533a:	ef5e                	sd	s7,408(sp)
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    8000533c:	e3040a13          	addi	s4,s0,-464
    80005340:	10000613          	li	a2,256
    80005344:	4581                	li	a1,0
    80005346:	8552                	mv	a0,s4
    80005348:	96dfb0ef          	jal	80000cb4 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    8000534c:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000534e:	89d2                	mv	s3,s4
    80005350:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005352:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005356:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    80005358:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000535c:	00391513          	slli	a0,s2,0x3
    80005360:	85d6                	mv	a1,s5
    80005362:	e2843783          	ld	a5,-472(s0)
    80005366:	953e                	add	a0,a0,a5
    80005368:	c20fd0ef          	jal	80002788 <fetchaddr>
    8000536c:	02054663          	bltz	a0,80005398 <sys_exec+0x8e>
    if (uarg == 0) {
    80005370:	e2043783          	ld	a5,-480(s0)
    80005374:	c3b9                	beqz	a5,800053ba <sys_exec+0xb0>
    argv[i] = kalloc();
    80005376:	fa8fb0ef          	jal	80000b1e <kalloc>
    8000537a:	85aa                	mv	a1,a0
    8000537c:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005380:	cd01                	beqz	a0,80005398 <sys_exec+0x8e>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005382:	865a                	mv	a2,s6
    80005384:	e2043503          	ld	a0,-480(s0)
    80005388:	c46fd0ef          	jal	800027ce <fetchstr>
    8000538c:	00054663          	bltz	a0,80005398 <sys_exec+0x8e>
    if (i >= NELEM(argv)) {
    80005390:	0905                	addi	s2,s2,1
    80005392:	09a1                	addi	s3,s3,8
    80005394:	fd7914e3          	bne	s2,s7,8000535c <sys_exec+0x52>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005398:	100a0a13          	addi	s4,s4,256
    8000539c:	6088                	ld	a0,0(s1)
    8000539e:	cd29                	beqz	a0,800053f8 <sys_exec+0xee>
    kfree(argv[i]);
    800053a0:	e96fb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053a4:	04a1                	addi	s1,s1,8
    800053a6:	ff449be3          	bne	s1,s4,8000539c <sys_exec+0x92>
    800053aa:	64be                	ld	s1,456(sp)
    800053ac:	691e                	ld	s2,448(sp)
    800053ae:	79fa                	ld	s3,440(sp)
    800053b0:	7a5a                	ld	s4,432(sp)
    800053b2:	7aba                	ld	s5,424(sp)
    800053b4:	7b1a                	ld	s6,416(sp)
    800053b6:	6bfa                	ld	s7,408(sp)
    800053b8:	a0b9                	j	80005406 <sys_exec+0xfc>
      argv[i] = 0;
    800053ba:	0009079b          	sext.w	a5,s2
    800053be:	e3040593          	addi	a1,s0,-464
    800053c2:	078e                	slli	a5,a5,0x3
    800053c4:	97ae                	add	a5,a5,a1
    800053c6:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800053ca:	f3040513          	addi	a0,s0,-208
    800053ce:	bdeff0ef          	jal	800047ac <kexec>
    800053d2:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053d4:	100a0a13          	addi	s4,s4,256
    800053d8:	6088                	ld	a0,0(s1)
    800053da:	c511                	beqz	a0,800053e6 <sys_exec+0xdc>
    kfree(argv[i]);
    800053dc:	e5afb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053e0:	04a1                	addi	s1,s1,8
    800053e2:	ff449be3          	bne	s1,s4,800053d8 <sys_exec+0xce>
  return ret;
    800053e6:	854a                	mv	a0,s2
    800053e8:	64be                	ld	s1,456(sp)
    800053ea:	691e                	ld	s2,448(sp)
    800053ec:	79fa                	ld	s3,440(sp)
    800053ee:	7a5a                	ld	s4,432(sp)
    800053f0:	7aba                	ld	s5,424(sp)
    800053f2:	7b1a                	ld	s6,416(sp)
    800053f4:	6bfa                	ld	s7,408(sp)
    800053f6:	a809                	j	80005408 <sys_exec+0xfe>
    800053f8:	64be                	ld	s1,456(sp)
    800053fa:	691e                	ld	s2,448(sp)
    800053fc:	79fa                	ld	s3,440(sp)
    800053fe:	7a5a                	ld	s4,432(sp)
    80005400:	7aba                	ld	s5,424(sp)
    80005402:	7b1a                	ld	s6,416(sp)
    80005404:	6bfa                	ld	s7,408(sp)
    return -1;
    80005406:	557d                	li	a0,-1
  return -1;
}
    80005408:	60fe                	ld	ra,472(sp)
    8000540a:	645e                	ld	s0,464(sp)
    8000540c:	613d                	addi	sp,sp,480
    8000540e:	8082                	ret

0000000080005410 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005410:	7139                	addi	sp,sp,-64
    80005412:	fc06                	sd	ra,56(sp)
    80005414:	f822                	sd	s0,48(sp)
    80005416:	f426                	sd	s1,40(sp)
    80005418:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000541a:	cc8fc0ef          	jal	800018e2 <myproc>
    8000541e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005420:	fd840593          	addi	a1,s0,-40
    80005424:	4501                	li	a0,0
    80005426:	c06fd0ef          	jal	8000282c <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000542a:	fc840593          	addi	a1,s0,-56
    8000542e:	fd040513          	addi	a0,s0,-48
    80005432:	812ff0ef          	jal	80004444 <pipealloc>
    80005436:	0a054663          	bltz	a0,800054e2 <sys_pipe+0xd2>
    return -1;
  fd0 = -1;
    8000543a:	57fd                	li	a5,-1
    8000543c:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005440:	fd043503          	ld	a0,-48(s0)
    80005444:	ed4ff0ef          	jal	80004b18 <fdalloc>
    80005448:	fca42223          	sw	a0,-60(s0)
    8000544c:	08054363          	bltz	a0,800054d2 <sys_pipe+0xc2>
    80005450:	fc843503          	ld	a0,-56(s0)
    80005454:	ec4ff0ef          	jal	80004b18 <fdalloc>
    80005458:	fca42023          	sw	a0,-64(s0)
    8000545c:	06054263          	bltz	a0,800054c0 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005460:	4711                	li	a4,4
    80005462:	fc440693          	addi	a3,s0,-60
    80005466:	fd843603          	ld	a2,-40(s0)
    8000546a:	64ac                	ld	a1,72(s1)
    8000546c:	68a8                	ld	a0,80(s1)
    8000546e:	8befc0ef          	jal	8000152c <copyout>
    80005472:	02054063          	bltz	a0,80005492 <sys_pipe+0x82>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80005476:	4711                	li	a4,4
    80005478:	fc040693          	addi	a3,s0,-64
    8000547c:	fd843603          	ld	a2,-40(s0)
    80005480:	963a                	add	a2,a2,a4
    80005482:	64ac                	ld	a1,72(s1)
    80005484:	68a8                	ld	a0,80(s1)
    80005486:	8a6fc0ef          	jal	8000152c <copyout>
    8000548a:	87aa                	mv	a5,a0
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000548c:	4501                	li	a0,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000548e:	0407db63          	bgez	a5,800054e4 <sys_pipe+0xd4>
    p->ofile[fd0] = 0;
    80005492:	fc442783          	lw	a5,-60(s0)
    80005496:	07e9                	addi	a5,a5,26
    80005498:	078e                	slli	a5,a5,0x3
    8000549a:	97a6                	add	a5,a5,s1
    8000549c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800054a0:	fc042783          	lw	a5,-64(s0)
    800054a4:	07e9                	addi	a5,a5,26
    800054a6:	078e                	slli	a5,a5,0x3
    800054a8:	94be                	add	s1,s1,a5
    800054aa:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800054ae:	fd043503          	ld	a0,-48(s0)
    800054b2:	c6ffe0ef          	jal	80004120 <fileclose>
    fileclose(wf);
    800054b6:	fc843503          	ld	a0,-56(s0)
    800054ba:	c67fe0ef          	jal	80004120 <fileclose>
    return -1;
    800054be:	a015                	j	800054e2 <sys_pipe+0xd2>
    if (fd0 >= 0)
    800054c0:	fc442783          	lw	a5,-60(s0)
    800054c4:	0007c763          	bltz	a5,800054d2 <sys_pipe+0xc2>
      p->ofile[fd0] = 0;
    800054c8:	07e9                	addi	a5,a5,26
    800054ca:	078e                	slli	a5,a5,0x3
    800054cc:	97a6                	add	a5,a5,s1
    800054ce:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800054d2:	fd043503          	ld	a0,-48(s0)
    800054d6:	c4bfe0ef          	jal	80004120 <fileclose>
    fileclose(wf);
    800054da:	fc843503          	ld	a0,-56(s0)
    800054de:	c43fe0ef          	jal	80004120 <fileclose>
    return -1;
    800054e2:	557d                	li	a0,-1
}
    800054e4:	70e2                	ld	ra,56(sp)
    800054e6:	7442                	ld	s0,48(sp)
    800054e8:	74a2                	ld	s1,40(sp)
    800054ea:	6121                	addi	sp,sp,64
    800054ec:	8082                	ret
	...

00000000800054f0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800054f0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800054f2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800054f4:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    800054f6:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800054f8:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800054fa:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800054fc:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800054fe:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005500:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005502:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005504:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005506:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005508:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000550a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000550c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000550e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005510:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005512:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005514:	982fd0ef          	jal	80002696 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005518:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000551a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000551c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000551e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005520:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005522:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005524:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005526:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005528:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000552a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000552c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000552e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005530:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005532:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005534:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005536:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005538:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000553a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000553c:	10200073          	sret
    80005540:	0001                	nop
    80005542:	00000013          	nop
    80005546:	00000013          	nop
    8000554a:	00000013          	nop

000000008000554e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000554e:	1141                	addi	sp,sp,-16
    80005550:	e406                	sd	ra,8(sp)
    80005552:	e022                	sd	s0,0(sp)
    80005554:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80005556:	0c000737          	lui	a4,0xc000
    8000555a:	4785                	li	a5,1
    8000555c:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    8000555e:	c35c                	sw	a5,4(a4)
}
    80005560:	60a2                	ld	ra,8(sp)
    80005562:	6402                	ld	s0,0(sp)
    80005564:	0141                	addi	sp,sp,16
    80005566:	8082                	ret

0000000080005568 <plicinithart>:

void
plicinithart(void)
{
    80005568:	1141                	addi	sp,sp,-16
    8000556a:	e406                	sd	ra,8(sp)
    8000556c:	e022                	sd	s0,0(sp)
    8000556e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005570:	b3efc0ef          	jal	800018ae <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005574:	0085171b          	slliw	a4,a0,0x8
    80005578:	0c0027b7          	lui	a5,0xc002
    8000557c:	97ba                	add	a5,a5,a4
    8000557e:	40200713          	li	a4,1026
    80005582:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005586:	00d5151b          	slliw	a0,a0,0xd
    8000558a:	0c2017b7          	lui	a5,0xc201
    8000558e:	97aa                	add	a5,a5,a0
    80005590:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005594:	60a2                	ld	ra,8(sp)
    80005596:	6402                	ld	s0,0(sp)
    80005598:	0141                	addi	sp,sp,16
    8000559a:	8082                	ret

000000008000559c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000559c:	1141                	addi	sp,sp,-16
    8000559e:	e406                	sd	ra,8(sp)
    800055a0:	e022                	sd	s0,0(sp)
    800055a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055a4:	b0afc0ef          	jal	800018ae <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    800055a8:	00d5151b          	slliw	a0,a0,0xd
    800055ac:	0c2017b7          	lui	a5,0xc201
    800055b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800055b2:	43c8                	lw	a0,4(a5)
    800055b4:	60a2                	ld	ra,8(sp)
    800055b6:	6402                	ld	s0,0(sp)
    800055b8:	0141                	addi	sp,sp,16
    800055ba:	8082                	ret

00000000800055bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800055bc:	1101                	addi	sp,sp,-32
    800055be:	ec06                	sd	ra,24(sp)
    800055c0:	e822                	sd	s0,16(sp)
    800055c2:	e426                	sd	s1,8(sp)
    800055c4:	1000                	addi	s0,sp,32
    800055c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055c8:	ae6fc0ef          	jal	800018ae <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    800055cc:	00d5179b          	slliw	a5,a0,0xd
    800055d0:	0c201737          	lui	a4,0xc201
    800055d4:	97ba                	add	a5,a5,a4
    800055d6:	c3c4                	sw	s1,4(a5)
}
    800055d8:	60e2                	ld	ra,24(sp)
    800055da:	6442                	ld	s0,16(sp)
    800055dc:	64a2                	ld	s1,8(sp)
    800055de:	6105                	addi	sp,sp,32
    800055e0:	8082                	ret

00000000800055e2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055e2:	1141                	addi	sp,sp,-16
    800055e4:	e406                	sd	ra,8(sp)
    800055e6:	e022                	sd	s0,0(sp)
    800055e8:	0800                	addi	s0,sp,16
  if (i >= NUM)
    800055ea:	479d                	li	a5,7
    800055ec:	04a7ca63          	blt	a5,a0,80005640 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    800055f0:	0001b797          	auipc	a5,0x1b
    800055f4:	48078793          	addi	a5,a5,1152 # 80020a70 <disk>
    800055f8:	97aa                	add	a5,a5,a0
    800055fa:	0187c783          	lbu	a5,24(a5)
    800055fe:	e7b9                	bnez	a5,8000564c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005600:	00451693          	slli	a3,a0,0x4
    80005604:	0001b797          	auipc	a5,0x1b
    80005608:	46c78793          	addi	a5,a5,1132 # 80020a70 <disk>
    8000560c:	6398                	ld	a4,0(a5)
    8000560e:	9736                	add	a4,a4,a3
    80005610:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005614:	6398                	ld	a4,0(a5)
    80005616:	9736                	add	a4,a4,a3
    80005618:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000561c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005620:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005624:	97aa                	add	a5,a5,a0
    80005626:	4705                	li	a4,1
    80005628:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000562c:	0001b517          	auipc	a0,0x1b
    80005630:	45c50513          	addi	a0,a0,1116 # 80020a88 <disk+0x18>
    80005634:	923fc0ef          	jal	80001f56 <wakeup>
}
    80005638:	60a2                	ld	ra,8(sp)
    8000563a:	6402                	ld	s0,0(sp)
    8000563c:	0141                	addi	sp,sp,16
    8000563e:	8082                	ret
    panic("free_desc 1");
    80005640:	00002517          	auipc	a0,0x2
    80005644:	ff050513          	addi	a0,a0,-16 # 80007630 <etext+0x630>
    80005648:	a00fb0ef          	jal	80000848 <panic>
    panic("free_desc 2");
    8000564c:	00002517          	auipc	a0,0x2
    80005650:	ff450513          	addi	a0,a0,-12 # 80007640 <etext+0x640>
    80005654:	9f4fb0ef          	jal	80000848 <panic>

0000000080005658 <virtio_disk_init>:
{
    80005658:	1101                	addi	sp,sp,-32
    8000565a:	ec06                	sd	ra,24(sp)
    8000565c:	e822                	sd	s0,16(sp)
    8000565e:	e426                	sd	s1,8(sp)
    80005660:	e04a                	sd	s2,0(sp)
    80005662:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005664:	00002597          	auipc	a1,0x2
    80005668:	fec58593          	addi	a1,a1,-20 # 80007650 <etext+0x650>
    8000566c:	0001b517          	auipc	a0,0x1b
    80005670:	52c50513          	addi	a0,a0,1324 # 80020b98 <disk+0x128>
    80005674:	d04fb0ef          	jal	80000b78 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005678:	100017b7          	lui	a5,0x10001
    8000567c:	4398                	lw	a4,0(a5)
    8000567e:	747277b7          	lui	a5,0x74727
    80005682:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005686:	14f71263          	bne	a4,a5,800057ca <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000568a:	100017b7          	lui	a5,0x10001
    8000568e:	43d8                	lw	a4,4(a5)
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005690:	4789                	li	a5,2
    80005692:	12f71c63          	bne	a4,a5,800057ca <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005696:	100017b7          	lui	a5,0x10001
    8000569a:	4798                	lw	a4,8(a5)
    8000569c:	4789                	li	a5,2
    8000569e:	12f71663          	bne	a4,a5,800057ca <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800056a2:	100017b7          	lui	a5,0x10001
    800056a6:	47d8                	lw	a4,12(a5)
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056a8:	554d47b7          	lui	a5,0x554d4
    800056ac:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056b0:	10f71d63          	bne	a4,a5,800057ca <virtio_disk_init+0x172>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056b4:	100017b7          	lui	a5,0x10001
    800056b8:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056bc:	4705                	li	a4,1
    800056be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056c0:	470d                	li	a4,3
    800056c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056c4:	10001737          	lui	a4,0x10001
    800056c8:	4b18                	lw	a4,16(a4)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056ca:	c7ffe6b7          	lui	a3,0xc7ffe
    800056ce:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fdd9af>
    800056d2:	8f75                	and	a4,a4,a3
    800056d4:	100016b7          	lui	a3,0x10001
    800056d8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056da:	472d                	li	a4,11
    800056dc:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800056de:	0707a903          	lw	s2,112(a5)
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800056e2:	00897793          	andi	a5,s2,8
    800056e6:	0e078863          	beqz	a5,800057d6 <virtio_disk_init+0x17e>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800056ea:	100017b7          	lui	a5,0x10001
    800056ee:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800056f2:	43fc                	lw	a5,68(a5)
    800056f4:	0e079763          	bnez	a5,800057e2 <virtio_disk_init+0x18a>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800056f8:	100017b7          	lui	a5,0x10001
    800056fc:	5bdc                	lw	a5,52(a5)
  if (max == 0)
    800056fe:	0e078863          	beqz	a5,800057ee <virtio_disk_init+0x196>
  if (max < NUM)
    80005702:	471d                	li	a4,7
    80005704:	0ef77b63          	bgeu	a4,a5,800057fa <virtio_disk_init+0x1a2>
  disk.desc = kalloc();
    80005708:	c16fb0ef          	jal	80000b1e <kalloc>
    8000570c:	0001b497          	auipc	s1,0x1b
    80005710:	36448493          	addi	s1,s1,868 # 80020a70 <disk>
    80005714:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005716:	c08fb0ef          	jal	80000b1e <kalloc>
    8000571a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000571c:	c02fb0ef          	jal	80000b1e <kalloc>
    80005720:	87aa                	mv	a5,a0
    80005722:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80005724:	6088                	ld	a0,0(s1)
    80005726:	0e050063          	beqz	a0,80005806 <virtio_disk_init+0x1ae>
    8000572a:	0001b717          	auipc	a4,0x1b
    8000572e:	34e73703          	ld	a4,846(a4) # 80020a78 <disk+0x8>
    80005732:	00173713          	seqz	a4,a4
    80005736:	0017b793          	seqz	a5,a5
    8000573a:	8fd9                	or	a5,a5,a4
    8000573c:	e7e9                	bnez	a5,80005806 <virtio_disk_init+0x1ae>
  memset(disk.desc, 0, PGSIZE);
    8000573e:	6605                	lui	a2,0x1
    80005740:	4581                	li	a1,0
    80005742:	d72fb0ef          	jal	80000cb4 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005746:	0001b497          	auipc	s1,0x1b
    8000574a:	32a48493          	addi	s1,s1,810 # 80020a70 <disk>
    8000574e:	6605                	lui	a2,0x1
    80005750:	4581                	li	a1,0
    80005752:	6488                	ld	a0,8(s1)
    80005754:	d60fb0ef          	jal	80000cb4 <memset>
  memset(disk.used, 0, PGSIZE);
    80005758:	6605                	lui	a2,0x1
    8000575a:	4581                	li	a1,0
    8000575c:	6888                	ld	a0,16(s1)
    8000575e:	d56fb0ef          	jal	80000cb4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005762:	100017b7          	lui	a5,0x10001
    80005766:	4721                	li	a4,8
    80005768:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000576a:	4098                	lw	a4,0(s1)
    8000576c:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005770:	40d8                	lw	a4,4(s1)
    80005772:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005776:	649c                	ld	a5,8(s1)
    80005778:	10001737          	lui	a4,0x10001
    8000577c:	08f72823          	sw	a5,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005780:	9781                	srai	a5,a5,0x20
    80005782:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005786:	689c                	ld	a5,16(s1)
    80005788:	0af72023          	sw	a5,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000578c:	9781                	srai	a5,a5,0x20
    8000578e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005792:	4785                	li	a5,1
    80005794:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005796:	00f48c23          	sb	a5,24(s1)
    8000579a:	00f48ca3          	sb	a5,25(s1)
    8000579e:	00f48d23          	sb	a5,26(s1)
    800057a2:	00f48da3          	sb	a5,27(s1)
    800057a6:	00f48e23          	sb	a5,28(s1)
    800057aa:	00f48ea3          	sb	a5,29(s1)
    800057ae:	00f48f23          	sb	a5,30(s1)
    800057b2:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800057b6:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800057ba:	07272823          	sw	s2,112(a4)
}
    800057be:	60e2                	ld	ra,24(sp)
    800057c0:	6442                	ld	s0,16(sp)
    800057c2:	64a2                	ld	s1,8(sp)
    800057c4:	6902                	ld	s2,0(sp)
    800057c6:	6105                	addi	sp,sp,32
    800057c8:	8082                	ret
    panic("could not find virtio disk");
    800057ca:	00002517          	auipc	a0,0x2
    800057ce:	e9650513          	addi	a0,a0,-362 # 80007660 <etext+0x660>
    800057d2:	876fb0ef          	jal	80000848 <panic>
    panic("virtio disk FEATURES_OK unset");
    800057d6:	00002517          	auipc	a0,0x2
    800057da:	eaa50513          	addi	a0,a0,-342 # 80007680 <etext+0x680>
    800057de:	86afb0ef          	jal	80000848 <panic>
    panic("virtio disk should not be ready");
    800057e2:	00002517          	auipc	a0,0x2
    800057e6:	ebe50513          	addi	a0,a0,-322 # 800076a0 <etext+0x6a0>
    800057ea:	85efb0ef          	jal	80000848 <panic>
    panic("virtio disk has no queue 0");
    800057ee:	00002517          	auipc	a0,0x2
    800057f2:	ed250513          	addi	a0,a0,-302 # 800076c0 <etext+0x6c0>
    800057f6:	852fb0ef          	jal	80000848 <panic>
    panic("virtio disk max queue too short");
    800057fa:	00002517          	auipc	a0,0x2
    800057fe:	ee650513          	addi	a0,a0,-282 # 800076e0 <etext+0x6e0>
    80005802:	846fb0ef          	jal	80000848 <panic>
    panic("virtio disk kalloc");
    80005806:	00002517          	auipc	a0,0x2
    8000580a:	efa50513          	addi	a0,a0,-262 # 80007700 <etext+0x700>
    8000580e:	83afb0ef          	jal	80000848 <panic>

0000000080005812 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005812:	711d                	addi	sp,sp,-96
    80005814:	ec86                	sd	ra,88(sp)
    80005816:	e8a2                	sd	s0,80(sp)
    80005818:	e4a6                	sd	s1,72(sp)
    8000581a:	e0ca                	sd	s2,64(sp)
    8000581c:	fc4e                	sd	s3,56(sp)
    8000581e:	f852                	sd	s4,48(sp)
    80005820:	f456                	sd	s5,40(sp)
    80005822:	f05a                	sd	s6,32(sp)
    80005824:	ec5e                	sd	s7,24(sp)
    80005826:	e862                	sd	s8,16(sp)
    80005828:	1080                	addi	s0,sp,96
    8000582a:	89aa                	mv	s3,a0
    8000582c:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000582e:	00c52b83          	lw	s7,12(a0)
    80005832:	001b9b9b          	slliw	s7,s7,0x1
    80005836:	1b82                	slli	s7,s7,0x20
    80005838:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000583c:	0001b517          	auipc	a0,0x1b
    80005840:	35c50513          	addi	a0,a0,860 # 80020b98 <disk+0x128>
    80005844:	bb4fb0ef          	jal	80000bf8 <acquire>
  for (int i = 0; i < NUM; i++) {
    80005848:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000584a:	0001ba97          	auipc	s5,0x1b
    8000584e:	226a8a93          	addi	s5,s5,550 # 80020a70 <disk>
  for (int i = 0; i < 3; i++) {
    80005852:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005854:	5c7d                	li	s8,-1
    80005856:	a8a5                	j	800058ce <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005858:	00fa8733          	add	a4,s5,a5
    8000585c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005860:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005862:	0207c563          	bltz	a5,8000588c <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005866:	2905                	addiw	s2,s2,1
    80005868:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000586a:	07490663          	beq	s2,s4,800058d6 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    8000586e:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005870:	0001b717          	auipc	a4,0x1b
    80005874:	20070713          	addi	a4,a4,512 # 80020a70 <disk>
    80005878:	4781                	li	a5,0
    if (disk.free[i]) {
    8000587a:	01874683          	lbu	a3,24(a4)
    8000587e:	fee9                	bnez	a3,80005858 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80005880:	2785                	addiw	a5,a5,1
    80005882:	0705                	addi	a4,a4,1
    80005884:	fe979be3          	bne	a5,s1,8000587a <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005888:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    8000588c:	01205d63          	blez	s2,800058a6 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005890:	fa042503          	lw	a0,-96(s0)
    80005894:	d4fff0ef          	jal	800055e2 <free_desc>
      for (int j = 0; j < i; j++)
    80005898:	4785                	li	a5,1
    8000589a:	0127d663          	bge	a5,s2,800058a6 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000589e:	fa442503          	lw	a0,-92(s0)
    800058a2:	d41ff0ef          	jal	800055e2 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    800058a6:	0001b517          	auipc	a0,0x1b
    800058aa:	1e250513          	addi	a0,a0,482 # 80020a88 <disk+0x18>
    800058ae:	e3cfc0ef          	jal	80001eea <sleep_prepare>
    release(&disk.vdisk_lock);
    800058b2:	0001b517          	auipc	a0,0x1b
    800058b6:	2e650513          	addi	a0,a0,742 # 80020b98 <disk+0x128>
    800058ba:	bc2fb0ef          	jal	80000c7c <release>
    sleep();
    800058be:	e68fc0ef          	jal	80001f26 <sleep>
    acquire(&disk.vdisk_lock);
    800058c2:	0001b517          	auipc	a0,0x1b
    800058c6:	2d650513          	addi	a0,a0,726 # 80020b98 <disk+0x128>
    800058ca:	b2efb0ef          	jal	80000bf8 <acquire>
  for (int i = 0; i < 3; i++) {
    800058ce:	fa040613          	addi	a2,s0,-96
    800058d2:	4901                	li	s2,0
    800058d4:	bf69                	j	8000586e <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058d6:	fa042503          	lw	a0,-96(s0)
    800058da:	00451693          	slli	a3,a0,0x4

  if (write)
    800058de:	0001b797          	auipc	a5,0x1b
    800058e2:	19278793          	addi	a5,a5,402 # 80020a70 <disk>
    800058e6:	00451713          	slli	a4,a0,0x4
    800058ea:	0a070713          	addi	a4,a4,160
    800058ee:	973e                	add	a4,a4,a5
    800058f0:	01603633          	snez	a2,s6
    800058f4:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058f6:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800058fa:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    800058fe:	6398                	ld	a4,0(a5)
    80005900:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005902:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005906:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005908:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000590a:	6390                	ld	a2,0(a5)
    8000590c:	00d605b3          	add	a1,a2,a3
    80005910:	4741                	li	a4,16
    80005912:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005914:	4805                	li	a6,1
    80005916:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000591a:	fa442703          	lw	a4,-92(s0)
    8000591e:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005922:	0712                	slli	a4,a4,0x4
    80005924:	963a                	add	a2,a2,a4
    80005926:	05898593          	addi	a1,s3,88
    8000592a:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000592c:	0007b883          	ld	a7,0(a5)
    80005930:	9746                	add	a4,a4,a7
    80005932:	40000613          	li	a2,1024
    80005936:	c710                	sw	a2,8(a4)
  if (write)
    80005938:	001b3613          	seqz	a2,s6
    8000593c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005940:	01066633          	or	a2,a2,a6
    80005944:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005948:	fa842583          	lw	a1,-88(s0)
    8000594c:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005950:	00250613          	addi	a2,a0,2
    80005954:	0612                	slli	a2,a2,0x4
    80005956:	963e                	add	a2,a2,a5
    80005958:	577d                	li	a4,-1
    8000595a:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000595e:	0592                	slli	a1,a1,0x4
    80005960:	98ae                	add	a7,a7,a1
    80005962:	03068713          	addi	a4,a3,48
    80005966:	973e                	add	a4,a4,a5
    80005968:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000596c:	6398                	ld	a4,0(a5)
    8000596e:	972e                	add	a4,a4,a1
    80005970:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005974:	4689                	li	a3,2
    80005976:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000597a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000597e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80005982:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005986:	6794                	ld	a3,8(a5)
    80005988:	0026d703          	lhu	a4,2(a3)
    8000598c:	8b1d                	andi	a4,a4,7
    8000598e:	0706                	slli	a4,a4,0x1
    80005990:	96ba                	add	a3,a3,a4
    80005992:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005996:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000599a:	6798                	ld	a4,8(a5)
    8000599c:	00275783          	lhu	a5,2(a4)
    800059a0:	2785                	addiw	a5,a5,1
    800059a2:	00f71123          	sh	a5,2(a4)
    800059a6:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800059aa:	100017b7          	lui	a5,0x10001
    800059ae:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800059b2:	0049a783          	lw	a5,4(s3)
    800059b6:	03079663          	bne	a5,a6,800059e2 <virtio_disk_rw+0x1d0>
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    800059ba:	0001b497          	auipc	s1,0x1b
    800059be:	1de48493          	addi	s1,s1,478 # 80020b98 <disk+0x128>
  while (b->disk == 1) {
    800059c2:	893e                	mv	s2,a5
    sleep_prepare(b);
    800059c4:	854e                	mv	a0,s3
    800059c6:	d24fc0ef          	jal	80001eea <sleep_prepare>
    release(&disk.vdisk_lock);
    800059ca:	8526                	mv	a0,s1
    800059cc:	ab0fb0ef          	jal	80000c7c <release>
    sleep();
    800059d0:	d56fc0ef          	jal	80001f26 <sleep>
    acquire(&disk.vdisk_lock);
    800059d4:	8526                	mv	a0,s1
    800059d6:	a22fb0ef          	jal	80000bf8 <acquire>
  while (b->disk == 1) {
    800059da:	0049a783          	lw	a5,4(s3)
    800059de:	ff2783e3          	beq	a5,s2,800059c4 <virtio_disk_rw+0x1b2>
  }

  disk.info[idx[0]].b = 0;
    800059e2:	fa042903          	lw	s2,-96(s0)
    800059e6:	00290713          	addi	a4,s2,2
    800059ea:	0712                	slli	a4,a4,0x4
    800059ec:	0001b797          	auipc	a5,0x1b
    800059f0:	08478793          	addi	a5,a5,132 # 80020a70 <disk>
    800059f4:	97ba                	add	a5,a5,a4
    800059f6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059fa:	0001b997          	auipc	s3,0x1b
    800059fe:	07698993          	addi	s3,s3,118 # 80020a70 <disk>
    80005a02:	00491713          	slli	a4,s2,0x4
    80005a06:	0009b783          	ld	a5,0(s3)
    80005a0a:	97ba                	add	a5,a5,a4
    80005a0c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a10:	854a                	mv	a0,s2
    80005a12:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a16:	bcdff0ef          	jal	800055e2 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005a1a:	8885                	andi	s1,s1,1
    80005a1c:	f0fd                	bnez	s1,80005a02 <virtio_disk_rw+0x1f0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a1e:	0001b517          	auipc	a0,0x1b
    80005a22:	17a50513          	addi	a0,a0,378 # 80020b98 <disk+0x128>
    80005a26:	a56fb0ef          	jal	80000c7c <release>
}
    80005a2a:	60e6                	ld	ra,88(sp)
    80005a2c:	6446                	ld	s0,80(sp)
    80005a2e:	64a6                	ld	s1,72(sp)
    80005a30:	6906                	ld	s2,64(sp)
    80005a32:	79e2                	ld	s3,56(sp)
    80005a34:	7a42                	ld	s4,48(sp)
    80005a36:	7aa2                	ld	s5,40(sp)
    80005a38:	7b02                	ld	s6,32(sp)
    80005a3a:	6be2                	ld	s7,24(sp)
    80005a3c:	6c42                	ld	s8,16(sp)
    80005a3e:	6125                	addi	sp,sp,96
    80005a40:	8082                	ret

0000000080005a42 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a42:	1101                	addi	sp,sp,-32
    80005a44:	ec06                	sd	ra,24(sp)
    80005a46:	e822                	sd	s0,16(sp)
    80005a48:	e426                	sd	s1,8(sp)
    80005a4a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a4c:	0001b497          	auipc	s1,0x1b
    80005a50:	02448493          	addi	s1,s1,36 # 80020a70 <disk>
    80005a54:	0001b517          	auipc	a0,0x1b
    80005a58:	14450513          	addi	a0,a0,324 # 80020b98 <disk+0x128>
    80005a5c:	99cfb0ef          	jal	80000bf8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a60:	100017b7          	lui	a5,0x10001
    80005a64:	53bc                	lw	a5,96(a5)
    80005a66:	8b8d                	andi	a5,a5,3
    80005a68:	10001737          	lui	a4,0x10001
    80005a6c:	d37c                	sw	a5,100(a4)
    80005a6e:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005a72:	689c                	ld	a5,16(s1)
    80005a74:	0204d703          	lhu	a4,32(s1)
    80005a78:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a7c:	04f70663          	beq	a4,a5,80005ac8 <virtio_disk_intr+0x86>
    80005a80:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a84:	6898                	ld	a4,16(s1)
    80005a86:	0204d783          	lhu	a5,32(s1)
    80005a8a:	8b9d                	andi	a5,a5,7
    80005a8c:	078e                	slli	a5,a5,0x3
    80005a8e:	97ba                	add	a5,a5,a4
    80005a90:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005a92:	00278713          	addi	a4,a5,2
    80005a96:	0712                	slli	a4,a4,0x4
    80005a98:	9726                	add	a4,a4,s1
    80005a9a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a9e:	e321                	bnez	a4,80005ade <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005aa0:	0789                	addi	a5,a5,2
    80005aa2:	0792                	slli	a5,a5,0x4
    80005aa4:	97a6                	add	a5,a5,s1
    80005aa6:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005aa8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005aac:	caafc0ef          	jal	80001f56 <wakeup>

    disk.used_idx += 1;
    80005ab0:	0204d783          	lhu	a5,32(s1)
    80005ab4:	2785                	addiw	a5,a5,1
    80005ab6:	17c2                	slli	a5,a5,0x30
    80005ab8:	93c1                	srli	a5,a5,0x30
    80005aba:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005abe:	6898                	ld	a4,16(s1)
    80005ac0:	00275703          	lhu	a4,2(a4)
    80005ac4:	faf71ee3          	bne	a4,a5,80005a80 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005ac8:	0001b517          	auipc	a0,0x1b
    80005acc:	0d050513          	addi	a0,a0,208 # 80020b98 <disk+0x128>
    80005ad0:	9acfb0ef          	jal	80000c7c <release>
}
    80005ad4:	60e2                	ld	ra,24(sp)
    80005ad6:	6442                	ld	s0,16(sp)
    80005ad8:	64a2                	ld	s1,8(sp)
    80005ada:	6105                	addi	sp,sp,32
    80005adc:	8082                	ret
      panic("virtio_disk_intr status");
    80005ade:	00002517          	auipc	a0,0x2
    80005ae2:	c3a50513          	addi	a0,a0,-966 # 80007718 <etext+0x718>
    80005ae6:	d63fa0ef          	jal	80000848 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	0000100f          	fence.i
    800060a0:	12000073          	sfence.vma
    800060a4:	18051073          	csrw	satp,a0
    800060a8:	12000073          	sfence.vma
    800060ac:	02000537          	lui	a0,0x2000
    800060b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060b2:	0536                	slli	a0,a0,0xd
    800060b4:	02853083          	ld	ra,40(a0)
    800060b8:	03053103          	ld	sp,48(a0)
    800060bc:	03853183          	ld	gp,56(a0)
    800060c0:	04053203          	ld	tp,64(a0)
    800060c4:	04853283          	ld	t0,72(a0)
    800060c8:	05053303          	ld	t1,80(a0)
    800060cc:	05853383          	ld	t2,88(a0)
    800060d0:	7120                	ld	s0,96(a0)
    800060d2:	7524                	ld	s1,104(a0)
    800060d4:	7d2c                	ld	a1,120(a0)
    800060d6:	6150                	ld	a2,128(a0)
    800060d8:	6554                	ld	a3,136(a0)
    800060da:	6958                	ld	a4,144(a0)
    800060dc:	6d5c                	ld	a5,152(a0)
    800060de:	0a053803          	ld	a6,160(a0)
    800060e2:	0a853883          	ld	a7,168(a0)
    800060e6:	0b053903          	ld	s2,176(a0)
    800060ea:	0b853983          	ld	s3,184(a0)
    800060ee:	0c053a03          	ld	s4,192(a0)
    800060f2:	0c853a83          	ld	s5,200(a0)
    800060f6:	0d053b03          	ld	s6,208(a0)
    800060fa:	0d853b83          	ld	s7,216(a0)
    800060fe:	0e053c03          	ld	s8,224(a0)
    80006102:	0e853c83          	ld	s9,232(a0)
    80006106:	0f053d03          	ld	s10,240(a0)
    8000610a:	0f853d83          	ld	s11,248(a0)
    8000610e:	10053e03          	ld	t3,256(a0)
    80006112:	10853e83          	ld	t4,264(a0)
    80006116:	11053f03          	ld	t5,272(a0)
    8000611a:	11853f83          	ld	t6,280(a0)
    8000611e:	7928                	ld	a0,112(a0)
    80006120:	10200073          	sret
	...
