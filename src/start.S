
    .global main
    .global __global_pointer$

    .global _start
    .text
    .p2align 2
    .type _start, %function
_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop
    la sp, __stack_top
    li tp, 0
    li s0, 0
    li a0, 0
    li a1, 0
    jal main
    ebreak



    .bss
    .global __stack_bottom
    .global __stack_top
    .p2align 4
__stack_bottom:
    .skip 8192
__stack_top:
