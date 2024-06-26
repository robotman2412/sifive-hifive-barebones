# HiFive Unleashed barebones example
This repository serves as a bare-bones example for booting a custom kernel.
It uses SiFive's recommended boot method: U-boot SPL -> OpenSBI -> U-boot
And continues into the custom part: Limine -> Custom kernel

## Prerequisites
- A 64-bit RISC-V C compiler like `riscv64-linux-gnu-gcc`
- GNU mtools for creating the boot partition
- `swig` for building OpenSBI

## Boot process explanation
When the FU740 starts, it looks at the MSEL switches for the boot mode.
We want MSEL=1011 because it boots from SD-card. *Warning: The HiFive Unmatched board has reverse polarity for the MSEL switches, so you only want MSEL2 to be "ON".*

The ZSBL (Zero-Stage BootLoader) will then look in the SD-card for the U-boot SPL<sup>(1)</sup> partition, load it and run it. U-boot SPL will look for OpenSBI and U-boot proper at sector 2082<sup>(2)</sup>.

Finally, U-boot loads Limine EFI which can in turn be used to load the custom kernel or any other operating systems.

(1): Partition GUID `5B193300-FC78-40CD-8002-E86C45580B47`

(2): Partition GUID `2E54B353-1271-4842-806F-E436D6AF6985`
