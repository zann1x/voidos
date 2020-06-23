struct registers
{
    /* Data segment selector */
    u32 ds;
    /* Pushed by pusha */
    u32 edi, esi, ebp, esp, ebx, edx, ecx, eax;
    /* Interrupt number and error code (if applicable) */
    u32 int_num, err_code;
    /* Pushed by the processor automatically */
    u32 eip, cs, eflags, useresp, ss;
};
typedef struct registers registers_t;

/* 
 * Extern directives to access the addresses of the ASM ISR handlers
 * reserved for CPU exceptions
 */
extern void isr0(void);
extern void isr1(void);
extern void isr2(void);
extern void isr3(void);
extern void isr4(void);
extern void isr5(void);
extern void isr6(void);
extern void isr7(void);
extern void isr8(void);
extern void isr9(void);
extern void isr10(void);
extern void isr11(void);
extern void isr12(void);
extern void isr13(void);
extern void isr14(void);
extern void isr15(void);
extern void isr16(void);
extern void isr17(void);
extern void isr18(void);
extern void isr19(void);
extern void isr20(void);
extern void isr21(void);
extern void isr22(void);
extern void isr23(void);
extern void isr24(void);
extern void isr25(void);
extern void isr26(void);
extern void isr27(void);
extern void isr28(void);
extern void isr29(void);
extern void isr30(void);
extern void isr31(void);

/* 
 * Error message for the special CPU dedicated intterupts
 */
char* exception_messages[] = {
    "Division by zero exception",
    "Debug exception",
    "Non maskable interrupt",
    "Breakpoint exception",
    "Into detected overflow",
    "Out of bounds exception",
    "Invalid opcode exception",
    "No coprocessor exception",

    "Double fault",                 /* Pushes an error code */
    "Coprocessor segment overrun",
    "Bad TSS",                      /* Pushes an error code */
    "Segment not present",          /* Pushes an error code */
    "Stack fault",                  /* Pushes an error code */
    "General protection fault",     /* Pushes an error code */
    "Page fault",                   /* Pushes an error code */
    "Unknown interrupt exception",

    "Coprocessor fault",
    "Alignment check exception",
    "Machine check exception",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",

    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved"
};
