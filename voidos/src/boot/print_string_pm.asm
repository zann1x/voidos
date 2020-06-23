[bits 32]                       ; Use 32bit protected mode

;; Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f         ; Color byte

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx]               ; ebx is the address of the character
    mov ah, WHITE_ON_BLACK

    cmp al, 0                   ; Check if the end of the string is reached
    je print_string_pm_done

    mov [edx], ax               ; Store character and attribute in video memory
    add ebx, 1                  ; Go to the next character in the string
    add edx, 2                  ; Go to the next character in video memory

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret
