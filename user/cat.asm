
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	ff890913          	addi	s2,s2,-8 # 1010 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	39c000ef          	jal	3c4 <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	394000ef          	jal	3cc <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	98058593          	addi	a1,a1,-1664 # 9c0 <malloc+0xfa>
  48:	4509                	li	a0,2
  4a:	796000ef          	jal	7e0 <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	35c000ef          	jal	3ac <exit>
    }
  }
  if (n < 0) {
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	96e58593          	addi	a1,a1,-1682 # 9d8 <malloc+0x112>
  72:	4509                	li	a0,2
  74:	76c000ef          	jal	7e0 <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	332000ef          	jal	3ac <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	340000ef          	jal	3ec <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	318000ef          	jal	3d4 <close>
  for (i = 1; i < argc; i++) {
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2e4000ef          	jal	3ac <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2d2000ef          	jal	3ac <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	90e58593          	addi	a1,a1,-1778 # 9f0 <malloc+0x12a>
  ea:	4509                	li	a0,2
  ec:	6f4000ef          	jal	7e0 <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2ba000ef          	jal	3ac <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fe:	f81ff0ef          	jal	7e <main>
  exit(r);
 102:	2aa000ef          	jal	3ac <exit>

0000000000000106 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0xa>
    ;
  return os;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x20>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x20>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x28>
 164:	00150793          	addi	a5,a0,1
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x12>
 172:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for (n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfdd                	j	176 <strlen+0x20>

0000000000000182 <memset>:

void *
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 18a:	ca19                	beqz	a2,1a0 <memset+0x1e>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x14>
  }
  return dst;
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char *
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e406                	sd	ra,8(sp)
 1ac:	e022                	sd	s0,0(sp)
 1ae:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	c799                	beqz	a5,1c2 <strchr+0x1a>
    if (*s == c)
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1c>
  for (; *s; s++)
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xe>
      return (char *)s;
  return 0;
 1c2:	4501                	li	a0,0
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <gets>:

char *
gets(char *buf, int max)
{
 1cc:	711d                	addi	sp,sp,-96
 1ce:	ec86                	sd	ra,88(sp)
 1d0:	e8a2                	sd	s0,80(sp)
 1d2:	e4a6                	sd	s1,72(sp)
 1d4:	e0ca                	sd	s2,64(sp)
 1d6:	fc4e                	sd	s3,56(sp)
 1d8:	f852                	sd	s4,48(sp)
 1da:	f456                	sd	s5,40(sp)
 1dc:	f05a                	sd	s6,32(sp)
 1de:	ec5e                	sd	s7,24(sp)
 1e0:	e862                	sd	s8,16(sp)
 1e2:	1080                	addi	s0,sp,96
 1e4:	8baa                	mv	s7,a0
 1e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1e8:	892a                	mv	s2,a0
 1ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ec:	faf40b13          	addi	s6,s0,-81
 1f0:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1f2:	8c26                	mv	s8,s1
 1f4:	0014899b          	addiw	s3,s1,1
 1f8:	84ce                	mv	s1,s3
 1fa:	0349d863          	bge	s3,s4,22a <gets+0x5e>
    cc = read(0, &c, 1);
 1fe:	8656                	mv	a2,s5
 200:	85da                	mv	a1,s6
 202:	4501                	li	a0,0
 204:	1c0000ef          	jal	3c4 <read>
    if (cc < 1)
 208:	02a05163          	blez	a0,22a <gets+0x5e>
      break;
    buf[i++] = c;
 20c:	faf44783          	lbu	a5,-81(s0)
 210:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 214:	0905                	addi	s2,s2,1
 216:	ff678713          	addi	a4,a5,-10
 21a:	00173713          	seqz	a4,a4
 21e:	17cd                	addi	a5,a5,-13
 220:	0017b793          	seqz	a5,a5
 224:	8fd9                	or	a5,a5,a4
 226:	d7f1                	beqz	a5,1f2 <gets+0x26>
    buf[i++] = c;
 228:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 22a:	9c5e                	add	s8,s8,s7
 22c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 230:	855e                	mv	a0,s7
 232:	60e6                	ld	ra,88(sp)
 234:	6446                	ld	s0,80(sp)
 236:	64a6                	ld	s1,72(sp)
 238:	6906                	ld	s2,64(sp)
 23a:	79e2                	ld	s3,56(sp)
 23c:	7a42                	ld	s4,48(sp)
 23e:	7aa2                	ld	s5,40(sp)
 240:	7b02                	ld	s6,32(sp)
 242:	6be2                	ld	s7,24(sp)
 244:	6c42                	ld	s8,16(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e04a                	sd	s2,0(sp)
 252:	1000                	addi	s0,sp,32
 254:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	4581                	li	a1,0
 258:	194000ef          	jal	3ec <open>
  if (fd < 0)
 25c:	02054263          	bltz	a0,280 <stat+0x36>
 260:	e426                	sd	s1,8(sp)
 262:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 264:	85ca                	mv	a1,s2
 266:	19e000ef          	jal	404 <fstat>
 26a:	892a                	mv	s2,a0
  close(fd);
 26c:	8526                	mv	a0,s1
 26e:	166000ef          	jal	3d4 <close>
  return r;
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	57fd                	li	a5,-1
 282:	893e                	mv	s2,a5
 284:	bfc5                	j	274 <stat+0x2a>

0000000000000286 <atoi>:

int
atoi(const char *s)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 28e:	00054683          	lbu	a3,0(a0)
 292:	fd06879b          	addiw	a5,a3,-48
 296:	0ff7f793          	zext.b	a5,a5
 29a:	4625                	li	a2,9
 29c:	02f66963          	bltu	a2,a5,2ce <atoi+0x48>
 2a0:	872a                	mv	a4,a0
  n = 0;
 2a2:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2a4:	0705                	addi	a4,a4,1
 2a6:	0025179b          	slliw	a5,a0,0x2
 2aa:	9fa9                	addw	a5,a5,a0
 2ac:	0017979b          	slliw	a5,a5,0x1
 2b0:	9fb5                	addw	a5,a5,a3
 2b2:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2b6:	00074683          	lbu	a3,0(a4)
 2ba:	fd06879b          	addiw	a5,a3,-48
 2be:	0ff7f793          	zext.b	a5,a5
 2c2:	fef671e3          	bgeu	a2,a5,2a4 <atoi+0x1e>
  return n;
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  n = 0;
 2ce:	4501                	li	a0,0
 2d0:	bfdd                	j	2c6 <atoi+0x40>

00000000000002d2 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2da:	02b57563          	bgeu	a0,a1,304 <memmove+0x32>
    while (n-- > 0)
 2de:	00c05f63          	blez	a2,2fc <memmove+0x2a>
 2e2:	1602                	slli	a2,a2,0x20
 2e4:	9201                	srli	a2,a2,0x20
 2e6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ea:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ec:	0585                	addi	a1,a1,1
 2ee:	0705                	addi	a4,a4,1
 2f0:	fff5c683          	lbu	a3,-1(a1)
 2f4:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2f8:	fee79ae3          	bne	a5,a4,2ec <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
    while (n-- > 0)
 304:	fec05ce3          	blez	a2,2fc <memmove+0x2a>
    dst += n;
 308:	00c50733          	add	a4,a0,a2
    src += n;
 30c:	95b2                	add	a1,a1,a2
 30e:	fff6079b          	addiw	a5,a2,-1
 312:	1782                	slli	a5,a5,0x20
 314:	9381                	srli	a5,a5,0x20
 316:	fff7c793          	not	a5,a5
 31a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31c:	15fd                	addi	a1,a1,-1
 31e:	177d                	addi	a4,a4,-1
 320:	0005c683          	lbu	a3,0(a1)
 324:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 328:	fef71ae3          	bne	a4,a5,31c <memmove+0x4a>
 32c:	bfc1                	j	2fc <memmove+0x2a>

000000000000032e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 336:	ce19                	beqz	a2,354 <memcmp+0x26>
 338:	1602                	slli	a2,a2,0x20
 33a:	9201                	srli	a2,a2,0x20
 33c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 340:	00054783          	lbu	a5,0(a0)
 344:	0005c703          	lbu	a4,0(a1)
 348:	00e79b63          	bne	a5,a4,35e <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 34c:	0505                	addi	a0,a0,1
    p2++;
 34e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 350:	fed518e3          	bne	a0,a3,340 <memcmp+0x12>
  }
  return 0;
 354:	4501                	li	a0,0
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
      return *p1 - *p2;
 35e:	40e7853b          	subw	a0,a5,a4
 362:	bfd5                	j	356 <memcmp+0x28>

0000000000000364 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36c:	f67ff0ef          	jal	2d2 <memmove>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <sbrk>:

char *
sbrk(int n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 380:	4585                	li	a1,1
 382:	0b2000ef          	jal	434 <sys_sbrk>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <sbrklazy>:

char *
sbrklazy(int n)
{
 38e:	1141                	addi	sp,sp,-16
 390:	e406                	sd	ra,8(sp)
 392:	e022                	sd	s0,0(sp)
 394:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 396:	4589                	li	a1,2
 398:	09c000ef          	jal	434 <sys_sbrk>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a4:	4885                	li	a7,1
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ac:	4889                	li	a7,2
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b4:	488d                	li	a7,3
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3bc:	4891                	li	a7,4
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <read>:
.global read
read:
 li a7, SYS_read
 3c4:	4895                	li	a7,5
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <write>:
.global write
write:
 li a7, SYS_write
 3cc:	48c1                	li	a7,16
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <close>:
.global close
close:
 li a7, SYS_close
 3d4:	48d5                	li	a7,21
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3dc:	4899                	li	a7,6
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e4:	489d                	li	a7,7
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <open>:
.global open
open:
 li a7, SYS_open
 3ec:	48bd                	li	a7,15
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f4:	48c5                	li	a7,17
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fc:	48c9                	li	a7,18
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 404:	48a1                	li	a7,8
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <link>:
.global link
link:
 li a7, SYS_link
 40c:	48cd                	li	a7,19
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 414:	48d1                	li	a7,20
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41c:	48a5                	li	a7,9
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <dup>:
.global dup
dup:
 li a7, SYS_dup
 424:	48a9                	li	a7,10
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42c:	48ad                	li	a7,11
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 434:	48b1                	li	a7,12
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <pause>:
.global pause
pause:
 li a7, SYS_pause
 43c:	48b5                	li	a7,13
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 444:	48b9                	li	a7,14
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sync>:
.global sync
sync:
 li a7, SYS_sync
 44c:	48d9                	li	a7,22
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 460:	4605                	li	a2,1
 462:	fef40593          	addi	a1,s0,-17
 466:	f67ff0ef          	jal	3cc <write>
}
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6105                	addi	sp,sp,32
 470:	8082                	ret

0000000000000472 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 472:	715d                	addi	sp,sp,-80
 474:	e486                	sd	ra,72(sp)
 476:	e0a2                	sd	s0,64(sp)
 478:	f84a                	sd	s2,48(sp)
 47a:	f44e                	sd	s3,40(sp)
 47c:	0880                	addi	s0,sp,80
 47e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 480:	00d036b3          	snez	a3,a3
 484:	03f5d793          	srli	a5,a1,0x3f
 488:	8efd                	and	a3,a3,a5
  neg = 0;
 48a:	4301                	li	t1,0
  if (sgn && xx < 0) {
 48c:	c681                	beqz	a3,494 <printint+0x22>
    neg = 1;
    x = -xx;
 48e:	40b005b3          	neg	a1,a1
    neg = 1;
 492:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 494:	fb840993          	addi	s3,s0,-72
  neg = 0;
 498:	86ce                	mv	a3,s3
  i = 0;
 49a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 49c:	00000817          	auipc	a6,0x0
 4a0:	57480813          	addi	a6,a6,1396 # a10 <digits>
 4a4:	88ba                	mv	a7,a4
 4a6:	0017051b          	addiw	a0,a4,1
 4aa:	872a                	mv	a4,a0
 4ac:	02c5f7b3          	remu	a5,a1,a2
 4b0:	97c2                	add	a5,a5,a6
 4b2:	0007c783          	lbu	a5,0(a5)
 4b6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4ba:	87ae                	mv	a5,a1
 4bc:	02c5d5b3          	divu	a1,a1,a2
 4c0:	0685                	addi	a3,a3,1
 4c2:	fec7f1e3          	bgeu	a5,a2,4a4 <printint+0x32>
  if (neg)
 4c6:	00030b63          	beqz	t1,4dc <printint+0x6a>
    buf[i++] = '-';
 4ca:	fd040793          	addi	a5,s0,-48
 4ce:	953e                	add	a0,a0,a5
 4d0:	02d00793          	li	a5,45
 4d4:	fef50423          	sb	a5,-24(a0)
 4d8:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4dc:	02e05563          	blez	a4,506 <printint+0x94>
 4e0:	fc26                	sd	s1,56(sp)
 4e2:	377d                	addiw	a4,a4,-1
 4e4:	00e984b3          	add	s1,s3,a4
 4e8:	19fd                	addi	s3,s3,-1
 4ea:	99ba                	add	s3,s3,a4
 4ec:	1702                	slli	a4,a4,0x20
 4ee:	9301                	srli	a4,a4,0x20
 4f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f4:	0004c583          	lbu	a1,0(s1)
 4f8:	854a                	mv	a0,s2
 4fa:	f5bff0ef          	jal	454 <putc>
  while (--i >= 0)
 4fe:	14fd                	addi	s1,s1,-1
 500:	ff349ae3          	bne	s1,s3,4f4 <printint+0x82>
 504:	74e2                	ld	s1,56(sp)
}
 506:	60a6                	ld	ra,72(sp)
 508:	6406                	ld	s0,64(sp)
 50a:	7942                	ld	s2,48(sp)
 50c:	79a2                	ld	s3,40(sp)
 50e:	6161                	addi	sp,sp,80
 510:	8082                	ret

0000000000000512 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 512:	711d                	addi	sp,sp,-96
 514:	ec86                	sd	ra,88(sp)
 516:	e8a2                	sd	s0,80(sp)
 518:	e4a6                	sd	s1,72(sp)
 51a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 51c:	0005c483          	lbu	s1,0(a1)
 520:	2a048063          	beqz	s1,7c0 <vprintf+0x2ae>
 524:	e0ca                	sd	s2,64(sp)
 526:	fc4e                	sd	s3,56(sp)
 528:	f852                	sd	s4,48(sp)
 52a:	f456                	sd	s5,40(sp)
 52c:	f05a                	sd	s6,32(sp)
 52e:	ec5e                	sd	s7,24(sp)
 530:	e862                	sd	s8,16(sp)
 532:	8b2a                	mv	s6,a0
 534:	8a2e                	mv	s4,a1
 536:	8bb2                	mv	s7,a2
  state = 0;
 538:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 53a:	4901                	li	s2,0
 53c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 53e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 542:	06400c13          	li	s8,100
 546:	a00d                	j	568 <vprintf+0x56>
        putc(fd, c0);
 548:	85a6                	mv	a1,s1
 54a:	855a                	mv	a0,s6
 54c:	f09ff0ef          	jal	454 <putc>
 550:	a019                	j	556 <vprintf+0x44>
    } else if (state == '%') {
 552:	03598363          	beq	s3,s5,578 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 556:	0019079b          	addiw	a5,s2,1
 55a:	893e                	mv	s2,a5
 55c:	873e                	mv	a4,a5
 55e:	97d2                	add	a5,a5,s4
 560:	0007c483          	lbu	s1,0(a5)
 564:	24048763          	beqz	s1,7b2 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 568:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 56c:	fe0993e3          	bnez	s3,552 <vprintf+0x40>
      if (c0 == '%') {
 570:	fd579ce3          	bne	a5,s5,548 <vprintf+0x36>
        state = '%';
 574:	89be                	mv	s3,a5
 576:	b7c5                	j	556 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 578:	00ea06b3          	add	a3,s4,a4
 57c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 580:	24060563          	beqz	a2,7ca <vprintf+0x2b8>
      if (c0 == 'd') {
 584:	0b878763          	beq	a5,s8,632 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 588:	f9478693          	addi	a3,a5,-108
 58c:	0016b693          	seqz	a3,a3
 590:	f9c60593          	addi	a1,a2,-100
 594:	0015b593          	seqz	a1,a1
 598:	8df5                	and	a1,a1,a3
 59a:	e9c5                	bnez	a1,64a <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 59c:	9752                	add	a4,a4,s4
 59e:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5a2:	f9460713          	addi	a4,a2,-108
 5a6:	00173713          	seqz	a4,a4
 5aa:	8f75                	and	a4,a4,a3
 5ac:	f9c50593          	addi	a1,a0,-100
 5b0:	0015b593          	seqz	a1,a1
 5b4:	8df9                	and	a1,a1,a4
 5b6:	e5dd                	bnez	a1,664 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5b8:	07500593          	li	a1,117
 5bc:	0cb78163          	beq	a5,a1,67e <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5c0:	f8b60593          	addi	a1,a2,-117
 5c4:	0015b593          	seqz	a1,a1
 5c8:	8df5                	and	a1,a1,a3
 5ca:	e5f1                	bnez	a1,696 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5cc:	f8b50593          	addi	a1,a0,-117
 5d0:	0015b593          	seqz	a1,a1
 5d4:	8df9                	and	a1,a1,a4
 5d6:	ede9                	bnez	a1,6b0 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5d8:	07800593          	li	a1,120
 5dc:	0eb78763          	beq	a5,a1,6ca <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5e0:	f8860613          	addi	a2,a2,-120
 5e4:	00163613          	seqz	a2,a2
 5e8:	8ef1                	and	a3,a3,a2
 5ea:	0e069c63          	bnez	a3,6e2 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5ee:	f8850513          	addi	a0,a0,-120
 5f2:	00153513          	seqz	a0,a0
 5f6:	8f69                	and	a4,a4,a0
 5f8:	10071263          	bnez	a4,6fc <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5fc:	07000713          	li	a4,112
 600:	10e78a63          	beq	a5,a4,714 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 604:	06300713          	li	a4,99
 608:	14e78a63          	beq	a5,a4,75c <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 60c:	07300713          	li	a4,115
 610:	16e78063          	beq	a5,a4,770 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 614:	02500713          	li	a4,37
 618:	18e78863          	beq	a5,a4,7a8 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61c:	02500593          	li	a1,37
 620:	855a                	mv	a0,s6
 622:	e33ff0ef          	jal	454 <putc>
        putc(fd, c0);
 626:	85a6                	mv	a1,s1
 628:	855a                	mv	a0,s6
 62a:	e2bff0ef          	jal	454 <putc>
      }

      state = 0;
 62e:	4981                	li	s3,0
 630:	b71d                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 632:	008b8493          	addi	s1,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000ba583          	lw	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e33ff0ef          	jal	472 <printint>
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
 648:	b739                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	008b8493          	addi	s1,s7,8
 64e:	4685                	li	a3,1
 650:	4629                	li	a2,10
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	e1bff0ef          	jal	472 <printint>
        i += 1;
 65c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	8ba6                	mv	s7,s1
      state = 0;
 660:	4981                	li	s3,0
 662:	bdd5                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	008b8493          	addi	s1,s7,8
 668:	4685                	li	a3,1
 66a:	4629                	li	a2,10
 66c:	000bb583          	ld	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e01ff0ef          	jal	472 <printint>
        i += 2;
 676:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	8ba6                	mv	s7,s1
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	bde9                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 67e:	008b8493          	addi	s1,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000be583          	lwu	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	de7ff0ef          	jal	472 <printint>
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
 694:	b5c9                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8493          	addi	s1,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000bb583          	ld	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	dcfff0ef          	jal	472 <printint>
        i += 1;
 6a8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	8ba6                	mv	s7,s1
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b565                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	008b8493          	addi	s1,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4629                	li	a2,10
 6b8:	000bb583          	ld	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	db5ff0ef          	jal	472 <printint>
        i += 2;
 6c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
        i += 2;
 6c8:	b579                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ca:	008b8493          	addi	s1,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000be583          	lwu	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	d9bff0ef          	jal	472 <printint>
 6dc:	8ba6                	mv	s7,s1
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bd9d                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	008b8493          	addi	s1,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000bb583          	ld	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	d83ff0ef          	jal	472 <printint>
        i += 1;
 6f4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	8ba6                	mv	s7,s1
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bdb1                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	008b8493          	addi	s1,s7,8
 700:	4641                	li	a2,16
 702:	000bb583          	ld	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	d6bff0ef          	jal	472 <printint>
        i += 2;
 70c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 70e:	8ba6                	mv	s7,s1
      state = 0;
 710:	4981                	li	s3,0
        i += 2;
 712:	b591                	j	556 <vprintf+0x44>
 714:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 716:	008b8793          	addi	a5,s7,8
 71a:	8cbe                	mv	s9,a5
 71c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 720:	03000593          	li	a1,48
 724:	855a                	mv	a0,s6
 726:	d2fff0ef          	jal	454 <putc>
  putc(fd, 'x');
 72a:	07800593          	li	a1,120
 72e:	855a                	mv	a0,s6
 730:	d25ff0ef          	jal	454 <putc>
 734:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 736:	00000b97          	auipc	s7,0x0
 73a:	2dab8b93          	addi	s7,s7,730 # a10 <digits>
 73e:	03c9d793          	srli	a5,s3,0x3c
 742:	97de                	add	a5,a5,s7
 744:	0007c583          	lbu	a1,0(a5)
 748:	855a                	mv	a0,s6
 74a:	d0bff0ef          	jal	454 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74e:	0992                	slli	s3,s3,0x4
 750:	34fd                	addiw	s1,s1,-1
 752:	f4f5                	bnez	s1,73e <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 754:	8be6                	mv	s7,s9
      state = 0;
 756:	4981                	li	s3,0
 758:	6ca2                	ld	s9,8(sp)
 75a:	bbf5                	j	556 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 75c:	008b8493          	addi	s1,s7,8
 760:	000bc583          	lbu	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	cefff0ef          	jal	454 <putc>
 76a:	8ba6                	mv	s7,s1
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b3e5                	j	556 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 770:	008b8993          	addi	s3,s7,8
 774:	000bb483          	ld	s1,0(s7)
 778:	cc91                	beqz	s1,794 <vprintf+0x282>
        for (; *s; s++)
 77a:	0004c583          	lbu	a1,0(s1)
 77e:	c195                	beqz	a1,7a2 <vprintf+0x290>
          putc(fd, *s);
 780:	855a                	mv	a0,s6
 782:	cd3ff0ef          	jal	454 <putc>
        for (; *s; s++)
 786:	0485                	addi	s1,s1,1
 788:	0004c583          	lbu	a1,0(s1)
 78c:	f9f5                	bnez	a1,780 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 78e:	8bce                	mv	s7,s3
      state = 0;
 790:	4981                	li	s3,0
 792:	b3d1                	j	556 <vprintf+0x44>
          s = "(null)";
 794:	00000497          	auipc	s1,0x0
 798:	27448493          	addi	s1,s1,628 # a08 <malloc+0x142>
        for (; *s; s++)
 79c:	02800593          	li	a1,40
 7a0:	b7c5                	j	780 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7a2:	8bce                	mv	s7,s3
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bb45                	j	556 <vprintf+0x44>
        putc(fd, '%');
 7a8:	85be                	mv	a1,a5
 7aa:	855a                	mv	a0,s6
 7ac:	ca9ff0ef          	jal	454 <putc>
 7b0:	bdbd                	j	62e <vprintf+0x11c>
 7b2:	6906                	ld	s2,64(sp)
 7b4:	79e2                	ld	s3,56(sp)
 7b6:	7a42                	ld	s4,48(sp)
 7b8:	7aa2                	ld	s5,40(sp)
 7ba:	7b02                	ld	s6,32(sp)
 7bc:	6be2                	ld	s7,24(sp)
 7be:	6c42                	ld	s8,16(sp)
    }
  }
}
 7c0:	60e6                	ld	ra,88(sp)
 7c2:	6446                	ld	s0,80(sp)
 7c4:	64a6                	ld	s1,72(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret
      if (c0 == 'd') {
 7ca:	06400713          	li	a4,100
 7ce:	e6e782e3          	beq	a5,a4,632 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7d2:	f9478693          	addi	a3,a5,-108
 7d6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7da:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7dc:	4701                	li	a4,0
 7de:	bbe9                	j	5b8 <vprintf+0xa6>

00000000000007e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e0:	715d                	addi	sp,sp,-80
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e010                	sd	a2,0(s0)
 7ea:	e414                	sd	a3,8(s0)
 7ec:	e818                	sd	a4,16(s0)
 7ee:	ec1c                	sd	a5,24(s0)
 7f0:	03043023          	sd	a6,32(s0)
 7f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	8622                	mv	a2,s0
 7fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fe:	d15ff0ef          	jal	512 <vprintf>
}
 802:	60e2                	ld	ra,24(sp)
 804:	6442                	ld	s0,16(sp)
 806:	6161                	addi	sp,sp,80
 808:	8082                	ret

000000000000080a <printf>:

void
printf(const char *fmt, ...)
{
 80a:	711d                	addi	sp,sp,-96
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e40c                	sd	a1,8(s0)
 814:	e810                	sd	a2,16(s0)
 816:	ec14                	sd	a3,24(s0)
 818:	f018                	sd	a4,32(s0)
 81a:	f41c                	sd	a5,40(s0)
 81c:	03043823          	sd	a6,48(s0)
 820:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 824:	00840613          	addi	a2,s0,8
 828:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82c:	85aa                	mv	a1,a0
 82e:	4505                	li	a0,1
 830:	ce3ff0ef          	jal	512 <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83c:	1141                	addi	sp,sp,-16
 83e:	e406                	sd	ra,8(sp)
 840:	e022                	sd	s0,0(sp)
 842:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 844:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	00000797          	auipc	a5,0x0
 84c:	7b87b783          	ld	a5,1976(a5) # 1000 <freep>
 850:	a095                	j	8b4 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 852:	ff852583          	lw	a1,-8(a0)
 856:	6390                	ld	a2,0(a5)
 858:	02059813          	slli	a6,a1,0x20
 85c:	01c85693          	srli	a3,a6,0x1c
 860:	96ba                	add	a3,a3,a4
 862:	02d60563          	beq	a2,a3,88c <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 86a:	4790                	lw	a2,8(a5)
 86c:	02061593          	slli	a1,a2,0x20
 870:	01c5d693          	srli	a3,a1,0x1c
 874:	96be                	add	a3,a3,a5
 876:	02d70263          	beq	a4,a3,89a <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 87a:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87c:	00000717          	auipc	a4,0x0
 880:	78f73223          	sd	a5,1924(a4) # 1000 <freep>
}
 884:	60a2                	ld	ra,8(sp)
 886:	6402                	ld	s0,0(sp)
 888:	0141                	addi	sp,sp,16
 88a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 88c:	4614                	lw	a3,8(a2)
 88e:	9ead                	addw	a3,a3,a1
 890:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	6394                	ld	a3,0(a5)
 896:	6290                	ld	a2,0(a3)
 898:	b7f9                	j	866 <free+0x2a>
    p->s.size += bp->s.size;
 89a:	ff852703          	lw	a4,-8(a0)
 89e:	9f31                	addw	a4,a4,a2
 8a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a2:	ff053703          	ld	a4,-16(a0)
 8a6:	bfd1                	j	87a <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	6394                	ld	a3,0(a5)
 8aa:	00d7e463          	bltu	a5,a3,8b2 <free+0x76>
 8ae:	fad762e3          	bltu	a4,a3,852 <free+0x16>
 8b2:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	fee7fae3          	bgeu	a5,a4,8a8 <free+0x6c>
 8b8:	6394                	ld	a3,0(a5)
 8ba:	f8d76ce3          	bltu	a4,a3,852 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	f8d7fae3          	bgeu	a5,a3,852 <free+0x16>
 8c2:	87b6                	mv	a5,a3
 8c4:	bfc5                	j	8b4 <free+0x78>

00000000000008c6 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8c6:	7139                	addi	sp,sp,-64
 8c8:	fc06                	sd	ra,56(sp)
 8ca:	f822                	sd	s0,48(sp)
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	ec4e                	sd	s3,24(sp)
 8d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8d2:	02051993          	slli	s3,a0,0x20
 8d6:	0209d993          	srli	s3,s3,0x20
 8da:	09bd                	addi	s3,s3,15
 8dc:	0049d993          	srli	s3,s3,0x4
 8e0:	2985                	addiw	s3,s3,1
 8e2:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8e4:	00000517          	auipc	a0,0x0
 8e8:	71c53503          	ld	a0,1820(a0) # 1000 <freep>
 8ec:	c905                	beqz	a0,91c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ee:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8f0:	4798                	lw	a4,8(a5)
 8f2:	09377663          	bgeu	a4,s3,97e <malloc+0xb8>
 8f6:	f426                	sd	s1,40(sp)
 8f8:	e852                	sd	s4,16(sp)
 8fa:	e456                	sd	s5,8(sp)
 8fc:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8fe:	8a4e                	mv	s4,s3
 900:	6705                	lui	a4,0x1
 902:	00e9f363          	bgeu	s3,a4,908 <malloc+0x42>
 906:	6a05                	lui	s4,0x1
 908:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 910:	00000497          	auipc	s1,0x0
 914:	6f048493          	addi	s1,s1,1776 # 1000 <freep>
  if (p == SBRK_ERROR)
 918:	5afd                	li	s5,-1
 91a:	a83d                	j	958 <malloc+0x92>
 91c:	f426                	sd	s1,40(sp)
 91e:	e852                	sd	s4,16(sp)
 920:	e456                	sd	s5,8(sp)
 922:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 924:	00001797          	auipc	a5,0x1
 928:	8ec78793          	addi	a5,a5,-1812 # 1210 <base>
 92c:	00000717          	auipc	a4,0x0
 930:	6cf73a23          	sd	a5,1748(a4) # 1000 <freep>
 934:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 936:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 93a:	b7d1                	j	8fe <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 93c:	6398                	ld	a4,0(a5)
 93e:	e118                	sd	a4,0(a0)
 940:	a899                	j	996 <malloc+0xd0>
  hp->s.size = nu;
 942:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 946:	0541                	addi	a0,a0,16
 948:	ef5ff0ef          	jal	83c <free>
  return freep;
 94c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 94e:	c125                	beqz	a0,9ae <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 950:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 952:	4798                	lw	a4,8(a5)
 954:	03277163          	bgeu	a4,s2,976 <malloc+0xb0>
    if (p == freep)
 958:	6098                	ld	a4,0(s1)
 95a:	853e                	mv	a0,a5
 95c:	fef71ae3          	bne	a4,a5,950 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 960:	8552                	mv	a0,s4
 962:	a17ff0ef          	jal	378 <sbrk>
  if (p == SBRK_ERROR)
 966:	fd551ee3          	bne	a0,s5,942 <malloc+0x7c>
        return 0;
 96a:	4501                	li	a0,0
 96c:	74a2                	ld	s1,40(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
 974:	a03d                	j	9a2 <malloc+0xdc>
 976:	74a2                	ld	s1,40(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 97e:	fae90fe3          	beq	s2,a4,93c <malloc+0x76>
        p->s.size -= nunits;
 982:	4137073b          	subw	a4,a4,s3
 986:	c798                	sw	a4,8(a5)
        p += p->s.size;
 988:	02071693          	slli	a3,a4,0x20
 98c:	01c6d713          	srli	a4,a3,0x1c
 990:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 992:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 996:	00000717          	auipc	a4,0x0
 99a:	66a73523          	sd	a0,1642(a4) # 1000 <freep>
      return (void *)(p + 1);
 99e:	01078513          	addi	a0,a5,16
  }
}
 9a2:	70e2                	ld	ra,56(sp)
 9a4:	7442                	ld	s0,48(sp)
 9a6:	7902                	ld	s2,32(sp)
 9a8:	69e2                	ld	s3,24(sp)
 9aa:	6121                	addi	sp,sp,64
 9ac:	8082                	ret
 9ae:	74a2                	ld	s1,40(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	b7f5                	j	9a2 <malloc+0xdc>
