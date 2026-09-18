#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"

char *fmtname(char *path) {
	static char buf[DIRSIZ + 1];
  	char *p;

	for (p = path + strlen(path); p >= path && *p != '/'; p--)
    ;
  	p++;

	if (strlen(p) >= DIRSIZ) return p;
	memmove(buf, p, strlen(p));
	buf[strlen(p)] = 0;
	return buf;
}

void find(char *path, char *name, int exec_flag, char *exec_argv[]) {
	char buf[64], *p;
	int fd;
	struct dirent de;
	struct stat st;

	if ((fd = open(path, O_RDONLY)) < 0) {
		fprintf(2, "find: cannot open %s\n", path);
		return;
	}

	if (fstat(fd, &st) < 0) {
		fprintf(2, "find: cannot stat %s\n", path);
		close(fd);
		return;
	}

	switch (st.type) {
		case T_DEVICE:
		case T_FILE:
		if (strcmp(fmtname(path), name) == 0) {
			if (exec_flag) {
				int pid = fork();
				if (pid == 0) {
					// 子进程
					char *argv[MAXARG];
					int i;
					for (i = 0; exec_argv[i] != 0; i++) {
						argv[i] = exec_argv[i];
					}
					argv[i++] = path;
					argv[i] = 0;
					exec(exec_argv[0], argv);
					// 正常不会运行到这
					printf("find: exec failed for %s\n", exec_argv[0]);
				}
				else if (pid < 0) { 
					fprintf(2, "find: fork failed\n");
					exit(1);
				}
				else {
					wait(0);
				}
			}
			else {
				printf("%s\n", path);
			}
		}		
		break;

		case T_DIR:
			if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {
				printf("find: path too long\n");
			}
			strcpy(buf, path);
			p = buf + strlen(buf);
			*p++ = '/';
			while (read(fd, &de, sizeof(de)) == sizeof(de)) {
				if (de.inum == 0 || 
					strcmp(de.name, ".") == 0 ||
					strcmp(de.name, "..") == 0) {
					continue;
				}
				memmove(p, de.name, DIRSIZ);
				p[DIRSIZ] = 0;
				find(buf, name, exec_flag, exec_argv);
			}
		break;
	}
	close(fd);
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(2, "find: wrong arguments\n");
        exit(0);
    }

    char *exec_argv[MAXARG];
    if (argc >= 4 && strcmp(argv[3], "-exec") == 0) {
        if (argc < 5) {
            fprintf(2, "find: wrong arguments\n");
            exit(0);
        }
        if (argc - 4 >= MAXARG) {
            fprintf(2, "too many arguments\n");
            exit(0);
        }
        for (int i = 4; i < argc; i++) {
            exec_argv[i - 4] = argv[i];
        }
        exec_argv[argc - 4] = 0;

        find(argv[1], argv[2], 1, exec_argv);
    } 
	else {
		find(argv[1], argv[2], 0, exec_argv);
    }

    exit(0);
}
