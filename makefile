CC = cc -m32 
CCFLAGS = -std=c99
TARGET = a.out

$(TARGET) : main.o func.o
	$(CC) main.o func.o -o $(TARGET)
main.o : main.c
	$(CC) $(CCFLAGS) -c main.c
func.o: func.s
	nasm -f elf32 func.s

.PHONY: clean
clean:
	rm -f *.o
	rm -f *.out

