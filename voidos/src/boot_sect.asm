;; Load the location where the MBR is loaded into the
;; data segment register ds for segment addressing.
[org 0x7c00]

    KERNEL_OFFSET equ 0x1000    ; The memory offset to which the kernel will be loaded

    mov [BOOT_DRIVE], dl        ; Boot drive is stored in dl, let's better remember that

    mov bp, 0x9000              ; Set up the stack
    mov sp, bp

    mov bx, MESSAGE_REAL_MODE   ; Announce starting booting from 16-bit real mode
    call print
    call print_nl

    call load_kernel            ; Load the kernel

    call switch_to_pm           ; Enter the 32-bit protected mode.
                                ; We never return from here

    jmp $

    %include "voidos/src/load_disk.asm"
    %include "voidos/src/print_string.asm"
    %include "voidos/src/print_hex.asm"

    %include "voidos/src/gdt.asm"
    %include "voidos/src/print_string_pm.asm"
    %include "voidos/src/switch_to_pm.asm"

[bits 16]
;; Load the kernel code from disk
load_kernel:
    mov bx, MESSAGE_LOAD_KERNEL ; Print message to say that the kernel is now being loaded
    call print
    call print_nl

    mov bx, KERNEL_OFFSET       ; Read into address KERNEL_OFFSET
    mov dh, 15                  ; Load the first 15 sectors (excluding the boot sector)
    mov dl, [BOOT_DRIVE]        ; Load from the boot disk
    call load_disk

    ret

[bits 32]
;; Arrival point after switching to and initializing protected mode
begin_pm:
    ;; Hello 32-bit protected mode
    mov ebx, MESSAGE_PROTECTED_MODE ; Announce that protected mode was entered
    call print_string_pm

    call KERNEL_OFFSET          ; Jump to the address of the loaded kernel code
                                ; and therefore give control to it

    jmp $                       ; Stay here when the kernel returns control (if ever)

;; Global variables
MESSAGE_REAL_MODE:
    db 'We are in the real world', 0

MESSAGE_LOAD_KERNEL:
    db 'Loading the kernel', 0

MESSAGE_PROTECTED_MODE:
    db 'Welcome to the protected world', 0

BOOT_DRIVE:
    db 0

;; Bootsector padding
times 510-($-$$) db 0       ; Fill the rest of the 512 bytes in the MBR with zeroes
dw 0xaa55                   ; Magic bytes (in little endian) indicating an executable MBR to the BIOS
