;; Ensures that the program jump straight into the kernel's entry function
[bits 32]                       ; Protected mode is already enabled at this point
[extern main]                   ; Reference the external symbol 'main', so the linker
                                ; can substitute the final address
    call main                   ; Invoke the main function in the C kernel
    jmp $                       ; Hang forever when returning from the kernel
