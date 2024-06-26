OUTPUT_FORMAT(elf64-littleriscv)
OUTPUT_ARCH(riscv)

ENTRY(_start)

PHDRS
{
    text     PT_LOAD    FLAGS(0x05); /* Execute + Read */
    rodata   PT_LOAD    FLAGS(0x04); /* Read only */
    data     PT_LOAD    FLAGS(0x06); /* Write + Read */
    dynamic  PT_DYNAMIC FLAGS(0x06); /* Dynamic PHDR for relocations */
}

SECTIONS
{
    . = 0xffffffff80000000;

    .text : {
        *(.text .text.*)
    } :text

    . = ALIGN(4096);

    .rodata : {
        *(.rodata .rodata.* .srodata .srodata.*)
    } :rodata

    . = ALIGN(4096);

    .data : {
        *(.data .data.* .sdata .sdata.*)

        /* Limine requests. */
        KEEP(*(.requests_start_marker))
        KEEP(*(.requests))
        KEEP(*(.requests_end_marker))
    } :data

    /* We need to support dynamic relocations I suppose. */
    .dynamic : {
        *(.dynamic)
    } :data :dynamic

    /* Add zero-initialized memory last to avoid padding. */
    .bss : {
        *(.bss .bss.* .sbss .sbss.*)
        *(COMMON)
    } :data

    /* Discard useless sections. */
    /DISCARD/ : {
        *(.eh_frame*)
        *(.note .note.*)
        *(.interp)
    }
}