int callee_function(int my_arg) {
    return my_arg;
}

void caller_function(void) {
    callee_function(0xdede);
}
