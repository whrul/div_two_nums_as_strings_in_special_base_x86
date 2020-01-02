#include <stdio.h> // NULL
#include <stdlib.h> // atoi, malloc
#include <string.h> // strlen

char *sdiv(unsigned int base, char *result, char *s1, char *s2); // remainder into s1

int main(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Enter arguments: base, s1, s2.\n");
        return 0;
    }
    int base = atoi(argv[1]);
    if (base <= 0 || base > 16) { // for now only 10; also should check strings for illegal numbers also check s2 == 0 and s1<S2 ; in main check length > 0 should? from input cmd; remove 0 at the begining?
        printf("Wrong base format.\n"); 
        return 0;
    }
    size_t sizeInBytes = strlen(argv[2]) + 1;
    char *result = (char*) malloc(sizeInBytes);
    if (result == NULL) {
        printf("Cannot alloc memory for result.\n");
        return 0;
    }
    // argv[2] = "";
    // argv[3] = "123123";     segmentation fault
    sdiv((unsigned int)base, result, argv[2], argv[3]);
    printf("Result: %s\nRemainder: %s\n\n", result, argv[2]);
    free(result);
    return 0;
}
