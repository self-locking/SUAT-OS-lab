
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
   * October 1988, p. 1195.
   */
  long hi, lo, x;

  /* Transform to [1, 0x7ffffffe] range. */
  x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
  hi = x / 127773;
  lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
  x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
  if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
    x += 0x7fffffff;
  /* Transform to [0, 0x7ffffffd] range. */
  x--;
      72:	17fd                	addi	a5,a5,-1
  *ctx = x;
      74:	e11c                	sd	a5,0(a0)
  return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
  return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	f63ff0ef          	jal	0 <do_rand>
}
      a2:	60a2                	ld	ra,8(sp)
      a4:	6402                	ld	s0,0(sp)
      a6:	0141                	addi	sp,sp,16
      a8:	8082                	ret

00000000000000aa <go>:

void
go(int which_child)
{
      aa:	7171                	addi	sp,sp,-176
      ac:	f506                	sd	ra,168(sp)
      ae:	f122                	sd	s0,160(sp)
      b0:	ed26                	sd	s1,152(sp)
      b2:	1900                	addi	s0,sp,176
      b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      b6:	4501                	li	a0,0
      b8:	347000ef          	jal	bfe <sbrk>
      bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c0:	00001517          	auipc	a0,0x1
      c4:	18050513          	addi	a0,a0,384 # 1240 <malloc+0xf4>
      c8:	3d3000ef          	jal	c9a <mkdir>
  if (chdir("grindir") != 0) {
      cc:	00001517          	auipc	a0,0x1
      d0:	17450513          	addi	a0,a0,372 # 1240 <malloc+0xf4>
      d4:	3cf000ef          	jal	ca2 <chdir>
      d8:	c505                	beqz	a0,100 <go+0x56>
      da:	e94a                	sd	s2,144(sp)
      dc:	e54e                	sd	s3,136(sp)
      de:	e152                	sd	s4,128(sp)
      e0:	fcd6                	sd	s5,120(sp)
      e2:	f8da                	sd	s6,112(sp)
      e4:	f4de                	sd	s7,104(sp)
      e6:	f0e2                	sd	s8,96(sp)
      e8:	ece6                	sd	s9,88(sp)
      ea:	e8ea                	sd	s10,80(sp)
      ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	15a50513          	addi	a0,a0,346 # 1248 <malloc+0xfc>
      f6:	79b000ef          	jal	1090 <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	337000ef          	jal	c32 <exit>
     100:	e94a                	sd	s2,144(sp)
     102:	e54e                	sd	s3,136(sp)
     104:	e152                	sd	s4,128(sp)
     106:	fcd6                	sd	s5,120(sp)
     108:	f8da                	sd	s6,112(sp)
     10a:	f4de                	sd	s7,104(sp)
     10c:	f0e2                	sd	s8,96(sp)
     10e:	ece6                	sd	s9,88(sp)
     110:	e8ea                	sd	s10,80(sp)
     112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     114:	00001517          	auipc	a0,0x1
     118:	15c50513          	addi	a0,a0,348 # 1270 <malloc+0x124>
     11c:	387000ef          	jal	ca2 <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	160c0c13          	addi	s8,s8,352 # 1280 <malloc+0x134>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	14ec0c13          	addi	s8,s8,334 # 1278 <malloc+0x12c>
  uint64 iters = 0;
     132:	4481                	li	s1,0
  int fd = -1;
     134:	5cfd                	li	s9,-1

  while (1) {
    iters++;
    if ((iters % 500) == 0)
     136:	106259b7          	lui	s3,0x10625
     13a:	dd398993          	addi	s3,s3,-557 # 10624dd3 <base+0x106229cb>
     13e:	09be                	slli	s3,s3,0xf
     140:	8d598993          	addi	s3,s3,-1835
     144:	09ca                	slli	s3,s3,0x12
     146:	80098993          	addi	s3,s3,-2048
     14a:	fcf98993          	addi	s3,s3,-49
     14e:	1f400b93          	li	s7,500
      write(1, which_child ? "B" : "A", 1);
     152:	4a05                	li	s4,1
    int what = rand() % 23;
     154:	b2164ab7          	lui	s5,0xb2164
     158:	2c9a8a93          	addi	s5,s5,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     15c:	4b59                	li	s6,22
     15e:	00001917          	auipc	s2,0x1
     162:	3f290913          	addi	s2,s2,1010 # 1550 <malloc+0x404>
      close(fd1);
      unlink("c");
    } else if (what == 22) {
      // echo hi | cat
      int aa[2], bb[2];
      if (pipe(aa) < 0) {
     166:	f6840d93          	addi	s11,s0,-152
     16a:	a819                	j	180 <go+0xd6>
      close(open("grindir/../a", O_CREATE | O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	11850513          	addi	a0,a0,280 # 1288 <malloc+0x13c>
     178:	2fb000ef          	jal	c72 <open>
     17c:	2df000ef          	jal	c5a <close>
    iters++;
     180:	0485                	addi	s1,s1,1
    if ((iters % 500) == 0)
     182:	0024d793          	srli	a5,s1,0x2
     186:	0337b7b3          	mulhu	a5,a5,s3
     18a:	8391                	srli	a5,a5,0x4
     18c:	037787b3          	mul	a5,a5,s7
     190:	00f49763          	bne	s1,a5,19e <go+0xf4>
      write(1, which_child ? "B" : "A", 1);
     194:	8652                	mv	a2,s4
     196:	85e2                	mv	a1,s8
     198:	8552                	mv	a0,s4
     19a:	2b9000ef          	jal	c52 <write>
    int what = rand() % 23;
     19e:	ef1ff0ef          	jal	8e <rand>
     1a2:	035507b3          	mul	a5,a0,s5
     1a6:	9381                	srli	a5,a5,0x20
     1a8:	9fa9                	addw	a5,a5,a0
     1aa:	4047d79b          	sraiw	a5,a5,0x4
     1ae:	41f5571b          	sraiw	a4,a0,0x1f
     1b2:	9f99                	subw	a5,a5,a4
     1b4:	0017971b          	slliw	a4,a5,0x1
     1b8:	9f3d                	addw	a4,a4,a5
     1ba:	0037171b          	slliw	a4,a4,0x3
     1be:	40f707bb          	subw	a5,a4,a5
     1c2:	9d1d                	subw	a0,a0,a5
     1c4:	faab6ee3          	bltu	s6,a0,180 <go+0xd6>
     1c8:	02051793          	slli	a5,a0,0x20
     1cc:	01e7d513          	srli	a0,a5,0x1e
     1d0:	954a                	add	a0,a0,s2
     1d2:	411c                	lw	a5,0(a0)
     1d4:	97ca                	add	a5,a5,s2
     1d6:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE | O_RDWR));
     1d8:	20200593          	li	a1,514
     1dc:	00001517          	auipc	a0,0x1
     1e0:	0bc50513          	addi	a0,a0,188 # 1298 <malloc+0x14c>
     1e4:	28f000ef          	jal	c72 <open>
     1e8:	273000ef          	jal	c5a <close>
     1ec:	bf51                	j	180 <go+0xd6>
      unlink("grindir/../a");
     1ee:	00001517          	auipc	a0,0x1
     1f2:	09a50513          	addi	a0,a0,154 # 1288 <malloc+0x13c>
     1f6:	28d000ef          	jal	c82 <unlink>
     1fa:	b759                	j	180 <go+0xd6>
      if (chdir("grindir") != 0) {
     1fc:	00001517          	auipc	a0,0x1
     200:	04450513          	addi	a0,a0,68 # 1240 <malloc+0xf4>
     204:	29f000ef          	jal	ca2 <chdir>
     208:	ed11                	bnez	a0,224 <go+0x17a>
      unlink("../b");
     20a:	00001517          	auipc	a0,0x1
     20e:	0a650513          	addi	a0,a0,166 # 12b0 <malloc+0x164>
     212:	271000ef          	jal	c82 <unlink>
      chdir("/");
     216:	00001517          	auipc	a0,0x1
     21a:	05a50513          	addi	a0,a0,90 # 1270 <malloc+0x124>
     21e:	285000ef          	jal	ca2 <chdir>
     222:	bfb9                	j	180 <go+0xd6>
        printf("grind: chdir grindir failed\n");
     224:	00001517          	auipc	a0,0x1
     228:	02450513          	addi	a0,a0,36 # 1248 <malloc+0xfc>
     22c:	665000ef          	jal	1090 <printf>
        exit(1);
     230:	4505                	li	a0,1
     232:	201000ef          	jal	c32 <exit>
      close(fd);
     236:	8566                	mv	a0,s9
     238:	223000ef          	jal	c5a <close>
      fd = open("/grindir/../a", O_CREATE | O_RDWR);
     23c:	20200593          	li	a1,514
     240:	00001517          	auipc	a0,0x1
     244:	07850513          	addi	a0,a0,120 # 12b8 <malloc+0x16c>
     248:	22b000ef          	jal	c72 <open>
     24c:	8caa                	mv	s9,a0
     24e:	bf0d                	j	180 <go+0xd6>
      close(fd);
     250:	8566                	mv	a0,s9
     252:	209000ef          	jal	c5a <close>
      fd = open("/./grindir/./../b", O_CREATE | O_RDWR);
     256:	20200593          	li	a1,514
     25a:	00001517          	auipc	a0,0x1
     25e:	06e50513          	addi	a0,a0,110 # 12c8 <malloc+0x17c>
     262:	211000ef          	jal	c72 <open>
     266:	8caa                	mv	s9,a0
     268:	bf21                	j	180 <go+0xd6>
      write(fd, buf, sizeof(buf));
     26a:	3e700613          	li	a2,999
     26e:	00002597          	auipc	a1,0x2
     272:	db258593          	addi	a1,a1,-590 # 2020 <buf.0>
     276:	8566                	mv	a0,s9
     278:	1db000ef          	jal	c52 <write>
     27c:	b711                	j	180 <go+0xd6>
      read(fd, buf, sizeof(buf));
     27e:	3e700613          	li	a2,999
     282:	00002597          	auipc	a1,0x2
     286:	d9e58593          	addi	a1,a1,-610 # 2020 <buf.0>
     28a:	8566                	mv	a0,s9
     28c:	1bf000ef          	jal	c4a <read>
     290:	bdc5                	j	180 <go+0xd6>
      mkdir("grindir/../a");
     292:	00001517          	auipc	a0,0x1
     296:	ff650513          	addi	a0,a0,-10 # 1288 <malloc+0x13c>
     29a:	201000ef          	jal	c9a <mkdir>
      close(open("a/../a/./a", O_CREATE | O_RDWR));
     29e:	20200593          	li	a1,514
     2a2:	00001517          	auipc	a0,0x1
     2a6:	03e50513          	addi	a0,a0,62 # 12e0 <malloc+0x194>
     2aa:	1c9000ef          	jal	c72 <open>
     2ae:	1ad000ef          	jal	c5a <close>
      unlink("a/a");
     2b2:	00001517          	auipc	a0,0x1
     2b6:	03e50513          	addi	a0,a0,62 # 12f0 <malloc+0x1a4>
     2ba:	1c9000ef          	jal	c82 <unlink>
     2be:	b5c9                	j	180 <go+0xd6>
      mkdir("/../b");
     2c0:	00001517          	auipc	a0,0x1
     2c4:	03850513          	addi	a0,a0,56 # 12f8 <malloc+0x1ac>
     2c8:	1d3000ef          	jal	c9a <mkdir>
      close(open("grindir/../b/b", O_CREATE | O_RDWR));
     2cc:	20200593          	li	a1,514
     2d0:	00001517          	auipc	a0,0x1
     2d4:	03050513          	addi	a0,a0,48 # 1300 <malloc+0x1b4>
     2d8:	19b000ef          	jal	c72 <open>
     2dc:	17f000ef          	jal	c5a <close>
      unlink("b/b");
     2e0:	00001517          	auipc	a0,0x1
     2e4:	03050513          	addi	a0,a0,48 # 1310 <malloc+0x1c4>
     2e8:	19b000ef          	jal	c82 <unlink>
     2ec:	bd51                	j	180 <go+0xd6>
      unlink("b");
     2ee:	00001517          	auipc	a0,0x1
     2f2:	02a50513          	addi	a0,a0,42 # 1318 <malloc+0x1cc>
     2f6:	18d000ef          	jal	c82 <unlink>
      link("../grindir/./../a", "../b");
     2fa:	00001597          	auipc	a1,0x1
     2fe:	fb658593          	addi	a1,a1,-74 # 12b0 <malloc+0x164>
     302:	00001517          	auipc	a0,0x1
     306:	01e50513          	addi	a0,a0,30 # 1320 <malloc+0x1d4>
     30a:	189000ef          	jal	c92 <link>
     30e:	bd8d                	j	180 <go+0xd6>
      unlink("../grindir/../a");
     310:	00001517          	auipc	a0,0x1
     314:	02850513          	addi	a0,a0,40 # 1338 <malloc+0x1ec>
     318:	16b000ef          	jal	c82 <unlink>
      link(".././b", "/grindir/../a");
     31c:	00001597          	auipc	a1,0x1
     320:	f9c58593          	addi	a1,a1,-100 # 12b8 <malloc+0x16c>
     324:	00001517          	auipc	a0,0x1
     328:	02450513          	addi	a0,a0,36 # 1348 <malloc+0x1fc>
     32c:	167000ef          	jal	c92 <link>
     330:	bd81                	j	180 <go+0xd6>
      int pid = fork();
     332:	0f9000ef          	jal	c2a <fork>
      if (pid == 0) {
     336:	c519                	beqz	a0,344 <go+0x29a>
      } else if (pid < 0) {
     338:	00054863          	bltz	a0,348 <go+0x29e>
      wait(0);
     33c:	4501                	li	a0,0
     33e:	0fd000ef          	jal	c3a <wait>
     342:	bd3d                	j	180 <go+0xd6>
        exit(0);
     344:	0ef000ef          	jal	c32 <exit>
        printf("grind: fork failed\n");
     348:	00001517          	auipc	a0,0x1
     34c:	00850513          	addi	a0,a0,8 # 1350 <malloc+0x204>
     350:	541000ef          	jal	1090 <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	0dd000ef          	jal	c32 <exit>
      int pid = fork();
     35a:	0d1000ef          	jal	c2a <fork>
      if (pid == 0) {
     35e:	c519                	beqz	a0,36c <go+0x2c2>
      } else if (pid < 0) {
     360:	00054d63          	bltz	a0,37a <go+0x2d0>
      wait(0);
     364:	4501                	li	a0,0
     366:	0d5000ef          	jal	c3a <wait>
     36a:	bd19                	j	180 <go+0xd6>
        fork();
     36c:	0bf000ef          	jal	c2a <fork>
        fork();
     370:	0bb000ef          	jal	c2a <fork>
        exit(0);
     374:	4501                	li	a0,0
     376:	0bd000ef          	jal	c32 <exit>
        printf("grind: fork failed\n");
     37a:	00001517          	auipc	a0,0x1
     37e:	fd650513          	addi	a0,a0,-42 # 1350 <malloc+0x204>
     382:	50f000ef          	jal	1090 <printf>
        exit(1);
     386:	4505                	li	a0,1
     388:	0ab000ef          	jal	c32 <exit>
      sbrk(6011);
     38c:	6505                	lui	a0,0x1
     38e:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x1cb>
     392:	06d000ef          	jal	bfe <sbrk>
     396:	b3ed                	j	180 <go+0xd6>
      if (sbrk(0) > break0)
     398:	4501                	li	a0,0
     39a:	065000ef          	jal	bfe <sbrk>
     39e:	f5843783          	ld	a5,-168(s0)
     3a2:	dca7ffe3          	bgeu	a5,a0,180 <go+0xd6>
        sbrk(-(sbrk(0) - break0));
     3a6:	4501                	li	a0,0
     3a8:	057000ef          	jal	bfe <sbrk>
     3ac:	f5843783          	ld	a5,-168(s0)
     3b0:	40a7853b          	subw	a0,a5,a0
     3b4:	04b000ef          	jal	bfe <sbrk>
     3b8:	b3e1                	j	180 <go+0xd6>
      int pid = fork();
     3ba:	071000ef          	jal	c2a <fork>
     3be:	8d2a                	mv	s10,a0
      if (pid == 0) {
     3c0:	c10d                	beqz	a0,3e2 <go+0x338>
      } else if (pid < 0) {
     3c2:	02054d63          	bltz	a0,3fc <go+0x352>
      if (chdir("../grindir/..") != 0) {
     3c6:	00001517          	auipc	a0,0x1
     3ca:	faa50513          	addi	a0,a0,-86 # 1370 <malloc+0x224>
     3ce:	0d5000ef          	jal	ca2 <chdir>
     3d2:	ed15                	bnez	a0,40e <go+0x364>
      kill(pid);
     3d4:	856a                	mv	a0,s10
     3d6:	08d000ef          	jal	c62 <kill>
      wait(0);
     3da:	4501                	li	a0,0
     3dc:	05f000ef          	jal	c3a <wait>
     3e0:	b345                	j	180 <go+0xd6>
        close(open("a", O_CREATE | O_RDWR));
     3e2:	20200593          	li	a1,514
     3e6:	00001517          	auipc	a0,0x1
     3ea:	f8250513          	addi	a0,a0,-126 # 1368 <malloc+0x21c>
     3ee:	085000ef          	jal	c72 <open>
     3f2:	069000ef          	jal	c5a <close>
        exit(0);
     3f6:	4501                	li	a0,0
     3f8:	03b000ef          	jal	c32 <exit>
        printf("grind: fork failed\n");
     3fc:	00001517          	auipc	a0,0x1
     400:	f5450513          	addi	a0,a0,-172 # 1350 <malloc+0x204>
     404:	48d000ef          	jal	1090 <printf>
        exit(1);
     408:	4505                	li	a0,1
     40a:	029000ef          	jal	c32 <exit>
        printf("grind: chdir failed\n");
     40e:	00001517          	auipc	a0,0x1
     412:	f7250513          	addi	a0,a0,-142 # 1380 <malloc+0x234>
     416:	47b000ef          	jal	1090 <printf>
        exit(1);
     41a:	4505                	li	a0,1
     41c:	017000ef          	jal	c32 <exit>
      int pid = fork();
     420:	00b000ef          	jal	c2a <fork>
      if (pid == 0) {
     424:	c519                	beqz	a0,432 <go+0x388>
      } else if (pid < 0) {
     426:	00054d63          	bltz	a0,440 <go+0x396>
      wait(0);
     42a:	4501                	li	a0,0
     42c:	00f000ef          	jal	c3a <wait>
     430:	bb81                	j	180 <go+0xd6>
        kill(getpid());
     432:	081000ef          	jal	cb2 <getpid>
     436:	02d000ef          	jal	c62 <kill>
        exit(0);
     43a:	4501                	li	a0,0
     43c:	7f6000ef          	jal	c32 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	f1050513          	addi	a0,a0,-240 # 1350 <malloc+0x204>
     448:	449000ef          	jal	1090 <printf>
        exit(1);
     44c:	4505                	li	a0,1
     44e:	7e4000ef          	jal	c32 <exit>
      if (pipe(fds) < 0) {
     452:	f7840513          	addi	a0,s0,-136
     456:	7ec000ef          	jal	c42 <pipe>
     45a:	02054363          	bltz	a0,480 <go+0x3d6>
      int pid = fork();
     45e:	7cc000ef          	jal	c2a <fork>
      if (pid == 0) {
     462:	c905                	beqz	a0,492 <go+0x3e8>
      } else if (pid < 0) {
     464:	08054263          	bltz	a0,4e8 <go+0x43e>
      close(fds[0]);
     468:	f7842503          	lw	a0,-136(s0)
     46c:	7ee000ef          	jal	c5a <close>
      close(fds[1]);
     470:	f7c42503          	lw	a0,-132(s0)
     474:	7e6000ef          	jal	c5a <close>
      wait(0);
     478:	4501                	li	a0,0
     47a:	7c0000ef          	jal	c3a <wait>
     47e:	b309                	j	180 <go+0xd6>
        printf("grind: pipe failed\n");
     480:	00001517          	auipc	a0,0x1
     484:	f1850513          	addi	a0,a0,-232 # 1398 <malloc+0x24c>
     488:	409000ef          	jal	1090 <printf>
        exit(1);
     48c:	4505                	li	a0,1
     48e:	7a4000ef          	jal	c32 <exit>
        fork();
     492:	798000ef          	jal	c2a <fork>
        fork();
     496:	794000ef          	jal	c2a <fork>
        if (write(fds[1], "x", 1) != 1)
     49a:	4605                	li	a2,1
     49c:	00001597          	auipc	a1,0x1
     4a0:	f1458593          	addi	a1,a1,-236 # 13b0 <malloc+0x264>
     4a4:	f7c42503          	lw	a0,-132(s0)
     4a8:	7aa000ef          	jal	c52 <write>
     4ac:	4785                	li	a5,1
     4ae:	00f51f63          	bne	a0,a5,4cc <go+0x422>
        if (read(fds[0], &c, 1) != 1)
     4b2:	4605                	li	a2,1
     4b4:	f7040593          	addi	a1,s0,-144
     4b8:	f7842503          	lw	a0,-136(s0)
     4bc:	78e000ef          	jal	c4a <read>
     4c0:	4785                	li	a5,1
     4c2:	00f51c63          	bne	a0,a5,4da <go+0x430>
        exit(0);
     4c6:	4501                	li	a0,0
     4c8:	76a000ef          	jal	c32 <exit>
          printf("grind: pipe write failed\n");
     4cc:	00001517          	auipc	a0,0x1
     4d0:	eec50513          	addi	a0,a0,-276 # 13b8 <malloc+0x26c>
     4d4:	3bd000ef          	jal	1090 <printf>
     4d8:	bfe9                	j	4b2 <go+0x408>
          printf("grind: pipe read failed\n");
     4da:	00001517          	auipc	a0,0x1
     4de:	efe50513          	addi	a0,a0,-258 # 13d8 <malloc+0x28c>
     4e2:	3af000ef          	jal	1090 <printf>
     4e6:	b7c5                	j	4c6 <go+0x41c>
        printf("grind: fork failed\n");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	e6850513          	addi	a0,a0,-408 # 1350 <malloc+0x204>
     4f0:	3a1000ef          	jal	1090 <printf>
        exit(1);
     4f4:	4505                	li	a0,1
     4f6:	73c000ef          	jal	c32 <exit>
      int pid = fork();
     4fa:	730000ef          	jal	c2a <fork>
      if (pid == 0) {
     4fe:	c519                	beqz	a0,50c <go+0x462>
      } else if (pid < 0) {
     500:	04054f63          	bltz	a0,55e <go+0x4b4>
      wait(0);
     504:	4501                	li	a0,0
     506:	734000ef          	jal	c3a <wait>
     50a:	b99d                	j	180 <go+0xd6>
        unlink("a");
     50c:	00001517          	auipc	a0,0x1
     510:	e5c50513          	addi	a0,a0,-420 # 1368 <malloc+0x21c>
     514:	76e000ef          	jal	c82 <unlink>
        mkdir("a");
     518:	00001517          	auipc	a0,0x1
     51c:	e5050513          	addi	a0,a0,-432 # 1368 <malloc+0x21c>
     520:	77a000ef          	jal	c9a <mkdir>
        chdir("a");
     524:	00001517          	auipc	a0,0x1
     528:	e4450513          	addi	a0,a0,-444 # 1368 <malloc+0x21c>
     52c:	776000ef          	jal	ca2 <chdir>
        unlink("../a");
     530:	00001517          	auipc	a0,0x1
     534:	ec850513          	addi	a0,a0,-312 # 13f8 <malloc+0x2ac>
     538:	74a000ef          	jal	c82 <unlink>
        fd = open("x", O_CREATE | O_RDWR);
     53c:	20200593          	li	a1,514
     540:	00001517          	auipc	a0,0x1
     544:	e7050513          	addi	a0,a0,-400 # 13b0 <malloc+0x264>
     548:	72a000ef          	jal	c72 <open>
        unlink("x");
     54c:	00001517          	auipc	a0,0x1
     550:	e6450513          	addi	a0,a0,-412 # 13b0 <malloc+0x264>
     554:	72e000ef          	jal	c82 <unlink>
        exit(0);
     558:	4501                	li	a0,0
     55a:	6d8000ef          	jal	c32 <exit>
        printf("grind: fork failed\n");
     55e:	00001517          	auipc	a0,0x1
     562:	df250513          	addi	a0,a0,-526 # 1350 <malloc+0x204>
     566:	32b000ef          	jal	1090 <printf>
        exit(1);
     56a:	4505                	li	a0,1
     56c:	6c6000ef          	jal	c32 <exit>
      unlink("c");
     570:	00001517          	auipc	a0,0x1
     574:	e9050513          	addi	a0,a0,-368 # 1400 <malloc+0x2b4>
     578:	70a000ef          	jal	c82 <unlink>
      int fd1 = open("c", O_CREATE | O_RDWR);
     57c:	20200593          	li	a1,514
     580:	00001517          	auipc	a0,0x1
     584:	e8050513          	addi	a0,a0,-384 # 1400 <malloc+0x2b4>
     588:	6ea000ef          	jal	c72 <open>
     58c:	8d2a                	mv	s10,a0
      if (fd1 < 0) {
     58e:	04054563          	bltz	a0,5d8 <go+0x52e>
      if (write(fd1, "x", 1) != 1) {
     592:	8652                	mv	a2,s4
     594:	00001597          	auipc	a1,0x1
     598:	e1c58593          	addi	a1,a1,-484 # 13b0 <malloc+0x264>
     59c:	6b6000ef          	jal	c52 <write>
     5a0:	05451563          	bne	a0,s4,5ea <go+0x540>
      if (fstat(fd1, &st) != 0) {
     5a4:	f7840593          	addi	a1,s0,-136
     5a8:	856a                	mv	a0,s10
     5aa:	6e0000ef          	jal	c8a <fstat>
     5ae:	e539                	bnez	a0,5fc <go+0x552>
      if (st.size != 1) {
     5b0:	f8843583          	ld	a1,-120(s0)
     5b4:	05459d63          	bne	a1,s4,60e <go+0x564>
      if (st.ino > 200) {
     5b8:	f7c42583          	lw	a1,-132(s0)
     5bc:	0c800793          	li	a5,200
     5c0:	06b7e163          	bltu	a5,a1,622 <go+0x578>
      close(fd1);
     5c4:	856a                	mv	a0,s10
     5c6:	694000ef          	jal	c5a <close>
      unlink("c");
     5ca:	00001517          	auipc	a0,0x1
     5ce:	e3650513          	addi	a0,a0,-458 # 1400 <malloc+0x2b4>
     5d2:	6b0000ef          	jal	c82 <unlink>
     5d6:	b66d                	j	180 <go+0xd6>
        printf("grind: create c failed\n");
     5d8:	00001517          	auipc	a0,0x1
     5dc:	e3050513          	addi	a0,a0,-464 # 1408 <malloc+0x2bc>
     5e0:	2b1000ef          	jal	1090 <printf>
        exit(1);
     5e4:	4505                	li	a0,1
     5e6:	64c000ef          	jal	c32 <exit>
        printf("grind: write c failed\n");
     5ea:	00001517          	auipc	a0,0x1
     5ee:	e3650513          	addi	a0,a0,-458 # 1420 <malloc+0x2d4>
     5f2:	29f000ef          	jal	1090 <printf>
        exit(1);
     5f6:	4505                	li	a0,1
     5f8:	63a000ef          	jal	c32 <exit>
        printf("grind: fstat failed\n");
     5fc:	00001517          	auipc	a0,0x1
     600:	e3c50513          	addi	a0,a0,-452 # 1438 <malloc+0x2ec>
     604:	28d000ef          	jal	1090 <printf>
        exit(1);
     608:	4505                	li	a0,1
     60a:	628000ef          	jal	c32 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60e:	2581                	sext.w	a1,a1
     610:	00001517          	auipc	a0,0x1
     614:	e4050513          	addi	a0,a0,-448 # 1450 <malloc+0x304>
     618:	279000ef          	jal	1090 <printf>
        exit(1);
     61c:	4505                	li	a0,1
     61e:	614000ef          	jal	c32 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     622:	00001517          	auipc	a0,0x1
     626:	e5650513          	addi	a0,a0,-426 # 1478 <malloc+0x32c>
     62a:	267000ef          	jal	1090 <printf>
        exit(1);
     62e:	4505                	li	a0,1
     630:	602000ef          	jal	c32 <exit>
      if (pipe(aa) < 0) {
     634:	856e                	mv	a0,s11
     636:	60c000ef          	jal	c42 <pipe>
     63a:	0c054263          	bltz	a0,6fe <go+0x654>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if (pipe(bb) < 0) {
     63e:	f7040513          	addi	a0,s0,-144
     642:	600000ef          	jal	c42 <pipe>
     646:	0c054663          	bltz	a0,712 <go+0x668>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     64a:	5e0000ef          	jal	c2a <fork>
      if (pid1 == 0) {
     64e:	0c050c63          	beqz	a0,726 <go+0x67c>
        close(aa[1]);
        char *args[3] = {"echo", "hi", 0};
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if (pid1 < 0) {
     652:	14054e63          	bltz	a0,7ae <go+0x704>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     656:	5d4000ef          	jal	c2a <fork>
      if (pid2 == 0) {
     65a:	16050463          	beqz	a0,7c2 <go+0x718>
        close(bb[1]);
        char *args[2] = {"cat", 0};
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if (pid2 < 0) {
     65e:	20054263          	bltz	a0,862 <go+0x7b8>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     662:	f6842503          	lw	a0,-152(s0)
     666:	5f4000ef          	jal	c5a <close>
      close(aa[1]);
     66a:	f6c42503          	lw	a0,-148(s0)
     66e:	5ec000ef          	jal	c5a <close>
      close(bb[1]);
     672:	f7442503          	lw	a0,-140(s0)
     676:	5e4000ef          	jal	c5a <close>
      char buf[4] = {0, 0, 0, 0};
     67a:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf + 0, 1);
     67e:	8652                	mv	a2,s4
     680:	f6040593          	addi	a1,s0,-160
     684:	f7042503          	lw	a0,-144(s0)
     688:	5c2000ef          	jal	c4a <read>
      read(bb[0], buf + 1, 1);
     68c:	8652                	mv	a2,s4
     68e:	f6140593          	addi	a1,s0,-159
     692:	f7042503          	lw	a0,-144(s0)
     696:	5b4000ef          	jal	c4a <read>
      read(bb[0], buf + 2, 1);
     69a:	8652                	mv	a2,s4
     69c:	f6240593          	addi	a1,s0,-158
     6a0:	f7042503          	lw	a0,-144(s0)
     6a4:	5a6000ef          	jal	c4a <read>
      close(bb[0]);
     6a8:	f7042503          	lw	a0,-144(s0)
     6ac:	5ae000ef          	jal	c5a <close>
      int st1, st2;
      wait(&st1);
     6b0:	f6440513          	addi	a0,s0,-156
     6b4:	586000ef          	jal	c3a <wait>
      wait(&st2);
     6b8:	f7840513          	addi	a0,s0,-136
     6bc:	57e000ef          	jal	c3a <wait>
      if (st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0) {
     6c0:	f6442783          	lw	a5,-156(s0)
     6c4:	f7842703          	lw	a4,-136(s0)
     6c8:	8fd9                	or	a5,a5,a4
     6ca:	eb99                	bnez	a5,6e0 <go+0x636>
     6cc:	00001597          	auipc	a1,0x1
     6d0:	e4c58593          	addi	a1,a1,-436 # 1518 <malloc+0x3cc>
     6d4:	f6040513          	addi	a0,s0,-160
     6d8:	2d4000ef          	jal	9ac <strcmp>
     6dc:	aa0502e3          	beqz	a0,180 <go+0xd6>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     6e0:	f6040693          	addi	a3,s0,-160
     6e4:	f7842603          	lw	a2,-136(s0)
     6e8:	f6442583          	lw	a1,-156(s0)
     6ec:	00001517          	auipc	a0,0x1
     6f0:	e3450513          	addi	a0,a0,-460 # 1520 <malloc+0x3d4>
     6f4:	19d000ef          	jal	1090 <printf>
        exit(1);
     6f8:	4505                	li	a0,1
     6fa:	538000ef          	jal	c32 <exit>
        fprintf(2, "grind: pipe failed\n");
     6fe:	00001597          	auipc	a1,0x1
     702:	c9a58593          	addi	a1,a1,-870 # 1398 <malloc+0x24c>
     706:	4509                	li	a0,2
     708:	15f000ef          	jal	1066 <fprintf>
        exit(1);
     70c:	4505                	li	a0,1
     70e:	524000ef          	jal	c32 <exit>
        fprintf(2, "grind: pipe failed\n");
     712:	00001597          	auipc	a1,0x1
     716:	c8658593          	addi	a1,a1,-890 # 1398 <malloc+0x24c>
     71a:	4509                	li	a0,2
     71c:	14b000ef          	jal	1066 <fprintf>
        exit(1);
     720:	4505                	li	a0,1
     722:	510000ef          	jal	c32 <exit>
        close(bb[0]);
     726:	f7042503          	lw	a0,-144(s0)
     72a:	530000ef          	jal	c5a <close>
        close(bb[1]);
     72e:	f7442503          	lw	a0,-140(s0)
     732:	528000ef          	jal	c5a <close>
        close(aa[0]);
     736:	f6842503          	lw	a0,-152(s0)
     73a:	520000ef          	jal	c5a <close>
        close(1);
     73e:	4505                	li	a0,1
     740:	51a000ef          	jal	c5a <close>
        if (dup(aa[1]) != 1) {
     744:	f6c42503          	lw	a0,-148(s0)
     748:	562000ef          	jal	caa <dup>
     74c:	4785                	li	a5,1
     74e:	00f50c63          	beq	a0,a5,766 <go+0x6bc>
          fprintf(2, "grind: dup failed\n");
     752:	00001597          	auipc	a1,0x1
     756:	d4e58593          	addi	a1,a1,-690 # 14a0 <malloc+0x354>
     75a:	4509                	li	a0,2
     75c:	10b000ef          	jal	1066 <fprintf>
          exit(1);
     760:	4505                	li	a0,1
     762:	4d0000ef          	jal	c32 <exit>
        close(aa[1]);
     766:	f6c42503          	lw	a0,-148(s0)
     76a:	4f0000ef          	jal	c5a <close>
        char *args[3] = {"echo", "hi", 0};
     76e:	00001797          	auipc	a5,0x1
     772:	d4a78793          	addi	a5,a5,-694 # 14b8 <malloc+0x36c>
     776:	f6f43c23          	sd	a5,-136(s0)
     77a:	00001797          	auipc	a5,0x1
     77e:	d4678793          	addi	a5,a5,-698 # 14c0 <malloc+0x374>
     782:	f8f43023          	sd	a5,-128(s0)
     786:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     78a:	f7840593          	addi	a1,s0,-136
     78e:	00001517          	auipc	a0,0x1
     792:	d3a50513          	addi	a0,a0,-710 # 14c8 <malloc+0x37c>
     796:	4d4000ef          	jal	c6a <exec>
        fprintf(2, "grind: echo: not found\n");
     79a:	00001597          	auipc	a1,0x1
     79e:	d3e58593          	addi	a1,a1,-706 # 14d8 <malloc+0x38c>
     7a2:	4509                	li	a0,2
     7a4:	0c3000ef          	jal	1066 <fprintf>
        exit(2);
     7a8:	4509                	li	a0,2
     7aa:	488000ef          	jal	c32 <exit>
        fprintf(2, "grind: fork failed\n");
     7ae:	00001597          	auipc	a1,0x1
     7b2:	ba258593          	addi	a1,a1,-1118 # 1350 <malloc+0x204>
     7b6:	4509                	li	a0,2
     7b8:	0af000ef          	jal	1066 <fprintf>
        exit(3);
     7bc:	450d                	li	a0,3
     7be:	474000ef          	jal	c32 <exit>
        close(aa[1]);
     7c2:	f6c42503          	lw	a0,-148(s0)
     7c6:	494000ef          	jal	c5a <close>
        close(bb[0]);
     7ca:	f7042503          	lw	a0,-144(s0)
     7ce:	48c000ef          	jal	c5a <close>
        close(0);
     7d2:	4501                	li	a0,0
     7d4:	486000ef          	jal	c5a <close>
        if (dup(aa[0]) != 0) {
     7d8:	f6842503          	lw	a0,-152(s0)
     7dc:	4ce000ef          	jal	caa <dup>
     7e0:	c919                	beqz	a0,7f6 <go+0x74c>
          fprintf(2, "grind: dup failed\n");
     7e2:	00001597          	auipc	a1,0x1
     7e6:	cbe58593          	addi	a1,a1,-834 # 14a0 <malloc+0x354>
     7ea:	4509                	li	a0,2
     7ec:	07b000ef          	jal	1066 <fprintf>
          exit(4);
     7f0:	4511                	li	a0,4
     7f2:	440000ef          	jal	c32 <exit>
        close(aa[0]);
     7f6:	f6842503          	lw	a0,-152(s0)
     7fa:	460000ef          	jal	c5a <close>
        close(1);
     7fe:	4505                	li	a0,1
     800:	45a000ef          	jal	c5a <close>
        if (dup(bb[1]) != 1) {
     804:	f7442503          	lw	a0,-140(s0)
     808:	4a2000ef          	jal	caa <dup>
     80c:	4785                	li	a5,1
     80e:	00f50c63          	beq	a0,a5,826 <go+0x77c>
          fprintf(2, "grind: dup failed\n");
     812:	00001597          	auipc	a1,0x1
     816:	c8e58593          	addi	a1,a1,-882 # 14a0 <malloc+0x354>
     81a:	4509                	li	a0,2
     81c:	04b000ef          	jal	1066 <fprintf>
          exit(5);
     820:	4515                	li	a0,5
     822:	410000ef          	jal	c32 <exit>
        close(bb[1]);
     826:	f7442503          	lw	a0,-140(s0)
     82a:	430000ef          	jal	c5a <close>
        char *args[2] = {"cat", 0};
     82e:	00001797          	auipc	a5,0x1
     832:	cc278793          	addi	a5,a5,-830 # 14f0 <malloc+0x3a4>
     836:	f6f43c23          	sd	a5,-136(s0)
     83a:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     83e:	f7840593          	addi	a1,s0,-136
     842:	00001517          	auipc	a0,0x1
     846:	cb650513          	addi	a0,a0,-842 # 14f8 <malloc+0x3ac>
     84a:	420000ef          	jal	c6a <exec>
        fprintf(2, "grind: cat: not found\n");
     84e:	00001597          	auipc	a1,0x1
     852:	cb258593          	addi	a1,a1,-846 # 1500 <malloc+0x3b4>
     856:	4509                	li	a0,2
     858:	00f000ef          	jal	1066 <fprintf>
        exit(6);
     85c:	4519                	li	a0,6
     85e:	3d4000ef          	jal	c32 <exit>
        fprintf(2, "grind: fork failed\n");
     862:	00001597          	auipc	a1,0x1
     866:	aee58593          	addi	a1,a1,-1298 # 1350 <malloc+0x204>
     86a:	4509                	li	a0,2
     86c:	7fa000ef          	jal	1066 <fprintf>
        exit(7);
     870:	451d                	li	a0,7
     872:	3c0000ef          	jal	c32 <exit>

0000000000000876 <iter>:
  }
}

void
iter()
{
     876:	7179                	addi	sp,sp,-48
     878:	f406                	sd	ra,40(sp)
     87a:	f022                	sd	s0,32(sp)
     87c:	1800                	addi	s0,sp,48
  unlink("a");
     87e:	00001517          	auipc	a0,0x1
     882:	aea50513          	addi	a0,a0,-1302 # 1368 <malloc+0x21c>
     886:	3fc000ef          	jal	c82 <unlink>
  unlink("b");
     88a:	00001517          	auipc	a0,0x1
     88e:	a8e50513          	addi	a0,a0,-1394 # 1318 <malloc+0x1cc>
     892:	3f0000ef          	jal	c82 <unlink>

  int pid1 = fork();
     896:	394000ef          	jal	c2a <fork>
  if (pid1 < 0) {
     89a:	02054163          	bltz	a0,8bc <iter+0x46>
     89e:	ec26                	sd	s1,24(sp)
     8a0:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid1 == 0) {
     8a2:	e905                	bnez	a0,8d2 <iter+0x5c>
     8a4:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     8a6:	00001717          	auipc	a4,0x1
     8aa:	75a70713          	addi	a4,a4,1882 # 2000 <rand_next>
     8ae:	631c                	ld	a5,0(a4)
     8b0:	01f7c793          	xori	a5,a5,31
     8b4:	e31c                	sd	a5,0(a4)
    go(0);
     8b6:	4501                	li	a0,0
     8b8:	ff2ff0ef          	jal	aa <go>
     8bc:	ec26                	sd	s1,24(sp)
     8be:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     8c0:	00001517          	auipc	a0,0x1
     8c4:	a9050513          	addi	a0,a0,-1392 # 1350 <malloc+0x204>
     8c8:	7c8000ef          	jal	1090 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	364000ef          	jal	c32 <exit>
     8d2:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8d4:	356000ef          	jal	c2a <fork>
     8d8:	892a                	mv	s2,a0
  if (pid2 < 0) {
     8da:	02054063          	bltz	a0,8fa <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid2 == 0) {
     8de:	e51d                	bnez	a0,90c <iter+0x96>
    rand_next ^= 7177;
     8e0:	00001697          	auipc	a3,0x1
     8e4:	72068693          	addi	a3,a3,1824 # 2000 <rand_next>
     8e8:	629c                	ld	a5,0(a3)
     8ea:	6709                	lui	a4,0x2
     8ec:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x659>
     8f0:	8fb9                	xor	a5,a5,a4
     8f2:	e29c                	sd	a5,0(a3)
    go(1);
     8f4:	4505                	li	a0,1
     8f6:	fb4ff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     8fa:	00001517          	auipc	a0,0x1
     8fe:	a5650513          	addi	a0,a0,-1450 # 1350 <malloc+0x204>
     902:	78e000ef          	jal	1090 <printf>
    exit(1);
     906:	4505                	li	a0,1
     908:	32a000ef          	jal	c32 <exit>
    exit(0);
  }

  int st1 = -1;
     90c:	57fd                	li	a5,-1
     90e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     912:	fdc40513          	addi	a0,s0,-36
     916:	324000ef          	jal	c3a <wait>
  if (st1 != 0) {
     91a:	fdc42783          	lw	a5,-36(s0)
     91e:	eb99                	bnez	a5,934 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     920:	57fd                	li	a5,-1
     922:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     926:	fd840513          	addi	a0,s0,-40
     92a:	310000ef          	jal	c3a <wait>

  exit(0);
     92e:	4501                	li	a0,0
     930:	302000ef          	jal	c32 <exit>
    kill(pid1);
     934:	8526                	mv	a0,s1
     936:	32c000ef          	jal	c62 <kill>
    kill(pid2);
     93a:	854a                	mv	a0,s2
     93c:	326000ef          	jal	c62 <kill>
     940:	b7c5                	j	920 <iter+0xaa>

0000000000000942 <main>:
}

int
main()
{
     942:	1101                	addi	sp,sp,-32
     944:	ec06                	sd	ra,24(sp)
     946:	e822                	sd	s0,16(sp)
     948:	e426                	sd	s1,8(sp)
     94a:	e04a                	sd	s2,0(sp)
     94c:	1000                	addi	s0,sp,32
      exit(0);
    }
    if (pid > 0) {
      wait(0);
    }
    pause(20);
     94e:	4951                	li	s2,20
    rand_next += 1;
     950:	00001497          	auipc	s1,0x1
     954:	6b048493          	addi	s1,s1,1712 # 2000 <rand_next>
     958:	a809                	j	96a <main+0x28>
      iter();
     95a:	f1dff0ef          	jal	876 <iter>
    pause(20);
     95e:	854a                	mv	a0,s2
     960:	362000ef          	jal	cc2 <pause>
    rand_next += 1;
     964:	609c                	ld	a5,0(s1)
     966:	0785                	addi	a5,a5,1
     968:	e09c                	sd	a5,0(s1)
    int pid = fork();
     96a:	2c0000ef          	jal	c2a <fork>
    if (pid == 0) {
     96e:	d575                	beqz	a0,95a <main+0x18>
    if (pid > 0) {
     970:	fea057e3          	blez	a0,95e <main+0x1c>
      wait(0);
     974:	4501                	li	a0,0
     976:	2c4000ef          	jal	c3a <wait>
     97a:	b7d5                	j	95e <main+0x1c>

000000000000097c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     97c:	1141                	addi	sp,sp,-16
     97e:	e406                	sd	ra,8(sp)
     980:	e022                	sd	s0,0(sp)
     982:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     984:	fbfff0ef          	jal	942 <main>
  exit(r);
     988:	2aa000ef          	jal	c32 <exit>

000000000000098c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     98c:	1141                	addi	sp,sp,-16
     98e:	e406                	sd	ra,8(sp)
     990:	e022                	sd	s0,0(sp)
     992:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
     994:	87aa                	mv	a5,a0
     996:	0585                	addi	a1,a1,1
     998:	0785                	addi	a5,a5,1
     99a:	fff5c703          	lbu	a4,-1(a1)
     99e:	fee78fa3          	sb	a4,-1(a5)
     9a2:	fb75                	bnez	a4,996 <strcpy+0xa>
    ;
  return os;
}
     9a4:	60a2                	ld	ra,8(sp)
     9a6:	6402                	ld	s0,0(sp)
     9a8:	0141                	addi	sp,sp,16
     9aa:	8082                	ret

00000000000009ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9ac:	1141                	addi	sp,sp,-16
     9ae:	e406                	sd	ra,8(sp)
     9b0:	e022                	sd	s0,0(sp)
     9b2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
     9b4:	00054783          	lbu	a5,0(a0)
     9b8:	cb91                	beqz	a5,9cc <strcmp+0x20>
     9ba:	0005c703          	lbu	a4,0(a1)
     9be:	00f71763          	bne	a4,a5,9cc <strcmp+0x20>
    p++, q++;
     9c2:	0505                	addi	a0,a0,1
     9c4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
     9c6:	00054783          	lbu	a5,0(a0)
     9ca:	fbe5                	bnez	a5,9ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9cc:	0005c503          	lbu	a0,0(a1)
}
     9d0:	40a7853b          	subw	a0,a5,a0
     9d4:	60a2                	ld	ra,8(sp)
     9d6:	6402                	ld	s0,0(sp)
     9d8:	0141                	addi	sp,sp,16
     9da:	8082                	ret

00000000000009dc <strlen>:

uint
strlen(const char *s)
{
     9dc:	1141                	addi	sp,sp,-16
     9de:	e406                	sd	ra,8(sp)
     9e0:	e022                	sd	s0,0(sp)
     9e2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
     9e4:	00054783          	lbu	a5,0(a0)
     9e8:	cf91                	beqz	a5,a04 <strlen+0x28>
     9ea:	00150793          	addi	a5,a0,1
     9ee:	86be                	mv	a3,a5
     9f0:	0785                	addi	a5,a5,1
     9f2:	fff7c703          	lbu	a4,-1(a5)
     9f6:	ff65                	bnez	a4,9ee <strlen+0x12>
     9f8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     9fc:	60a2                	ld	ra,8(sp)
     9fe:	6402                	ld	s0,0(sp)
     a00:	0141                	addi	sp,sp,16
     a02:	8082                	ret
  for (n = 0; s[n]; n++)
     a04:	4501                	li	a0,0
     a06:	bfdd                	j	9fc <strlen+0x20>

0000000000000a08 <memset>:

void *
memset(void *dst, int c, uint n)
{
     a08:	1141                	addi	sp,sp,-16
     a0a:	e406                	sd	ra,8(sp)
     a0c:	e022                	sd	s0,0(sp)
     a0e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
     a10:	ca19                	beqz	a2,a26 <memset+0x1e>
     a12:	87aa                	mv	a5,a0
     a14:	1602                	slli	a2,a2,0x20
     a16:	9201                	srli	a2,a2,0x20
     a18:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a1c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
     a20:	0785                	addi	a5,a5,1
     a22:	fee79de3          	bne	a5,a4,a1c <memset+0x14>
  }
  return dst;
}
     a26:	60a2                	ld	ra,8(sp)
     a28:	6402                	ld	s0,0(sp)
     a2a:	0141                	addi	sp,sp,16
     a2c:	8082                	ret

0000000000000a2e <strchr>:

char *
strchr(const char *s, char c)
{
     a2e:	1141                	addi	sp,sp,-16
     a30:	e406                	sd	ra,8(sp)
     a32:	e022                	sd	s0,0(sp)
     a34:	0800                	addi	s0,sp,16
  for (; *s; s++)
     a36:	00054783          	lbu	a5,0(a0)
     a3a:	c799                	beqz	a5,a48 <strchr+0x1a>
    if (*s == c)
     a3c:	00f58763          	beq	a1,a5,a4a <strchr+0x1c>
  for (; *s; s++)
     a40:	0505                	addi	a0,a0,1
     a42:	00054783          	lbu	a5,0(a0)
     a46:	fbfd                	bnez	a5,a3c <strchr+0xe>
      return (char *)s;
  return 0;
     a48:	4501                	li	a0,0
}
     a4a:	60a2                	ld	ra,8(sp)
     a4c:	6402                	ld	s0,0(sp)
     a4e:	0141                	addi	sp,sp,16
     a50:	8082                	ret

0000000000000a52 <gets>:

char *
gets(char *buf, int max)
{
     a52:	711d                	addi	sp,sp,-96
     a54:	ec86                	sd	ra,88(sp)
     a56:	e8a2                	sd	s0,80(sp)
     a58:	e4a6                	sd	s1,72(sp)
     a5a:	e0ca                	sd	s2,64(sp)
     a5c:	fc4e                	sd	s3,56(sp)
     a5e:	f852                	sd	s4,48(sp)
     a60:	f456                	sd	s5,40(sp)
     a62:	f05a                	sd	s6,32(sp)
     a64:	ec5e                	sd	s7,24(sp)
     a66:	e862                	sd	s8,16(sp)
     a68:	1080                	addi	s0,sp,96
     a6a:	8baa                	mv	s7,a0
     a6c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
     a6e:	892a                	mv	s2,a0
     a70:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a72:	faf40b13          	addi	s6,s0,-81
     a76:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
     a78:	8c26                	mv	s8,s1
     a7a:	0014899b          	addiw	s3,s1,1
     a7e:	84ce                	mv	s1,s3
     a80:	0349d863          	bge	s3,s4,ab0 <gets+0x5e>
    cc = read(0, &c, 1);
     a84:	8656                	mv	a2,s5
     a86:	85da                	mv	a1,s6
     a88:	4501                	li	a0,0
     a8a:	1c0000ef          	jal	c4a <read>
    if (cc < 1)
     a8e:	02a05163          	blez	a0,ab0 <gets+0x5e>
      break;
    buf[i++] = c;
     a92:	faf44783          	lbu	a5,-81(s0)
     a96:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
     a9a:	0905                	addi	s2,s2,1
     a9c:	ff678713          	addi	a4,a5,-10
     aa0:	00173713          	seqz	a4,a4
     aa4:	17cd                	addi	a5,a5,-13
     aa6:	0017b793          	seqz	a5,a5
     aaa:	8fd9                	or	a5,a5,a4
     aac:	d7f1                	beqz	a5,a78 <gets+0x26>
    buf[i++] = c;
     aae:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     ab0:	9c5e                	add	s8,s8,s7
     ab2:	000c0023          	sb	zero,0(s8)
  return buf;
}
     ab6:	855e                	mv	a0,s7
     ab8:	60e6                	ld	ra,88(sp)
     aba:	6446                	ld	s0,80(sp)
     abc:	64a6                	ld	s1,72(sp)
     abe:	6906                	ld	s2,64(sp)
     ac0:	79e2                	ld	s3,56(sp)
     ac2:	7a42                	ld	s4,48(sp)
     ac4:	7aa2                	ld	s5,40(sp)
     ac6:	7b02                	ld	s6,32(sp)
     ac8:	6be2                	ld	s7,24(sp)
     aca:	6c42                	ld	s8,16(sp)
     acc:	6125                	addi	sp,sp,96
     ace:	8082                	ret

0000000000000ad0 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad0:	1101                	addi	sp,sp,-32
     ad2:	ec06                	sd	ra,24(sp)
     ad4:	e822                	sd	s0,16(sp)
     ad6:	e04a                	sd	s2,0(sp)
     ad8:	1000                	addi	s0,sp,32
     ada:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     adc:	4581                	li	a1,0
     ade:	194000ef          	jal	c72 <open>
  if (fd < 0)
     ae2:	02054263          	bltz	a0,b06 <stat+0x36>
     ae6:	e426                	sd	s1,8(sp)
     ae8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     aea:	85ca                	mv	a1,s2
     aec:	19e000ef          	jal	c8a <fstat>
     af0:	892a                	mv	s2,a0
  close(fd);
     af2:	8526                	mv	a0,s1
     af4:	166000ef          	jal	c5a <close>
  return r;
     af8:	64a2                	ld	s1,8(sp)
}
     afa:	854a                	mv	a0,s2
     afc:	60e2                	ld	ra,24(sp)
     afe:	6442                	ld	s0,16(sp)
     b00:	6902                	ld	s2,0(sp)
     b02:	6105                	addi	sp,sp,32
     b04:	8082                	ret
    return -1;
     b06:	57fd                	li	a5,-1
     b08:	893e                	mv	s2,a5
     b0a:	bfc5                	j	afa <stat+0x2a>

0000000000000b0c <atoi>:

int
atoi(const char *s)
{
     b0c:	1141                	addi	sp,sp,-16
     b0e:	e406                	sd	ra,8(sp)
     b10:	e022                	sd	s0,0(sp)
     b12:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
     b14:	00054683          	lbu	a3,0(a0)
     b18:	fd06879b          	addiw	a5,a3,-48
     b1c:	0ff7f793          	zext.b	a5,a5
     b20:	4625                	li	a2,9
     b22:	02f66963          	bltu	a2,a5,b54 <atoi+0x48>
     b26:	872a                	mv	a4,a0
  n = 0;
     b28:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
     b2a:	0705                	addi	a4,a4,1
     b2c:	0025179b          	slliw	a5,a0,0x2
     b30:	9fa9                	addw	a5,a5,a0
     b32:	0017979b          	slliw	a5,a5,0x1
     b36:	9fb5                	addw	a5,a5,a3
     b38:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
     b3c:	00074683          	lbu	a3,0(a4)
     b40:	fd06879b          	addiw	a5,a3,-48
     b44:	0ff7f793          	zext.b	a5,a5
     b48:	fef671e3          	bgeu	a2,a5,b2a <atoi+0x1e>
  return n;
}
     b4c:	60a2                	ld	ra,8(sp)
     b4e:	6402                	ld	s0,0(sp)
     b50:	0141                	addi	sp,sp,16
     b52:	8082                	ret
  n = 0;
     b54:	4501                	li	a0,0
     b56:	bfdd                	j	b4c <atoi+0x40>

0000000000000b58 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     b58:	1141                	addi	sp,sp,-16
     b5a:	e406                	sd	ra,8(sp)
     b5c:	e022                	sd	s0,0(sp)
     b5e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b60:	02b57563          	bgeu	a0,a1,b8a <memmove+0x32>
    while (n-- > 0)
     b64:	00c05f63          	blez	a2,b82 <memmove+0x2a>
     b68:	1602                	slli	a2,a2,0x20
     b6a:	9201                	srli	a2,a2,0x20
     b6c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b70:	872a                	mv	a4,a0
      *dst++ = *src++;
     b72:	0585                	addi	a1,a1,1
     b74:	0705                	addi	a4,a4,1
     b76:	fff5c683          	lbu	a3,-1(a1)
     b7a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
     b7e:	fee79ae3          	bne	a5,a4,b72 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b82:	60a2                	ld	ra,8(sp)
     b84:	6402                	ld	s0,0(sp)
     b86:	0141                	addi	sp,sp,16
     b88:	8082                	ret
    while (n-- > 0)
     b8a:	fec05ce3          	blez	a2,b82 <memmove+0x2a>
    dst += n;
     b8e:	00c50733          	add	a4,a0,a2
    src += n;
     b92:	95b2                	add	a1,a1,a2
     b94:	fff6079b          	addiw	a5,a2,-1
     b98:	1782                	slli	a5,a5,0x20
     b9a:	9381                	srli	a5,a5,0x20
     b9c:	fff7c793          	not	a5,a5
     ba0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ba2:	15fd                	addi	a1,a1,-1
     ba4:	177d                	addi	a4,a4,-1
     ba6:	0005c683          	lbu	a3,0(a1)
     baa:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
     bae:	fef71ae3          	bne	a4,a5,ba2 <memmove+0x4a>
     bb2:	bfc1                	j	b82 <memmove+0x2a>

0000000000000bb4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bb4:	1141                	addi	sp,sp,-16
     bb6:	e406                	sd	ra,8(sp)
     bb8:	e022                	sd	s0,0(sp)
     bba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bbc:	ce19                	beqz	a2,bda <memcmp+0x26>
     bbe:	1602                	slli	a2,a2,0x20
     bc0:	9201                	srli	a2,a2,0x20
     bc2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     bc6:	00054783          	lbu	a5,0(a0)
     bca:	0005c703          	lbu	a4,0(a1)
     bce:	00e79b63          	bne	a5,a4,be4 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
     bd2:	0505                	addi	a0,a0,1
    p2++;
     bd4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bd6:	fed518e3          	bne	a0,a3,bc6 <memcmp+0x12>
  }
  return 0;
     bda:	4501                	li	a0,0
}
     bdc:	60a2                	ld	ra,8(sp)
     bde:	6402                	ld	s0,0(sp)
     be0:	0141                	addi	sp,sp,16
     be2:	8082                	ret
      return *p1 - *p2;
     be4:	40e7853b          	subw	a0,a5,a4
     be8:	bfd5                	j	bdc <memcmp+0x28>

0000000000000bea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bea:	1141                	addi	sp,sp,-16
     bec:	e406                	sd	ra,8(sp)
     bee:	e022                	sd	s0,0(sp)
     bf0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bf2:	f67ff0ef          	jal	b58 <memmove>
}
     bf6:	60a2                	ld	ra,8(sp)
     bf8:	6402                	ld	s0,0(sp)
     bfa:	0141                	addi	sp,sp,16
     bfc:	8082                	ret

0000000000000bfe <sbrk>:

char *
sbrk(int n)
{
     bfe:	1141                	addi	sp,sp,-16
     c00:	e406                	sd	ra,8(sp)
     c02:	e022                	sd	s0,0(sp)
     c04:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c06:	4585                	li	a1,1
     c08:	0b2000ef          	jal	cba <sys_sbrk>
}
     c0c:	60a2                	ld	ra,8(sp)
     c0e:	6402                	ld	s0,0(sp)
     c10:	0141                	addi	sp,sp,16
     c12:	8082                	ret

0000000000000c14 <sbrklazy>:

char *
sbrklazy(int n)
{
     c14:	1141                	addi	sp,sp,-16
     c16:	e406                	sd	ra,8(sp)
     c18:	e022                	sd	s0,0(sp)
     c1a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c1c:	4589                	li	a1,2
     c1e:	09c000ef          	jal	cba <sys_sbrk>
}
     c22:	60a2                	ld	ra,8(sp)
     c24:	6402                	ld	s0,0(sp)
     c26:	0141                	addi	sp,sp,16
     c28:	8082                	ret

0000000000000c2a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c2a:	4885                	li	a7,1
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c32:	4889                	li	a7,2
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <wait>:
.global wait
wait:
 li a7, SYS_wait
     c3a:	488d                	li	a7,3
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c42:	4891                	li	a7,4
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <read>:
.global read
read:
 li a7, SYS_read
     c4a:	4895                	li	a7,5
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <write>:
.global write
write:
 li a7, SYS_write
     c52:	48c1                	li	a7,16
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <close>:
.global close
close:
 li a7, SYS_close
     c5a:	48d5                	li	a7,21
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c62:	4899                	li	a7,6
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <exec>:
.global exec
exec:
 li a7, SYS_exec
     c6a:	489d                	li	a7,7
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <open>:
.global open
open:
 li a7, SYS_open
     c72:	48bd                	li	a7,15
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c7a:	48c5                	li	a7,17
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c82:	48c9                	li	a7,18
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c8a:	48a1                	li	a7,8
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <link>:
.global link
link:
 li a7, SYS_link
     c92:	48cd                	li	a7,19
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c9a:	48d1                	li	a7,20
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ca2:	48a5                	li	a7,9
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <dup>:
.global dup
dup:
 li a7, SYS_dup
     caa:	48a9                	li	a7,10
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cb2:	48ad                	li	a7,11
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     cba:	48b1                	li	a7,12
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <pause>:
.global pause
pause:
 li a7, SYS_pause
     cc2:	48b5                	li	a7,13
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cca:	48b9                	li	a7,14
 ecall
     ccc:	00000073          	ecall
 ret
     cd0:	8082                	ret

0000000000000cd2 <sync>:
.global sync
sync:
 li a7, SYS_sync
     cd2:	48d9                	li	a7,22
 ecall
     cd4:	00000073          	ecall
 ret
     cd8:	8082                	ret

0000000000000cda <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cda:	1101                	addi	sp,sp,-32
     cdc:	ec06                	sd	ra,24(sp)
     cde:	e822                	sd	s0,16(sp)
     ce0:	1000                	addi	s0,sp,32
     ce2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ce6:	4605                	li	a2,1
     ce8:	fef40593          	addi	a1,s0,-17
     cec:	f67ff0ef          	jal	c52 <write>
}
     cf0:	60e2                	ld	ra,24(sp)
     cf2:	6442                	ld	s0,16(sp)
     cf4:	6105                	addi	sp,sp,32
     cf6:	8082                	ret

0000000000000cf8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     cf8:	715d                	addi	sp,sp,-80
     cfa:	e486                	sd	ra,72(sp)
     cfc:	e0a2                	sd	s0,64(sp)
     cfe:	f84a                	sd	s2,48(sp)
     d00:	f44e                	sd	s3,40(sp)
     d02:	0880                	addi	s0,sp,80
     d04:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
     d06:	00d036b3          	snez	a3,a3
     d0a:	03f5d793          	srli	a5,a1,0x3f
     d0e:	8efd                	and	a3,a3,a5
  neg = 0;
     d10:	4301                	li	t1,0
  if (sgn && xx < 0) {
     d12:	c681                	beqz	a3,d1a <printint+0x22>
    neg = 1;
    x = -xx;
     d14:	40b005b3          	neg	a1,a1
    neg = 1;
     d18:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d1a:	fb840993          	addi	s3,s0,-72
  neg = 0;
     d1e:	86ce                	mv	a3,s3
  i = 0;
     d20:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
     d22:	00001817          	auipc	a6,0x1
     d26:	88e80813          	addi	a6,a6,-1906 # 15b0 <digits>
     d2a:	88ba                	mv	a7,a4
     d2c:	0017051b          	addiw	a0,a4,1
     d30:	872a                	mv	a4,a0
     d32:	02c5f7b3          	remu	a5,a1,a2
     d36:	97c2                	add	a5,a5,a6
     d38:	0007c783          	lbu	a5,0(a5)
     d3c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
     d40:	87ae                	mv	a5,a1
     d42:	02c5d5b3          	divu	a1,a1,a2
     d46:	0685                	addi	a3,a3,1
     d48:	fec7f1e3          	bgeu	a5,a2,d2a <printint+0x32>
  if (neg)
     d4c:	00030b63          	beqz	t1,d62 <printint+0x6a>
    buf[i++] = '-';
     d50:	fd040793          	addi	a5,s0,-48
     d54:	953e                	add	a0,a0,a5
     d56:	02d00793          	li	a5,45
     d5a:	fef50423          	sb	a5,-24(a0)
     d5e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
     d62:	02e05563          	blez	a4,d8c <printint+0x94>
     d66:	fc26                	sd	s1,56(sp)
     d68:	377d                	addiw	a4,a4,-1
     d6a:	00e984b3          	add	s1,s3,a4
     d6e:	19fd                	addi	s3,s3,-1
     d70:	99ba                	add	s3,s3,a4
     d72:	1702                	slli	a4,a4,0x20
     d74:	9301                	srli	a4,a4,0x20
     d76:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d7a:	0004c583          	lbu	a1,0(s1)
     d7e:	854a                	mv	a0,s2
     d80:	f5bff0ef          	jal	cda <putc>
  while (--i >= 0)
     d84:	14fd                	addi	s1,s1,-1
     d86:	ff349ae3          	bne	s1,s3,d7a <printint+0x82>
     d8a:	74e2                	ld	s1,56(sp)
}
     d8c:	60a6                	ld	ra,72(sp)
     d8e:	6406                	ld	s0,64(sp)
     d90:	7942                	ld	s2,48(sp)
     d92:	79a2                	ld	s3,40(sp)
     d94:	6161                	addi	sp,sp,80
     d96:	8082                	ret

0000000000000d98 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d98:	711d                	addi	sp,sp,-96
     d9a:	ec86                	sd	ra,88(sp)
     d9c:	e8a2                	sd	s0,80(sp)
     d9e:	e4a6                	sd	s1,72(sp)
     da0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
     da2:	0005c483          	lbu	s1,0(a1)
     da6:	2a048063          	beqz	s1,1046 <vprintf+0x2ae>
     daa:	e0ca                	sd	s2,64(sp)
     dac:	fc4e                	sd	s3,56(sp)
     dae:	f852                	sd	s4,48(sp)
     db0:	f456                	sd	s5,40(sp)
     db2:	f05a                	sd	s6,32(sp)
     db4:	ec5e                	sd	s7,24(sp)
     db6:	e862                	sd	s8,16(sp)
     db8:	8b2a                	mv	s6,a0
     dba:	8a2e                	mv	s4,a1
     dbc:	8bb2                	mv	s7,a2
  state = 0;
     dbe:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
     dc0:	4901                	li	s2,0
     dc2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
     dc4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
     dc8:	06400c13          	li	s8,100
     dcc:	a00d                	j	dee <vprintf+0x56>
        putc(fd, c0);
     dce:	85a6                	mv	a1,s1
     dd0:	855a                	mv	a0,s6
     dd2:	f09ff0ef          	jal	cda <putc>
     dd6:	a019                	j	ddc <vprintf+0x44>
    } else if (state == '%') {
     dd8:	03598363          	beq	s3,s5,dfe <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
     ddc:	0019079b          	addiw	a5,s2,1
     de0:	893e                	mv	s2,a5
     de2:	873e                	mv	a4,a5
     de4:	97d2                	add	a5,a5,s4
     de6:	0007c483          	lbu	s1,0(a5)
     dea:	24048763          	beqz	s1,1038 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
     dee:	0004879b          	sext.w	a5,s1
    if (state == 0) {
     df2:	fe0993e3          	bnez	s3,dd8 <vprintf+0x40>
      if (c0 == '%') {
     df6:	fd579ce3          	bne	a5,s5,dce <vprintf+0x36>
        state = '%';
     dfa:	89be                	mv	s3,a5
     dfc:	b7c5                	j	ddc <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
     dfe:	00ea06b3          	add	a3,s4,a4
     e02:	0016c603          	lbu	a2,1(a3)
      if (c1)
     e06:	24060563          	beqz	a2,1050 <vprintf+0x2b8>
      if (c0 == 'd') {
     e0a:	0b878763          	beq	a5,s8,eb8 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
     e0e:	f9478693          	addi	a3,a5,-108
     e12:	0016b693          	seqz	a3,a3
     e16:	f9c60593          	addi	a1,a2,-100
     e1a:	0015b593          	seqz	a1,a1
     e1e:	8df5                	and	a1,a1,a3
     e20:	e9c5                	bnez	a1,ed0 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
     e22:	9752                	add	a4,a4,s4
     e24:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     e28:	f9460713          	addi	a4,a2,-108
     e2c:	00173713          	seqz	a4,a4
     e30:	8f75                	and	a4,a4,a3
     e32:	f9c50593          	addi	a1,a0,-100
     e36:	0015b593          	seqz	a1,a1
     e3a:	8df9                	and	a1,a1,a4
     e3c:	e5dd                	bnez	a1,eea <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
     e3e:	07500593          	li	a1,117
     e42:	0cb78163          	beq	a5,a1,f04 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
     e46:	f8b60593          	addi	a1,a2,-117
     e4a:	0015b593          	seqz	a1,a1
     e4e:	8df5                	and	a1,a1,a3
     e50:	e5f1                	bnez	a1,f1c <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
     e52:	f8b50593          	addi	a1,a0,-117
     e56:	0015b593          	seqz	a1,a1
     e5a:	8df9                	and	a1,a1,a4
     e5c:	ede9                	bnez	a1,f36 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
     e5e:	07800593          	li	a1,120
     e62:	0eb78763          	beq	a5,a1,f50 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
     e66:	f8860613          	addi	a2,a2,-120
     e6a:	00163613          	seqz	a2,a2
     e6e:	8ef1                	and	a3,a3,a2
     e70:	0e069c63          	bnez	a3,f68 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
     e74:	f8850513          	addi	a0,a0,-120
     e78:	00153513          	seqz	a0,a0
     e7c:	8f69                	and	a4,a4,a0
     e7e:	10071263          	bnez	a4,f82 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
     e82:	07000713          	li	a4,112
     e86:	10e78a63          	beq	a5,a4,f9a <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
     e8a:	06300713          	li	a4,99
     e8e:	14e78a63          	beq	a5,a4,fe2 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
     e92:	07300713          	li	a4,115
     e96:	16e78063          	beq	a5,a4,ff6 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
     e9a:	02500713          	li	a4,37
     e9e:	18e78863          	beq	a5,a4,102e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     ea2:	02500593          	li	a1,37
     ea6:	855a                	mv	a0,s6
     ea8:	e33ff0ef          	jal	cda <putc>
        putc(fd, c0);
     eac:	85a6                	mv	a1,s1
     eae:	855a                	mv	a0,s6
     eb0:	e2bff0ef          	jal	cda <putc>
      }

      state = 0;
     eb4:	4981                	li	s3,0
     eb6:	b71d                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     eb8:	008b8493          	addi	s1,s7,8
     ebc:	4685                	li	a3,1
     ebe:	4629                	li	a2,10
     ec0:	000ba583          	lw	a1,0(s7)
     ec4:	855a                	mv	a0,s6
     ec6:	e33ff0ef          	jal	cf8 <printint>
     eca:	8ba6                	mv	s7,s1
      state = 0;
     ecc:	4981                	li	s3,0
     ece:	b739                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ed0:	008b8493          	addi	s1,s7,8
     ed4:	4685                	li	a3,1
     ed6:	4629                	li	a2,10
     ed8:	000bb583          	ld	a1,0(s7)
     edc:	855a                	mv	a0,s6
     ede:	e1bff0ef          	jal	cf8 <printint>
        i += 1;
     ee2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ee4:	8ba6                	mv	s7,s1
      state = 0;
     ee6:	4981                	li	s3,0
     ee8:	bdd5                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eea:	008b8493          	addi	s1,s7,8
     eee:	4685                	li	a3,1
     ef0:	4629                	li	a2,10
     ef2:	000bb583          	ld	a1,0(s7)
     ef6:	855a                	mv	a0,s6
     ef8:	e01ff0ef          	jal	cf8 <printint>
        i += 2;
     efc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     efe:	8ba6                	mv	s7,s1
      state = 0;
     f00:	4981                	li	s3,0
        i += 2;
     f02:	bde9                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f04:	008b8493          	addi	s1,s7,8
     f08:	4681                	li	a3,0
     f0a:	4629                	li	a2,10
     f0c:	000be583          	lwu	a1,0(s7)
     f10:	855a                	mv	a0,s6
     f12:	de7ff0ef          	jal	cf8 <printint>
     f16:	8ba6                	mv	s7,s1
      state = 0;
     f18:	4981                	li	s3,0
     f1a:	b5c9                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f1c:	008b8493          	addi	s1,s7,8
     f20:	4681                	li	a3,0
     f22:	4629                	li	a2,10
     f24:	000bb583          	ld	a1,0(s7)
     f28:	855a                	mv	a0,s6
     f2a:	dcfff0ef          	jal	cf8 <printint>
        i += 1;
     f2e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f30:	8ba6                	mv	s7,s1
      state = 0;
     f32:	4981                	li	s3,0
     f34:	b565                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f36:	008b8493          	addi	s1,s7,8
     f3a:	4681                	li	a3,0
     f3c:	4629                	li	a2,10
     f3e:	000bb583          	ld	a1,0(s7)
     f42:	855a                	mv	a0,s6
     f44:	db5ff0ef          	jal	cf8 <printint>
        i += 2;
     f48:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f4a:	8ba6                	mv	s7,s1
      state = 0;
     f4c:	4981                	li	s3,0
        i += 2;
     f4e:	b579                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f50:	008b8493          	addi	s1,s7,8
     f54:	4681                	li	a3,0
     f56:	4641                	li	a2,16
     f58:	000be583          	lwu	a1,0(s7)
     f5c:	855a                	mv	a0,s6
     f5e:	d9bff0ef          	jal	cf8 <printint>
     f62:	8ba6                	mv	s7,s1
      state = 0;
     f64:	4981                	li	s3,0
     f66:	bd9d                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f68:	008b8493          	addi	s1,s7,8
     f6c:	4681                	li	a3,0
     f6e:	4641                	li	a2,16
     f70:	000bb583          	ld	a1,0(s7)
     f74:	855a                	mv	a0,s6
     f76:	d83ff0ef          	jal	cf8 <printint>
        i += 1;
     f7a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f7c:	8ba6                	mv	s7,s1
      state = 0;
     f7e:	4981                	li	s3,0
     f80:	bdb1                	j	ddc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f82:	008b8493          	addi	s1,s7,8
     f86:	4641                	li	a2,16
     f88:	000bb583          	ld	a1,0(s7)
     f8c:	855a                	mv	a0,s6
     f8e:	d6bff0ef          	jal	cf8 <printint>
        i += 2;
     f92:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f94:	8ba6                	mv	s7,s1
      state = 0;
     f96:	4981                	li	s3,0
        i += 2;
     f98:	b591                	j	ddc <vprintf+0x44>
     f9a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     f9c:	008b8793          	addi	a5,s7,8
     fa0:	8cbe                	mv	s9,a5
     fa2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fa6:	03000593          	li	a1,48
     faa:	855a                	mv	a0,s6
     fac:	d2fff0ef          	jal	cda <putc>
  putc(fd, 'x');
     fb0:	07800593          	li	a1,120
     fb4:	855a                	mv	a0,s6
     fb6:	d25ff0ef          	jal	cda <putc>
     fba:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fbc:	00000b97          	auipc	s7,0x0
     fc0:	5f4b8b93          	addi	s7,s7,1524 # 15b0 <digits>
     fc4:	03c9d793          	srli	a5,s3,0x3c
     fc8:	97de                	add	a5,a5,s7
     fca:	0007c583          	lbu	a1,0(a5)
     fce:	855a                	mv	a0,s6
     fd0:	d0bff0ef          	jal	cda <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fd4:	0992                	slli	s3,s3,0x4
     fd6:	34fd                	addiw	s1,s1,-1
     fd8:	f4f5                	bnez	s1,fc4 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
     fda:	8be6                	mv	s7,s9
      state = 0;
     fdc:	4981                	li	s3,0
     fde:	6ca2                	ld	s9,8(sp)
     fe0:	bbf5                	j	ddc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     fe2:	008b8493          	addi	s1,s7,8
     fe6:	000bc583          	lbu	a1,0(s7)
     fea:	855a                	mv	a0,s6
     fec:	cefff0ef          	jal	cda <putc>
     ff0:	8ba6                	mv	s7,s1
      state = 0;
     ff2:	4981                	li	s3,0
     ff4:	b3e5                	j	ddc <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
     ff6:	008b8993          	addi	s3,s7,8
     ffa:	000bb483          	ld	s1,0(s7)
     ffe:	cc91                	beqz	s1,101a <vprintf+0x282>
        for (; *s; s++)
    1000:	0004c583          	lbu	a1,0(s1)
    1004:	c195                	beqz	a1,1028 <vprintf+0x290>
          putc(fd, *s);
    1006:	855a                	mv	a0,s6
    1008:	cd3ff0ef          	jal	cda <putc>
        for (; *s; s++)
    100c:	0485                	addi	s1,s1,1
    100e:	0004c583          	lbu	a1,0(s1)
    1012:	f9f5                	bnez	a1,1006 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    1014:	8bce                	mv	s7,s3
      state = 0;
    1016:	4981                	li	s3,0
    1018:	b3d1                	j	ddc <vprintf+0x44>
          s = "(null)";
    101a:	00000497          	auipc	s1,0x0
    101e:	52e48493          	addi	s1,s1,1326 # 1548 <malloc+0x3fc>
        for (; *s; s++)
    1022:	02800593          	li	a1,40
    1026:	b7c5                	j	1006 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    1028:	8bce                	mv	s7,s3
      state = 0;
    102a:	4981                	li	s3,0
    102c:	bb45                	j	ddc <vprintf+0x44>
        putc(fd, '%');
    102e:	85be                	mv	a1,a5
    1030:	855a                	mv	a0,s6
    1032:	ca9ff0ef          	jal	cda <putc>
    1036:	bdbd                	j	eb4 <vprintf+0x11c>
    1038:	6906                	ld	s2,64(sp)
    103a:	79e2                	ld	s3,56(sp)
    103c:	7a42                	ld	s4,48(sp)
    103e:	7aa2                	ld	s5,40(sp)
    1040:	7b02                	ld	s6,32(sp)
    1042:	6be2                	ld	s7,24(sp)
    1044:	6c42                	ld	s8,16(sp)
    }
  }
}
    1046:	60e6                	ld	ra,88(sp)
    1048:	6446                	ld	s0,80(sp)
    104a:	64a6                	ld	s1,72(sp)
    104c:	6125                	addi	sp,sp,96
    104e:	8082                	ret
      if (c0 == 'd') {
    1050:	06400713          	li	a4,100
    1054:	e6e782e3          	beq	a5,a4,eb8 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
    1058:	f9478693          	addi	a3,a5,-108
    105c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    1060:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    1062:	4701                	li	a4,0
    1064:	bbe9                	j	e3e <vprintf+0xa6>

0000000000001066 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1066:	715d                	addi	sp,sp,-80
    1068:	ec06                	sd	ra,24(sp)
    106a:	e822                	sd	s0,16(sp)
    106c:	1000                	addi	s0,sp,32
    106e:	e010                	sd	a2,0(s0)
    1070:	e414                	sd	a3,8(s0)
    1072:	e818                	sd	a4,16(s0)
    1074:	ec1c                	sd	a5,24(s0)
    1076:	03043023          	sd	a6,32(s0)
    107a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    107e:	8622                	mv	a2,s0
    1080:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1084:	d15ff0ef          	jal	d98 <vprintf>
}
    1088:	60e2                	ld	ra,24(sp)
    108a:	6442                	ld	s0,16(sp)
    108c:	6161                	addi	sp,sp,80
    108e:	8082                	ret

0000000000001090 <printf>:

void
printf(const char *fmt, ...)
{
    1090:	711d                	addi	sp,sp,-96
    1092:	ec06                	sd	ra,24(sp)
    1094:	e822                	sd	s0,16(sp)
    1096:	1000                	addi	s0,sp,32
    1098:	e40c                	sd	a1,8(s0)
    109a:	e810                	sd	a2,16(s0)
    109c:	ec14                	sd	a3,24(s0)
    109e:	f018                	sd	a4,32(s0)
    10a0:	f41c                	sd	a5,40(s0)
    10a2:	03043823          	sd	a6,48(s0)
    10a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10aa:	00840613          	addi	a2,s0,8
    10ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10b2:	85aa                	mv	a1,a0
    10b4:	4505                	li	a0,1
    10b6:	ce3ff0ef          	jal	d98 <vprintf>
}
    10ba:	60e2                	ld	ra,24(sp)
    10bc:	6442                	ld	s0,16(sp)
    10be:	6125                	addi	sp,sp,96
    10c0:	8082                	ret

00000000000010c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10c2:	1141                	addi	sp,sp,-16
    10c4:	e406                	sd	ra,8(sp)
    10c6:	e022                	sd	s0,0(sp)
    10c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    10ca:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ce:	00001797          	auipc	a5,0x1
    10d2:	f427b783          	ld	a5,-190(a5) # 2010 <freep>
    10d6:	a095                	j	113a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    10d8:	ff852583          	lw	a1,-8(a0)
    10dc:	6390                	ld	a2,0(a5)
    10de:	02059813          	slli	a6,a1,0x20
    10e2:	01c85693          	srli	a3,a6,0x1c
    10e6:	96ba                	add	a3,a3,a4
    10e8:	02d60563          	beq	a2,a3,1112 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    10ec:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    10f0:	4790                	lw	a2,8(a5)
    10f2:	02061593          	slli	a1,a2,0x20
    10f6:	01c5d693          	srli	a3,a1,0x1c
    10fa:	96be                	add	a3,a3,a5
    10fc:	02d70263          	beq	a4,a3,1120 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1100:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1102:	00001717          	auipc	a4,0x1
    1106:	f0f73723          	sd	a5,-242(a4) # 2010 <freep>
}
    110a:	60a2                	ld	ra,8(sp)
    110c:	6402                	ld	s0,0(sp)
    110e:	0141                	addi	sp,sp,16
    1110:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1112:	4614                	lw	a3,8(a2)
    1114:	9ead                	addw	a3,a3,a1
    1116:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    111a:	6394                	ld	a3,0(a5)
    111c:	6290                	ld	a2,0(a3)
    111e:	b7f9                	j	10ec <free+0x2a>
    p->s.size += bp->s.size;
    1120:	ff852703          	lw	a4,-8(a0)
    1124:	9f31                	addw	a4,a4,a2
    1126:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1128:	ff053703          	ld	a4,-16(a0)
    112c:	bfd1                	j	1100 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    112e:	6394                	ld	a3,0(a5)
    1130:	00d7e463          	bltu	a5,a3,1138 <free+0x76>
    1134:	fad762e3          	bltu	a4,a3,10d8 <free+0x16>
    1138:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    113a:	fee7fae3          	bgeu	a5,a4,112e <free+0x6c>
    113e:	6394                	ld	a3,0(a5)
    1140:	f8d76ce3          	bltu	a4,a3,10d8 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1144:	f8d7fae3          	bgeu	a5,a3,10d8 <free+0x16>
    1148:	87b6                	mv	a5,a3
    114a:	bfc5                	j	113a <free+0x78>

000000000000114c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    114c:	7139                	addi	sp,sp,-64
    114e:	fc06                	sd	ra,56(sp)
    1150:	f822                	sd	s0,48(sp)
    1152:	f04a                	sd	s2,32(sp)
    1154:	ec4e                	sd	s3,24(sp)
    1156:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1158:	02051993          	slli	s3,a0,0x20
    115c:	0209d993          	srli	s3,s3,0x20
    1160:	09bd                	addi	s3,s3,15
    1162:	0049d993          	srli	s3,s3,0x4
    1166:	2985                	addiw	s3,s3,1
    1168:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    116a:	00001517          	auipc	a0,0x1
    116e:	ea653503          	ld	a0,-346(a0) # 2010 <freep>
    1172:	c905                	beqz	a0,11a2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1174:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    1176:	4798                	lw	a4,8(a5)
    1178:	09377663          	bgeu	a4,s3,1204 <malloc+0xb8>
    117c:	f426                	sd	s1,40(sp)
    117e:	e852                	sd	s4,16(sp)
    1180:	e456                	sd	s5,8(sp)
    1182:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    1184:	8a4e                	mv	s4,s3
    1186:	6705                	lui	a4,0x1
    1188:	00e9f363          	bgeu	s3,a4,118e <malloc+0x42>
    118c:	6a05                	lui	s4,0x1
    118e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1192:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    1196:	00001497          	auipc	s1,0x1
    119a:	e7a48493          	addi	s1,s1,-390 # 2010 <freep>
  if (p == SBRK_ERROR)
    119e:	5afd                	li	s5,-1
    11a0:	a83d                	j	11de <malloc+0x92>
    11a2:	f426                	sd	s1,40(sp)
    11a4:	e852                	sd	s4,16(sp)
    11a6:	e456                	sd	s5,8(sp)
    11a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11aa:	00001797          	auipc	a5,0x1
    11ae:	25e78793          	addi	a5,a5,606 # 2408 <base>
    11b2:	00001717          	auipc	a4,0x1
    11b6:	e4f73f23          	sd	a5,-418(a4) # 2010 <freep>
    11ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11bc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    11c0:	b7d1                	j	1184 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11c2:	6398                	ld	a4,0(a5)
    11c4:	e118                	sd	a4,0(a0)
    11c6:	a899                	j	121c <malloc+0xd0>
  hp->s.size = nu;
    11c8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    11cc:	0541                	addi	a0,a0,16
    11ce:	ef5ff0ef          	jal	10c2 <free>
  return freep;
    11d2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    11d4:	c125                	beqz	a0,1234 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    11d6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    11d8:	4798                	lw	a4,8(a5)
    11da:	03277163          	bgeu	a4,s2,11fc <malloc+0xb0>
    if (p == freep)
    11de:	6098                	ld	a4,0(s1)
    11e0:	853e                	mv	a0,a5
    11e2:	fef71ae3          	bne	a4,a5,11d6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11e6:	8552                	mv	a0,s4
    11e8:	a17ff0ef          	jal	bfe <sbrk>
  if (p == SBRK_ERROR)
    11ec:	fd551ee3          	bne	a0,s5,11c8 <malloc+0x7c>
        return 0;
    11f0:	4501                	li	a0,0
    11f2:	74a2                	ld	s1,40(sp)
    11f4:	6a42                	ld	s4,16(sp)
    11f6:	6aa2                	ld	s5,8(sp)
    11f8:	6b02                	ld	s6,0(sp)
    11fa:	a03d                	j	1228 <malloc+0xdc>
    11fc:	74a2                	ld	s1,40(sp)
    11fe:	6a42                	ld	s4,16(sp)
    1200:	6aa2                	ld	s5,8(sp)
    1202:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    1204:	fae90fe3          	beq	s2,a4,11c2 <malloc+0x76>
        p->s.size -= nunits;
    1208:	4137073b          	subw	a4,a4,s3
    120c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    120e:	02071693          	slli	a3,a4,0x20
    1212:	01c6d713          	srli	a4,a3,0x1c
    1216:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1218:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    121c:	00001717          	auipc	a4,0x1
    1220:	dea73a23          	sd	a0,-524(a4) # 2010 <freep>
      return (void *)(p + 1);
    1224:	01078513          	addi	a0,a5,16
  }
}
    1228:	70e2                	ld	ra,56(sp)
    122a:	7442                	ld	s0,48(sp)
    122c:	7902                	ld	s2,32(sp)
    122e:	69e2                	ld	s3,24(sp)
    1230:	6121                	addi	sp,sp,64
    1232:	8082                	ret
    1234:	74a2                	ld	s1,40(sp)
    1236:	6a42                	ld	s4,16(sp)
    1238:	6aa2                	ld	s5,8(sp)
    123a:	6b02                	ld	s6,0(sp)
    123c:	b7f5                	j	1228 <malloc+0xdc>
