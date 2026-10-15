#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
    int pid = fork();

    if (pid < 0) {
        printf("fork failed\n");
        exit(1);
    } else if (pid == 0) {
        while(1) {
            printf("B");
            pause(1);
            yield();
        }
        exit(0);
    } else {
        while(1) {
            printf("A");
            pause(1);
            yield();
        }
        exit(0);
    }

}