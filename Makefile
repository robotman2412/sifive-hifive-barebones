
MAKEFLAGS     += --silent
OPENSBI        = $(shell pwd)/opensbi/build/platform/generic/firmware/fw_dynamic.bin
CROSS_COMPILE ?= riscv64-linux-gnu-

.PHONY: image kernel clean fullclean

image: kernel
	# Create boot filesystem
	rm -rf image.dir
	cp -r image.rom.dir image.dir
	mkdir -p image.dir/EFI/BOOT/
	mkdir -p image.dir/boot/
	make -C limine
	cp limine/BOOTRISCV64.EFI image.dir/EFI/BOOT/
	cp build/hifive image.dir/boot/
	
	# Build OpenSBI and U-boot
	make -C opensbi PLATFORM=generic CROSS_COMPILE=$(CROSS_COMPILE)
	make -C u-boot sifive_unmatched_defconfig CROSS_COMPILE=$(CROSS_COMPILE)
	make -C u-boot OPENSBI=$(OPENSBI) CROSS_COMPILE=$(CROSS_COMPILE)
	
	# Format FAT filesystem
	rm -f fatfs.bin
	dd if=/dev/zero bs=1M count=4  of=fatfs.bin
	mformat -i fatfs.bin
	mcopy -s -i fatfs.bin image.dir/* ::/
	
	# Create image
	rm -f image.hdd
	dd if=/dev/zero bs=1M count=64 of=image.hdd
	# 1M (SPL), 1007K (U-boot), 4M /boot, remainder /root
	sgdisk -a 1 \
		--new=1:34:2081    --change-name=1:spl   --typecode=1:5B193300-FC78-40CD-8002-E86C45580B47 \
		--new=2:2082:4095  --change-name=2:uboot --typecode=2:2E54B353-1271-4842-806F-E436D6AF6985 \
		--new=3:4096:12287 --change-name=3:boot  --typecode=3:0x0700 \
		--new=4:12288:-0   --change-name=4:root  --typecode=4:0x8300 \
		image.hdd
	
	# Copy data onto partitions
	dd if=u-boot/spl/u-boot-spl.bin bs=512 seek=34   of=image.hdd conv=notrunc
	dd if=u-boot/u-boot.itb         bs=512 seek=2082 of=image.hdd conv=notrunc
	dd if=fatfs.bin                 bs=512 seek=4096 of=image.hdd conv=notrunc

kernel:
	cmake -B build
	cmake --build build

clean:
	rm -rf build image.dir

fullclean: clean
	make -C opensbi clean
	make -C u-boot clean
