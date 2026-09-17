
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
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
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for (i = 1; i < argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1bc000ef          	jal	1e4 <atoi>
  2c:	30e000ef          	jal	33a <kill>
  for (i = 1; i < argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2d2000ef          	jal	30a <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8e058593          	addi	a1,a1,-1824 # 920 <malloc+0xfc>
  48:	4509                	li	a0,2
  4a:	6f4000ef          	jal	73e <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2ba000ef          	jal	30a <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  5c:	fa5ff0ef          	jal	0 <main>
  exit(r);
  60:	2aa000ef          	jal	30a <exit>

0000000000000064 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0xa>
    ;
  return os;
}
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cb91                	beqz	a5,a4 <strcmp+0x20>
  92:	0005c703          	lbu	a4,0(a1)
  96:	00f71763          	bne	a4,a5,a4 <strcmp+0x20>
    p++, q++;
  9a:	0505                	addi	a0,a0,1
  9c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	fbe5                	bnez	a5,92 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a4:	0005c503          	lbu	a0,0(a1)
}
  a8:	40a7853b          	subw	a0,a5,a0
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cf91                	beqz	a5,dc <strlen+0x28>
  c2:	00150793          	addi	a5,a0,1
  c6:	86be                	mv	a3,a5
  c8:	0785                	addi	a5,a5,1
  ca:	fff7c703          	lbu	a4,-1(a5)
  ce:	ff65                	bnez	a4,c6 <strlen+0x12>
  d0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  for (n = 0; s[n]; n++)
  dc:	4501                	li	a0,0
  de:	bfdd                	j	d4 <strlen+0x20>

00000000000000e0 <memset>:

void *
memset(void *dst, int c, uint n)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e8:	ca19                	beqz	a2,fe <memset+0x1e>
  ea:	87aa                	mv	a5,a0
  ec:	1602                	slli	a2,a2,0x20
  ee:	9201                	srli	a2,a2,0x20
  f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f8:	0785                	addi	a5,a5,1
  fa:	fee79de3          	bne	a5,a4,f4 <memset+0x14>
  }
  return dst;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strchr>:

char *
strchr(const char *s, char c)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	c799                	beqz	a5,120 <strchr+0x1a>
    if (*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1c>
  for (; *s; s++)
 118:	0505                	addi	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xe>
      return (char *)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <gets>:

char *
gets(char *buf, int max)
{
 12a:	711d                	addi	sp,sp,-96
 12c:	ec86                	sd	ra,88(sp)
 12e:	e8a2                	sd	s0,80(sp)
 130:	e4a6                	sd	s1,72(sp)
 132:	e0ca                	sd	s2,64(sp)
 134:	fc4e                	sd	s3,56(sp)
 136:	f852                	sd	s4,48(sp)
 138:	f456                	sd	s5,40(sp)
 13a:	f05a                	sd	s6,32(sp)
 13c:	ec5e                	sd	s7,24(sp)
 13e:	e862                	sd	s8,16(sp)
 140:	1080                	addi	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14a:	faf40b13          	addi	s6,s0,-81
 14e:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 150:	8c26                	mv	s8,s1
 152:	0014899b          	addiw	s3,s1,1
 156:	84ce                	mv	s1,s3
 158:	0349d863          	bge	s3,s4,188 <gets+0x5e>
    cc = read(0, &c, 1);
 15c:	8656                	mv	a2,s5
 15e:	85da                	mv	a1,s6
 160:	4501                	li	a0,0
 162:	1c0000ef          	jal	322 <read>
    if (cc < 1)
 166:	02a05163          	blez	a0,188 <gets+0x5e>
      break;
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 172:	0905                	addi	s2,s2,1
 174:	ff678713          	addi	a4,a5,-10
 178:	00173713          	seqz	a4,a4
 17c:	17cd                	addi	a5,a5,-13
 17e:	0017b793          	seqz	a5,a5
 182:	8fd9                	or	a5,a5,a4
 184:	d7f1                	beqz	a5,150 <gets+0x26>
    buf[i++] = c;
 186:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 188:	9c5e                	add	s8,s8,s7
 18a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 18e:	855e                	mv	a0,s7
 190:	60e6                	ld	ra,88(sp)
 192:	6446                	ld	s0,80(sp)
 194:	64a6                	ld	s1,72(sp)
 196:	6906                	ld	s2,64(sp)
 198:	79e2                	ld	s3,56(sp)
 19a:	7a42                	ld	s4,48(sp)
 19c:	7aa2                	ld	s5,40(sp)
 19e:	7b02                	ld	s6,32(sp)
 1a0:	6be2                	ld	s7,24(sp)
 1a2:	6c42                	ld	s8,16(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	194000ef          	jal	34a <open>
  if (fd < 0)
 1ba:	02054263          	bltz	a0,1de <stat+0x36>
 1be:	e426                	sd	s1,8(sp)
 1c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c2:	85ca                	mv	a1,s2
 1c4:	19e000ef          	jal	362 <fstat>
 1c8:	892a                	mv	s2,a0
  close(fd);
 1ca:	8526                	mv	a0,s1
 1cc:	166000ef          	jal	332 <close>
  return r;
 1d0:	64a2                	ld	s1,8(sp)
}
 1d2:	854a                	mv	a0,s2
 1d4:	60e2                	ld	ra,24(sp)
 1d6:	6442                	ld	s0,16(sp)
 1d8:	6902                	ld	s2,0(sp)
 1da:	6105                	addi	sp,sp,32
 1dc:	8082                	ret
    return -1;
 1de:	57fd                	li	a5,-1
 1e0:	893e                	mv	s2,a5
 1e2:	bfc5                	j	1d2 <stat+0x2a>

00000000000001e4 <atoi>:

int
atoi(const char *s)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1ec:	00054683          	lbu	a3,0(a0)
 1f0:	fd06879b          	addiw	a5,a3,-48
 1f4:	0ff7f793          	zext.b	a5,a5
 1f8:	4625                	li	a2,9
 1fa:	02f66963          	bltu	a2,a5,22c <atoi+0x48>
 1fe:	872a                	mv	a4,a0
  n = 0;
 200:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 202:	0705                	addi	a4,a4,1
 204:	0025179b          	slliw	a5,a0,0x2
 208:	9fa9                	addw	a5,a5,a0
 20a:	0017979b          	slliw	a5,a5,0x1
 20e:	9fb5                	addw	a5,a5,a3
 210:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 214:	00074683          	lbu	a3,0(a4)
 218:	fd06879b          	addiw	a5,a3,-48
 21c:	0ff7f793          	zext.b	a5,a5
 220:	fef671e3          	bgeu	a2,a5,202 <atoi+0x1e>
  return n;
}
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfdd                	j	224 <atoi+0x40>

0000000000000230 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e406                	sd	ra,8(sp)
 234:	e022                	sd	s0,0(sp)
 236:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 238:	02b57563          	bgeu	a0,a1,262 <memmove+0x32>
    while (n-- > 0)
 23c:	00c05f63          	blez	a2,25a <memmove+0x2a>
 240:	1602                	slli	a2,a2,0x20
 242:	9201                	srli	a2,a2,0x20
 244:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 248:	872a                	mv	a4,a0
      *dst++ = *src++;
 24a:	0585                	addi	a1,a1,1
 24c:	0705                	addi	a4,a4,1
 24e:	fff5c683          	lbu	a3,-1(a1)
 252:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 256:	fee79ae3          	bne	a5,a4,24a <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25a:	60a2                	ld	ra,8(sp)
 25c:	6402                	ld	s0,0(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    while (n-- > 0)
 262:	fec05ce3          	blez	a2,25a <memmove+0x2a>
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 286:	fef71ae3          	bne	a4,a5,27a <memmove+0x4a>
 28a:	bfc1                	j	25a <memmove+0x2a>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ce19                	beqz	a2,2b2 <memcmp+0x26>
 296:	1602                	slli	a2,a2,0x20
 298:	9201                	srli	a2,a2,0x20
 29a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00e79b63          	bne	a5,a4,2bc <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2aa:	0505                	addi	a0,a0,1
    p2++;
 2ac:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ae:	fed518e3          	bne	a0,a3,29e <memcmp+0x12>
  }
  return 0;
 2b2:	4501                	li	a0,0
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
 2c0:	bfd5                	j	2b4 <memcmp+0x28>

00000000000002c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ca:	f67ff0ef          	jal	230 <memmove>
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <sbrk>:

char *
sbrk(int n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2de:	4585                	li	a1,1
 2e0:	0b2000ef          	jal	392 <sys_sbrk>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrklazy>:

char *
sbrklazy(int n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f4:	4589                	li	a1,2
 2f6:	09c000ef          	jal	392 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31a:	4891                	li	a7,4
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <read>:
.global read
read:
 li a7, SYS_read
 322:	4895                	li	a7,5
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <write>:
.global write
write:
 li a7, SYS_write
 32a:	48c1                	li	a7,16
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <close>:
.global close
close:
 li a7, SYS_close
 332:	48d5                	li	a7,21
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <kill>:
.global kill
kill:
 li a7, SYS_kill
 33a:	4899                	li	a7,6
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exec>:
.global exec
exec:
 li a7, SYS_exec
 342:	489d                	li	a7,7
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <open>:
.global open
open:
 li a7, SYS_open
 34a:	48bd                	li	a7,15
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 362:	48a1                	li	a7,8
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <link>:
.global link
link:
 li a7, SYS_link
 36a:	48cd                	li	a7,19
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 372:	48d1                	li	a7,20
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37a:	48a5                	li	a7,9
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <dup>:
.global dup
dup:
 li a7, SYS_dup
 382:	48a9                	li	a7,10
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38a:	48ad                	li	a7,11
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 392:	48b1                	li	a7,12
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <pause>:
.global pause
pause:
 li a7, SYS_pause
 39a:	48b5                	li	a7,13
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a2:	48b9                	li	a7,14
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sync>:
.global sync
sync:
 li a7, SYS_sync
 3aa:	48d9                	li	a7,22
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b2:	1101                	addi	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	1000                	addi	s0,sp,32
 3ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3be:	4605                	li	a2,1
 3c0:	fef40593          	addi	a1,s0,-17
 3c4:	f67ff0ef          	jal	32a <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d0:	715d                	addi	sp,sp,-80
 3d2:	e486                	sd	ra,72(sp)
 3d4:	e0a2                	sd	s0,64(sp)
 3d6:	f84a                	sd	s2,48(sp)
 3d8:	f44e                	sd	s3,40(sp)
 3da:	0880                	addi	s0,sp,80
 3dc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3de:	00d036b3          	snez	a3,a3
 3e2:	03f5d793          	srli	a5,a1,0x3f
 3e6:	8efd                	and	a3,a3,a5
  neg = 0;
 3e8:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3ea:	c681                	beqz	a3,3f2 <printint+0x22>
    neg = 1;
    x = -xx;
 3ec:	40b005b3          	neg	a1,a1
    neg = 1;
 3f0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f2:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3f6:	86ce                	mv	a3,s3
  i = 0;
 3f8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3fa:	00000817          	auipc	a6,0x0
 3fe:	54680813          	addi	a6,a6,1350 # 940 <digits>
 402:	88ba                	mv	a7,a4
 404:	0017051b          	addiw	a0,a4,1
 408:	872a                	mv	a4,a0
 40a:	02c5f7b3          	remu	a5,a1,a2
 40e:	97c2                	add	a5,a5,a6
 410:	0007c783          	lbu	a5,0(a5)
 414:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 418:	87ae                	mv	a5,a1
 41a:	02c5d5b3          	divu	a1,a1,a2
 41e:	0685                	addi	a3,a3,1
 420:	fec7f1e3          	bgeu	a5,a2,402 <printint+0x32>
  if (neg)
 424:	00030b63          	beqz	t1,43a <printint+0x6a>
    buf[i++] = '-';
 428:	fd040793          	addi	a5,s0,-48
 42c:	953e                	add	a0,a0,a5
 42e:	02d00793          	li	a5,45
 432:	fef50423          	sb	a5,-24(a0)
 436:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 43a:	02e05563          	blez	a4,464 <printint+0x94>
 43e:	fc26                	sd	s1,56(sp)
 440:	377d                	addiw	a4,a4,-1
 442:	00e984b3          	add	s1,s3,a4
 446:	19fd                	addi	s3,s3,-1
 448:	99ba                	add	s3,s3,a4
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 452:	0004c583          	lbu	a1,0(s1)
 456:	854a                	mv	a0,s2
 458:	f5bff0ef          	jal	3b2 <putc>
  while (--i >= 0)
 45c:	14fd                	addi	s1,s1,-1
 45e:	ff349ae3          	bne	s1,s3,452 <printint+0x82>
 462:	74e2                	ld	s1,56(sp)
}
 464:	60a6                	ld	ra,72(sp)
 466:	6406                	ld	s0,64(sp)
 468:	7942                	ld	s2,48(sp)
 46a:	79a2                	ld	s3,40(sp)
 46c:	6161                	addi	sp,sp,80
 46e:	8082                	ret

0000000000000470 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 470:	711d                	addi	sp,sp,-96
 472:	ec86                	sd	ra,88(sp)
 474:	e8a2                	sd	s0,80(sp)
 476:	e4a6                	sd	s1,72(sp)
 478:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 47a:	0005c483          	lbu	s1,0(a1)
 47e:	2a048063          	beqz	s1,71e <vprintf+0x2ae>
 482:	e0ca                	sd	s2,64(sp)
 484:	fc4e                	sd	s3,56(sp)
 486:	f852                	sd	s4,48(sp)
 488:	f456                	sd	s5,40(sp)
 48a:	f05a                	sd	s6,32(sp)
 48c:	ec5e                	sd	s7,24(sp)
 48e:	e862                	sd	s8,16(sp)
 490:	8b2a                	mv	s6,a0
 492:	8a2e                	mv	s4,a1
 494:	8bb2                	mv	s7,a2
  state = 0;
 496:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 498:	4901                	li	s2,0
 49a:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 49c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4a0:	06400c13          	li	s8,100
 4a4:	a00d                	j	4c6 <vprintf+0x56>
        putc(fd, c0);
 4a6:	85a6                	mv	a1,s1
 4a8:	855a                	mv	a0,s6
 4aa:	f09ff0ef          	jal	3b2 <putc>
 4ae:	a019                	j	4b4 <vprintf+0x44>
    } else if (state == '%') {
 4b0:	03598363          	beq	s3,s5,4d6 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4b4:	0019079b          	addiw	a5,s2,1
 4b8:	893e                	mv	s2,a5
 4ba:	873e                	mv	a4,a5
 4bc:	97d2                	add	a5,a5,s4
 4be:	0007c483          	lbu	s1,0(a5)
 4c2:	24048763          	beqz	s1,710 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4c6:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4ca:	fe0993e3          	bnez	s3,4b0 <vprintf+0x40>
      if (c0 == '%') {
 4ce:	fd579ce3          	bne	a5,s5,4a6 <vprintf+0x36>
        state = '%';
 4d2:	89be                	mv	s3,a5
 4d4:	b7c5                	j	4b4 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4d6:	00ea06b3          	add	a3,s4,a4
 4da:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4de:	24060563          	beqz	a2,728 <vprintf+0x2b8>
      if (c0 == 'd') {
 4e2:	0b878763          	beq	a5,s8,590 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4e6:	f9478693          	addi	a3,a5,-108
 4ea:	0016b693          	seqz	a3,a3
 4ee:	f9c60593          	addi	a1,a2,-100
 4f2:	0015b593          	seqz	a1,a1
 4f6:	8df5                	and	a1,a1,a3
 4f8:	e9c5                	bnez	a1,5a8 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4fa:	9752                	add	a4,a4,s4
 4fc:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 500:	f9460713          	addi	a4,a2,-108
 504:	00173713          	seqz	a4,a4
 508:	8f75                	and	a4,a4,a3
 50a:	f9c50593          	addi	a1,a0,-100
 50e:	0015b593          	seqz	a1,a1
 512:	8df9                	and	a1,a1,a4
 514:	e5dd                	bnez	a1,5c2 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 516:	07500593          	li	a1,117
 51a:	0cb78163          	beq	a5,a1,5dc <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 51e:	f8b60593          	addi	a1,a2,-117
 522:	0015b593          	seqz	a1,a1
 526:	8df5                	and	a1,a1,a3
 528:	e5f1                	bnez	a1,5f4 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 52a:	f8b50593          	addi	a1,a0,-117
 52e:	0015b593          	seqz	a1,a1
 532:	8df9                	and	a1,a1,a4
 534:	ede9                	bnez	a1,60e <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 536:	07800593          	li	a1,120
 53a:	0eb78763          	beq	a5,a1,628 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 53e:	f8860613          	addi	a2,a2,-120
 542:	00163613          	seqz	a2,a2
 546:	8ef1                	and	a3,a3,a2
 548:	0e069c63          	bnez	a3,640 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 54c:	f8850513          	addi	a0,a0,-120
 550:	00153513          	seqz	a0,a0
 554:	8f69                	and	a4,a4,a0
 556:	10071263          	bnez	a4,65a <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 55a:	07000713          	li	a4,112
 55e:	10e78a63          	beq	a5,a4,672 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 562:	06300713          	li	a4,99
 566:	14e78a63          	beq	a5,a4,6ba <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 56a:	07300713          	li	a4,115
 56e:	16e78063          	beq	a5,a4,6ce <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 572:	02500713          	li	a4,37
 576:	18e78863          	beq	a5,a4,706 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57a:	02500593          	li	a1,37
 57e:	855a                	mv	a0,s6
 580:	e33ff0ef          	jal	3b2 <putc>
        putc(fd, c0);
 584:	85a6                	mv	a1,s1
 586:	855a                	mv	a0,s6
 588:	e2bff0ef          	jal	3b2 <putc>
      }

      state = 0;
 58c:	4981                	li	s3,0
 58e:	b71d                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 590:	008b8493          	addi	s1,s7,8
 594:	4685                	li	a3,1
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e33ff0ef          	jal	3d0 <printint>
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b739                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4685                	li	a3,1
 5ae:	4629                	li	a2,10
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e1bff0ef          	jal	3d0 <printint>
        i += 1;
 5ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bdd5                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e01ff0ef          	jal	3d0 <printint>
        i += 2;
 5d4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	bde9                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5dc:	008b8493          	addi	s1,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000be583          	lwu	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	de7ff0ef          	jal	3d0 <printint>
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b5c9                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4629                	li	a2,10
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	dcfff0ef          	jal	3d0 <printint>
        i += 1;
 606:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b565                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	db5ff0ef          	jal	3d0 <printint>
        i += 2;
 620:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	b579                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 628:	008b8493          	addi	s1,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000be583          	lwu	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	d9bff0ef          	jal	3d0 <printint>
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bd9d                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	008b8493          	addi	s1,s7,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	d83ff0ef          	jal	3d0 <printint>
        i += 1;
 652:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
 658:	bdb1                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4641                	li	a2,16
 660:	000bb583          	ld	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	d6bff0ef          	jal	3d0 <printint>
        i += 2;
 66a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66c:	8ba6                	mv	s7,s1
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	b591                	j	4b4 <vprintf+0x44>
 672:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 674:	008b8793          	addi	a5,s7,8
 678:	8cbe                	mv	s9,a5
 67a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67e:	03000593          	li	a1,48
 682:	855a                	mv	a0,s6
 684:	d2fff0ef          	jal	3b2 <putc>
  putc(fd, 'x');
 688:	07800593          	li	a1,120
 68c:	855a                	mv	a0,s6
 68e:	d25ff0ef          	jal	3b2 <putc>
 692:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 694:	00000b97          	auipc	s7,0x0
 698:	2acb8b93          	addi	s7,s7,684 # 940 <digits>
 69c:	03c9d793          	srli	a5,s3,0x3c
 6a0:	97de                	add	a5,a5,s7
 6a2:	0007c583          	lbu	a1,0(a5)
 6a6:	855a                	mv	a0,s6
 6a8:	d0bff0ef          	jal	3b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ac:	0992                	slli	s3,s3,0x4
 6ae:	34fd                	addiw	s1,s1,-1
 6b0:	f4f5                	bnez	s1,69c <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6b2:	8be6                	mv	s7,s9
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	6ca2                	ld	s9,8(sp)
 6b8:	bbf5                	j	4b4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ba:	008b8493          	addi	s1,s7,8
 6be:	000bc583          	lbu	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	cefff0ef          	jal	3b2 <putc>
 6c8:	8ba6                	mv	s7,s1
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b3e5                	j	4b4 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6ce:	008b8993          	addi	s3,s7,8
 6d2:	000bb483          	ld	s1,0(s7)
 6d6:	cc91                	beqz	s1,6f2 <vprintf+0x282>
        for (; *s; s++)
 6d8:	0004c583          	lbu	a1,0(s1)
 6dc:	c195                	beqz	a1,700 <vprintf+0x290>
          putc(fd, *s);
 6de:	855a                	mv	a0,s6
 6e0:	cd3ff0ef          	jal	3b2 <putc>
        for (; *s; s++)
 6e4:	0485                	addi	s1,s1,1
 6e6:	0004c583          	lbu	a1,0(s1)
 6ea:	f9f5                	bnez	a1,6de <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b3d1                	j	4b4 <vprintf+0x44>
          s = "(null)";
 6f2:	00000497          	auipc	s1,0x0
 6f6:	24648493          	addi	s1,s1,582 # 938 <malloc+0x114>
        for (; *s; s++)
 6fa:	02800593          	li	a1,40
 6fe:	b7c5                	j	6de <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	bb45                	j	4b4 <vprintf+0x44>
        putc(fd, '%');
 706:	85be                	mv	a1,a5
 708:	855a                	mv	a0,s6
 70a:	ca9ff0ef          	jal	3b2 <putc>
 70e:	bdbd                	j	58c <vprintf+0x11c>
 710:	6906                	ld	s2,64(sp)
 712:	79e2                	ld	s3,56(sp)
 714:	7a42                	ld	s4,48(sp)
 716:	7aa2                	ld	s5,40(sp)
 718:	7b02                	ld	s6,32(sp)
 71a:	6be2                	ld	s7,24(sp)
 71c:	6c42                	ld	s8,16(sp)
    }
  }
}
 71e:	60e6                	ld	ra,88(sp)
 720:	6446                	ld	s0,80(sp)
 722:	64a6                	ld	s1,72(sp)
 724:	6125                	addi	sp,sp,96
 726:	8082                	ret
      if (c0 == 'd') {
 728:	06400713          	li	a4,100
 72c:	e6e782e3          	beq	a5,a4,590 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 730:	f9478693          	addi	a3,a5,-108
 734:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 738:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 73a:	4701                	li	a4,0
 73c:	bbe9                	j	516 <vprintf+0xa6>

000000000000073e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73e:	715d                	addi	sp,sp,-80
 740:	ec06                	sd	ra,24(sp)
 742:	e822                	sd	s0,16(sp)
 744:	1000                	addi	s0,sp,32
 746:	e010                	sd	a2,0(s0)
 748:	e414                	sd	a3,8(s0)
 74a:	e818                	sd	a4,16(s0)
 74c:	ec1c                	sd	a5,24(s0)
 74e:	03043023          	sd	a6,32(s0)
 752:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 756:	8622                	mv	a2,s0
 758:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75c:	d15ff0ef          	jal	470 <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6161                	addi	sp,sp,80
 766:	8082                	ret

0000000000000768 <printf>:

void
printf(const char *fmt, ...)
{
 768:	711d                	addi	sp,sp,-96
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	addi	s0,sp,32
 770:	e40c                	sd	a1,8(s0)
 772:	e810                	sd	a2,16(s0)
 774:	ec14                	sd	a3,24(s0)
 776:	f018                	sd	a4,32(s0)
 778:	f41c                	sd	a5,40(s0)
 77a:	03043823          	sd	a6,48(s0)
 77e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 782:	00840613          	addi	a2,s0,8
 786:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78a:	85aa                	mv	a1,a0
 78c:	4505                	li	a0,1
 78e:	ce3ff0ef          	jal	470 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret

000000000000079a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79a:	1141                	addi	sp,sp,-16
 79c:	e406                	sd	ra,8(sp)
 79e:	e022                	sd	s0,0(sp)
 7a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7a2:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	00001797          	auipc	a5,0x1
 7aa:	85a7b783          	ld	a5,-1958(a5) # 1000 <freep>
 7ae:	a095                	j	812 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7b0:	ff852583          	lw	a1,-8(a0)
 7b4:	6390                	ld	a2,0(a5)
 7b6:	02059813          	slli	a6,a1,0x20
 7ba:	01c85693          	srli	a3,a6,0x1c
 7be:	96ba                	add	a3,a3,a4
 7c0:	02d60563          	beq	a2,a3,7ea <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7c8:	4790                	lw	a2,8(a5)
 7ca:	02061593          	slli	a1,a2,0x20
 7ce:	01c5d693          	srli	a3,a1,0x1c
 7d2:	96be                	add	a3,a3,a5
 7d4:	02d70263          	beq	a4,a3,7f8 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7d8:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7da:	00001717          	auipc	a4,0x1
 7de:	82f73323          	sd	a5,-2010(a4) # 1000 <freep>
}
 7e2:	60a2                	ld	ra,8(sp)
 7e4:	6402                	ld	s0,0(sp)
 7e6:	0141                	addi	sp,sp,16
 7e8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ea:	4614                	lw	a3,8(a2)
 7ec:	9ead                	addw	a3,a3,a1
 7ee:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	6394                	ld	a3,0(a5)
 7f4:	6290                	ld	a2,0(a3)
 7f6:	b7f9                	j	7c4 <free+0x2a>
    p->s.size += bp->s.size;
 7f8:	ff852703          	lw	a4,-8(a0)
 7fc:	9f31                	addw	a4,a4,a2
 7fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 800:	ff053703          	ld	a4,-16(a0)
 804:	bfd1                	j	7d8 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	6394                	ld	a3,0(a5)
 808:	00d7e463          	bltu	a5,a3,810 <free+0x76>
 80c:	fad762e3          	bltu	a4,a3,7b0 <free+0x16>
 810:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 812:	fee7fae3          	bgeu	a5,a4,806 <free+0x6c>
 816:	6394                	ld	a3,0(a5)
 818:	f8d76ce3          	bltu	a4,a3,7b0 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81c:	f8d7fae3          	bgeu	a5,a3,7b0 <free+0x16>
 820:	87b6                	mv	a5,a3
 822:	bfc5                	j	812 <free+0x78>

0000000000000824 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 824:	7139                	addi	sp,sp,-64
 826:	fc06                	sd	ra,56(sp)
 828:	f822                	sd	s0,48(sp)
 82a:	f04a                	sd	s2,32(sp)
 82c:	ec4e                	sd	s3,24(sp)
 82e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 830:	02051993          	slli	s3,a0,0x20
 834:	0209d993          	srli	s3,s3,0x20
 838:	09bd                	addi	s3,s3,15
 83a:	0049d993          	srli	s3,s3,0x4
 83e:	2985                	addiw	s3,s3,1
 840:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 842:	00000517          	auipc	a0,0x0
 846:	7be53503          	ld	a0,1982(a0) # 1000 <freep>
 84a:	c905                	beqz	a0,87a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 84c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 84e:	4798                	lw	a4,8(a5)
 850:	09377663          	bgeu	a4,s3,8dc <malloc+0xb8>
 854:	f426                	sd	s1,40(sp)
 856:	e852                	sd	s4,16(sp)
 858:	e456                	sd	s5,8(sp)
 85a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 85c:	8a4e                	mv	s4,s3
 85e:	6705                	lui	a4,0x1
 860:	00e9f363          	bgeu	s3,a4,866 <malloc+0x42>
 864:	6a05                	lui	s4,0x1
 866:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 86e:	00000497          	auipc	s1,0x0
 872:	79248493          	addi	s1,s1,1938 # 1000 <freep>
  if (p == SBRK_ERROR)
 876:	5afd                	li	s5,-1
 878:	a83d                	j	8b6 <malloc+0x92>
 87a:	f426                	sd	s1,40(sp)
 87c:	e852                	sd	s4,16(sp)
 87e:	e456                	sd	s5,8(sp)
 880:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 882:	00000797          	auipc	a5,0x0
 886:	78e78793          	addi	a5,a5,1934 # 1010 <base>
 88a:	00000717          	auipc	a4,0x0
 88e:	76f73b23          	sd	a5,1910(a4) # 1000 <freep>
 892:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 894:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 898:	b7d1                	j	85c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 89a:	6398                	ld	a4,0(a5)
 89c:	e118                	sd	a4,0(a0)
 89e:	a899                	j	8f4 <malloc+0xd0>
  hp->s.size = nu;
 8a0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8a4:	0541                	addi	a0,a0,16
 8a6:	ef5ff0ef          	jal	79a <free>
  return freep;
 8aa:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8ac:	c125                	beqz	a0,90c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ae:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b0:	4798                	lw	a4,8(a5)
 8b2:	03277163          	bgeu	a4,s2,8d4 <malloc+0xb0>
    if (p == freep)
 8b6:	6098                	ld	a4,0(s1)
 8b8:	853e                	mv	a0,a5
 8ba:	fef71ae3          	bne	a4,a5,8ae <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8be:	8552                	mv	a0,s4
 8c0:	a17ff0ef          	jal	2d6 <sbrk>
  if (p == SBRK_ERROR)
 8c4:	fd551ee3          	bne	a0,s5,8a0 <malloc+0x7c>
        return 0;
 8c8:	4501                	li	a0,0
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
 8d2:	a03d                	j	900 <malloc+0xdc>
 8d4:	74a2                	ld	s1,40(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8dc:	fae90fe3          	beq	s2,a4,89a <malloc+0x76>
        p->s.size -= nunits;
 8e0:	4137073b          	subw	a4,a4,s3
 8e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e6:	02071693          	slli	a3,a4,0x20
 8ea:	01c6d713          	srli	a4,a3,0x1c
 8ee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70a73623          	sd	a0,1804(a4) # 1000 <freep>
      return (void *)(p + 1);
 8fc:	01078513          	addi	a0,a5,16
  }
}
 900:	70e2                	ld	ra,56(sp)
 902:	7442                	ld	s0,48(sp)
 904:	7902                	ld	s2,32(sp)
 906:	69e2                	ld	s3,24(sp)
 908:	6121                	addi	sp,sp,64
 90a:	8082                	ret
 90c:	74a2                	ld	s1,40(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
 914:	b7f5                	j	900 <malloc+0xdc>
