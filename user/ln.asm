
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if (argc != 3) {
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	90058593          	addi	a1,a1,-1792 # 910 <malloc+0xf2>
  18:	4509                	li	a0,2
  1a:	71e000ef          	jal	738 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if (link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8ea58593          	addi	a1,a1,-1814 # 928 <malloc+0x10a>
  46:	4509                	li	a0,2
  48:	6f0000ef          	jal	738 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2aa000ef          	jal	304 <exit>

000000000000005e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for (n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void *
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char *
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for (; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	c799                	beqz	a5,11a <strchr+0x1a>
    if (*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for (; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char *)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <gets>:

char *
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	e862                	sd	s8,16(sp)
 13a:	1080                	addi	s0,sp,96
 13c:	8baa                	mv	s7,a0
 13e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 140:	892a                	mv	s2,a0
 142:	4481                	li	s1,0
    cc = read(0, &c, 1);
 144:	faf40b13          	addi	s6,s0,-81
 148:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 14a:	8c26                	mv	s8,s1
 14c:	0014899b          	addiw	s3,s1,1
 150:	84ce                	mv	s1,s3
 152:	0349d863          	bge	s3,s4,182 <gets+0x5e>
    cc = read(0, &c, 1);
 156:	8656                	mv	a2,s5
 158:	85da                	mv	a1,s6
 15a:	4501                	li	a0,0
 15c:	1c0000ef          	jal	31c <read>
    if (cc < 1)
 160:	02a05163          	blez	a0,182 <gets+0x5e>
      break;
    buf[i++] = c;
 164:	faf44783          	lbu	a5,-81(s0)
 168:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 16c:	0905                	addi	s2,s2,1
 16e:	ff678713          	addi	a4,a5,-10
 172:	00173713          	seqz	a4,a4
 176:	17cd                	addi	a5,a5,-13
 178:	0017b793          	seqz	a5,a5
 17c:	8fd9                	or	a5,a5,a4
 17e:	d7f1                	beqz	a5,14a <gets+0x26>
    buf[i++] = c;
 180:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 182:	9c5e                	add	s8,s8,s7
 184:	000c0023          	sb	zero,0(s8)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6c42                	ld	s8,16(sp)
 19e:	6125                	addi	sp,sp,96
 1a0:	8082                	ret

00000000000001a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	194000ef          	jal	344 <open>
  if (fd < 0)
 1b4:	02054263          	bltz	a0,1d8 <stat+0x36>
 1b8:	e426                	sd	s1,8(sp)
 1ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1bc:	85ca                	mv	a1,s2
 1be:	19e000ef          	jal	35c <fstat>
 1c2:	892a                	mv	s2,a0
  close(fd);
 1c4:	8526                	mv	a0,s1
 1c6:	166000ef          	jal	32c <close>
  return r;
 1ca:	64a2                	ld	s1,8(sp)
}
 1cc:	854a                	mv	a0,s2
 1ce:	60e2                	ld	ra,24(sp)
 1d0:	6442                	ld	s0,16(sp)
 1d2:	6902                	ld	s2,0(sp)
 1d4:	6105                	addi	sp,sp,32
 1d6:	8082                	ret
    return -1;
 1d8:	57fd                	li	a5,-1
 1da:	893e                	mv	s2,a5
 1dc:	bfc5                	j	1cc <stat+0x2a>

00000000000001de <atoi>:

int
atoi(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e406                	sd	ra,8(sp)
 1e2:	e022                	sd	s0,0(sp)
 1e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1e6:	00054683          	lbu	a3,0(a0)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	4625                	li	a2,9
 1f4:	02f66963          	bltu	a2,a5,226 <atoi+0x48>
 1f8:	872a                	mv	a4,a0
  n = 0;
 1fa:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1fc:	0705                	addi	a4,a4,1
 1fe:	0025179b          	slliw	a5,a0,0x2
 202:	9fa9                	addw	a5,a5,a0
 204:	0017979b          	slliw	a5,a5,0x1
 208:	9fb5                	addw	a5,a5,a3
 20a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 20e:	00074683          	lbu	a3,0(a4)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	zext.b	a5,a5
 21a:	fef671e3          	bgeu	a2,a5,1fc <atoi+0x1e>
  return n;
}
 21e:	60a2                	ld	ra,8(sp)
 220:	6402                	ld	s0,0(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  n = 0;
 226:	4501                	li	a0,0
 228:	bfdd                	j	21e <atoi+0x40>

000000000000022a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 232:	02b57563          	bgeu	a0,a1,25c <memmove+0x32>
    while (n-- > 0)
 236:	00c05f63          	blez	a2,254 <memmove+0x2a>
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 242:	872a                	mv	a4,a0
      *dst++ = *src++;
 244:	0585                	addi	a1,a1,1
 246:	0705                	addi	a4,a4,1
 248:	fff5c683          	lbu	a3,-1(a1)
 24c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    while (n-- > 0)
 25c:	fec05ce3          	blez	a2,254 <memmove+0x2a>
    dst += n;
 260:	00c50733          	add	a4,a0,a2
    src += n;
 264:	95b2                	add	a1,a1,a2
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 280:	fef71ae3          	bne	a4,a5,274 <memmove+0x4a>
 284:	bfc1                	j	254 <memmove+0x2a>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ce19                	beqz	a2,2ac <memcmp+0x26>
 290:	1602                	slli	a2,a2,0x20
 292:	9201                	srli	a2,a2,0x20
 294:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 298:	00054783          	lbu	a5,0(a0)
 29c:	0005c703          	lbu	a4,0(a1)
 2a0:	00e79b63          	bne	a5,a4,2b6 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2a4:	0505                	addi	a0,a0,1
    p2++;
 2a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a8:	fed518e3          	bne	a0,a3,298 <memcmp+0x12>
  }
  return 0;
 2ac:	4501                	li	a0,0
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
      return *p1 - *p2;
 2b6:	40e7853b          	subw	a0,a5,a4
 2ba:	bfd5                	j	2ae <memcmp+0x28>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f67ff0ef          	jal	22a <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0b2000ef          	jal	38c <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	09c000ef          	jal	38c <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	f67ff0ef          	jal	324 <write>
}
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret

00000000000003ca <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ca:	715d                	addi	sp,sp,-80
 3cc:	e486                	sd	ra,72(sp)
 3ce:	e0a2                	sd	s0,64(sp)
 3d0:	f84a                	sd	s2,48(sp)
 3d2:	f44e                	sd	s3,40(sp)
 3d4:	0880                	addi	s0,sp,80
 3d6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3d8:	00d036b3          	snez	a3,a3
 3dc:	03f5d793          	srli	a5,a1,0x3f
 3e0:	8efd                	and	a3,a3,a5
  neg = 0;
 3e2:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3e4:	c681                	beqz	a3,3ec <printint+0x22>
    neg = 1;
    x = -xx;
 3e6:	40b005b3          	neg	a1,a1
    neg = 1;
 3ea:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ec:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3f0:	86ce                	mv	a3,s3
  i = 0;
 3f2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3f4:	00000817          	auipc	a6,0x0
 3f8:	55480813          	addi	a6,a6,1364 # 948 <digits>
 3fc:	88ba                	mv	a7,a4
 3fe:	0017051b          	addiw	a0,a4,1
 402:	872a                	mv	a4,a0
 404:	02c5f7b3          	remu	a5,a1,a2
 408:	97c2                	add	a5,a5,a6
 40a:	0007c783          	lbu	a5,0(a5)
 40e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 412:	87ae                	mv	a5,a1
 414:	02c5d5b3          	divu	a1,a1,a2
 418:	0685                	addi	a3,a3,1
 41a:	fec7f1e3          	bgeu	a5,a2,3fc <printint+0x32>
  if (neg)
 41e:	00030b63          	beqz	t1,434 <printint+0x6a>
    buf[i++] = '-';
 422:	fd040793          	addi	a5,s0,-48
 426:	953e                	add	a0,a0,a5
 428:	02d00793          	li	a5,45
 42c:	fef50423          	sb	a5,-24(a0)
 430:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 434:	02e05563          	blez	a4,45e <printint+0x94>
 438:	fc26                	sd	s1,56(sp)
 43a:	377d                	addiw	a4,a4,-1
 43c:	00e984b3          	add	s1,s3,a4
 440:	19fd                	addi	s3,s3,-1
 442:	99ba                	add	s3,s3,a4
 444:	1702                	slli	a4,a4,0x20
 446:	9301                	srli	a4,a4,0x20
 448:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44c:	0004c583          	lbu	a1,0(s1)
 450:	854a                	mv	a0,s2
 452:	f5bff0ef          	jal	3ac <putc>
  while (--i >= 0)
 456:	14fd                	addi	s1,s1,-1
 458:	ff349ae3          	bne	s1,s3,44c <printint+0x82>
 45c:	74e2                	ld	s1,56(sp)
}
 45e:	60a6                	ld	ra,72(sp)
 460:	6406                	ld	s0,64(sp)
 462:	7942                	ld	s2,48(sp)
 464:	79a2                	ld	s3,40(sp)
 466:	6161                	addi	sp,sp,80
 468:	8082                	ret

000000000000046a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46a:	711d                	addi	sp,sp,-96
 46c:	ec86                	sd	ra,88(sp)
 46e:	e8a2                	sd	s0,80(sp)
 470:	e4a6                	sd	s1,72(sp)
 472:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 474:	0005c483          	lbu	s1,0(a1)
 478:	2a048063          	beqz	s1,718 <vprintf+0x2ae>
 47c:	e0ca                	sd	s2,64(sp)
 47e:	fc4e                	sd	s3,56(sp)
 480:	f852                	sd	s4,48(sp)
 482:	f456                	sd	s5,40(sp)
 484:	f05a                	sd	s6,32(sp)
 486:	ec5e                	sd	s7,24(sp)
 488:	e862                	sd	s8,16(sp)
 48a:	8b2a                	mv	s6,a0
 48c:	8a2e                	mv	s4,a1
 48e:	8bb2                	mv	s7,a2
  state = 0;
 490:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 492:	4901                	li	s2,0
 494:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 496:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 49a:	06400c13          	li	s8,100
 49e:	a00d                	j	4c0 <vprintf+0x56>
        putc(fd, c0);
 4a0:	85a6                	mv	a1,s1
 4a2:	855a                	mv	a0,s6
 4a4:	f09ff0ef          	jal	3ac <putc>
 4a8:	a019                	j	4ae <vprintf+0x44>
    } else if (state == '%') {
 4aa:	03598363          	beq	s3,s5,4d0 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4ae:	0019079b          	addiw	a5,s2,1
 4b2:	893e                	mv	s2,a5
 4b4:	873e                	mv	a4,a5
 4b6:	97d2                	add	a5,a5,s4
 4b8:	0007c483          	lbu	s1,0(a5)
 4bc:	24048763          	beqz	s1,70a <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4c0:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4c4:	fe0993e3          	bnez	s3,4aa <vprintf+0x40>
      if (c0 == '%') {
 4c8:	fd579ce3          	bne	a5,s5,4a0 <vprintf+0x36>
        state = '%';
 4cc:	89be                	mv	s3,a5
 4ce:	b7c5                	j	4ae <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4d0:	00ea06b3          	add	a3,s4,a4
 4d4:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4d8:	24060563          	beqz	a2,722 <vprintf+0x2b8>
      if (c0 == 'd') {
 4dc:	0b878763          	beq	a5,s8,58a <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4e0:	f9478693          	addi	a3,a5,-108
 4e4:	0016b693          	seqz	a3,a3
 4e8:	f9c60593          	addi	a1,a2,-100
 4ec:	0015b593          	seqz	a1,a1
 4f0:	8df5                	and	a1,a1,a3
 4f2:	e9c5                	bnez	a1,5a2 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4f4:	9752                	add	a4,a4,s4
 4f6:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4fa:	f9460713          	addi	a4,a2,-108
 4fe:	00173713          	seqz	a4,a4
 502:	8f75                	and	a4,a4,a3
 504:	f9c50593          	addi	a1,a0,-100
 508:	0015b593          	seqz	a1,a1
 50c:	8df9                	and	a1,a1,a4
 50e:	e5dd                	bnez	a1,5bc <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 510:	07500593          	li	a1,117
 514:	0cb78163          	beq	a5,a1,5d6 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 518:	f8b60593          	addi	a1,a2,-117
 51c:	0015b593          	seqz	a1,a1
 520:	8df5                	and	a1,a1,a3
 522:	e5f1                	bnez	a1,5ee <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 524:	f8b50593          	addi	a1,a0,-117
 528:	0015b593          	seqz	a1,a1
 52c:	8df9                	and	a1,a1,a4
 52e:	ede9                	bnez	a1,608 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 530:	07800593          	li	a1,120
 534:	0eb78763          	beq	a5,a1,622 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 538:	f8860613          	addi	a2,a2,-120
 53c:	00163613          	seqz	a2,a2
 540:	8ef1                	and	a3,a3,a2
 542:	0e069c63          	bnez	a3,63a <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 546:	f8850513          	addi	a0,a0,-120
 54a:	00153513          	seqz	a0,a0
 54e:	8f69                	and	a4,a4,a0
 550:	10071263          	bnez	a4,654 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 554:	07000713          	li	a4,112
 558:	10e78a63          	beq	a5,a4,66c <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 55c:	06300713          	li	a4,99
 560:	14e78a63          	beq	a5,a4,6b4 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 564:	07300713          	li	a4,115
 568:	16e78063          	beq	a5,a4,6c8 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 56c:	02500713          	li	a4,37
 570:	18e78863          	beq	a5,a4,700 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 574:	02500593          	li	a1,37
 578:	855a                	mv	a0,s6
 57a:	e33ff0ef          	jal	3ac <putc>
        putc(fd, c0);
 57e:	85a6                	mv	a1,s1
 580:	855a                	mv	a0,s6
 582:	e2bff0ef          	jal	3ac <putc>
      }

      state = 0;
 586:	4981                	li	s3,0
 588:	b71d                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	e33ff0ef          	jal	3ca <printint>
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b739                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000bb583          	ld	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	e1bff0ef          	jal	3ca <printint>
        i += 1;
 5b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bdd5                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000bb583          	ld	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e01ff0ef          	jal	3ca <printint>
        i += 2;
 5ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
        i += 2;
 5d4:	bde9                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000be583          	lwu	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	de7ff0ef          	jal	3ca <printint>
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b5c9                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000bb583          	ld	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	dcfff0ef          	jal	3ca <printint>
        i += 1;
 600:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	b565                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4629                	li	a2,10
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	db5ff0ef          	jal	3ca <printint>
        i += 2;
 61a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	b579                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000be583          	lwu	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	d9bff0ef          	jal	3ca <printint>
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
 638:	bd9d                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	d83ff0ef          	jal	3ca <printint>
        i += 1;
 64c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
 652:	bdb1                	j	4ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8493          	addi	s1,s7,8
 658:	4641                	li	a2,16
 65a:	000bb583          	ld	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d6bff0ef          	jal	3ca <printint>
        i += 2;
 664:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	b591                	j	4ae <vprintf+0x44>
 66c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 66e:	008b8793          	addi	a5,s7,8
 672:	8cbe                	mv	s9,a5
 674:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 678:	03000593          	li	a1,48
 67c:	855a                	mv	a0,s6
 67e:	d2fff0ef          	jal	3ac <putc>
  putc(fd, 'x');
 682:	07800593          	li	a1,120
 686:	855a                	mv	a0,s6
 688:	d25ff0ef          	jal	3ac <putc>
 68c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	00000b97          	auipc	s7,0x0
 692:	2bab8b93          	addi	s7,s7,698 # 948 <digits>
 696:	03c9d793          	srli	a5,s3,0x3c
 69a:	97de                	add	a5,a5,s7
 69c:	0007c583          	lbu	a1,0(a5)
 6a0:	855a                	mv	a0,s6
 6a2:	d0bff0ef          	jal	3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a6:	0992                	slli	s3,s3,0x4
 6a8:	34fd                	addiw	s1,s1,-1
 6aa:	f4f5                	bnez	s1,696 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6ac:	8be6                	mv	s7,s9
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	6ca2                	ld	s9,8(sp)
 6b2:	bbf5                	j	4ae <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6b4:	008b8493          	addi	s1,s7,8
 6b8:	000bc583          	lbu	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	cefff0ef          	jal	3ac <putc>
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b3e5                	j	4ae <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6c8:	008b8993          	addi	s3,s7,8
 6cc:	000bb483          	ld	s1,0(s7)
 6d0:	cc91                	beqz	s1,6ec <vprintf+0x282>
        for (; *s; s++)
 6d2:	0004c583          	lbu	a1,0(s1)
 6d6:	c195                	beqz	a1,6fa <vprintf+0x290>
          putc(fd, *s);
 6d8:	855a                	mv	a0,s6
 6da:	cd3ff0ef          	jal	3ac <putc>
        for (; *s; s++)
 6de:	0485                	addi	s1,s1,1
 6e0:	0004c583          	lbu	a1,0(s1)
 6e4:	f9f5                	bnez	a1,6d8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6e6:	8bce                	mv	s7,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b3d1                	j	4ae <vprintf+0x44>
          s = "(null)";
 6ec:	00000497          	auipc	s1,0x0
 6f0:	25448493          	addi	s1,s1,596 # 940 <malloc+0x122>
        for (; *s; s++)
 6f4:	02800593          	li	a1,40
 6f8:	b7c5                	j	6d8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6fa:	8bce                	mv	s7,s3
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bb45                	j	4ae <vprintf+0x44>
        putc(fd, '%');
 700:	85be                	mv	a1,a5
 702:	855a                	mv	a0,s6
 704:	ca9ff0ef          	jal	3ac <putc>
 708:	bdbd                	j	586 <vprintf+0x11c>
 70a:	6906                	ld	s2,64(sp)
 70c:	79e2                	ld	s3,56(sp)
 70e:	7a42                	ld	s4,48(sp)
 710:	7aa2                	ld	s5,40(sp)
 712:	7b02                	ld	s6,32(sp)
 714:	6be2                	ld	s7,24(sp)
 716:	6c42                	ld	s8,16(sp)
    }
  }
}
 718:	60e6                	ld	ra,88(sp)
 71a:	6446                	ld	s0,80(sp)
 71c:	64a6                	ld	s1,72(sp)
 71e:	6125                	addi	sp,sp,96
 720:	8082                	ret
      if (c0 == 'd') {
 722:	06400713          	li	a4,100
 726:	e6e782e3          	beq	a5,a4,58a <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 72a:	f9478693          	addi	a3,a5,-108
 72e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 732:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 734:	4701                	li	a4,0
 736:	bbe9                	j	510 <vprintf+0xa6>

0000000000000738 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 738:	715d                	addi	sp,sp,-80
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e010                	sd	a2,0(s0)
 742:	e414                	sd	a3,8(s0)
 744:	e818                	sd	a4,16(s0)
 746:	ec1c                	sd	a5,24(s0)
 748:	03043023          	sd	a6,32(s0)
 74c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	8622                	mv	a2,s0
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	d15ff0ef          	jal	46a <vprintf>
}
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	6161                	addi	sp,sp,80
 760:	8082                	ret

0000000000000762 <printf>:

void
printf(const char *fmt, ...)
{
 762:	711d                	addi	sp,sp,-96
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e40c                	sd	a1,8(s0)
 76c:	e810                	sd	a2,16(s0)
 76e:	ec14                	sd	a3,24(s0)
 770:	f018                	sd	a4,32(s0)
 772:	f41c                	sd	a5,40(s0)
 774:	03043823          	sd	a6,48(s0)
 778:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	00840613          	addi	a2,s0,8
 780:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 784:	85aa                	mv	a1,a0
 786:	4505                	li	a0,1
 788:	ce3ff0ef          	jal	46a <vprintf>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6125                	addi	sp,sp,96
 792:	8082                	ret

0000000000000794 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 794:	1141                	addi	sp,sp,-16
 796:	e406                	sd	ra,8(sp)
 798:	e022                	sd	s0,0(sp)
 79a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 79c:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	00001797          	auipc	a5,0x1
 7a4:	8607b783          	ld	a5,-1952(a5) # 1000 <freep>
 7a8:	a095                	j	80c <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7aa:	ff852583          	lw	a1,-8(a0)
 7ae:	6390                	ld	a2,0(a5)
 7b0:	02059813          	slli	a6,a1,0x20
 7b4:	01c85693          	srli	a3,a6,0x1c
 7b8:	96ba                	add	a3,a3,a4
 7ba:	02d60563          	beq	a2,a3,7e4 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7c2:	4790                	lw	a2,8(a5)
 7c4:	02061593          	slli	a1,a2,0x20
 7c8:	01c5d693          	srli	a3,a1,0x1c
 7cc:	96be                	add	a3,a3,a5
 7ce:	02d70263          	beq	a4,a3,7f2 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7d2:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82f73623          	sd	a5,-2004(a4) # 1000 <freep>
}
 7dc:	60a2                	ld	ra,8(sp)
 7de:	6402                	ld	s0,0(sp)
 7e0:	0141                	addi	sp,sp,16
 7e2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7e4:	4614                	lw	a3,8(a2)
 7e6:	9ead                	addw	a3,a3,a1
 7e8:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	6394                	ld	a3,0(a5)
 7ee:	6290                	ld	a2,0(a3)
 7f0:	b7f9                	j	7be <free+0x2a>
    p->s.size += bp->s.size;
 7f2:	ff852703          	lw	a4,-8(a0)
 7f6:	9f31                	addw	a4,a4,a2
 7f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fa:	ff053703          	ld	a4,-16(a0)
 7fe:	bfd1                	j	7d2 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	6394                	ld	a3,0(a5)
 802:	00d7e463          	bltu	a5,a3,80a <free+0x76>
 806:	fad762e3          	bltu	a4,a3,7aa <free+0x16>
 80a:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80c:	fee7fae3          	bgeu	a5,a4,800 <free+0x6c>
 810:	6394                	ld	a3,0(a5)
 812:	f8d76ce3          	bltu	a4,a3,7aa <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	f8d7fae3          	bgeu	a5,a3,7aa <free+0x16>
 81a:	87b6                	mv	a5,a3
 81c:	bfc5                	j	80c <free+0x78>

000000000000081e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 81e:	7139                	addi	sp,sp,-64
 820:	fc06                	sd	ra,56(sp)
 822:	f822                	sd	s0,48(sp)
 824:	f04a                	sd	s2,32(sp)
 826:	ec4e                	sd	s3,24(sp)
 828:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 82a:	02051993          	slli	s3,a0,0x20
 82e:	0209d993          	srli	s3,s3,0x20
 832:	09bd                	addi	s3,s3,15
 834:	0049d993          	srli	s3,s3,0x4
 838:	2985                	addiw	s3,s3,1
 83a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 83c:	00000517          	auipc	a0,0x0
 840:	7c453503          	ld	a0,1988(a0) # 1000 <freep>
 844:	c905                	beqz	a0,874 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 846:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 848:	4798                	lw	a4,8(a5)
 84a:	09377663          	bgeu	a4,s3,8d6 <malloc+0xb8>
 84e:	f426                	sd	s1,40(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 856:	8a4e                	mv	s4,s3
 858:	6705                	lui	a4,0x1
 85a:	00e9f363          	bgeu	s3,a4,860 <malloc+0x42>
 85e:	6a05                	lui	s4,0x1
 860:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 864:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 868:	00000497          	auipc	s1,0x0
 86c:	79848493          	addi	s1,s1,1944 # 1000 <freep>
  if (p == SBRK_ERROR)
 870:	5afd                	li	s5,-1
 872:	a83d                	j	8b0 <malloc+0x92>
 874:	f426                	sd	s1,40(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 87c:	00000797          	auipc	a5,0x0
 880:	79478793          	addi	a5,a5,1940 # 1010 <base>
 884:	00000717          	auipc	a4,0x0
 888:	76f73e23          	sd	a5,1916(a4) # 1000 <freep>
 88c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 892:	b7d1                	j	856 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	e118                	sd	a4,0(a0)
 898:	a899                	j	8ee <malloc+0xd0>
  hp->s.size = nu;
 89a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 89e:	0541                	addi	a0,a0,16
 8a0:	ef5ff0ef          	jal	794 <free>
  return freep;
 8a4:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8a6:	c125                	beqz	a0,906 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8a8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8aa:	4798                	lw	a4,8(a5)
 8ac:	03277163          	bgeu	a4,s2,8ce <malloc+0xb0>
    if (p == freep)
 8b0:	6098                	ld	a4,0(s1)
 8b2:	853e                	mv	a0,a5
 8b4:	fef71ae3          	bne	a4,a5,8a8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b8:	8552                	mv	a0,s4
 8ba:	a17ff0ef          	jal	2d0 <sbrk>
  if (p == SBRK_ERROR)
 8be:	fd551ee3          	bne	a0,s5,89a <malloc+0x7c>
        return 0;
 8c2:	4501                	li	a0,0
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	a03d                	j	8fa <malloc+0xdc>
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8d6:	fae90fe3          	beq	s2,a4,894 <malloc+0x76>
        p->s.size -= nunits;
 8da:	4137073b          	subw	a4,a4,s3
 8de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e0:	02071693          	slli	a3,a4,0x20
 8e4:	01c6d713          	srli	a4,a3,0x1c
 8e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70a73923          	sd	a0,1810(a4) # 1000 <freep>
      return (void *)(p + 1);
 8f6:	01078513          	addi	a0,a5,16
  }
}
 8fa:	70e2                	ld	ra,56(sp)
 8fc:	7442                	ld	s0,48(sp)
 8fe:	7902                	ld	s2,32(sp)
 900:	69e2                	ld	s3,24(sp)
 902:	6121                	addi	sp,sp,64
 904:	8082                	ret
 906:	74a2                	ld	s1,40(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
 90e:	b7f5                	j	8fa <malloc+0xdc>
