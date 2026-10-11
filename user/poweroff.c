#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
  poweroff();
  exit(0);
}