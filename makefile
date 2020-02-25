CC = cc -m32 
CCFLAGS = -std=c99
TARGET = a.out

$(TARGET) : main.o func.o
	$(CC) main.o func.o -o $(TARGET)
main.o : main.c
	$(CC) $(CCFLAGS) -c main.c
func.o: func.s
	nasm -f elf32 func.s

.PHONY: clean, tests
clean:
	rm -f *.o
	rm -f *.out
tests: $(TARGET)
	./$(TARGET) 10 7 0
	./$(TARGET) 10 0 7
	./$(TARGET) 10 7 1
	./$(TARGET) 10 7 5
	./$(TARGET) 10 7 7
	./$(TARGET) 10 7 9
	./$(TARGET) 10 7 90
	./$(TARGET) 10 7 0000000003
	./$(TARGET) 10 000000007 3
	
	./$(TARGET) 2 101 10

	./$(TARGET) 16 f a
	./$(TARGET) 16 F A
	./$(TARGET) 16 F a
	./$(TARGET) 16 f A
	./$(TARGET) 16 Ff 5
	./$(TARGET) 16 1f 2
