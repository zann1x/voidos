# $<: defines the first dependency
# $@: defines the target file
# $^: is substituted with all of the target's dependency files

all: os_image

clean:
	rm bin/* int/* os_image

byte: build
	od -t x1 -A n bin/boot.bin

bin/boot_sect.bin: voidos/src/boot/boot_sect.asm
	nasm -f bin $< -I 'voidos/src/' -o $@

int/kernel_entry.o: voidos/src/boot/kernel_entry.asm
	nasm -f elf $< -o $@

# -m32: Output in 32-bit
# -fno-pie: Do not enable position independent execution. Otherwise there would
#			be an error of not being able to find GLOBAL_OFFSET_TABLE_.
int/kernel.o: voidos/src/kernel/kernel.c
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@

# -m elf_i386: Output in 32-bit emulation mode
bin/kernel.bin: int/kernel_entry.o int/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# ..-i386: Run in 32-bit
# ..-x86_64: Run in 64-bit
run: all
	qemu-system-x86_64 os_image

os_image: bin/boot_sect.bin bin/kernel.bin
	cat $^ > $@
