build: voidos/src/boot.asm
	nasm -f bin voidos/src/boot.asm -o bin/boot.bin

qemu: build
	qemu-system-x86_64 bin/boot.bin

clean:
	rm bin/*.bin

byte: build
	od -t x1 -A n bin/boot.bin

basicc: voidos/src/basic.c
	gcc -ffreestanding -c voidos/src/basic.c -o bin/basic.o
	ld -o bin/basic.bin -Ttext 0x0 --oformat binary bin/basic.o
	ndisasm -b 32 bin/basic.bin > bin/basic.dis

localvar: voidos/src/local_var.c
	gcc -ffreestanding -c voidos/src/local_var.c -o bin/local_var.o
	ld -o bin/local_var.bin -Ttext 0x0 --oformat binary bin/local_var.o
	ndisasm -b 32 bin/local_var.bin > bin/local_var.dis

callingstuff: voidos/src/calling_stuff.c
	gcc -ffreestanding -c voidos/src/calling_stuff.c -o bin/calling_stuff.o
	ld -o bin/calling_stuff.bin -Ttext 0x0 --oformat binary bin/calling_stuff.o
	ndisasm -b 32 bin/calling_stuff.bin > bin/calling_stuff.dis

ptrfun: voidos/src/ptr_fun.c
	gcc -ffreestanding -c voidos/src/ptr_fun.c -o bin/ptr_fun.o
	ld -o bin/ptr_fun.bin -Ttext 0x0 --oformat binary bin/ptr_fun.o
	ndisasm -b 32 bin/ptr_fun.bin > bin/ptr_fun.dis
