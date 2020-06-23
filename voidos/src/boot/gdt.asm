gdt_start:

;; Place the mandatory 8 byte null descriptor at the start
gdt_null:
    dd 0x0
    dd 0x0

;; Code segment descriptor (base=0x0, length=0xfffff)
gdt_code:
    dw 0xffff                   ; Segment length (bits 0-15)
    dw 0x0                      ; Segment base (bits 0-15)
    db 0x0                      ; Segment base (bits 16-23)
    db 10011010b                ; First flags + type flags (8 bits)
                                ; 1(present) 00(privilege) 1(descriptor type)
                                ; 1(code) 0(conforming) 1(readable) 0(accessed)
    db 11001111b                ; Second flags (4 bits) + Segment length (bits 16-19)
                                ; 1(granularity) 1(32bit default) 0(64bit segment) 0(AVL)
    db 0x0                      ; Segment base (bits 24-31)

;; Data segment descriptor.
;; Everything like in the code segment except for the type flags
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b                ; 1(present) 00(privilege) 1(descriptor type)
                                ; 0(code) 0(expand down) 1(writable) 0(accessed)
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of the GDT (16bit), one less of its true size
    dd gdt_start                ; Start address of the GDT (32bit)

;; Constants
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
