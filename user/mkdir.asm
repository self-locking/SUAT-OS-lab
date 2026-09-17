
user/_mkdir:     file format elf64-littleriscv


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
  int i;

  if (argc < 2) {
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for (i = 1; i < argc; i++) {
    if (mkdir(argv[i]) < 0) {
  26:	6088                	ld	a0,0(s1)
  28:	35c000ef          	jal	384 <mkdir>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for (i = 1; i < argc; i++) {
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2e4000ef          	jal	31c <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8f058593          	addi	a1,a1,-1808 # 930 <malloc+0xfa>
  48:	4509                	li	a0,2
  4a:	706000ef          	jal	750 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2cc000ef          	jal	31c <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	8f258593          	addi	a1,a1,-1806 # 948 <malloc+0x112>
  5e:	4509                	li	a0,2
  60:	6f0000ef          	jal	750 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6e:	f93ff0ef          	jal	0 <main>
  exit(r);
  72:	2aa000ef          	jal	31c <exit>

0000000000000076 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0xa>
    ;
  return os;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x20>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x20>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf91                	beqz	a5,ee <strlen+0x28>
  d4:	00150793          	addi	a5,a0,1
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x12>
  e2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for (n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfdd                	j	e6 <strlen+0x20>

00000000000000f2 <memset>:

void *
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  fa:	ca19                	beqz	a2,110 <memset+0x1e>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x14>
  }
  return dst;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char *
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 120:	00054783          	lbu	a5,0(a0)
 124:	c799                	beqz	a5,132 <strchr+0x1a>
    if (*s == c)
 126:	00f58763          	beq	a1,a5,134 <strchr+0x1c>
  for (; *s; s++)
 12a:	0505                	addi	a0,a0,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbfd                	bnez	a5,126 <strchr+0xe>
      return (char *)s;
  return 0;
 132:	4501                	li	a0,0
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <gets>:

char *
gets(char *buf, int max)
{
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	e862                	sd	s8,16(sp)
 152:	1080                	addi	s0,sp,96
 154:	8baa                	mv	s7,a0
 156:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 158:	892a                	mv	s2,a0
 15a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 15c:	faf40b13          	addi	s6,s0,-81
 160:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 162:	8c26                	mv	s8,s1
 164:	0014899b          	addiw	s3,s1,1
 168:	84ce                	mv	s1,s3
 16a:	0349d863          	bge	s3,s4,19a <gets+0x5e>
    cc = read(0, &c, 1);
 16e:	8656                	mv	a2,s5
 170:	85da                	mv	a1,s6
 172:	4501                	li	a0,0
 174:	1c0000ef          	jal	334 <read>
    if (cc < 1)
 178:	02a05163          	blez	a0,19a <gets+0x5e>
      break;
    buf[i++] = c;
 17c:	faf44783          	lbu	a5,-81(s0)
 180:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 184:	0905                	addi	s2,s2,1
 186:	ff678713          	addi	a4,a5,-10
 18a:	00173713          	seqz	a4,a4
 18e:	17cd                	addi	a5,a5,-13
 190:	0017b793          	seqz	a5,a5
 194:	8fd9                	or	a5,a5,a4
 196:	d7f1                	beqz	a5,162 <gets+0x26>
    buf[i++] = c;
 198:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 19a:	9c5e                	add	s8,s8,s7
 19c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a0:	855e                	mv	a0,s7
 1a2:	60e6                	ld	ra,88(sp)
 1a4:	6446                	ld	s0,80(sp)
 1a6:	64a6                	ld	s1,72(sp)
 1a8:	6906                	ld	s2,64(sp)
 1aa:	79e2                	ld	s3,56(sp)
 1ac:	7a42                	ld	s4,48(sp)
 1ae:	7aa2                	ld	s5,40(sp)
 1b0:	7b02                	ld	s6,32(sp)
 1b2:	6be2                	ld	s7,24(sp)
 1b4:	6c42                	ld	s8,16(sp)
 1b6:	6125                	addi	sp,sp,96
 1b8:	8082                	ret

00000000000001ba <stat>:

int
stat(const char *n, struct stat *st)
{
 1ba:	1101                	addi	sp,sp,-32
 1bc:	ec06                	sd	ra,24(sp)
 1be:	e822                	sd	s0,16(sp)
 1c0:	e04a                	sd	s2,0(sp)
 1c2:	1000                	addi	s0,sp,32
 1c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c6:	4581                	li	a1,0
 1c8:	194000ef          	jal	35c <open>
  if (fd < 0)
 1cc:	02054263          	bltz	a0,1f0 <stat+0x36>
 1d0:	e426                	sd	s1,8(sp)
 1d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d4:	85ca                	mv	a1,s2
 1d6:	19e000ef          	jal	374 <fstat>
 1da:	892a                	mv	s2,a0
  close(fd);
 1dc:	8526                	mv	a0,s1
 1de:	166000ef          	jal	344 <close>
  return r;
 1e2:	64a2                	ld	s1,8(sp)
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	6902                	ld	s2,0(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret
    return -1;
 1f0:	57fd                	li	a5,-1
 1f2:	893e                	mv	s2,a5
 1f4:	bfc5                	j	1e4 <stat+0x2a>

00000000000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e406                	sd	ra,8(sp)
 1fa:	e022                	sd	s0,0(sp)
 1fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1fe:	00054683          	lbu	a3,0(a0)
 202:	fd06879b          	addiw	a5,a3,-48
 206:	0ff7f793          	zext.b	a5,a5
 20a:	4625                	li	a2,9
 20c:	02f66963          	bltu	a2,a5,23e <atoi+0x48>
 210:	872a                	mv	a4,a0
  n = 0;
 212:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 214:	0705                	addi	a4,a4,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb5                	addw	a5,a5,a3
 222:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 226:	00074683          	lbu	a3,0(a4)
 22a:	fd06879b          	addiw	a5,a3,-48
 22e:	0ff7f793          	zext.b	a5,a5
 232:	fef671e3          	bgeu	a2,a5,214 <atoi+0x1e>
  return n;
}
 236:	60a2                	ld	ra,8(sp)
 238:	6402                	ld	s0,0(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
  n = 0;
 23e:	4501                	li	a0,0
 240:	bfdd                	j	236 <atoi+0x40>

0000000000000242 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 242:	1141                	addi	sp,sp,-16
 244:	e406                	sd	ra,8(sp)
 246:	e022                	sd	s0,0(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57563          	bgeu	a0,a1,274 <memmove+0x32>
    while (n-- > 0)
 24e:	00c05f63          	blez	a2,26c <memmove+0x2a>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25a:	872a                	mv	a4,a0
      *dst++ = *src++;
 25c:	0585                	addi	a1,a1,1
 25e:	0705                	addi	a4,a4,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26c:	60a2                	ld	ra,8(sp)
 26e:	6402                	ld	s0,0(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    while (n-- > 0)
 274:	fec05ce3          	blez	a2,26c <memmove+0x2a>
    dst += n;
 278:	00c50733          	add	a4,a0,a2
    src += n;
 27c:	95b2                	add	a1,a1,a2
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 298:	fef71ae3          	bne	a4,a5,28c <memmove+0x4a>
 29c:	bfc1                	j	26c <memmove+0x2a>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a6:	ce19                	beqz	a2,2c4 <memcmp+0x26>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00e79b63          	bne	a5,a4,2ce <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2bc:	0505                	addi	a0,a0,1
    p2++;
 2be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c0:	fed518e3          	bne	a0,a3,2b0 <memcmp+0x12>
  }
  return 0;
 2c4:	4501                	li	a0,0
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
      return *p1 - *p2;
 2ce:	40e7853b          	subw	a0,a5,a4
 2d2:	bfd5                	j	2c6 <memcmp+0x28>

00000000000002d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2dc:	f67ff0ef          	jal	242 <memmove>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrk>:

char *
sbrk(int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f0:	4585                	li	a1,1
 2f2:	0b2000ef          	jal	3a4 <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrklazy>:

char *
sbrklazy(int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 306:	4589                	li	a1,2
 308:	09c000ef          	jal	3a4 <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32c:	4891                	li	a7,4
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <read>:
.global read
read:
 li a7, SYS_read
 334:	4895                	li	a7,5
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <write>:
.global write
write:
 li a7, SYS_write
 33c:	48c1                	li	a7,16
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <close>:
.global close
close:
 li a7, SYS_close
 344:	48d5                	li	a7,21
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kill>:
.global kill
kill:
 li a7, SYS_kill
 34c:	4899                	li	a7,6
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exec>:
.global exec
exec:
 li a7, SYS_exec
 354:	489d                	li	a7,7
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <open>:
.global open
open:
 li a7, SYS_open
 35c:	48bd                	li	a7,15
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 364:	48c5                	li	a7,17
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36c:	48c9                	li	a7,18
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 374:	48a1                	li	a7,8
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <link>:
.global link
link:
 li a7, SYS_link
 37c:	48cd                	li	a7,19
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 384:	48d1                	li	a7,20
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38c:	48a5                	li	a7,9
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <dup>:
.global dup
dup:
 li a7, SYS_dup
 394:	48a9                	li	a7,10
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39c:	48ad                	li	a7,11
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a4:	48b1                	li	a7,12
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ac:	48b5                	li	a7,13
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b4:	48b9                	li	a7,14
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sync>:
.global sync
sync:
 li a7, SYS_sync
 3bc:	48d9                	li	a7,22
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c4:	1101                	addi	sp,sp,-32
 3c6:	ec06                	sd	ra,24(sp)
 3c8:	e822                	sd	s0,16(sp)
 3ca:	1000                	addi	s0,sp,32
 3cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	fef40593          	addi	a1,s0,-17
 3d6:	f67ff0ef          	jal	33c <write>
}
 3da:	60e2                	ld	ra,24(sp)
 3dc:	6442                	ld	s0,16(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret

00000000000003e2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3e2:	715d                	addi	sp,sp,-80
 3e4:	e486                	sd	ra,72(sp)
 3e6:	e0a2                	sd	s0,64(sp)
 3e8:	f84a                	sd	s2,48(sp)
 3ea:	f44e                	sd	s3,40(sp)
 3ec:	0880                	addi	s0,sp,80
 3ee:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3f0:	00d036b3          	snez	a3,a3
 3f4:	03f5d793          	srli	a5,a1,0x3f
 3f8:	8efd                	and	a3,a3,a5
  neg = 0;
 3fa:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3fc:	c681                	beqz	a3,404 <printint+0x22>
    neg = 1;
    x = -xx;
 3fe:	40b005b3          	neg	a1,a1
    neg = 1;
 402:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 404:	fb840993          	addi	s3,s0,-72
  neg = 0;
 408:	86ce                	mv	a3,s3
  i = 0;
 40a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 40c:	00000817          	auipc	a6,0x0
 410:	56480813          	addi	a6,a6,1380 # 970 <digits>
 414:	88ba                	mv	a7,a4
 416:	0017051b          	addiw	a0,a4,1
 41a:	872a                	mv	a4,a0
 41c:	02c5f7b3          	remu	a5,a1,a2
 420:	97c2                	add	a5,a5,a6
 422:	0007c783          	lbu	a5,0(a5)
 426:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 42a:	87ae                	mv	a5,a1
 42c:	02c5d5b3          	divu	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fec7f1e3          	bgeu	a5,a2,414 <printint+0x32>
  if (neg)
 436:	00030b63          	beqz	t1,44c <printint+0x6a>
    buf[i++] = '-';
 43a:	fd040793          	addi	a5,s0,-48
 43e:	953e                	add	a0,a0,a5
 440:	02d00793          	li	a5,45
 444:	fef50423          	sb	a5,-24(a0)
 448:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 44c:	02e05563          	blez	a4,476 <printint+0x94>
 450:	fc26                	sd	s1,56(sp)
 452:	377d                	addiw	a4,a4,-1
 454:	00e984b3          	add	s1,s3,a4
 458:	19fd                	addi	s3,s3,-1
 45a:	99ba                	add	s3,s3,a4
 45c:	1702                	slli	a4,a4,0x20
 45e:	9301                	srli	a4,a4,0x20
 460:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 464:	0004c583          	lbu	a1,0(s1)
 468:	854a                	mv	a0,s2
 46a:	f5bff0ef          	jal	3c4 <putc>
  while (--i >= 0)
 46e:	14fd                	addi	s1,s1,-1
 470:	ff349ae3          	bne	s1,s3,464 <printint+0x82>
 474:	74e2                	ld	s1,56(sp)
}
 476:	60a6                	ld	ra,72(sp)
 478:	6406                	ld	s0,64(sp)
 47a:	7942                	ld	s2,48(sp)
 47c:	79a2                	ld	s3,40(sp)
 47e:	6161                	addi	sp,sp,80
 480:	8082                	ret

0000000000000482 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 482:	711d                	addi	sp,sp,-96
 484:	ec86                	sd	ra,88(sp)
 486:	e8a2                	sd	s0,80(sp)
 488:	e4a6                	sd	s1,72(sp)
 48a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 48c:	0005c483          	lbu	s1,0(a1)
 490:	2a048063          	beqz	s1,730 <vprintf+0x2ae>
 494:	e0ca                	sd	s2,64(sp)
 496:	fc4e                	sd	s3,56(sp)
 498:	f852                	sd	s4,48(sp)
 49a:	f456                	sd	s5,40(sp)
 49c:	f05a                	sd	s6,32(sp)
 49e:	ec5e                	sd	s7,24(sp)
 4a0:	e862                	sd	s8,16(sp)
 4a2:	8b2a                	mv	s6,a0
 4a4:	8a2e                	mv	s4,a1
 4a6:	8bb2                	mv	s7,a2
  state = 0;
 4a8:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4aa:	4901                	li	s2,0
 4ac:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4b2:	06400c13          	li	s8,100
 4b6:	a00d                	j	4d8 <vprintf+0x56>
        putc(fd, c0);
 4b8:	85a6                	mv	a1,s1
 4ba:	855a                	mv	a0,s6
 4bc:	f09ff0ef          	jal	3c4 <putc>
 4c0:	a019                	j	4c6 <vprintf+0x44>
    } else if (state == '%') {
 4c2:	03598363          	beq	s3,s5,4e8 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4c6:	0019079b          	addiw	a5,s2,1
 4ca:	893e                	mv	s2,a5
 4cc:	873e                	mv	a4,a5
 4ce:	97d2                	add	a5,a5,s4
 4d0:	0007c483          	lbu	s1,0(a5)
 4d4:	24048763          	beqz	s1,722 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4d8:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4dc:	fe0993e3          	bnez	s3,4c2 <vprintf+0x40>
      if (c0 == '%') {
 4e0:	fd579ce3          	bne	a5,s5,4b8 <vprintf+0x36>
        state = '%';
 4e4:	89be                	mv	s3,a5
 4e6:	b7c5                	j	4c6 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4e8:	00ea06b3          	add	a3,s4,a4
 4ec:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4f0:	24060563          	beqz	a2,73a <vprintf+0x2b8>
      if (c0 == 'd') {
 4f4:	0b878763          	beq	a5,s8,5a2 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4f8:	f9478693          	addi	a3,a5,-108
 4fc:	0016b693          	seqz	a3,a3
 500:	f9c60593          	addi	a1,a2,-100
 504:	0015b593          	seqz	a1,a1
 508:	8df5                	and	a1,a1,a3
 50a:	e9c5                	bnez	a1,5ba <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 50c:	9752                	add	a4,a4,s4
 50e:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 512:	f9460713          	addi	a4,a2,-108
 516:	00173713          	seqz	a4,a4
 51a:	8f75                	and	a4,a4,a3
 51c:	f9c50593          	addi	a1,a0,-100
 520:	0015b593          	seqz	a1,a1
 524:	8df9                	and	a1,a1,a4
 526:	e5dd                	bnez	a1,5d4 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 528:	07500593          	li	a1,117
 52c:	0cb78163          	beq	a5,a1,5ee <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 530:	f8b60593          	addi	a1,a2,-117
 534:	0015b593          	seqz	a1,a1
 538:	8df5                	and	a1,a1,a3
 53a:	e5f1                	bnez	a1,606 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 53c:	f8b50593          	addi	a1,a0,-117
 540:	0015b593          	seqz	a1,a1
 544:	8df9                	and	a1,a1,a4
 546:	ede9                	bnez	a1,620 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 548:	07800593          	li	a1,120
 54c:	0eb78763          	beq	a5,a1,63a <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 550:	f8860613          	addi	a2,a2,-120
 554:	00163613          	seqz	a2,a2
 558:	8ef1                	and	a3,a3,a2
 55a:	0e069c63          	bnez	a3,652 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 55e:	f8850513          	addi	a0,a0,-120
 562:	00153513          	seqz	a0,a0
 566:	8f69                	and	a4,a4,a0
 568:	10071263          	bnez	a4,66c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 56c:	07000713          	li	a4,112
 570:	10e78a63          	beq	a5,a4,684 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 574:	06300713          	li	a4,99
 578:	14e78a63          	beq	a5,a4,6cc <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 57c:	07300713          	li	a4,115
 580:	16e78063          	beq	a5,a4,6e0 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 584:	02500713          	li	a4,37
 588:	18e78863          	beq	a5,a4,718 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58c:	02500593          	li	a1,37
 590:	855a                	mv	a0,s6
 592:	e33ff0ef          	jal	3c4 <putc>
        putc(fd, c0);
 596:	85a6                	mv	a1,s1
 598:	855a                	mv	a0,s6
 59a:	e2bff0ef          	jal	3c4 <putc>
      }

      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b71d                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	e33ff0ef          	jal	3e2 <printint>
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b739                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000bb583          	ld	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e1bff0ef          	jal	3e2 <printint>
        i += 1;
 5cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bdd5                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000bb583          	ld	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	e01ff0ef          	jal	3e2 <printint>
        i += 2;
 5e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
        i += 2;
 5ec:	bde9                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000be583          	lwu	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	de7ff0ef          	jal	3e2 <printint>
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
 604:	b5c9                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000bb583          	ld	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	dcfff0ef          	jal	3e2 <printint>
        i += 1;
 618:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b565                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000bb583          	ld	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	db5ff0ef          	jal	3e2 <printint>
        i += 2;
 632:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	b579                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000be583          	lwu	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	d9bff0ef          	jal	3e2 <printint>
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	bd9d                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	008b8493          	addi	s1,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000bb583          	ld	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d83ff0ef          	jal	3e2 <printint>
        i += 1;
 664:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
 66a:	bdb1                	j	4c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66c:	008b8493          	addi	s1,s7,8
 670:	4641                	li	a2,16
 672:	000bb583          	ld	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	d6bff0ef          	jal	3e2 <printint>
        i += 2;
 67c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
        i += 2;
 682:	b591                	j	4c6 <vprintf+0x44>
 684:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 686:	008b8793          	addi	a5,s7,8
 68a:	8cbe                	mv	s9,a5
 68c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 690:	03000593          	li	a1,48
 694:	855a                	mv	a0,s6
 696:	d2fff0ef          	jal	3c4 <putc>
  putc(fd, 'x');
 69a:	07800593          	li	a1,120
 69e:	855a                	mv	a0,s6
 6a0:	d25ff0ef          	jal	3c4 <putc>
 6a4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a6:	00000b97          	auipc	s7,0x0
 6aa:	2cab8b93          	addi	s7,s7,714 # 970 <digits>
 6ae:	03c9d793          	srli	a5,s3,0x3c
 6b2:	97de                	add	a5,a5,s7
 6b4:	0007c583          	lbu	a1,0(a5)
 6b8:	855a                	mv	a0,s6
 6ba:	d0bff0ef          	jal	3c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6be:	0992                	slli	s3,s3,0x4
 6c0:	34fd                	addiw	s1,s1,-1
 6c2:	f4f5                	bnez	s1,6ae <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6c4:	8be6                	mv	s7,s9
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	6ca2                	ld	s9,8(sp)
 6ca:	bbf5                	j	4c6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6cc:	008b8493          	addi	s1,s7,8
 6d0:	000bc583          	lbu	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	cefff0ef          	jal	3c4 <putc>
 6da:	8ba6                	mv	s7,s1
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b3e5                	j	4c6 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6e0:	008b8993          	addi	s3,s7,8
 6e4:	000bb483          	ld	s1,0(s7)
 6e8:	cc91                	beqz	s1,704 <vprintf+0x282>
        for (; *s; s++)
 6ea:	0004c583          	lbu	a1,0(s1)
 6ee:	c195                	beqz	a1,712 <vprintf+0x290>
          putc(fd, *s);
 6f0:	855a                	mv	a0,s6
 6f2:	cd3ff0ef          	jal	3c4 <putc>
        for (; *s; s++)
 6f6:	0485                	addi	s1,s1,1
 6f8:	0004c583          	lbu	a1,0(s1)
 6fc:	f9f5                	bnez	a1,6f0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6fe:	8bce                	mv	s7,s3
      state = 0;
 700:	4981                	li	s3,0
 702:	b3d1                	j	4c6 <vprintf+0x44>
          s = "(null)";
 704:	00000497          	auipc	s1,0x0
 708:	26448493          	addi	s1,s1,612 # 968 <malloc+0x132>
        for (; *s; s++)
 70c:	02800593          	li	a1,40
 710:	b7c5                	j	6f0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 712:	8bce                	mv	s7,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	bb45                	j	4c6 <vprintf+0x44>
        putc(fd, '%');
 718:	85be                	mv	a1,a5
 71a:	855a                	mv	a0,s6
 71c:	ca9ff0ef          	jal	3c4 <putc>
 720:	bdbd                	j	59e <vprintf+0x11c>
 722:	6906                	ld	s2,64(sp)
 724:	79e2                	ld	s3,56(sp)
 726:	7a42                	ld	s4,48(sp)
 728:	7aa2                	ld	s5,40(sp)
 72a:	7b02                	ld	s6,32(sp)
 72c:	6be2                	ld	s7,24(sp)
 72e:	6c42                	ld	s8,16(sp)
    }
  }
}
 730:	60e6                	ld	ra,88(sp)
 732:	6446                	ld	s0,80(sp)
 734:	64a6                	ld	s1,72(sp)
 736:	6125                	addi	sp,sp,96
 738:	8082                	ret
      if (c0 == 'd') {
 73a:	06400713          	li	a4,100
 73e:	e6e782e3          	beq	a5,a4,5a2 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 742:	f9478693          	addi	a3,a5,-108
 746:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 74a:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 74c:	4701                	li	a4,0
 74e:	bbe9                	j	528 <vprintf+0xa6>

0000000000000750 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 750:	715d                	addi	sp,sp,-80
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e010                	sd	a2,0(s0)
 75a:	e414                	sd	a3,8(s0)
 75c:	e818                	sd	a4,16(s0)
 75e:	ec1c                	sd	a5,24(s0)
 760:	03043023          	sd	a6,32(s0)
 764:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	8622                	mv	a2,s0
 76a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76e:	d15ff0ef          	jal	482 <vprintf>
}
 772:	60e2                	ld	ra,24(sp)
 774:	6442                	ld	s0,16(sp)
 776:	6161                	addi	sp,sp,80
 778:	8082                	ret

000000000000077a <printf>:

void
printf(const char *fmt, ...)
{
 77a:	711d                	addi	sp,sp,-96
 77c:	ec06                	sd	ra,24(sp)
 77e:	e822                	sd	s0,16(sp)
 780:	1000                	addi	s0,sp,32
 782:	e40c                	sd	a1,8(s0)
 784:	e810                	sd	a2,16(s0)
 786:	ec14                	sd	a3,24(s0)
 788:	f018                	sd	a4,32(s0)
 78a:	f41c                	sd	a5,40(s0)
 78c:	03043823          	sd	a6,48(s0)
 790:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 794:	00840613          	addi	a2,s0,8
 798:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79c:	85aa                	mv	a1,a0
 79e:	4505                	li	a0,1
 7a0:	ce3ff0ef          	jal	482 <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ac:	1141                	addi	sp,sp,-16
 7ae:	e406                	sd	ra,8(sp)
 7b0:	e022                	sd	s0,0(sp)
 7b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7b4:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	00001797          	auipc	a5,0x1
 7bc:	8487b783          	ld	a5,-1976(a5) # 1000 <freep>
 7c0:	a095                	j	824 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	slli	a6,a1,0x20
 7cc:	01c85693          	srli	a3,a6,0x1c
 7d0:	96ba                	add	a3,a3,a4
 7d2:	02d60563          	beq	a2,a3,7fc <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	slli	a1,a2,0x20
 7e0:	01c5d693          	srli	a3,a1,0x1c
 7e4:	96be                	add	a3,a3,a5
 7e6:	02d70263          	beq	a4,a3,80a <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ea:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
}
 7f4:	60a2                	ld	ra,8(sp)
 7f6:	6402                	ld	s0,0(sp)
 7f8:	0141                	addi	sp,sp,16
 7fa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7fc:	4614                	lw	a3,8(a2)
 7fe:	9ead                	addw	a3,a3,a1
 800:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	6394                	ld	a3,0(a5)
 806:	6290                	ld	a2,0(a3)
 808:	b7f9                	j	7d6 <free+0x2a>
    p->s.size += bp->s.size;
 80a:	ff852703          	lw	a4,-8(a0)
 80e:	9f31                	addw	a4,a4,a2
 810:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 812:	ff053703          	ld	a4,-16(a0)
 816:	bfd1                	j	7ea <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	6394                	ld	a3,0(a5)
 81a:	00d7e463          	bltu	a5,a3,822 <free+0x76>
 81e:	fad762e3          	bltu	a4,a3,7c2 <free+0x16>
 822:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 824:	fee7fae3          	bgeu	a5,a4,818 <free+0x6c>
 828:	6394                	ld	a3,0(a5)
 82a:	f8d76ce3          	bltu	a4,a3,7c2 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82e:	f8d7fae3          	bgeu	a5,a3,7c2 <free+0x16>
 832:	87b6                	mv	a5,a3
 834:	bfc5                	j	824 <free+0x78>

0000000000000836 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 836:	7139                	addi	sp,sp,-64
 838:	fc06                	sd	ra,56(sp)
 83a:	f822                	sd	s0,48(sp)
 83c:	f04a                	sd	s2,32(sp)
 83e:	ec4e                	sd	s3,24(sp)
 840:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 842:	02051993          	slli	s3,a0,0x20
 846:	0209d993          	srli	s3,s3,0x20
 84a:	09bd                	addi	s3,s3,15
 84c:	0049d993          	srli	s3,s3,0x4
 850:	2985                	addiw	s3,s3,1
 852:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 854:	00000517          	auipc	a0,0x0
 858:	7ac53503          	ld	a0,1964(a0) # 1000 <freep>
 85c:	c905                	beqz	a0,88c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 85e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 860:	4798                	lw	a4,8(a5)
 862:	09377663          	bgeu	a4,s3,8ee <malloc+0xb8>
 866:	f426                	sd	s1,40(sp)
 868:	e852                	sd	s4,16(sp)
 86a:	e456                	sd	s5,8(sp)
 86c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 86e:	8a4e                	mv	s4,s3
 870:	6705                	lui	a4,0x1
 872:	00e9f363          	bgeu	s3,a4,878 <malloc+0x42>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 880:	00000497          	auipc	s1,0x0
 884:	78048493          	addi	s1,s1,1920 # 1000 <freep>
  if (p == SBRK_ERROR)
 888:	5afd                	li	s5,-1
 88a:	a83d                	j	8c8 <malloc+0x92>
 88c:	f426                	sd	s1,40(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	77c78793          	addi	a5,a5,1916 # 1010 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8aa:	b7d1                	j	86e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	a899                	j	906 <malloc+0xd0>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	ef5ff0ef          	jal	7ac <free>
  return freep;
 8bc:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8be:	c125                	beqz	a0,91e <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8c2:	4798                	lw	a4,8(a5)
 8c4:	03277163          	bgeu	a4,s2,8e6 <malloc+0xb0>
    if (p == freep)
 8c8:	6098                	ld	a4,0(s1)
 8ca:	853e                	mv	a0,a5
 8cc:	fef71ae3          	bne	a4,a5,8c0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d0:	8552                	mv	a0,s4
 8d2:	a17ff0ef          	jal	2e8 <sbrk>
  if (p == SBRK_ERROR)
 8d6:	fd551ee3          	bne	a0,s5,8b2 <malloc+0x7c>
        return 0;
 8da:	4501                	li	a0,0
 8dc:	74a2                	ld	s1,40(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	a03d                	j	912 <malloc+0xdc>
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8ee:	fae90fe3          	beq	s2,a4,8ac <malloc+0x76>
        p->s.size -= nunits;
 8f2:	4137073b          	subw	a4,a4,s3
 8f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f8:	02071693          	slli	a3,a4,0x20
 8fc:	01c6d713          	srli	a4,a3,0x1c
 900:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 902:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 906:	00000717          	auipc	a4,0x0
 90a:	6ea73d23          	sd	a0,1786(a4) # 1000 <freep>
      return (void *)(p + 1);
 90e:	01078513          	addi	a0,a5,16
  }
}
 912:	70e2                	ld	ra,56(sp)
 914:	7442                	ld	s0,48(sp)
 916:	7902                	ld	s2,32(sp)
 918:	69e2                	ld	s3,24(sp)
 91a:	6121                	addi	sp,sp,64
 91c:	8082                	ret
 91e:	74a2                	ld	s1,40(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	b7f5                	j	912 <malloc+0xdc>
