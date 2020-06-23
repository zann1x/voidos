#include "cpu/idt.h"

void idt_set_gate(int pos, u32 handler) {
    idt_entries[pos].low_offset = handler & 0xffff;
    idt_entries[pos].sel = 0x08;
    idt_entries[pos].always0 = 0;
    idt_entries[pos].flags = 0x8e;
    idt_entries[pos].high_offset = (handler >> 16) & 0xffff;
}

void idt_set(void) {
    idt_ptr.base = (u32)&idt_entries;
    idt_ptr.limit = sizeof(idt_entry_t) * IDT_ENTRIES - 1;

    /* Always load &idt_ptr, not &idt_entries*/
    __asm__ __volatile__("lidtl (%0)" : : "r" (&idt_ptr));
}
