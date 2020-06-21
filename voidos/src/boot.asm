;; Load the location where the MBR is loaded into the
;; data segment register ds for segment addressing.
;; (Values cannot be loaded directly into ds)
;mov ax, 0x07c0
;mov ds, ax                  ; Load value into data segment register
[org 0x7c00]

;; Set up the interrupt handler
;mov ah, 0x0                 ; 0x0 refers to setting video mode and size
;mov al, 0x3                 ; 0x3 means video size should be 80x25 characters
;int 0x10                    ; Interrupt CPU and call handler for video services

;; Set up the character printing loop.
;; Register si is used because the lodsb instruction uses the
;; segmented address ds:si to load a byte from that location.
mov si, msg                 ; Move pointer to address of message into register si
mov ah, 0x0E                ; Use 0x10 interrupt for printing to the screen (tty mode)

;; Loop to print characters to the screen
print_character_loop:
    ;; Load byte into register al from address ds:si
    ;; and move register si to the next byte.
    ;; (load string char by char)
    lodsb

    or al, al               ; Check if the character is zero (end of string)
    jz hang                 ; Jump to hang if zero is returned

    int 0x10                ; Print character to the screen

    jmp print_character_loop    ; Jump to start of loop to print another character

;; The message to print to the screen stored
;; at address msg
msg:
    ;; "Hello world!\r\n\0"
    db 'Hello world!', 13, 10, 0

hang:
    jmp hang
    times 510-($-$$) db 0       ; Fill the rest of the 512 bytes in the MBR with zeroes
    dw 0xaa55                   ; Magic bytes indicating an executable MBR to the BIOS
