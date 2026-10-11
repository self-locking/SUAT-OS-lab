#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"

#define R(addr) ((volatile uint32 *)(addr))

static struct spinlock td_lock;

void
testdevinit(void)
{
  initlock(&td_lock, "testdev");
}

void
testwrite(uint32 data)
{
  acquire(&td_lock);
  *R(TESTDEV) = data;
  while (1) { }
}