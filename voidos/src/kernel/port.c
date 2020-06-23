/*
====================
port_byte_in

C wrapper function that reads a byte from the specified port.
"=a" (result): Put AL register in variable result when finished
"d" (port): Map the variable port into EDX
====================
*/
unsigned char port_byte_in(u16 port) {
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

/*
====================
port_byte_out

C wrapper function that outputs a byte at the specified port.
"a" (result): Load EAX with data
"d" (port): Map the variable port into EDX
====================
*/
void port_byte_out(u16 port, u8 data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

/*
====================
port_word_in

C wrapper function that reads a word from the specified port.
"=a" (result): Put AL register in variable result when finished
"d" (port): Map the variable port into EDX
====================
*/
unsigned short port_word_in(u16 port) {
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

/*
====================
port_word_out

C wrapper function that outputs a word at the specified port.
"a" (result): Load EAX with data
"d" (port): Map the variable port into EDX
====================
*/
void port_word_out(u16 port, u16 data) {
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
