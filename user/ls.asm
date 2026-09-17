
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	2ac000ef          	jal	2b8 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if (strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	284000ef          	jal	2b8 <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  buf[sizeof(buf) - 1] = '\0';
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	60e2                	ld	ra,24(sp)
  42:	6442                	ld	s0,16(sp)
  44:	64a2                	ld	s1,8(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret
  4a:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
  4c:	8526                	mv	a0,s1
  4e:	26a000ef          	jal	2b8 <strlen>
  52:	862a                	mv	a2,a0
  54:	85a6                	mv	a1,s1
  56:	00001517          	auipc	a0,0x1
  5a:	fba50513          	addi	a0,a0,-70 # 1010 <buf.0>
  5e:	3d6000ef          	jal	434 <memmove>
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  62:	8526                	mv	a0,s1
  64:	254000ef          	jal	2b8 <strlen>
  68:	892a                	mv	s2,a0
  6a:	8526                	mv	a0,s1
  6c:	24c000ef          	jal	2b8 <strlen>
  70:	02091793          	slli	a5,s2,0x20
  74:	9381                	srli	a5,a5,0x20
  76:	4639                	li	a2,14
  78:	9e09                	subw	a2,a2,a0
  7a:	02000593          	li	a1,32
  7e:	00001717          	auipc	a4,0x1
  82:	f9270713          	addi	a4,a4,-110 # 1010 <buf.0>
  86:	84ba                	mv	s1,a4
  88:	00f70533          	add	a0,a4,a5
  8c:	258000ef          	jal	2e4 <memset>
  buf[sizeof(buf) - 1] = '\0';
  90:	00048723          	sb	zero,14(s1)
  return buf;
  94:	6902                	ld	s2,0(sp)
  96:	b765                	j	3e <fmtname+0x3e>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	da010113          	addi	sp,sp,-608
  9c:	24113c23          	sd	ra,600(sp)
  a0:	24813823          	sd	s0,592(sp)
  a4:	25213023          	sd	s2,576(sp)
  a8:	1480                	addi	s0,sp,608
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0) {
  ac:	4581                	li	a1,0
  ae:	4a0000ef          	jal	54e <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913423          	sd	s1,584(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0) {
  bc:	da840593          	addi	a1,s0,-600
  c0:	4a6000ef          	jal	566 <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch (st.type) {
  c8:	db041783          	lh	a5,-592(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int)st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	db842703          	lw	a4,-584(s0)
  e8:	dac42683          	lw	a3,-596(s0)
  ec:	db041603          	lh	a2,-592(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a6050513          	addi	a0,a0,-1440 # b50 <malloc+0x128>
  f8:	075000ef          	jal	96c <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int)st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	438000ef          	jal	536 <close>
 102:	24813483          	ld	s1,584(sp)
}
 106:	25813083          	ld	ra,600(sp)
 10a:	25013403          	ld	s0,592(sp)
 10e:	24013903          	ld	s2,576(sp)
 112:	26010113          	addi	sp,sp,608
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	a0658593          	addi	a1,a1,-1530 # b20 <malloc+0xf8>
 122:	4509                	li	a0,2
 124:	01f000ef          	jal	942 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	a0c58593          	addi	a1,a1,-1524 # b38 <malloc+0x110>
 134:	4509                	li	a0,2
 136:	00d000ef          	jal	942 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	3fa000ef          	jal	536 <close>
    return;
 140:	24813483          	ld	s1,584(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 146:	854a                	mv	a0,s2
 148:	170000ef          	jal	2b8 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a0a50513          	addi	a0,a0,-1526 # b60 <malloc+0x138>
 15e:	00f000ef          	jal	96c <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
 168:	85ca                	mv	a1,s2
 16a:	dd040513          	addi	a0,s0,-560
 16e:	0fa000ef          	jal	268 <strcpy>
    p = buf + strlen(buf);
 172:	dd040513          	addi	a0,s0,-560
 176:	142000ef          	jal	2b8 <strlen>
 17a:	1502                	slli	a0,a0,0x20
 17c:	9101                	srli	a0,a0,0x20
 17e:	dd040793          	addi	a5,s0,-560
 182:	00a78733          	add	a4,a5,a0
 186:	893a                	mv	s2,a4
    *p++ = '/';
 188:	00170793          	addi	a5,a4,1
 18c:	89be                	mv	s3,a5
 18e:	02f00793          	li	a5,47
 192:	00f70023          	sb	a5,0(a4)
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 196:	a809                	j	1a8 <ls+0x110>
        printf("ls: cannot stat %s\n", buf);
 198:	dd040593          	addi	a1,s0,-560
 19c:	00001517          	auipc	a0,0x1
 1a0:	99c50513          	addi	a0,a0,-1636 # b38 <malloc+0x110>
 1a4:	7c8000ef          	jal	96c <printf>
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1a8:	4641                	li	a2,16
 1aa:	dc040593          	addi	a1,s0,-576
 1ae:	8526                	mv	a0,s1
 1b0:	376000ef          	jal	526 <read>
 1b4:	47c1                	li	a5,16
 1b6:	04f51763          	bne	a0,a5,204 <ls+0x16c>
      if (de.inum == 0)
 1ba:	dc045783          	lhu	a5,-576(s0)
 1be:	d7ed                	beqz	a5,1a8 <ls+0x110>
      memmove(p, de.name, DIRSIZ);
 1c0:	4639                	li	a2,14
 1c2:	dc240593          	addi	a1,s0,-574
 1c6:	854e                	mv	a0,s3
 1c8:	26c000ef          	jal	434 <memmove>
      p[DIRSIZ] = 0;
 1cc:	000907a3          	sb	zero,15(s2)
      if (stat(buf, &st) < 0) {
 1d0:	da840593          	addi	a1,s0,-600
 1d4:	dd040513          	addi	a0,s0,-560
 1d8:	1d4000ef          	jal	3ac <stat>
 1dc:	fa054ee3          	bltz	a0,198 <ls+0x100>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int)st.size);
 1e0:	dd040513          	addi	a0,s0,-560
 1e4:	e1dff0ef          	jal	0 <fmtname>
 1e8:	85aa                	mv	a1,a0
 1ea:	db842703          	lw	a4,-584(s0)
 1ee:	dac42683          	lw	a3,-596(s0)
 1f2:	db041603          	lh	a2,-592(s0)
 1f6:	00001517          	auipc	a0,0x1
 1fa:	95a50513          	addi	a0,a0,-1702 # b50 <malloc+0x128>
 1fe:	76e000ef          	jal	96c <printf>
 202:	b75d                	j	1a8 <ls+0x110>
 204:	23813983          	ld	s3,568(sp)
 208:	bdd5                	j	fc <ls+0x64>

000000000000020a <main>:

int
main(int argc, char *argv[])
{
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
 212:	4785                	li	a5,1
 214:	02a7d763          	bge	a5,a0,242 <main+0x38>
 218:	e426                	sd	s1,8(sp)
 21a:	e04a                	sd	s2,0(sp)
 21c:	00858493          	addi	s1,a1,8
 220:	ffe5091b          	addiw	s2,a0,-2
 224:	02091793          	slli	a5,s2,0x20
 228:	01d7d913          	srli	s2,a5,0x1d
 22c:	05c1                	addi	a1,a1,16
 22e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
 230:	6088                	ld	a0,0(s1)
 232:	e67ff0ef          	jal	98 <ls>
  for (i = 1; i < argc; i++)
 236:	04a1                	addi	s1,s1,8
 238:	ff249ce3          	bne	s1,s2,230 <main+0x26>
  exit(0);
 23c:	4501                	li	a0,0
 23e:	2d0000ef          	jal	50e <exit>
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
    ls(".");
 246:	00001517          	auipc	a0,0x1
 24a:	93250513          	addi	a0,a0,-1742 # b78 <malloc+0x150>
 24e:	e4bff0ef          	jal	98 <ls>
    exit(0);
 252:	4501                	li	a0,0
 254:	2ba000ef          	jal	50e <exit>

0000000000000258 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 260:	fabff0ef          	jal	20a <main>
  exit(r);
 264:	2aa000ef          	jal	50e <exit>

0000000000000268 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 270:	87aa                	mv	a5,a0
 272:	0585                	addi	a1,a1,1
 274:	0785                	addi	a5,a5,1
 276:	fff5c703          	lbu	a4,-1(a1)
 27a:	fee78fa3          	sb	a4,-1(a5)
 27e:	fb75                	bnez	a4,272 <strcpy+0xa>
    ;
  return os;
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	cb91                	beqz	a5,2a8 <strcmp+0x20>
 296:	0005c703          	lbu	a4,0(a1)
 29a:	00f71763          	bne	a4,a5,2a8 <strcmp+0x20>
    p++, q++;
 29e:	0505                	addi	a0,a0,1
 2a0:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbe5                	bnez	a5,296 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2a8:	0005c503          	lbu	a0,0(a1)
}
 2ac:	40a7853b          	subw	a0,a5,a0
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <strlen>:

uint
strlen(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cf91                	beqz	a5,2e0 <strlen+0x28>
 2c6:	00150793          	addi	a5,a0,1
 2ca:	86be                	mv	a3,a5
 2cc:	0785                	addi	a5,a5,1
 2ce:	fff7c703          	lbu	a4,-1(a5)
 2d2:	ff65                	bnez	a4,2ca <strlen+0x12>
 2d4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  for (n = 0; s[n]; n++)
 2e0:	4501                	li	a0,0
 2e2:	bfdd                	j	2d8 <strlen+0x20>

00000000000002e4 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2ec:	ca19                	beqz	a2,302 <memset+0x1e>
 2ee:	87aa                	mv	a5,a0
 2f0:	1602                	slli	a2,a2,0x20
 2f2:	9201                	srli	a2,a2,0x20
 2f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 2fc:	0785                	addi	a5,a5,1
 2fe:	fee79de3          	bne	a5,a4,2f8 <memset+0x14>
  }
  return dst;
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strchr>:

char *
strchr(const char *s, char c)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  for (; *s; s++)
 312:	00054783          	lbu	a5,0(a0)
 316:	c799                	beqz	a5,324 <strchr+0x1a>
    if (*s == c)
 318:	00f58763          	beq	a1,a5,326 <strchr+0x1c>
  for (; *s; s++)
 31c:	0505                	addi	a0,a0,1
 31e:	00054783          	lbu	a5,0(a0)
 322:	fbfd                	bnez	a5,318 <strchr+0xe>
      return (char *)s;
  return 0;
 324:	4501                	li	a0,0
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <gets>:

char *
gets(char *buf, int max)
{
 32e:	711d                	addi	sp,sp,-96
 330:	ec86                	sd	ra,88(sp)
 332:	e8a2                	sd	s0,80(sp)
 334:	e4a6                	sd	s1,72(sp)
 336:	e0ca                	sd	s2,64(sp)
 338:	fc4e                	sd	s3,56(sp)
 33a:	f852                	sd	s4,48(sp)
 33c:	f456                	sd	s5,40(sp)
 33e:	f05a                	sd	s6,32(sp)
 340:	ec5e                	sd	s7,24(sp)
 342:	e862                	sd	s8,16(sp)
 344:	1080                	addi	s0,sp,96
 346:	8baa                	mv	s7,a0
 348:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 34a:	892a                	mv	s2,a0
 34c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 34e:	faf40b13          	addi	s6,s0,-81
 352:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 354:	8c26                	mv	s8,s1
 356:	0014899b          	addiw	s3,s1,1
 35a:	84ce                	mv	s1,s3
 35c:	0349d863          	bge	s3,s4,38c <gets+0x5e>
    cc = read(0, &c, 1);
 360:	8656                	mv	a2,s5
 362:	85da                	mv	a1,s6
 364:	4501                	li	a0,0
 366:	1c0000ef          	jal	526 <read>
    if (cc < 1)
 36a:	02a05163          	blez	a0,38c <gets+0x5e>
      break;
    buf[i++] = c;
 36e:	faf44783          	lbu	a5,-81(s0)
 372:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 376:	0905                	addi	s2,s2,1
 378:	ff678713          	addi	a4,a5,-10
 37c:	00173713          	seqz	a4,a4
 380:	17cd                	addi	a5,a5,-13
 382:	0017b793          	seqz	a5,a5
 386:	8fd9                	or	a5,a5,a4
 388:	d7f1                	beqz	a5,354 <gets+0x26>
    buf[i++] = c;
 38a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38c:	9c5e                	add	s8,s8,s7
 38e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 392:	855e                	mv	a0,s7
 394:	60e6                	ld	ra,88(sp)
 396:	6446                	ld	s0,80(sp)
 398:	64a6                	ld	s1,72(sp)
 39a:	6906                	ld	s2,64(sp)
 39c:	79e2                	ld	s3,56(sp)
 39e:	7a42                	ld	s4,48(sp)
 3a0:	7aa2                	ld	s5,40(sp)
 3a2:	7b02                	ld	s6,32(sp)
 3a4:	6be2                	ld	s7,24(sp)
 3a6:	6c42                	ld	s8,16(sp)
 3a8:	6125                	addi	sp,sp,96
 3aa:	8082                	ret

00000000000003ac <stat>:

int
stat(const char *n, struct stat *st)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	e04a                	sd	s2,0(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b8:	4581                	li	a1,0
 3ba:	194000ef          	jal	54e <open>
  if (fd < 0)
 3be:	02054263          	bltz	a0,3e2 <stat+0x36>
 3c2:	e426                	sd	s1,8(sp)
 3c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c6:	85ca                	mv	a1,s2
 3c8:	19e000ef          	jal	566 <fstat>
 3cc:	892a                	mv	s2,a0
  close(fd);
 3ce:	8526                	mv	a0,s1
 3d0:	166000ef          	jal	536 <close>
  return r;
 3d4:	64a2                	ld	s1,8(sp)
}
 3d6:	854a                	mv	a0,s2
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6902                	ld	s2,0(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret
    return -1;
 3e2:	57fd                	li	a5,-1
 3e4:	893e                	mv	s2,a5
 3e6:	bfc5                	j	3d6 <stat+0x2a>

00000000000003e8 <atoi>:

int
atoi(const char *s)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 3f0:	00054683          	lbu	a3,0(a0)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	4625                	li	a2,9
 3fe:	02f66963          	bltu	a2,a5,430 <atoi+0x48>
 402:	872a                	mv	a4,a0
  n = 0;
 404:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 406:	0705                	addi	a4,a4,1
 408:	0025179b          	slliw	a5,a0,0x2
 40c:	9fa9                	addw	a5,a5,a0
 40e:	0017979b          	slliw	a5,a5,0x1
 412:	9fb5                	addw	a5,a5,a3
 414:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 418:	00074683          	lbu	a3,0(a4)
 41c:	fd06879b          	addiw	a5,a3,-48
 420:	0ff7f793          	zext.b	a5,a5
 424:	fef671e3          	bgeu	a2,a5,406 <atoi+0x1e>
  return n;
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
  n = 0;
 430:	4501                	li	a0,0
 432:	bfdd                	j	428 <atoi+0x40>

0000000000000434 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43c:	02b57563          	bgeu	a0,a1,466 <memmove+0x32>
    while (n-- > 0)
 440:	00c05f63          	blez	a2,45e <memmove+0x2a>
 444:	1602                	slli	a2,a2,0x20
 446:	9201                	srli	a2,a2,0x20
 448:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44c:	872a                	mv	a4,a0
      *dst++ = *src++;
 44e:	0585                	addi	a1,a1,1
 450:	0705                	addi	a4,a4,1
 452:	fff5c683          	lbu	a3,-1(a1)
 456:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 45a:	fee79ae3          	bne	a5,a4,44e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
    while (n-- > 0)
 466:	fec05ce3          	blez	a2,45e <memmove+0x2a>
    dst += n;
 46a:	00c50733          	add	a4,a0,a2
    src += n;
 46e:	95b2                	add	a1,a1,a2
 470:	fff6079b          	addiw	a5,a2,-1
 474:	1782                	slli	a5,a5,0x20
 476:	9381                	srli	a5,a5,0x20
 478:	fff7c793          	not	a5,a5
 47c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47e:	15fd                	addi	a1,a1,-1
 480:	177d                	addi	a4,a4,-1
 482:	0005c683          	lbu	a3,0(a1)
 486:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 48a:	fef71ae3          	bne	a4,a5,47e <memmove+0x4a>
 48e:	bfc1                	j	45e <memmove+0x2a>

0000000000000490 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 498:	ce19                	beqz	a2,4b6 <memcmp+0x26>
 49a:	1602                	slli	a2,a2,0x20
 49c:	9201                	srli	a2,a2,0x20
 49e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	0005c703          	lbu	a4,0(a1)
 4aa:	00e79b63          	bne	a5,a4,4c0 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 4ae:	0505                	addi	a0,a0,1
    p2++;
 4b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b2:	fed518e3          	bne	a0,a3,4a2 <memcmp+0x12>
  }
  return 0;
 4b6:	4501                	li	a0,0
}
 4b8:	60a2                	ld	ra,8(sp)
 4ba:	6402                	ld	s0,0(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
      return *p1 - *p2;
 4c0:	40e7853b          	subw	a0,a5,a4
 4c4:	bfd5                	j	4b8 <memcmp+0x28>

00000000000004c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e406                	sd	ra,8(sp)
 4ca:	e022                	sd	s0,0(sp)
 4cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ce:	f67ff0ef          	jal	434 <memmove>
}
 4d2:	60a2                	ld	ra,8(sp)
 4d4:	6402                	ld	s0,0(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret

00000000000004da <sbrk>:

char *
sbrk(int n)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e406                	sd	ra,8(sp)
 4de:	e022                	sd	s0,0(sp)
 4e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4e2:	4585                	li	a1,1
 4e4:	0b2000ef          	jal	596 <sys_sbrk>
}
 4e8:	60a2                	ld	ra,8(sp)
 4ea:	6402                	ld	s0,0(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <sbrklazy>:

char *
sbrklazy(int n)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e406                	sd	ra,8(sp)
 4f4:	e022                	sd	s0,0(sp)
 4f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4f8:	4589                	li	a1,2
 4fa:	09c000ef          	jal	596 <sys_sbrk>
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 506:	4885                	li	a7,1
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <exit>:
.global exit
exit:
 li a7, SYS_exit
 50e:	4889                	li	a7,2
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <wait>:
.global wait
wait:
 li a7, SYS_wait
 516:	488d                	li	a7,3
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51e:	4891                	li	a7,4
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <read>:
.global read
read:
 li a7, SYS_read
 526:	4895                	li	a7,5
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <write>:
.global write
write:
 li a7, SYS_write
 52e:	48c1                	li	a7,16
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <close>:
.global close
close:
 li a7, SYS_close
 536:	48d5                	li	a7,21
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <kill>:
.global kill
kill:
 li a7, SYS_kill
 53e:	4899                	li	a7,6
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exec>:
.global exec
exec:
 li a7, SYS_exec
 546:	489d                	li	a7,7
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <open>:
.global open
open:
 li a7, SYS_open
 54e:	48bd                	li	a7,15
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 556:	48c5                	li	a7,17
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55e:	48c9                	li	a7,18
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 566:	48a1                	li	a7,8
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <link>:
.global link
link:
 li a7, SYS_link
 56e:	48cd                	li	a7,19
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 576:	48d1                	li	a7,20
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57e:	48a5                	li	a7,9
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <dup>:
.global dup
dup:
 li a7, SYS_dup
 586:	48a9                	li	a7,10
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58e:	48ad                	li	a7,11
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 596:	48b1                	li	a7,12
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <pause>:
.global pause
pause:
 li a7, SYS_pause
 59e:	48b5                	li	a7,13
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a6:	48b9                	li	a7,14
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sync>:
.global sync
sync:
 li a7, SYS_sync
 5ae:	48d9                	li	a7,22
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b6:	1101                	addi	sp,sp,-32
 5b8:	ec06                	sd	ra,24(sp)
 5ba:	e822                	sd	s0,16(sp)
 5bc:	1000                	addi	s0,sp,32
 5be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c2:	4605                	li	a2,1
 5c4:	fef40593          	addi	a1,s0,-17
 5c8:	f67ff0ef          	jal	52e <write>
}
 5cc:	60e2                	ld	ra,24(sp)
 5ce:	6442                	ld	s0,16(sp)
 5d0:	6105                	addi	sp,sp,32
 5d2:	8082                	ret

00000000000005d4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5d4:	715d                	addi	sp,sp,-80
 5d6:	e486                	sd	ra,72(sp)
 5d8:	e0a2                	sd	s0,64(sp)
 5da:	f84a                	sd	s2,48(sp)
 5dc:	f44e                	sd	s3,40(sp)
 5de:	0880                	addi	s0,sp,80
 5e0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 5e2:	00d036b3          	snez	a3,a3
 5e6:	03f5d793          	srli	a5,a1,0x3f
 5ea:	8efd                	and	a3,a3,a5
  neg = 0;
 5ec:	4301                	li	t1,0
  if (sgn && xx < 0) {
 5ee:	c681                	beqz	a3,5f6 <printint+0x22>
    neg = 1;
    x = -xx;
 5f0:	40b005b3          	neg	a1,a1
    neg = 1;
 5f4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5f6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 5fa:	86ce                	mv	a3,s3
  i = 0;
 5fc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 5fe:	00000817          	auipc	a6,0x0
 602:	58a80813          	addi	a6,a6,1418 # b88 <digits>
 606:	88ba                	mv	a7,a4
 608:	0017051b          	addiw	a0,a4,1
 60c:	872a                	mv	a4,a0
 60e:	02c5f7b3          	remu	a5,a1,a2
 612:	97c2                	add	a5,a5,a6
 614:	0007c783          	lbu	a5,0(a5)
 618:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 61c:	87ae                	mv	a5,a1
 61e:	02c5d5b3          	divu	a1,a1,a2
 622:	0685                	addi	a3,a3,1
 624:	fec7f1e3          	bgeu	a5,a2,606 <printint+0x32>
  if (neg)
 628:	00030b63          	beqz	t1,63e <printint+0x6a>
    buf[i++] = '-';
 62c:	fd040793          	addi	a5,s0,-48
 630:	953e                	add	a0,a0,a5
 632:	02d00793          	li	a5,45
 636:	fef50423          	sb	a5,-24(a0)
 63a:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 63e:	02e05563          	blez	a4,668 <printint+0x94>
 642:	fc26                	sd	s1,56(sp)
 644:	377d                	addiw	a4,a4,-1
 646:	00e984b3          	add	s1,s3,a4
 64a:	19fd                	addi	s3,s3,-1
 64c:	99ba                	add	s3,s3,a4
 64e:	1702                	slli	a4,a4,0x20
 650:	9301                	srli	a4,a4,0x20
 652:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 656:	0004c583          	lbu	a1,0(s1)
 65a:	854a                	mv	a0,s2
 65c:	f5bff0ef          	jal	5b6 <putc>
  while (--i >= 0)
 660:	14fd                	addi	s1,s1,-1
 662:	ff349ae3          	bne	s1,s3,656 <printint+0x82>
 666:	74e2                	ld	s1,56(sp)
}
 668:	60a6                	ld	ra,72(sp)
 66a:	6406                	ld	s0,64(sp)
 66c:	7942                	ld	s2,48(sp)
 66e:	79a2                	ld	s3,40(sp)
 670:	6161                	addi	sp,sp,80
 672:	8082                	ret

0000000000000674 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 674:	711d                	addi	sp,sp,-96
 676:	ec86                	sd	ra,88(sp)
 678:	e8a2                	sd	s0,80(sp)
 67a:	e4a6                	sd	s1,72(sp)
 67c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 67e:	0005c483          	lbu	s1,0(a1)
 682:	2a048063          	beqz	s1,922 <vprintf+0x2ae>
 686:	e0ca                	sd	s2,64(sp)
 688:	fc4e                	sd	s3,56(sp)
 68a:	f852                	sd	s4,48(sp)
 68c:	f456                	sd	s5,40(sp)
 68e:	f05a                	sd	s6,32(sp)
 690:	ec5e                	sd	s7,24(sp)
 692:	e862                	sd	s8,16(sp)
 694:	8b2a                	mv	s6,a0
 696:	8a2e                	mv	s4,a1
 698:	8bb2                	mv	s7,a2
  state = 0;
 69a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 69c:	4901                	li	s2,0
 69e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 6a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 6a4:	06400c13          	li	s8,100
 6a8:	a00d                	j	6ca <vprintf+0x56>
        putc(fd, c0);
 6aa:	85a6                	mv	a1,s1
 6ac:	855a                	mv	a0,s6
 6ae:	f09ff0ef          	jal	5b6 <putc>
 6b2:	a019                	j	6b8 <vprintf+0x44>
    } else if (state == '%') {
 6b4:	03598363          	beq	s3,s5,6da <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 6b8:	0019079b          	addiw	a5,s2,1
 6bc:	893e                	mv	s2,a5
 6be:	873e                	mv	a4,a5
 6c0:	97d2                	add	a5,a5,s4
 6c2:	0007c483          	lbu	s1,0(a5)
 6c6:	24048763          	beqz	s1,914 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 6ca:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 6ce:	fe0993e3          	bnez	s3,6b4 <vprintf+0x40>
      if (c0 == '%') {
 6d2:	fd579ce3          	bne	a5,s5,6aa <vprintf+0x36>
        state = '%';
 6d6:	89be                	mv	s3,a5
 6d8:	b7c5                	j	6b8 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 6da:	00ea06b3          	add	a3,s4,a4
 6de:	0016c603          	lbu	a2,1(a3)
      if (c1)
 6e2:	24060563          	beqz	a2,92c <vprintf+0x2b8>
      if (c0 == 'd') {
 6e6:	0b878763          	beq	a5,s8,794 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 6ea:	f9478693          	addi	a3,a5,-108
 6ee:	0016b693          	seqz	a3,a3
 6f2:	f9c60593          	addi	a1,a2,-100
 6f6:	0015b593          	seqz	a1,a1
 6fa:	8df5                	and	a1,a1,a3
 6fc:	e9c5                	bnez	a1,7ac <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 6fe:	9752                	add	a4,a4,s4
 700:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 704:	f9460713          	addi	a4,a2,-108
 708:	00173713          	seqz	a4,a4
 70c:	8f75                	and	a4,a4,a3
 70e:	f9c50593          	addi	a1,a0,-100
 712:	0015b593          	seqz	a1,a1
 716:	8df9                	and	a1,a1,a4
 718:	e5dd                	bnez	a1,7c6 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 71a:	07500593          	li	a1,117
 71e:	0cb78163          	beq	a5,a1,7e0 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 722:	f8b60593          	addi	a1,a2,-117
 726:	0015b593          	seqz	a1,a1
 72a:	8df5                	and	a1,a1,a3
 72c:	e5f1                	bnez	a1,7f8 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 72e:	f8b50593          	addi	a1,a0,-117
 732:	0015b593          	seqz	a1,a1
 736:	8df9                	and	a1,a1,a4
 738:	ede9                	bnez	a1,812 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 73a:	07800593          	li	a1,120
 73e:	0eb78763          	beq	a5,a1,82c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 742:	f8860613          	addi	a2,a2,-120
 746:	00163613          	seqz	a2,a2
 74a:	8ef1                	and	a3,a3,a2
 74c:	0e069c63          	bnez	a3,844 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 750:	f8850513          	addi	a0,a0,-120
 754:	00153513          	seqz	a0,a0
 758:	8f69                	and	a4,a4,a0
 75a:	10071263          	bnez	a4,85e <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 75e:	07000713          	li	a4,112
 762:	10e78a63          	beq	a5,a4,876 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 766:	06300713          	li	a4,99
 76a:	14e78a63          	beq	a5,a4,8be <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 76e:	07300713          	li	a4,115
 772:	16e78063          	beq	a5,a4,8d2 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 776:	02500713          	li	a4,37
 77a:	18e78863          	beq	a5,a4,90a <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 77e:	02500593          	li	a1,37
 782:	855a                	mv	a0,s6
 784:	e33ff0ef          	jal	5b6 <putc>
        putc(fd, c0);
 788:	85a6                	mv	a1,s1
 78a:	855a                	mv	a0,s6
 78c:	e2bff0ef          	jal	5b6 <putc>
      }

      state = 0;
 790:	4981                	li	s3,0
 792:	b71d                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 794:	008b8493          	addi	s1,s7,8
 798:	4685                	li	a3,1
 79a:	4629                	li	a2,10
 79c:	000ba583          	lw	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	e33ff0ef          	jal	5d4 <printint>
 7a6:	8ba6                	mv	s7,s1
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b739                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ac:	008b8493          	addi	s1,s7,8
 7b0:	4685                	li	a3,1
 7b2:	4629                	li	a2,10
 7b4:	000bb583          	ld	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	e1bff0ef          	jal	5d4 <printint>
        i += 1;
 7be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c0:	8ba6                	mv	s7,s1
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bdd5                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c6:	008b8493          	addi	s1,s7,8
 7ca:	4685                	li	a3,1
 7cc:	4629                	li	a2,10
 7ce:	000bb583          	ld	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	e01ff0ef          	jal	5d4 <printint>
        i += 2;
 7d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7da:	8ba6                	mv	s7,s1
      state = 0;
 7dc:	4981                	li	s3,0
        i += 2;
 7de:	bde9                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7e0:	008b8493          	addi	s1,s7,8
 7e4:	4681                	li	a3,0
 7e6:	4629                	li	a2,10
 7e8:	000be583          	lwu	a1,0(s7)
 7ec:	855a                	mv	a0,s6
 7ee:	de7ff0ef          	jal	5d4 <printint>
 7f2:	8ba6                	mv	s7,s1
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b5c9                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f8:	008b8493          	addi	s1,s7,8
 7fc:	4681                	li	a3,0
 7fe:	4629                	li	a2,10
 800:	000bb583          	ld	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	dcfff0ef          	jal	5d4 <printint>
        i += 1;
 80a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 80c:	8ba6                	mv	s7,s1
      state = 0;
 80e:	4981                	li	s3,0
 810:	b565                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 812:	008b8493          	addi	s1,s7,8
 816:	4681                	li	a3,0
 818:	4629                	li	a2,10
 81a:	000bb583          	ld	a1,0(s7)
 81e:	855a                	mv	a0,s6
 820:	db5ff0ef          	jal	5d4 <printint>
        i += 2;
 824:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 826:	8ba6                	mv	s7,s1
      state = 0;
 828:	4981                	li	s3,0
        i += 2;
 82a:	b579                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 82c:	008b8493          	addi	s1,s7,8
 830:	4681                	li	a3,0
 832:	4641                	li	a2,16
 834:	000be583          	lwu	a1,0(s7)
 838:	855a                	mv	a0,s6
 83a:	d9bff0ef          	jal	5d4 <printint>
 83e:	8ba6                	mv	s7,s1
      state = 0;
 840:	4981                	li	s3,0
 842:	bd9d                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 844:	008b8493          	addi	s1,s7,8
 848:	4681                	li	a3,0
 84a:	4641                	li	a2,16
 84c:	000bb583          	ld	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	d83ff0ef          	jal	5d4 <printint>
        i += 1;
 856:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 858:	8ba6                	mv	s7,s1
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bdb1                	j	6b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 85e:	008b8493          	addi	s1,s7,8
 862:	4641                	li	a2,16
 864:	000bb583          	ld	a1,0(s7)
 868:	855a                	mv	a0,s6
 86a:	d6bff0ef          	jal	5d4 <printint>
        i += 2;
 86e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 870:	8ba6                	mv	s7,s1
      state = 0;
 872:	4981                	li	s3,0
        i += 2;
 874:	b591                	j	6b8 <vprintf+0x44>
 876:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 878:	008b8793          	addi	a5,s7,8
 87c:	8cbe                	mv	s9,a5
 87e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 882:	03000593          	li	a1,48
 886:	855a                	mv	a0,s6
 888:	d2fff0ef          	jal	5b6 <putc>
  putc(fd, 'x');
 88c:	07800593          	li	a1,120
 890:	855a                	mv	a0,s6
 892:	d25ff0ef          	jal	5b6 <putc>
 896:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 898:	00000b97          	auipc	s7,0x0
 89c:	2f0b8b93          	addi	s7,s7,752 # b88 <digits>
 8a0:	03c9d793          	srli	a5,s3,0x3c
 8a4:	97de                	add	a5,a5,s7
 8a6:	0007c583          	lbu	a1,0(a5)
 8aa:	855a                	mv	a0,s6
 8ac:	d0bff0ef          	jal	5b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8b0:	0992                	slli	s3,s3,0x4
 8b2:	34fd                	addiw	s1,s1,-1
 8b4:	f4f5                	bnez	s1,8a0 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 8b6:	8be6                	mv	s7,s9
      state = 0;
 8b8:	4981                	li	s3,0
 8ba:	6ca2                	ld	s9,8(sp)
 8bc:	bbf5                	j	6b8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 8be:	008b8493          	addi	s1,s7,8
 8c2:	000bc583          	lbu	a1,0(s7)
 8c6:	855a                	mv	a0,s6
 8c8:	cefff0ef          	jal	5b6 <putc>
 8cc:	8ba6                	mv	s7,s1
      state = 0;
 8ce:	4981                	li	s3,0
 8d0:	b3e5                	j	6b8 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 8d2:	008b8993          	addi	s3,s7,8
 8d6:	000bb483          	ld	s1,0(s7)
 8da:	cc91                	beqz	s1,8f6 <vprintf+0x282>
        for (; *s; s++)
 8dc:	0004c583          	lbu	a1,0(s1)
 8e0:	c195                	beqz	a1,904 <vprintf+0x290>
          putc(fd, *s);
 8e2:	855a                	mv	a0,s6
 8e4:	cd3ff0ef          	jal	5b6 <putc>
        for (; *s; s++)
 8e8:	0485                	addi	s1,s1,1
 8ea:	0004c583          	lbu	a1,0(s1)
 8ee:	f9f5                	bnez	a1,8e2 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 8f0:	8bce                	mv	s7,s3
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	b3d1                	j	6b8 <vprintf+0x44>
          s = "(null)";
 8f6:	00000497          	auipc	s1,0x0
 8fa:	28a48493          	addi	s1,s1,650 # b80 <malloc+0x158>
        for (; *s; s++)
 8fe:	02800593          	li	a1,40
 902:	b7c5                	j	8e2 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 904:	8bce                	mv	s7,s3
      state = 0;
 906:	4981                	li	s3,0
 908:	bb45                	j	6b8 <vprintf+0x44>
        putc(fd, '%');
 90a:	85be                	mv	a1,a5
 90c:	855a                	mv	a0,s6
 90e:	ca9ff0ef          	jal	5b6 <putc>
 912:	bdbd                	j	790 <vprintf+0x11c>
 914:	6906                	ld	s2,64(sp)
 916:	79e2                	ld	s3,56(sp)
 918:	7a42                	ld	s4,48(sp)
 91a:	7aa2                	ld	s5,40(sp)
 91c:	7b02                	ld	s6,32(sp)
 91e:	6be2                	ld	s7,24(sp)
 920:	6c42                	ld	s8,16(sp)
    }
  }
}
 922:	60e6                	ld	ra,88(sp)
 924:	6446                	ld	s0,80(sp)
 926:	64a6                	ld	s1,72(sp)
 928:	6125                	addi	sp,sp,96
 92a:	8082                	ret
      if (c0 == 'd') {
 92c:	06400713          	li	a4,100
 930:	e6e782e3          	beq	a5,a4,794 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 934:	f9478693          	addi	a3,a5,-108
 938:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 93c:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 93e:	4701                	li	a4,0
 940:	bbe9                	j	71a <vprintf+0xa6>

0000000000000942 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 942:	715d                	addi	sp,sp,-80
 944:	ec06                	sd	ra,24(sp)
 946:	e822                	sd	s0,16(sp)
 948:	1000                	addi	s0,sp,32
 94a:	e010                	sd	a2,0(s0)
 94c:	e414                	sd	a3,8(s0)
 94e:	e818                	sd	a4,16(s0)
 950:	ec1c                	sd	a5,24(s0)
 952:	03043023          	sd	a6,32(s0)
 956:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 95a:	8622                	mv	a2,s0
 95c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 960:	d15ff0ef          	jal	674 <vprintf>
}
 964:	60e2                	ld	ra,24(sp)
 966:	6442                	ld	s0,16(sp)
 968:	6161                	addi	sp,sp,80
 96a:	8082                	ret

000000000000096c <printf>:

void
printf(const char *fmt, ...)
{
 96c:	711d                	addi	sp,sp,-96
 96e:	ec06                	sd	ra,24(sp)
 970:	e822                	sd	s0,16(sp)
 972:	1000                	addi	s0,sp,32
 974:	e40c                	sd	a1,8(s0)
 976:	e810                	sd	a2,16(s0)
 978:	ec14                	sd	a3,24(s0)
 97a:	f018                	sd	a4,32(s0)
 97c:	f41c                	sd	a5,40(s0)
 97e:	03043823          	sd	a6,48(s0)
 982:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 986:	00840613          	addi	a2,s0,8
 98a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 98e:	85aa                	mv	a1,a0
 990:	4505                	li	a0,1
 992:	ce3ff0ef          	jal	674 <vprintf>
}
 996:	60e2                	ld	ra,24(sp)
 998:	6442                	ld	s0,16(sp)
 99a:	6125                	addi	sp,sp,96
 99c:	8082                	ret

000000000000099e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 99e:	1141                	addi	sp,sp,-16
 9a0:	e406                	sd	ra,8(sp)
 9a2:	e022                	sd	s0,0(sp)
 9a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 9a6:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9aa:	00000797          	auipc	a5,0x0
 9ae:	6567b783          	ld	a5,1622(a5) # 1000 <freep>
 9b2:	a095                	j	a16 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 9b4:	ff852583          	lw	a1,-8(a0)
 9b8:	6390                	ld	a2,0(a5)
 9ba:	02059813          	slli	a6,a1,0x20
 9be:	01c85693          	srli	a3,a6,0x1c
 9c2:	96ba                	add	a3,a3,a4
 9c4:	02d60563          	beq	a2,a3,9ee <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 9cc:	4790                	lw	a2,8(a5)
 9ce:	02061593          	slli	a1,a2,0x20
 9d2:	01c5d693          	srli	a3,a1,0x1c
 9d6:	96be                	add	a3,a3,a5
 9d8:	02d70263          	beq	a4,a3,9fc <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9dc:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62f73123          	sd	a5,1570(a4) # 1000 <freep>
}
 9e6:	60a2                	ld	ra,8(sp)
 9e8:	6402                	ld	s0,0(sp)
 9ea:	0141                	addi	sp,sp,16
 9ec:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9ee:	4614                	lw	a3,8(a2)
 9f0:	9ead                	addw	a3,a3,a1
 9f2:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9f6:	6394                	ld	a3,0(a5)
 9f8:	6290                	ld	a2,0(a3)
 9fa:	b7f9                	j	9c8 <free+0x2a>
    p->s.size += bp->s.size;
 9fc:	ff852703          	lw	a4,-8(a0)
 a00:	9f31                	addw	a4,a4,a2
 a02:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a04:	ff053703          	ld	a4,-16(a0)
 a08:	bfd1                	j	9dc <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a0a:	6394                	ld	a3,0(a5)
 a0c:	00d7e463          	bltu	a5,a3,a14 <free+0x76>
 a10:	fad762e3          	bltu	a4,a3,9b4 <free+0x16>
 a14:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a16:	fee7fae3          	bgeu	a5,a4,a0a <free+0x6c>
 a1a:	6394                	ld	a3,0(a5)
 a1c:	f8d76ce3          	bltu	a4,a3,9b4 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a20:	f8d7fae3          	bgeu	a5,a3,9b4 <free+0x16>
 a24:	87b6                	mv	a5,a3
 a26:	bfc5                	j	a16 <free+0x78>

0000000000000a28 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 a28:	7139                	addi	sp,sp,-64
 a2a:	fc06                	sd	ra,56(sp)
 a2c:	f822                	sd	s0,48(sp)
 a2e:	f04a                	sd	s2,32(sp)
 a30:	ec4e                	sd	s3,24(sp)
 a32:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a34:	02051993          	slli	s3,a0,0x20
 a38:	0209d993          	srli	s3,s3,0x20
 a3c:	09bd                	addi	s3,s3,15
 a3e:	0049d993          	srli	s3,s3,0x4
 a42:	2985                	addiw	s3,s3,1
 a44:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 a46:	00000517          	auipc	a0,0x0
 a4a:	5ba53503          	ld	a0,1466(a0) # 1000 <freep>
 a4e:	c905                	beqz	a0,a7e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a50:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a52:	4798                	lw	a4,8(a5)
 a54:	09377663          	bgeu	a4,s3,ae0 <malloc+0xb8>
 a58:	f426                	sd	s1,40(sp)
 a5a:	e852                	sd	s4,16(sp)
 a5c:	e456                	sd	s5,8(sp)
 a5e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a60:	8a4e                	mv	s4,s3
 a62:	6705                	lui	a4,0x1
 a64:	00e9f363          	bgeu	s3,a4,a6a <malloc+0x42>
 a68:	6a05                	lui	s4,0x1
 a6a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a6e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a72:	00000497          	auipc	s1,0x0
 a76:	58e48493          	addi	s1,s1,1422 # 1000 <freep>
  if (p == SBRK_ERROR)
 a7a:	5afd                	li	s5,-1
 a7c:	a83d                	j	aba <malloc+0x92>
 a7e:	f426                	sd	s1,40(sp)
 a80:	e852                	sd	s4,16(sp)
 a82:	e456                	sd	s5,8(sp)
 a84:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a86:	00000797          	auipc	a5,0x0
 a8a:	59a78793          	addi	a5,a5,1434 # 1020 <base>
 a8e:	00000717          	auipc	a4,0x0
 a92:	56f73923          	sd	a5,1394(a4) # 1000 <freep>
 a96:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a98:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a9c:	b7d1                	j	a60 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a9e:	6398                	ld	a4,0(a5)
 aa0:	e118                	sd	a4,0(a0)
 aa2:	a899                	j	af8 <malloc+0xd0>
  hp->s.size = nu;
 aa4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 aa8:	0541                	addi	a0,a0,16
 aaa:	ef5ff0ef          	jal	99e <free>
  return freep;
 aae:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 ab0:	c125                	beqz	a0,b10 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ab2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 ab4:	4798                	lw	a4,8(a5)
 ab6:	03277163          	bgeu	a4,s2,ad8 <malloc+0xb0>
    if (p == freep)
 aba:	6098                	ld	a4,0(s1)
 abc:	853e                	mv	a0,a5
 abe:	fef71ae3          	bne	a4,a5,ab2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ac2:	8552                	mv	a0,s4
 ac4:	a17ff0ef          	jal	4da <sbrk>
  if (p == SBRK_ERROR)
 ac8:	fd551ee3          	bne	a0,s5,aa4 <malloc+0x7c>
        return 0;
 acc:	4501                	li	a0,0
 ace:	74a2                	ld	s1,40(sp)
 ad0:	6a42                	ld	s4,16(sp)
 ad2:	6aa2                	ld	s5,8(sp)
 ad4:	6b02                	ld	s6,0(sp)
 ad6:	a03d                	j	b04 <malloc+0xdc>
 ad8:	74a2                	ld	s1,40(sp)
 ada:	6a42                	ld	s4,16(sp)
 adc:	6aa2                	ld	s5,8(sp)
 ade:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 ae0:	fae90fe3          	beq	s2,a4,a9e <malloc+0x76>
        p->s.size -= nunits;
 ae4:	4137073b          	subw	a4,a4,s3
 ae8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aea:	02071693          	slli	a3,a4,0x20
 aee:	01c6d713          	srli	a4,a3,0x1c
 af2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 af4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 af8:	00000717          	auipc	a4,0x0
 afc:	50a73423          	sd	a0,1288(a4) # 1000 <freep>
      return (void *)(p + 1);
 b00:	01078513          	addi	a0,a5,16
  }
}
 b04:	70e2                	ld	ra,56(sp)
 b06:	7442                	ld	s0,48(sp)
 b08:	7902                	ld	s2,32(sp)
 b0a:	69e2                	ld	s3,24(sp)
 b0c:	6121                	addi	sp,sp,64
 b0e:	8082                	ret
 b10:	74a2                	ld	s1,40(sp)
 b12:	6a42                	ld	s4,16(sp)
 b14:	6aa2                	ld	s5,8(sp)
 b16:	6b02                	ld	s6,0(sp)
 b18:	b7f5                	j	b04 <malloc+0xdc>
