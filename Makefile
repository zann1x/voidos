# $<: defines the first dependency
# $@: defines the target file
# $^: is substituted with all of the target's dependency files

C_SOURCES = $(wildcard *.c)
HEADERS = $(wildcard *.h)
OBJ = ${C_SOURCES:.c=.o}

# Cross-compiler
CC = $$HOME/opt/cross/bin/i386-elf-gcc
# GDB = <location of the cross-debugger>
CLD = $$HOME/opt/cross/bin/i386-elf-ld

# -g: Use debugging symbols in gcc
# -m32: Output in 32-bit -- not needed when building with a cross-compiler
# -ffreestanding: Compile for non-hosted environment
# -fno-pie: Do not enable position independent execution. Otherwise there would
#			be an error of not being able to find GLOBAL_OFFSET_TABLE_.
CFLAGS = -ffreestanding #-fno-pie
CINCLUDE = -I 'voidos/src/'

# -nostdlib: Exclude the start files and default libraries like libc as they're
#            only useful in user-space programs
LDFLAGS = #-nostdlib #-m elf_i386

# Build everything and create the OS image used to start the OS
os_image: bin/boot_sect.bin bin/kernel.bin
	cat $^ > $@

# Run the built OS
# ..-i386: Run in 32-bit
# ..-x86_64: Run in 64-bit
# -fda: Use file as floppy disk 0/1 image
run: os_image
	qemu-system-i386 -fda os_image

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
	$(CC) $(CFLAGS) $(CINCLUDE) -c $< -o $@

####################
# Binary files
####################

bin/boot_sect.bin: voidos/src/boot/boot_sect.asm
	nasm -f bin $< $(CINCLUDE) -o $@

# -m elf_i386: Output in 32-bit emulation mode
# -lgcc: Enable libgcc for GCC as it's disabled via the linker option -nostdlib
bin/kernel.bin: int/kernel_entry.o int/interrupt.o int/kernel.o
	$(CLD) ${LDFLAGS} -o $@ -Ttext 0x1000 $^ --oformat binary
