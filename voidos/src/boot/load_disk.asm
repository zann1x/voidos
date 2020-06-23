;; Load dh many sectors to es:bx from drive dl.
load_disk:
    pusha

    push dx                     ; Push dx onto the stack, so the amount
                                ; of read sectors can be checked against
                                ; the specified amount later on

    mov ah, 0x02                ; BIOS read sector function
    mov al, dh                  ; Read as many sectors as specified in dh
                                ; (0x01 .. 0x80)
    mov ch, 0x00                ; Select cylinder 0
                                ; (0x0 .. 0x3ff, with upper 2 bits from cl)
    mov dh, 0x00                ; Select head 0
                                ; (0x0 .. 0xf)
    mov cl, 0x02                ; Start reading from the second sector
                                ; (first sector after the boot sector)
                                ; (0x01 .. 0x11)

    int 0x13                    ; BIOS read disk interrupt
    jc disk_error               ; If the carry flag is set, we have an error

    pop dx
    cmp al, dh                  ; Have we read as many sectors as specified?
                                ; (al = sectors read; dh = sectors expected)
    jne sectors_error

    popa
    ret

;; Print an error message to the screen if something went wrong while loading from disk
disk_error:
    mov bx, DISK_ERROR_MSG
    call print
    mov dh, ah                  ; ah contains the error code, dl contains the disk drive
                                ; that dropped the error
    call print_hex              ; See http://stanislavs.org/helppc/int_13-1.html
    jmp $

;; Print an error message to the screen if the read amount of sectors differs from the
;; amount specified to read
sectors_error:
    mov bx, SECTORS_ERROR
    call print
    jmp $

;; Error messages
DISK_ERROR_MSG:
    db "Disk read error: ", 0

SECTORS_ERROR:
    db "Incorrect number of sectors read", 0
