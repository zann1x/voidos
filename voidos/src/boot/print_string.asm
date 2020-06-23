;; Print the string loaded in bx
print:
    pusha
    mov ah, 0x0e                ; Enter tty mode

start:
    mov al, [bx]                ; Move base address of string to al
    cmp al, 0                   ; Have we reached the end of the string yet?
    je done
    ; or al, al                   ; Have we reached the end of the string yet?
    ; jz done

    int 0x10                    ; Print the currently in loaded character in al

    add bx, 1                   ; Move on to the next character
    jmp start

done:
    popa
    ret

;; Print new line characters
print_nl:
    pusha

    mov ah, 0x0e                ; Enter tty mode
    mov al, 0x0a                ; New line (\n)
    int 0x10
    mov al, 0x0d                ; Carriage return (\r)
    int 0x10

    popa
    ret
