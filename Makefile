exe: main.o color.o
	gcc -m32 -g -o exe main.o color.o

main.o: main.c
	gcc -m32 -c -g -O0 -o main.o main.c

color.o: color.asm
	nasm -o color.o -f elf -g -l color.lst color.asm

.PHONY: clean

clean:
	rm -f exe main.o color.o color.lst