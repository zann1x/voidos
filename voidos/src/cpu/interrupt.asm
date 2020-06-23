[EXTERN isr_handler]

;; Common ISR code
isr_common_stub:
    ;; Save the CPU state and make the setup for kernel mode segments
    pusha                       ; Pushes edi, esi, ebp, esp, ebx, edx, ecx, eax
    mov ax, ds                  ; Lower 16-bits of eax = ds.
    push eax                    ; Save the data segment descriptor

    mov ax, 0x10                ; Load the kernel data segment descriptor (no effect rn)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ;; Call the C fault handler
    call isr_handler

    ;; Restore the stack frame
    pop eax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    popa                        ; Pop edi, esi, ebp, ...
    add esp, 8                  ; Clean up the pushed error code and pushed ISR number
    sti
    iret                        ; Return from the interrupt.
                                ; Pop CS, EIP, EFLAGS, SS and ESP

;; Define a macro, taking one parameter
%macro ISR_NOERRCODE 1
  [GLOBAL isr%1]                ; %1 accesses the first parameter.
  isr%1:
    cli
    push byte 0
    push byte %1
    jmp isr_common_stub
%endmacro

%macro ISR_ERRCODE 1
  [GLOBAL isr%1]
  isr%1:
    cli
    push byte %1
    jmp isr_common_stub
%endmacro

ISR_NOERRCODE   0
ISR_NOERRCODE   1
ISR_NOERRCODE   2
ISR_NOERRCODE   3
ISR_NOERRCODE   4
ISR_NOERRCODE   5
ISR_NOERRCODE   6
ISR_NOERRCODE   7
ISR_ERRCODE     8
ISR_NOERRCODE   9
ISR_ERRCODE     10
ISR_ERRCODE     11
ISR_ERRCODE     12
ISR_ERRCODE     13
ISR_ERRCODE     14
ISR_NOERRCODE   15
ISR_NOERRCODE   16
ISR_NOERRCODE   17
ISR_NOERRCODE   18
ISR_NOERRCODE   19
ISR_NOERRCODE   20
ISR_NOERRCODE   21
ISR_NOERRCODE   22
ISR_NOERRCODE   23
ISR_NOERRCODE   24
ISR_NOERRCODE   25
ISR_NOERRCODE   26
ISR_NOERRCODE   27
ISR_NOERRCODE   28
ISR_NOERRCODE   29
ISR_NOERRCODE   30
ISR_NOERRCODE   31
