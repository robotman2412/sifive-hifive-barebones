
cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_EXPORT_COMPILE_COMMANDS true)

project(hifive)

# Set compiler.
set(CMAKE_C_COMPILER "riscv64-linux-gnu-gcc")
add_compile_options(
    -ffreestanding
    -march=rv64gc -mabi=lp64
    -fno-stack-protector
    -fno-stack-check
    -fno-lto
    -fPIE
)
add_link_options(
    -nodefaultlibs -nostartfiles
    -T${CMAKE_CURRENT_LIST_DIR}/linker.ld
    -pie
    -Wl,--build-id=none
)

# Add sources.
add_executable(hifive
    src/main.c
)
target_include_directories(hifive PRIVATE include)
