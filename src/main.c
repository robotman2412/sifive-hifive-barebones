
// EID #0x01
long sbi_console_putchar(int ch) __attribute__((naked));
long sbi_console_putchar(int ch) {
    asm("li a7, 0x01; ecall; ret");
}

void sbi_print(char const *cstr) {
    while (*cstr) {
        sbi_console_putchar(*cstr);
        cstr++;
    }
}

void _start() {
    // Clear the screen.
    sbi_print("\033[0m\033[2J");
    // Print a message.
    sbi_print("Hello, World!\n");
    
    while(1);
}
