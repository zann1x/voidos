;; Load the location where the MBR is loaded into the
;; data segment register ds for segment addressing.
;; (Values cannot be loaded directly into ds)
;mov ax, 0x07c0              ; Address is multiplied with 16
                             ; (0x07c0*16+offset = 0x7c00+offset)
;mov ds, ax                  ; Load value into data segment register
[org 0x7c00]

    mov [BOOT_DRIVE], dl        ; Boot drive is stored in dl, let's better remember that

    ;; Hello world
    mov bx, MESSAGE
    call print
    call print_nl

    ;; Hello hex
    mov dx, 0xface
    call print_hex
    call print_nl

    ;; Load data from disk
    mov bp, 0x8000              ; Set the stack safely far out of the way
    mov sp, bp

    mov bx, 0x9000              ; Load from 0x0000 (es) to 0x9000 (bx)
    mov dh, 2                   ; Load 2 sectors
    mov dl, [BOOT_DRIVE]
    call load_disk

    mov dx, [0x9000]            ; Print the first loaded word stored at 0x9000
    call print_hex
    call print_nl

    mov dx, [0x9000 + 512]      ; Print the first word of the second loaded sector
    call print_hex
    call print_nl

    jmp $

    %include "voidos/src/print_string.asm"
    %include "voidos/src/print_hex.asm"
    %include "voidos/src/load_disk.asm"

;; Global variables
MESSAGE:
    db 'Hello world!', 0
    
BOOT_DRIVE:
    db 0

;; Bootsector padding
times 510-($-$$) db 0       ; Fill the rest of the 512 bytes in the MBR with zeroes
dw 0xaa55                   ; Magic bytes (in little endian) indicating an executable MBR to the BIOS

;; The first 512 byte are loaded as part of the boot sector.
;; (sector 1 of cylinder 0 of head 0 of hdd 0)
;; Let's actually load data beyond that.
times 256 dw 0xdabe         ; Sector 2
times 256 dw 0xabec         ; Sector 3
