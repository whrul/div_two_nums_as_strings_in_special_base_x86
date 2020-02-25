// Author: Walerij Hrul
//
#include <stdio.h> // NULL
#include <stdlib.h> // atoi, malloc
#include <string.h> // strlen

char *sdiv(unsigned int base, char *result, char *s1, char *s2); // remainder into s1
char toLower(const char c);
short int isDigit(const char c);
short int isCorrectNum(char *s, unsigned int base); 

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
    if(!isCorrectNum(argv[2], base)) {
        printf("Wrong s1 format.\n"); 
        return 0;
    }
    if(!isCorrectNum(argv[3], base)) {
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

short int isDigit(const char c) {
    return c >= '0' && c <= '9';
}

short int isCorrectNum(char *s, unsigned int base) {
    for (size_t i = 0; i < strlen(s); ++i) {
        if (isDigit(s[i])) {
            if (s[i] >= '0' + base) {
                return 0;
            }
        } else {
            if (toLower(s[i]) >= 'a' + base - 10 || toLower(s[i]) < 'a') {
                return 0;
            }
        }
    }
    return 1;
}
