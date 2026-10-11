#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
  int hartid;

  asm volatile(".word 0x0000000b\n\tmv %0, a0"
               : "=r"(hartid)
               :
               : "a0", "memory");
  printf("hartid=%d\n", hartid);
  exit(0);
}