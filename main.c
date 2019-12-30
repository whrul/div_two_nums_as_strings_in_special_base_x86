#include <stdio.h> // NULL
#include <stdlib.h> // atoi, malloc

char *sdiv(unsigned int base, char *result, char *s1, char *s2); // remainder into s1

int main(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Enter arguments: base, s1, s2.\n");
        return 0;
    }
    int base = atoi(argv[1]);
    if (base <= 0 || base > 10) { // for now only 10; also should check strings for illegal numbers also check s2 == 0 and s1<S2
        printf("Wrong base format.\n");
        return 0;
    }
    size_t sizeInBytes = 10;
    char *result = (char*) malloc(sizeInBytes);
    if (result == NULL) {
        printf("Cannot alloc memory for result.\n");
        return 0;
    }
    // printf("%s\n", sdiv((unsigned int)base, result, argv[2], argv[3]));
    sdiv((unsigned int)base, result, argv[2], argv[3]);
    printf("Result: %s\nRemainder: %s\n", result, argv[2]);
    return 0;
}

