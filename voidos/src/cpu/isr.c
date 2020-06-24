#include "cpu/isr.h"

/*
====================
isr_install

Set up the interrupt service routines for all CPU interrupts
====================
*/
void isr_install(void) {
    memory_set(&idt_entries, 0, sizeof(idt_entry_t) * IDT_ENTRIES);

    /* Can't do this with a loop because the address of the function names are needed */
    idt_set_gate(0, (u32)isr0);
    idt_set_gate(1, (u32)isr1);
    idt_set_gate(2, (u32)isr2);
    idt_set_gate(3, (u32)isr3);
    idt_set_gate(4, (u32)isr4);
    idt_set_gate(5, (u32)isr5);
    idt_set_gate(6, (u32)isr6);
    idt_set_gate(7, (u32)isr7);
    idt_set_gate(8, (u32)isr8);
    idt_set_gate(9, (u32)isr9);
    idt_set_gate(10, (u32)isr10);
    idt_set_gate(11, (u32)isr11);
    idt_set_gate(12, (u32)isr12);
    idt_set_gate(13, (u32)isr13);
    idt_set_gate(14, (u32)isr14);
    idt_set_gate(15, (u32)isr15);
    idt_set_gate(16, (u32)isr16);
    idt_set_gate(17, (u32)isr17);
    idt_set_gate(18, (u32)isr18);
    idt_set_gate(19, (u32)isr19);
    idt_set_gate(20, (u32)isr20);
    idt_set_gate(21, (u32)isr21);
    idt_set_gate(22, (u32)isr22);
    idt_set_gate(23, (u32)isr23);
    idt_set_gate(24, (u32)isr24);
    idt_set_gate(25, (u32)isr25);
    idt_set_gate(26, (u32)isr26);
    idt_set_gate(27, (u32)isr27);
    idt_set_gate(28, (u32)isr28);
    idt_set_gate(29, (u32)isr29);
    idt_set_gate(30, (u32)isr30);
    idt_set_gate(31, (u32)isr31);

    /* Load with ASM */
    idt_set();
}

/*
====================
isr_handler

Gets called from the ASM interrupt handler stub
====================
*/
void isr_handler(registers_t reg) {
    print("Received interrupt: ");
    char str[3];
    int_to_ascii(reg.int_num, str);
    print(str);
    print("\n");
    // TODO: this doesn't print the exception message
    print(exception_messages[reg.int_num]);
    print("\n");
}
