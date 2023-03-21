exec:

	rm -rf src/python/build

	mkdir src/python/build

	nasm -felf64 -o src/python/build/rsa_decrypt.o src/asm/rsa_decrypt.asm

	ld -o src/python/build/rsa_decrypt src/python/build/rsa_decrypt.o

	python3 src/python/main.py

debug_asm:

	rm -rf src/python/build

	mkdir src/python/build

	nasm -felf64 -g -o src/python/build/rsa_decrypt.o src/asm/rsa_decrypt.asm

	ld -o src/python/build/rsa_decrypt src/python/build/rsa_decrypt.o

	gdb src/python/build/rsa_decrypt