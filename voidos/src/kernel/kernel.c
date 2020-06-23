#include "cpu/types.h"
#include "kernel/util.c"

#include "kernel/port.c"
#include "drivers/screen.c"

#include "cpu/idt.c"
#include "cpu/isr.c"

int main(int argc, char* argv[]) {
    clear_screen();
    // for (int i = 0; i < 24; i++) {
    //     char str[255];
    //     int_to_ascii(i, str);
    //     print_at(str, 0, i);
    // }

    // print_at("This text forces the kernel to scroll. Row 0 will disappear. ", 56, 24);
    // print("And with this text, the kernel will scroll again, and row 1 will "
    //       "disappear too!");

    isr_install();
    /* Test the interrupts */
    __asm__ __volatile__("int $0x3");
    __asm__ __volatile__("int $0x4");

    return 0;
}
