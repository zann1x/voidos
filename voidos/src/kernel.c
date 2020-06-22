void dummy_function(void) {
}

void main(void) {
    // Point a char pointer to the first text cell of video memory (i.e. top-left)
    char* video_memory = (char*)0xb8000;
    // At the address pointed to, store the character 'X'
    // TL;DR: display 'X' at the top-left of the screen
    *video_memory = 'X';

    dummy_function();
}
