boot.bin: voidos/src/boot.asm
	nasm -f bin voidos/src/boot.asm -o bin/boot.bin

qemu: boot.bin
	qemu-system-x86_64 bin/boot.bin

clean:
	rm bin/*.bin

