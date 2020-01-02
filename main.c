#include <stdio.h> // NULL
#include <stdlib.h> // atoi, malloc
#include <string.h> // strlen


char *sdiv(unsigned int base, char *result, char *s1, char *s2); // remainder into s1
char toLower(const char c);

int main(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Enter arguments: base, s1, s2.\n");
        return 0;
    }
    int base = atoi(argv[1]);
    if (base <= 0 || base > 16) {
        printf("Wrong base format.\n"); 
        return 0;
    }
    for (size_t i = 0; i < strlen(argv[2]); ++i) {
        if (argv[2][i] >= '0' && argv[2][i] <= '9') {
            continue;
        }
        if (toLower(argv[2][i]) >= 'a' && toLower(argv[2][i]) <= 'a' + base - 11) {
            continue;
        }
        printf("Wrong s1 format.\n"); 
        return 0;
    }
    for (size_t i = 0; i < strlen(argv[3]); ++i) {
        if (argv[3][i] >= '0' && argv[3][i] <= '9') {
            continue;
        }
        if (toLower(argv[3][i]) >= 'a' && toLower(argv[3][i]) <= 'a' + base - 11) {
            continue;
        }
        printf("Wrong s2 format.\n"); 
        return 0;
    }
    size_t sizeInBytes = strlen(argv[2]) + 1;
    char *result = (char*) malloc(sizeInBytes);
    if (result == NULL) {
        printf("Cannot alloc memory for result.\n");
        return 0;
    }
    sdiv((unsigned int)base, result, argv[2], argv[3]);
    printf("Result: %s\nRemainder: %s\n\n", result, argv[2]);
    free(result);
    return 0;
}

char toLower(const char c) {
    if (c >= 'A' && c <= 'Z') {
        return c - 'A' + 'a';
    }
    return c;
}

// argv[2] = "";
// argv[3] = "xxx";     segmentation fault

