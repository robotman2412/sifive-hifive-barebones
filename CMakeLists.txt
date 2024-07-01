
cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_EXPORT_COMPILE_COMMANDS true)

project(hifive C ASM)

# Set compiler.
set(CMAKE_C_COMPILER "riscv32-unknown-elf-gcc")
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
add_compile_options(
    -ffreestanding
    -march=rv64gc -mabi=lp64
    -fno-stack-protector
    -fno-stack-check
    -fno-lto
    -ggdb
    -fpie
)
add_link_options(
    -nodefaultlibs -nostartfiles
    -T${CMAKE_CURRENT_LIST_DIR}/linker.ld
    -static-pie
    -Wl,--build-id=none
)

# Add sources.
add_executable(hifive
    src/main.c
    src/start.S
)
target_include_directories(hifive PRIVATE include)
# set_target_properties(hifive PROPERTIES LINK_DEPENDS ${CMAKE_CURRENT_LIST_DIR}/linker.ld)
