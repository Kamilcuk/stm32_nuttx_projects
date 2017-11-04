
## create links inside nuttx directory

DEBUG:=true
BOARD:=stm32f103-minimum/usbnsh

all: all


nuttx/apps/kcapps:
	ln -f -s ../../kcnuttx/apps/kcapps nuttx/apps

prebuild: nuttx/apps/kcapps
	cd nuttx/nuttx/tools && ./configure.sh $(BOARD) || true
#ifeq ($(DEBUG),true)
#	edit_kernel_config_handler.sh nuttx/nuttx/.config CONFIG_DEBUG_SYMBOLS y
#else
#	edit_kernel_config_handler.sh nuttx/nuttx/.config clear CONFIG_DEBUG_SYMBOLS
#endif
#	edit_kernel_config_handler.sh nuttx/nuttx/.config CONFIG_INTELHEX_BINARY y


nuttx/nuttx/nuttx.hex: all
flash-hex: nuttx/nuttx/nuttx.hex
	st-flash --reset --format ihex write $<

nuttx/nuttx/nuttx.bin: all
flash-bin: nuttx/nuttx/nuttx.bin
	st-flash --reset write $< 0x08000000

flash: flash-bin

%: prebuild
	make -j4 -C nuttx/nuttx $@

.PHONY: prebuild flash nuttx/nuttx/nuttx.bin