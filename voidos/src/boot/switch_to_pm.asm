[bits 16]
;; Switch to protected mode
switch_to_pm:
    cli                         ; Turn off interrupts unil the protected mode interrupt
                                ; vector is set up

    lgdt [gdt_descriptor]       ; Load the global descriptor table

    mov eax, cr0                ; To make the switch to protected mode, the first bit of
                                ; cr0 (control register) needs to be set
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm        ; Make a far jump (to a new segment) to the 32-bit code.
                                ; This forces the CPU to flush its cache of pre-fetched
                                ; and real-moded dcoded instructions

[bits 32]
;; Initialize registers and stack once in protected mode
init_pm:
    mov ax, DATA_SEG            ; In the new protected mode the old segments are
                                ; meaningless, so the segment registers need to be
                                ; pointed to the data selector that was defined in
                                ; the GDT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000            ; Update the stack position so it's at the top of the
                                ; free space
    mov esp, ebp

    call begin_pm               ; Call a well-known label to enter further routine
                                ; execution in protected mode
