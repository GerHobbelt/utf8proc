/* #define _GNU_SOURCE */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/errno.h>

int main(int argc, char **argv)
{
    FILE *data_fp, *lc_fp, *uc_fp;
    char * line = NULL;
    size_t len = 0;
    ssize_t read;

    if (argc < 2) {
        fprintf(stderr, "Missing file arg");
        exit(EXIT_FAILURE);
    }

    errno = 0;
    data_fp = fopen(argv[1], "r");
    if (data_fp == NULL) {
        fprintf(stderr, "fopen %s failure: %s\n",
                argv[1],
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    errno = 0;
    lc_fp = fopen("Lowercase.txt", "w");
    if (lc_fp == NULL) {
        fprintf(stderr, "fopen Lowercase.txt failure: %s\n",
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    errno = 0;
    uc_fp = fopen("Uppercase.txt", "w");
    if (uc_fp == NULL) {
        fprintf(stderr, "fopen Uppercase.txt failure: %s\n",
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    bool lc_start = false;
    bool lc_end   = false;
    bool uc_start = false;
    bool uc_end   = false;

    while ((read = getline(&line, &len, data_fp)) != -1) {
        /* printf("Retrieved line of length %zu:\n", read); */
        if (lc_start && lc_end) {
            if (uc_end) break;
            if (uc_start) {
                if (strncmp(line,
                            "# Total code points:",
                            20) == 0) {
                    uc_end = true;
                }
                fprintf(uc_fp, "%s", line);
            } else {
                if (strncmp(line,
                            "# Derived Property: Uppercase",
                            29) == 0) {
                    uc_start = true;
                    fprintf(uc_fp, "%s", line);
                }
            }
        } else {
            if (lc_start) {
                if (strncmp(line,
                            "# Total code points:",
                            20) == 0) {
                    lc_end = true;
                }
                fprintf(lc_fp, "%s", line);
            } else {
                if (strncmp(line,
                            "# Derived Property: Lowercase",
                            29) == 0) {
                    lc_start = true;
                    fprintf(lc_fp, "%s", line);
                }
                // else skip
            }
        }
        /* free(line); */
    }

    fclose(data_fp);
    fclose(lc_fp);
    fclose(uc_fp);
    if (line)
        free(line);
    exit(EXIT_SUCCESS);
}
