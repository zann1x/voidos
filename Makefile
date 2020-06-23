# $<: defines the first dependency
# $@: defines the target file
# $^: is substituted with all of the target's dependency files

C_SOURCES = $(wildcard *.c)
HEADERS = $(wildcard *.h)
OBJ = ${C_SOURCES:.c=.o}

# TODO: Cross-compiler location
CC = gcc
# GDB = <location of the cross-debugger>

# -g: Use debugging symbols in gcc
# -m32: Output in 32-bit
# -fno-pie: Do not enable position independent execution. Otherwise there would
#			be an error of not being able to find GLOBAL_OFFSET_TABLE_.
CFLAGS = -m32 -fno-pie
CINCLUDE = -I 'voidos/src/'

LDFLAGS = -m elf_i386

# Build everything and create the OS image used to start the OS
os_image: bin/boot_sect.bin bin/kernel.bin
	cat $^ > $@

# Run the built OS
# ..-i386: Run in 32-bit
# ..-x86_64: Run in 64-bit
run: os_image
	qemu-system-x86_64 os_image

# Clean up all built files
clean:
	rm bin/* int/* os_image

####################
# Object files
####################

int/kernel_entry.o: voidos/src/boot/kernel_entry.asm
	nasm -f elf $< $(CINCLUDE) -o $@

int/interrupt.o: voidos/src/cpu/interrupt.asm
	nasm -f elf $< $(CINCLUDE) -o $@

# -m32: Output in 32-bit
# -fno-pie: Do not enable position independent execution. Otherwise there would
#			be an error of not being able to find GLOBAL_OFFSET_TABLE_.
int/kernel.o: voidos/src/kernel/kernel.c
	gcc -m32 -fno-pie -ffreestanding -I 'voidos/src/' -c $< -o $@

####################
# Binary files
####################

bin/boot_sect.bin: voidos/src/boot/boot_sect.asm
	nasm -f bin $< $(CINCLUDE) -o $@

# -m elf_i386: Output in 32-bit emulation mode
bin/kernel.bin: int/kernel_entry.o int/interrupt.o int/kernel.o
	ld ${LDFLAGS} -o $@ -Ttext 0x1000 $^ --oformat binary
