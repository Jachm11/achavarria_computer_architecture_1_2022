exec:

	nasm -felf64 -o x86.o read_write.asm

	ld -o x86 x86.o

	./x86

debug:

	nasm -felf64 -g -o x86.o read_write.asm

	ld -o x86 x86.o

	gdb x86 

	#correr b _start, run