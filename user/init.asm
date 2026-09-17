
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = {"sh", 0};

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if (open("console", O_RDWR) < 0) {
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	97250513          	addi	a0,a0,-1678 # 980 <malloc+0xf4>
  16:	39c000ef          	jal	3b2 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0); // stdout
  1e:	4501                	li	a0,0
  20:	3ca000ef          	jal	3ea <dup>
  dup(0); // stderr
  24:	4501                	li	a0,0
  26:	3c4000ef          	jal	3ea <dup>

  for (;;) {
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	95e90913          	addi	s2,s2,-1698 # 988 <malloc+0xfc>
  32:	854a                	mv	a0,s2
  34:	79c000ef          	jal	7d0 <printf>
    pid = fork();
  38:	332000ef          	jal	36a <fork>
  3c:	84aa                	mv	s1,a0
    if (pid < 0) {
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for (;;) {
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *)0);
  44:	4501                	li	a0,0
  46:	334000ef          	jal	37a <wait>
      if (wpid == pid) {
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if (wpid < 0) {
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	98650513          	addi	a0,a0,-1658 # 9d8 <malloc+0x14c>
  5a:	776000ef          	jal	7d0 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	312000ef          	jal	372 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	91850513          	addi	a0,a0,-1768 # 980 <malloc+0xf4>
  70:	34a000ef          	jal	3ba <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	90a50513          	addi	a0,a0,-1782 # 980 <malloc+0xf4>
  7e:	334000ef          	jal	3b2 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	91c50513          	addi	a0,a0,-1764 # 9a0 <malloc+0x114>
  8c:	744000ef          	jal	7d0 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2e0000ef          	jal	372 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	91a50513          	addi	a0,a0,-1766 # 9b8 <malloc+0x12c>
  a6:	304000ef          	jal	3aa <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	91650513          	addi	a0,a0,-1770 # 9c0 <malloc+0x134>
  b2:	71e000ef          	jal	7d0 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2ba000ef          	jal	372 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	0 <main>
  exit(r);
  c8:	2aa000ef          	jal	372 <exit>

00000000000000cc <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0xa>
    ;
  return os;
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x20>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x20>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x28>
 12a:	00150793          	addi	a5,a0,1
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x12>
 138:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 13c:	60a2                	ld	ra,8(sp)
 13e:	6402                	ld	s0,0(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  for (n = 0; s[n]; n++)
 144:	4501                	li	a0,0
 146:	bfdd                	j	13c <strlen+0x20>

0000000000000148 <memset>:

void *
memset(void *dst, int c, uint n)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 150:	ca19                	beqz	a2,166 <memset+0x1e>
 152:	87aa                	mv	a5,a0
 154:	1602                	slli	a2,a2,0x20
 156:	9201                	srli	a2,a2,0x20
 158:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 160:	0785                	addi	a5,a5,1
 162:	fee79de3          	bne	a5,a4,15c <memset+0x14>
  }
  return dst;
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strchr>:

char *
strchr(const char *s, char c)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  for (; *s; s++)
 176:	00054783          	lbu	a5,0(a0)
 17a:	c799                	beqz	a5,188 <strchr+0x1a>
    if (*s == c)
 17c:	00f58763          	beq	a1,a5,18a <strchr+0x1c>
  for (; *s; s++)
 180:	0505                	addi	a0,a0,1
 182:	00054783          	lbu	a5,0(a0)
 186:	fbfd                	bnez	a5,17c <strchr+0xe>
      return (char *)s;
  return 0;
 188:	4501                	li	a0,0
}
 18a:	60a2                	ld	ra,8(sp)
 18c:	6402                	ld	s0,0(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret

0000000000000192 <gets>:

char *
gets(char *buf, int max)
{
 192:	711d                	addi	sp,sp,-96
 194:	ec86                	sd	ra,88(sp)
 196:	e8a2                	sd	s0,80(sp)
 198:	e4a6                	sd	s1,72(sp)
 19a:	e0ca                	sd	s2,64(sp)
 19c:	fc4e                	sd	s3,56(sp)
 19e:	f852                	sd	s4,48(sp)
 1a0:	f456                	sd	s5,40(sp)
 1a2:	f05a                	sd	s6,32(sp)
 1a4:	ec5e                	sd	s7,24(sp)
 1a6:	e862                	sd	s8,16(sp)
 1a8:	1080                	addi	s0,sp,96
 1aa:	8baa                	mv	s7,a0
 1ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1ae:	892a                	mv	s2,a0
 1b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b2:	faf40b13          	addi	s6,s0,-81
 1b6:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1b8:	8c26                	mv	s8,s1
 1ba:	0014899b          	addiw	s3,s1,1
 1be:	84ce                	mv	s1,s3
 1c0:	0349d863          	bge	s3,s4,1f0 <gets+0x5e>
    cc = read(0, &c, 1);
 1c4:	8656                	mv	a2,s5
 1c6:	85da                	mv	a1,s6
 1c8:	4501                	li	a0,0
 1ca:	1c0000ef          	jal	38a <read>
    if (cc < 1)
 1ce:	02a05163          	blez	a0,1f0 <gets+0x5e>
      break;
    buf[i++] = c;
 1d2:	faf44783          	lbu	a5,-81(s0)
 1d6:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1da:	0905                	addi	s2,s2,1
 1dc:	ff678713          	addi	a4,a5,-10
 1e0:	00173713          	seqz	a4,a4
 1e4:	17cd                	addi	a5,a5,-13
 1e6:	0017b793          	seqz	a5,a5
 1ea:	8fd9                	or	a5,a5,a4
 1ec:	d7f1                	beqz	a5,1b8 <gets+0x26>
    buf[i++] = c;
 1ee:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1f0:	9c5e                	add	s8,s8,s7
 1f2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1f6:	855e                	mv	a0,s7
 1f8:	60e6                	ld	ra,88(sp)
 1fa:	6446                	ld	s0,80(sp)
 1fc:	64a6                	ld	s1,72(sp)
 1fe:	6906                	ld	s2,64(sp)
 200:	79e2                	ld	s3,56(sp)
 202:	7a42                	ld	s4,48(sp)
 204:	7aa2                	ld	s5,40(sp)
 206:	7b02                	ld	s6,32(sp)
 208:	6be2                	ld	s7,24(sp)
 20a:	6c42                	ld	s8,16(sp)
 20c:	6125                	addi	sp,sp,96
 20e:	8082                	ret

0000000000000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	1101                	addi	sp,sp,-32
 212:	ec06                	sd	ra,24(sp)
 214:	e822                	sd	s0,16(sp)
 216:	e04a                	sd	s2,0(sp)
 218:	1000                	addi	s0,sp,32
 21a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21c:	4581                	li	a1,0
 21e:	194000ef          	jal	3b2 <open>
  if (fd < 0)
 222:	02054263          	bltz	a0,246 <stat+0x36>
 226:	e426                	sd	s1,8(sp)
 228:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22a:	85ca                	mv	a1,s2
 22c:	19e000ef          	jal	3ca <fstat>
 230:	892a                	mv	s2,a0
  close(fd);
 232:	8526                	mv	a0,s1
 234:	166000ef          	jal	39a <close>
  return r;
 238:	64a2                	ld	s1,8(sp)
}
 23a:	854a                	mv	a0,s2
 23c:	60e2                	ld	ra,24(sp)
 23e:	6442                	ld	s0,16(sp)
 240:	6902                	ld	s2,0(sp)
 242:	6105                	addi	sp,sp,32
 244:	8082                	ret
    return -1;
 246:	57fd                	li	a5,-1
 248:	893e                	mv	s2,a5
 24a:	bfc5                	j	23a <stat+0x2a>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 254:	00054683          	lbu	a3,0(a0)
 258:	fd06879b          	addiw	a5,a3,-48
 25c:	0ff7f793          	zext.b	a5,a5
 260:	4625                	li	a2,9
 262:	02f66963          	bltu	a2,a5,294 <atoi+0x48>
 266:	872a                	mv	a4,a0
  n = 0;
 268:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 26a:	0705                	addi	a4,a4,1
 26c:	0025179b          	slliw	a5,a0,0x2
 270:	9fa9                	addw	a5,a5,a0
 272:	0017979b          	slliw	a5,a5,0x1
 276:	9fb5                	addw	a5,a5,a3
 278:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 27c:	00074683          	lbu	a3,0(a4)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	fef671e3          	bgeu	a2,a5,26a <atoi+0x1e>
  return n;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  n = 0;
 294:	4501                	li	a0,0
 296:	bfdd                	j	28c <atoi+0x40>

0000000000000298 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e406                	sd	ra,8(sp)
 29c:	e022                	sd	s0,0(sp)
 29e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a0:	02b57563          	bgeu	a0,a1,2ca <memmove+0x32>
    while (n-- > 0)
 2a4:	00c05f63          	blez	a2,2c2 <memmove+0x2a>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b2:	0585                	addi	a1,a1,1
 2b4:	0705                	addi	a4,a4,1
 2b6:	fff5c683          	lbu	a3,-1(a1)
 2ba:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2be:	fee79ae3          	bne	a5,a4,2b2 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
    while (n-- > 0)
 2ca:	fec05ce3          	blez	a2,2c2 <memmove+0x2a>
    dst += n;
 2ce:	00c50733          	add	a4,a0,a2
    src += n;
 2d2:	95b2                	add	a1,a1,a2
 2d4:	fff6079b          	addiw	a5,a2,-1
 2d8:	1782                	slli	a5,a5,0x20
 2da:	9381                	srli	a5,a5,0x20
 2dc:	fff7c793          	not	a5,a5
 2e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e2:	15fd                	addi	a1,a1,-1
 2e4:	177d                	addi	a4,a4,-1
 2e6:	0005c683          	lbu	a3,0(a1)
 2ea:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2ee:	fef71ae3          	bne	a4,a5,2e2 <memmove+0x4a>
 2f2:	bfc1                	j	2c2 <memmove+0x2a>

00000000000002f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fc:	ce19                	beqz	a2,31a <memcmp+0x26>
 2fe:	1602                	slli	a2,a2,0x20
 300:	9201                	srli	a2,a2,0x20
 302:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 306:	00054783          	lbu	a5,0(a0)
 30a:	0005c703          	lbu	a4,0(a1)
 30e:	00e79b63          	bne	a5,a4,324 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 312:	0505                	addi	a0,a0,1
    p2++;
 314:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 316:	fed518e3          	bne	a0,a3,306 <memcmp+0x12>
  }
  return 0;
 31a:	4501                	li	a0,0
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
      return *p1 - *p2;
 324:	40e7853b          	subw	a0,a5,a4
 328:	bfd5                	j	31c <memcmp+0x28>

000000000000032a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 332:	f67ff0ef          	jal	298 <memmove>
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <sbrk>:

char *
sbrk(int n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 346:	4585                	li	a1,1
 348:	0b2000ef          	jal	3fa <sys_sbrk>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <sbrklazy>:

char *
sbrklazy(int n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 35c:	4589                	li	a1,2
 35e:	09c000ef          	jal	3fa <sys_sbrk>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36a:	4885                	li	a7,1
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <exit>:
.global exit
exit:
 li a7, SYS_exit
 372:	4889                	li	a7,2
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <wait>:
.global wait
wait:
 li a7, SYS_wait
 37a:	488d                	li	a7,3
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 382:	4891                	li	a7,4
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <read>:
.global read
read:
 li a7, SYS_read
 38a:	4895                	li	a7,5
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <write>:
.global write
write:
 li a7, SYS_write
 392:	48c1                	li	a7,16
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <close>:
.global close
close:
 li a7, SYS_close
 39a:	48d5                	li	a7,21
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a2:	4899                	li	a7,6
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3aa:	489d                	li	a7,7
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <open>:
.global open
open:
 li a7, SYS_open
 3b2:	48bd                	li	a7,15
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ba:	48c5                	li	a7,17
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c2:	48c9                	li	a7,18
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ca:	48a1                	li	a7,8
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <link>:
.global link
link:
 li a7, SYS_link
 3d2:	48cd                	li	a7,19
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3da:	48d1                	li	a7,20
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e2:	48a5                	li	a7,9
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ea:	48a9                	li	a7,10
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f2:	48ad                	li	a7,11
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3fa:	48b1                	li	a7,12
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <pause>:
.global pause
pause:
 li a7, SYS_pause
 402:	48b5                	li	a7,13
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40a:	48b9                	li	a7,14
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sync>:
.global sync
sync:
 li a7, SYS_sync
 412:	48d9                	li	a7,22
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	1000                	addi	s0,sp,32
 422:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 426:	4605                	li	a2,1
 428:	fef40593          	addi	a1,s0,-17
 42c:	f67ff0ef          	jal	392 <write>
}
 430:	60e2                	ld	ra,24(sp)
 432:	6442                	ld	s0,16(sp)
 434:	6105                	addi	sp,sp,32
 436:	8082                	ret

0000000000000438 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 438:	715d                	addi	sp,sp,-80
 43a:	e486                	sd	ra,72(sp)
 43c:	e0a2                	sd	s0,64(sp)
 43e:	f84a                	sd	s2,48(sp)
 440:	f44e                	sd	s3,40(sp)
 442:	0880                	addi	s0,sp,80
 444:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 446:	00d036b3          	snez	a3,a3
 44a:	03f5d793          	srli	a5,a1,0x3f
 44e:	8efd                	and	a3,a3,a5
  neg = 0;
 450:	4301                	li	t1,0
  if (sgn && xx < 0) {
 452:	c681                	beqz	a3,45a <printint+0x22>
    neg = 1;
    x = -xx;
 454:	40b005b3          	neg	a1,a1
    neg = 1;
 458:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 45a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 45e:	86ce                	mv	a3,s3
  i = 0;
 460:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 462:	00000817          	auipc	a6,0x0
 466:	59e80813          	addi	a6,a6,1438 # a00 <digits>
 46a:	88ba                	mv	a7,a4
 46c:	0017051b          	addiw	a0,a4,1
 470:	872a                	mv	a4,a0
 472:	02c5f7b3          	remu	a5,a1,a2
 476:	97c2                	add	a5,a5,a6
 478:	0007c783          	lbu	a5,0(a5)
 47c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 480:	87ae                	mv	a5,a1
 482:	02c5d5b3          	divu	a1,a1,a2
 486:	0685                	addi	a3,a3,1
 488:	fec7f1e3          	bgeu	a5,a2,46a <printint+0x32>
  if (neg)
 48c:	00030b63          	beqz	t1,4a2 <printint+0x6a>
    buf[i++] = '-';
 490:	fd040793          	addi	a5,s0,-48
 494:	953e                	add	a0,a0,a5
 496:	02d00793          	li	a5,45
 49a:	fef50423          	sb	a5,-24(a0)
 49e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4a2:	02e05563          	blez	a4,4cc <printint+0x94>
 4a6:	fc26                	sd	s1,56(sp)
 4a8:	377d                	addiw	a4,a4,-1
 4aa:	00e984b3          	add	s1,s3,a4
 4ae:	19fd                	addi	s3,s3,-1
 4b0:	99ba                	add	s3,s3,a4
 4b2:	1702                	slli	a4,a4,0x20
 4b4:	9301                	srli	a4,a4,0x20
 4b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ba:	0004c583          	lbu	a1,0(s1)
 4be:	854a                	mv	a0,s2
 4c0:	f5bff0ef          	jal	41a <putc>
  while (--i >= 0)
 4c4:	14fd                	addi	s1,s1,-1
 4c6:	ff349ae3          	bne	s1,s3,4ba <printint+0x82>
 4ca:	74e2                	ld	s1,56(sp)
}
 4cc:	60a6                	ld	ra,72(sp)
 4ce:	6406                	ld	s0,64(sp)
 4d0:	7942                	ld	s2,48(sp)
 4d2:	79a2                	ld	s3,40(sp)
 4d4:	6161                	addi	sp,sp,80
 4d6:	8082                	ret

00000000000004d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d8:	711d                	addi	sp,sp,-96
 4da:	ec86                	sd	ra,88(sp)
 4dc:	e8a2                	sd	s0,80(sp)
 4de:	e4a6                	sd	s1,72(sp)
 4e0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4e2:	0005c483          	lbu	s1,0(a1)
 4e6:	2a048063          	beqz	s1,786 <vprintf+0x2ae>
 4ea:	e0ca                	sd	s2,64(sp)
 4ec:	fc4e                	sd	s3,56(sp)
 4ee:	f852                	sd	s4,48(sp)
 4f0:	f456                	sd	s5,40(sp)
 4f2:	f05a                	sd	s6,32(sp)
 4f4:	ec5e                	sd	s7,24(sp)
 4f6:	e862                	sd	s8,16(sp)
 4f8:	8b2a                	mv	s6,a0
 4fa:	8a2e                	mv	s4,a1
 4fc:	8bb2                	mv	s7,a2
  state = 0;
 4fe:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 500:	4901                	li	s2,0
 502:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 504:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 508:	06400c13          	li	s8,100
 50c:	a00d                	j	52e <vprintf+0x56>
        putc(fd, c0);
 50e:	85a6                	mv	a1,s1
 510:	855a                	mv	a0,s6
 512:	f09ff0ef          	jal	41a <putc>
 516:	a019                	j	51c <vprintf+0x44>
    } else if (state == '%') {
 518:	03598363          	beq	s3,s5,53e <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 51c:	0019079b          	addiw	a5,s2,1
 520:	893e                	mv	s2,a5
 522:	873e                	mv	a4,a5
 524:	97d2                	add	a5,a5,s4
 526:	0007c483          	lbu	s1,0(a5)
 52a:	24048763          	beqz	s1,778 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 52e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 532:	fe0993e3          	bnez	s3,518 <vprintf+0x40>
      if (c0 == '%') {
 536:	fd579ce3          	bne	a5,s5,50e <vprintf+0x36>
        state = '%';
 53a:	89be                	mv	s3,a5
 53c:	b7c5                	j	51c <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 53e:	00ea06b3          	add	a3,s4,a4
 542:	0016c603          	lbu	a2,1(a3)
      if (c1)
 546:	24060563          	beqz	a2,790 <vprintf+0x2b8>
      if (c0 == 'd') {
 54a:	0b878763          	beq	a5,s8,5f8 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 54e:	f9478693          	addi	a3,a5,-108
 552:	0016b693          	seqz	a3,a3
 556:	f9c60593          	addi	a1,a2,-100
 55a:	0015b593          	seqz	a1,a1
 55e:	8df5                	and	a1,a1,a3
 560:	e9c5                	bnez	a1,610 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 562:	9752                	add	a4,a4,s4
 564:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 568:	f9460713          	addi	a4,a2,-108
 56c:	00173713          	seqz	a4,a4
 570:	8f75                	and	a4,a4,a3
 572:	f9c50593          	addi	a1,a0,-100
 576:	0015b593          	seqz	a1,a1
 57a:	8df9                	and	a1,a1,a4
 57c:	e5dd                	bnez	a1,62a <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 57e:	07500593          	li	a1,117
 582:	0cb78163          	beq	a5,a1,644 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 586:	f8b60593          	addi	a1,a2,-117
 58a:	0015b593          	seqz	a1,a1
 58e:	8df5                	and	a1,a1,a3
 590:	e5f1                	bnez	a1,65c <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 592:	f8b50593          	addi	a1,a0,-117
 596:	0015b593          	seqz	a1,a1
 59a:	8df9                	and	a1,a1,a4
 59c:	ede9                	bnez	a1,676 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 59e:	07800593          	li	a1,120
 5a2:	0eb78763          	beq	a5,a1,690 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5a6:	f8860613          	addi	a2,a2,-120
 5aa:	00163613          	seqz	a2,a2
 5ae:	8ef1                	and	a3,a3,a2
 5b0:	0e069c63          	bnez	a3,6a8 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5b4:	f8850513          	addi	a0,a0,-120
 5b8:	00153513          	seqz	a0,a0
 5bc:	8f69                	and	a4,a4,a0
 5be:	10071263          	bnez	a4,6c2 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5c2:	07000713          	li	a4,112
 5c6:	10e78a63          	beq	a5,a4,6da <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5ca:	06300713          	li	a4,99
 5ce:	14e78a63          	beq	a5,a4,722 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5d2:	07300713          	li	a4,115
 5d6:	16e78063          	beq	a5,a4,736 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5da:	02500713          	li	a4,37
 5de:	18e78863          	beq	a5,a4,76e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e2:	02500593          	li	a1,37
 5e6:	855a                	mv	a0,s6
 5e8:	e33ff0ef          	jal	41a <putc>
        putc(fd, c0);
 5ec:	85a6                	mv	a1,s1
 5ee:	855a                	mv	a0,s6
 5f0:	e2bff0ef          	jal	41a <putc>
      }

      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b71d                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e33ff0ef          	jal	438 <printint>
 60a:	8ba6                	mv	s7,s1
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b739                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 610:	008b8493          	addi	s1,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e1bff0ef          	jal	438 <printint>
        i += 1;
 622:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
 628:	bdd5                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e01ff0ef          	jal	438 <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bde9                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000be583          	lwu	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	de7ff0ef          	jal	438 <printint>
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
 65a:	b5c9                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	008b8493          	addi	s1,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dcfff0ef          	jal	438 <printint>
        i += 1;
 66e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	b565                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	008b8493          	addi	s1,s7,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	db5ff0ef          	jal	438 <printint>
        i += 2;
 688:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
        i += 2;
 68e:	b579                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000be583          	lwu	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d9bff0ef          	jal	438 <printint>
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bd9d                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	008b8493          	addi	s1,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000bb583          	ld	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d83ff0ef          	jal	438 <printint>
        i += 1;
 6ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bdb1                	j	51c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	008b8493          	addi	s1,s7,8
 6c6:	4641                	li	a2,16
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d6bff0ef          	jal	438 <printint>
        i += 2;
 6d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	8ba6                	mv	s7,s1
      state = 0;
 6d6:	4981                	li	s3,0
        i += 2;
 6d8:	b591                	j	51c <vprintf+0x44>
 6da:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6dc:	008b8793          	addi	a5,s7,8
 6e0:	8cbe                	mv	s9,a5
 6e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e6:	03000593          	li	a1,48
 6ea:	855a                	mv	a0,s6
 6ec:	d2fff0ef          	jal	41a <putc>
  putc(fd, 'x');
 6f0:	07800593          	li	a1,120
 6f4:	855a                	mv	a0,s6
 6f6:	d25ff0ef          	jal	41a <putc>
 6fa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fc:	00000b97          	auipc	s7,0x0
 700:	304b8b93          	addi	s7,s7,772 # a00 <digits>
 704:	03c9d793          	srli	a5,s3,0x3c
 708:	97de                	add	a5,a5,s7
 70a:	0007c583          	lbu	a1,0(a5)
 70e:	855a                	mv	a0,s6
 710:	d0bff0ef          	jal	41a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 714:	0992                	slli	s3,s3,0x4
 716:	34fd                	addiw	s1,s1,-1
 718:	f4f5                	bnez	s1,704 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 71a:	8be6                	mv	s7,s9
      state = 0;
 71c:	4981                	li	s3,0
 71e:	6ca2                	ld	s9,8(sp)
 720:	bbf5                	j	51c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 722:	008b8493          	addi	s1,s7,8
 726:	000bc583          	lbu	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	cefff0ef          	jal	41a <putc>
 730:	8ba6                	mv	s7,s1
      state = 0;
 732:	4981                	li	s3,0
 734:	b3e5                	j	51c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 736:	008b8993          	addi	s3,s7,8
 73a:	000bb483          	ld	s1,0(s7)
 73e:	cc91                	beqz	s1,75a <vprintf+0x282>
        for (; *s; s++)
 740:	0004c583          	lbu	a1,0(s1)
 744:	c195                	beqz	a1,768 <vprintf+0x290>
          putc(fd, *s);
 746:	855a                	mv	a0,s6
 748:	cd3ff0ef          	jal	41a <putc>
        for (; *s; s++)
 74c:	0485                	addi	s1,s1,1
 74e:	0004c583          	lbu	a1,0(s1)
 752:	f9f5                	bnez	a1,746 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 754:	8bce                	mv	s7,s3
      state = 0;
 756:	4981                	li	s3,0
 758:	b3d1                	j	51c <vprintf+0x44>
          s = "(null)";
 75a:	00000497          	auipc	s1,0x0
 75e:	29e48493          	addi	s1,s1,670 # 9f8 <malloc+0x16c>
        for (; *s; s++)
 762:	02800593          	li	a1,40
 766:	b7c5                	j	746 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 768:	8bce                	mv	s7,s3
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bb45                	j	51c <vprintf+0x44>
        putc(fd, '%');
 76e:	85be                	mv	a1,a5
 770:	855a                	mv	a0,s6
 772:	ca9ff0ef          	jal	41a <putc>
 776:	bdbd                	j	5f4 <vprintf+0x11c>
 778:	6906                	ld	s2,64(sp)
 77a:	79e2                	ld	s3,56(sp)
 77c:	7a42                	ld	s4,48(sp)
 77e:	7aa2                	ld	s5,40(sp)
 780:	7b02                	ld	s6,32(sp)
 782:	6be2                	ld	s7,24(sp)
 784:	6c42                	ld	s8,16(sp)
    }
  }
}
 786:	60e6                	ld	ra,88(sp)
 788:	6446                	ld	s0,80(sp)
 78a:	64a6                	ld	s1,72(sp)
 78c:	6125                	addi	sp,sp,96
 78e:	8082                	ret
      if (c0 == 'd') {
 790:	06400713          	li	a4,100
 794:	e6e782e3          	beq	a5,a4,5f8 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 798:	f9478693          	addi	a3,a5,-108
 79c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7a0:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7a2:	4701                	li	a4,0
 7a4:	bbe9                	j	57e <vprintf+0xa6>

00000000000007a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a6:	715d                	addi	sp,sp,-80
 7a8:	ec06                	sd	ra,24(sp)
 7aa:	e822                	sd	s0,16(sp)
 7ac:	1000                	addi	s0,sp,32
 7ae:	e010                	sd	a2,0(s0)
 7b0:	e414                	sd	a3,8(s0)
 7b2:	e818                	sd	a4,16(s0)
 7b4:	ec1c                	sd	a5,24(s0)
 7b6:	03043023          	sd	a6,32(s0)
 7ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7be:	8622                	mv	a2,s0
 7c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c4:	d15ff0ef          	jal	4d8 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6161                	addi	sp,sp,80
 7ce:	8082                	ret

00000000000007d0 <printf>:

void
printf(const char *fmt, ...)
{
 7d0:	711d                	addi	sp,sp,-96
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e40c                	sd	a1,8(s0)
 7da:	e810                	sd	a2,16(s0)
 7dc:	ec14                	sd	a3,24(s0)
 7de:	f018                	sd	a4,32(s0)
 7e0:	f41c                	sd	a5,40(s0)
 7e2:	03043823          	sd	a6,48(s0)
 7e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ea:	00840613          	addi	a2,s0,8
 7ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f2:	85aa                	mv	a1,a0
 7f4:	4505                	li	a0,1
 7f6:	ce3ff0ef          	jal	4d8 <vprintf>
}
 7fa:	60e2                	ld	ra,24(sp)
 7fc:	6442                	ld	s0,16(sp)
 7fe:	6125                	addi	sp,sp,96
 800:	8082                	ret

0000000000000802 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 802:	1141                	addi	sp,sp,-16
 804:	e406                	sd	ra,8(sp)
 806:	e022                	sd	s0,0(sp)
 808:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 80a:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	00001797          	auipc	a5,0x1
 812:	8027b783          	ld	a5,-2046(a5) # 1010 <freep>
 816:	a095                	j	87a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 818:	ff852583          	lw	a1,-8(a0)
 81c:	6390                	ld	a2,0(a5)
 81e:	02059813          	slli	a6,a1,0x20
 822:	01c85693          	srli	a3,a6,0x1c
 826:	96ba                	add	a3,a3,a4
 828:	02d60563          	beq	a2,a3,852 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 830:	4790                	lw	a2,8(a5)
 832:	02061593          	slli	a1,a2,0x20
 836:	01c5d693          	srli	a3,a1,0x1c
 83a:	96be                	add	a3,a3,a5
 83c:	02d70263          	beq	a4,a3,860 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 840:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 842:	00000717          	auipc	a4,0x0
 846:	7cf73723          	sd	a5,1998(a4) # 1010 <freep>
}
 84a:	60a2                	ld	ra,8(sp)
 84c:	6402                	ld	s0,0(sp)
 84e:	0141                	addi	sp,sp,16
 850:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 852:	4614                	lw	a3,8(a2)
 854:	9ead                	addw	a3,a3,a1
 856:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 85a:	6394                	ld	a3,0(a5)
 85c:	6290                	ld	a2,0(a3)
 85e:	b7f9                	j	82c <free+0x2a>
    p->s.size += bp->s.size;
 860:	ff852703          	lw	a4,-8(a0)
 864:	9f31                	addw	a4,a4,a2
 866:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 868:	ff053703          	ld	a4,-16(a0)
 86c:	bfd1                	j	840 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86e:	6394                	ld	a3,0(a5)
 870:	00d7e463          	bltu	a5,a3,878 <free+0x76>
 874:	fad762e3          	bltu	a4,a3,818 <free+0x16>
 878:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	fee7fae3          	bgeu	a5,a4,86e <free+0x6c>
 87e:	6394                	ld	a3,0(a5)
 880:	f8d76ce3          	bltu	a4,a3,818 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	f8d7fae3          	bgeu	a5,a3,818 <free+0x16>
 888:	87b6                	mv	a5,a3
 88a:	bfc5                	j	87a <free+0x78>

000000000000088c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 88c:	7139                	addi	sp,sp,-64
 88e:	fc06                	sd	ra,56(sp)
 890:	f822                	sd	s0,48(sp)
 892:	f04a                	sd	s2,32(sp)
 894:	ec4e                	sd	s3,24(sp)
 896:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 898:	02051993          	slli	s3,a0,0x20
 89c:	0209d993          	srli	s3,s3,0x20
 8a0:	09bd                	addi	s3,s3,15
 8a2:	0049d993          	srli	s3,s3,0x4
 8a6:	2985                	addiw	s3,s3,1
 8a8:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8aa:	00000517          	auipc	a0,0x0
 8ae:	76653503          	ld	a0,1894(a0) # 1010 <freep>
 8b2:	c905                	beqz	a0,8e2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b6:	4798                	lw	a4,8(a5)
 8b8:	09377663          	bgeu	a4,s3,944 <malloc+0xb8>
 8bc:	f426                	sd	s1,40(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8c4:	8a4e                	mv	s4,s3
 8c6:	6705                	lui	a4,0x1
 8c8:	00e9f363          	bgeu	s3,a4,8ce <malloc+0x42>
 8cc:	6a05                	lui	s4,0x1
 8ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8d6:	00000497          	auipc	s1,0x0
 8da:	73a48493          	addi	s1,s1,1850 # 1010 <freep>
  if (p == SBRK_ERROR)
 8de:	5afd                	li	s5,-1
 8e0:	a83d                	j	91e <malloc+0x92>
 8e2:	f426                	sd	s1,40(sp)
 8e4:	e852                	sd	s4,16(sp)
 8e6:	e456                	sd	s5,8(sp)
 8e8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ea:	00000797          	auipc	a5,0x0
 8ee:	73678793          	addi	a5,a5,1846 # 1020 <base>
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70f73f23          	sd	a5,1822(a4) # 1010 <freep>
 8fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 900:	b7d1                	j	8c4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 902:	6398                	ld	a4,0(a5)
 904:	e118                	sd	a4,0(a0)
 906:	a899                	j	95c <malloc+0xd0>
  hp->s.size = nu;
 908:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 90c:	0541                	addi	a0,a0,16
 90e:	ef5ff0ef          	jal	802 <free>
  return freep;
 912:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 914:	c125                	beqz	a0,974 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 916:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 918:	4798                	lw	a4,8(a5)
 91a:	03277163          	bgeu	a4,s2,93c <malloc+0xb0>
    if (p == freep)
 91e:	6098                	ld	a4,0(s1)
 920:	853e                	mv	a0,a5
 922:	fef71ae3          	bne	a4,a5,916 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 926:	8552                	mv	a0,s4
 928:	a17ff0ef          	jal	33e <sbrk>
  if (p == SBRK_ERROR)
 92c:	fd551ee3          	bne	a0,s5,908 <malloc+0x7c>
        return 0;
 930:	4501                	li	a0,0
 932:	74a2                	ld	s1,40(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
 93a:	a03d                	j	968 <malloc+0xdc>
 93c:	74a2                	ld	s1,40(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 944:	fae90fe3          	beq	s2,a4,902 <malloc+0x76>
        p->s.size -= nunits;
 948:	4137073b          	subw	a4,a4,s3
 94c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94e:	02071693          	slli	a3,a4,0x20
 952:	01c6d713          	srli	a4,a3,0x1c
 956:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 958:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 95c:	00000717          	auipc	a4,0x0
 960:	6aa73a23          	sd	a0,1716(a4) # 1010 <freep>
      return (void *)(p + 1);
 964:	01078513          	addi	a0,a5,16
  }
}
 968:	70e2                	ld	ra,56(sp)
 96a:	7442                	ld	s0,48(sp)
 96c:	7902                	ld	s2,32(sp)
 96e:	69e2                	ld	s3,24(sp)
 970:	6121                	addi	sp,sp,64
 972:	8082                	ret
 974:	74a2                	ld	s1,40(sp)
 976:	6a42                	ld	s4,16(sp)
 978:	6aa2                	ld	s5,8(sp)
 97a:	6b02                	ld	s6,0(sp)
 97c:	b7f5                	j	968 <malloc+0xdc>
