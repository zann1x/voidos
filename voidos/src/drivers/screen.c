#include "screen.h"

/*
====================2
get_screen_offset
====================
*/
int get_screen_offset(int col, int row) {
    return 2 * (row * MAX_COLS + col);
}

/*
====================
get_row_offset
====================
*/
int get_row_offset(int offset) {
    return offset / (2 * MAX_COLS);
}

/*
====================
get_col_offset
====================
*/
int get_col_offset(int offset) {
    return (offset - (get_row_offset(offset) * 2 * MAX_COLS)) / 2;
}


/*
====================
get_cursor_offset

Use the VGA port to get the current cursor position
====================
*/
int get_cursor_offset() {
    // Ask for the high byte (<< 8) of the cursor offset (data 14)
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;

    // Ask for the low byte of the cursor offset (dat 15)
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);

    // Position * size of a character cell
    return offset * 2;
}

/*
====================
set_cursor_offset
====================
*/
void set_cursor_offset(int offset) {
    // Position / size of a character cell
    offset /= 2;

    // Output the high byte (>> 8) of the cursor offset (data 14)
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));

    // Output for the low byte of the cursor offset (dat 15)
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

/*
====================
print_char

If col and row are negative, we will print at the current cursor location.
if attribute_byte is zero, it will print white on black as default.

Returns the offset of the next character.
Sets the video cursor to the returned offset.
====================
*/
int print_char(char character, int col, int row, char attribute_byte) {
    unsigned char* video_memory = (unsigned char*)VIDEO_ADDRESS;
    if (!attribute_byte) {
        attribute_byte = WHITE_ON_BLACK;
    }

    if (col >= MAX_COLS || row >= MAX_ROWS) {
        video_memory[2 * MAX_COLS * MAX_ROWS - 2] = 'E';
        video_memory[2 * MAX_COLS * MAX_ROWS - 1] = RED_ON_WHITE;
        return get_screen_offset(col, row);
    }

    int offset;
    if (col >= 0 && row >= 0) {
        offset = get_screen_offset(col, row);
    } else {
        offset = get_cursor_offset();
    }

    if (character == '\n') {
        row = get_row_offset(offset);
        offset = get_screen_offset(0, row + 1);
    } else {
        video_memory[offset] = character;
        video_memory[offset + 1] = attribute_byte;
        offset += 2;
    }
    
    // Check if the offset is the over screen size and scroll if necessary
    if (offset >= MAX_ROWS * MAX_COLS * 2) {
        // Shuffle the rows back one row
        for (int i = 1; i < MAX_ROWS; i++) {
            memory_copy((char*)(get_screen_offset(0, i) + VIDEO_ADDRESS),
                        (char*)(get_screen_offset(0, i - 1) + VIDEO_ADDRESS),
                        MAX_COLS * 2);
        }

        // Blank the last line by setting all bytes to 0
        char* last_line = (char*)(get_screen_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS);
        for (int i = 0; i < MAX_COLS * 2; i++) {
            last_line[i] = 0;
        }

        // Move the offset back one row such that it is now on the last row
        // rather than off the edge of the screen
        offset -= 2 * MAX_COLS;
    }

    set_cursor_offset(offset);
    return offset;
}

/*
====================
print_at

If col and row are negative, we will use the current screen offset
====================
*/
void print_at(char* message, int col, int row) {
    // If col and row are negative, the cursor needs to be set
    int offset;
    if (col >= 0 && row >= 0) {
        offset = get_screen_offset(col, row);
    } else {
        offset = get_cursor_offset();
        row = get_row_offset(offset);
        col = get_col_offset(offset);
    }

    // Loop through the message and print it
    for (int i = 0; message[i] != 0; i++) {
        offset = print_char(message[i], col, row, WHITE_ON_BLACK);

        // Compute row and col for the next iteration
        row = get_row_offset(offset);
        col = get_col_offset(offset);
    }
}

/*
====================
print
====================
*/
void print(char* message) {
    print_at(message, -1, -1);
}

/*
====================
clear_screen

Sets all characters on the screen to space and puts the cursor at (0, 0)
====================
*/
void clear_screen(void) {
    int screen_size = MAX_COLS * MAX_ROWS;
    char* screen = (char*)VIDEO_ADDRESS;

    for (int i = 0; i < screen_size; i++) {
        screen[i * 2] = ' ';
        screen[i * 2 + 1] = WHITE_ON_BLACK;
    }

    set_cursor_offset(get_screen_offset(0, 0));
}
