#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   volatile int *bad = (volatile int *)0x40000000L;
   printf("before fault\n");

   if (argc > 1 && argv[1][0] == 'w')
      *bad = 1;
   else if (argc > 1 && argv[1][0] == 'r')
      printf("value=%d\n", *bad);

   printf("after fault\n");
   exit(0);
}