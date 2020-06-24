/*
 * Interrupt descriptor table
 */

/*
 * How every interrupt gate (handler) is defined
 */
struct idt_entry_struct {
    u16 low_offset;             /* Lower 16 bits of the address to jump to on interrupt */
    u16 sel;                    /* Kernel segment selector */
    u8 always0;                 /* Always value 0 */
    u8 flags;                   /* Some more flags:
                                 * First byte 
                                 * Bit 7: "Interrupt is present"
                                 * Bits 6-5: Privilege level of caller (0=kernel..3=user)
                                 * Bit 4: Set to 0 for interrupt gates
                                 * Bits 3-0: bits 1110 = decimal 14 = "32 bit interrupt gate" */
    u16 high_offset;            /* Upper 16 bits of the address to jump to */
} __attribute__((packed));
typedef struct idt_entry_struct idt_entry_t;

/*
 * A pointer to the array of interrupt handlers.
 * Assembly instruction 'lidt' will read it
 */
struct idt_ptr_struct {
    u16 limit;
    u32 base;                   /* Address of the first elment in idt_entry_struct array */
} __attribute__((packed));
typedef struct idt_ptr_struct idt_ptr_t;

#define IDT_ENTRIES 256
idt_entry_t idt_entries[IDT_ENTRIES];
idt_ptr_t idt_ptr;
