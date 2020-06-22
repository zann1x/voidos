all: os_image

build: voidos/src/boot.asm
	nasm -f bin voidos/src/boot.asm -o bin/boot.bin

qemu: build
	qemu-system-x86_64 bin/boot.bin

clean:
	rm bin/* os_image

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

bootsect: voidos/src/boot_sect.asm
	nasm -f bin voidos/src/boot_sect.asm -o bin/boot_sect.bin

kernel: voidos/src/kernel_entry.asm voidos/src/kernel.c
	nasm -f elf voidos/src/kernel_entry.asm -o bin/kernel_entry.o
	gcc -ffreestanding -c voidos/src/kernel.c -o bin/kernel.o
	ld -o bin/kernel.bin -Ttext 0x1000 bin/kernel_entry.o bin/kernel.o --oformat binary

bin/boot_sect.bin: voidos/src/boot_sect.asm
	nasm -f bin $< -I 'voidos/src/' -o $@

bin/kernel_entry.o: voidos/src/kernel_entry.asm
	nasm -f elf $< -o $@

# $< defines the first dependency and $@ the target file
bin/kernel.o: voidos/src/kernel.c
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@

# $^ is substituted with all of the target's dependency files
bin/kernel.bin: bin/kernel_entry.o bin/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

run: all
	qemu-system-i386 os_image

os_image: bin/boot_sect.bin bin/kernel.bin
	cat $^ > $@
