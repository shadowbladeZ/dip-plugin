# devkitARM path
DEVKITARM ?=	/opt/devkitARM

# Prefix
PREFIX	=	$(DEVKITARM)/bin/arm-eabi-

# Executables
CC	=	$(PREFIX)gcc
LD	=	$(PREFIX)gcc
STRIP	=	./stripios

# Flags
ARCH	=	-mcpu=arm926ej-s -mthumb -mthumb-interwork -mbig-endian
CFLAGS	=	$(ARCH) -I. -fomit-frame-pointer -Os -Wall -Wstrict-prototypes -ffunction-sections
LDFLAGS	=	$(ARCH) -nostartfiles -Wl,-T,link.ld,-Map,$(TARGET).map -Wl,--gc-sections -Wl,-static

# Libraries
LIBS	=

# Target
TARGET	=	dip-plugin

# Objects
OBJS	=	dip.o			\
		dip_calls.o		\
		dma.o			\
		file.o			\
		fs.o			\
		ipc.o			\
		main.o			\
		patches.o		\
		plugin.o		\
		start.o			\
		swi_mload.o		\
		syscalls.o		\
		tools.o			\
		wbfs.o


$(TARGET).elf: $(OBJS)
	@echo -e " LD\t$@"
	@$(LD) $(LDFLAGS) $(OBJS) $(LIBS) -o $@.orig
	@$(STRIP) $@.orig $@

%.o: %.s
	@echo -e " CC\t$@"
	@$(CC) $(CFLAGS) -D_LANGUAGE_ASSEMBLY -c -x assembler-with-cpp -o $@ $<

%.o: %.c
	@echo -e " CC\t$@"
	@$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@echo -e "Cleaning..."
	@rm -f $(OBJS) $(TARGET).elf $(TARGET).elf.orig $(TARGET).map
