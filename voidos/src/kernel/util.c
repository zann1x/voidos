/*
====================
memory_set
====================
*/
void memory_set(u8* destination, u8 value, u32 length) {
    u8* tmp = (u8*)destination;
    for (; length != 0; length--) {
        *tmp++ = value;
    }
}

/*
====================
memory_copy
====================
*/
void memory_copy(char* source, char* destination, int size) {
    for (int i = 0; i < size; i++) {
        *(destination + i) = *(source + i);
    }
}

/*
====================
string_length
====================
*/
int string_length(char str[]) {
    const char* s;
    for (s = str; *s; s++) {}
    return (s - str);
}

/*
====================
reverse

Reverses the string str in-place.
(See K&R implementation of reverse)
====================
*/
void string_reverse(char str[]) {
    int i, j;
    char c;

    for (i = 0, j = string_length(str) - 1; i < j; i++, j--) {
        c = str[i];
        str[i] = str[j];
        str[j] = c;
    }
}

/*
====================
int_to_ascii

Convert the number into its ascii representation.
The result is stored into str.
(See K&R implementation of itoa)
====================
*/
void int_to_ascii(int number, char str[]) {
    int i, sign;

    if ((sign = number) < 0) {
        number = -number;
    }

    i = 0;
    do {
        str[i++] = number % 10 + '0';
    } while ((number /= 10) > 0);

    if (sign < 0) {
        str[i++] = '-';
    }
    str[i] = '\0';

    string_reverse(str);
}
