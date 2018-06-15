#To RUN:
#in two different terminals: cd /Users/nicholasreynolds/stm32stexamples/STM32F4-Discovery_FW_V1.1.0/Project/Audio_playback_and_record
#In one terminal: "make debug"
#In other terminal: "arm-none-eabi-gdb -x init.gdbinit"
#OR for visual debugger: "arm-none-eabi-gdb -tui --eval-command="target remote localhost:3333" DIYAudio.elf"
#			to set breakpoint: "break main.c:51"
#			to clear breakpoint: "delete Breakpoint 1"

#in (gdb):
# to reset from beginning of prog and stop: "monitor reset halt"
# after this "c" to continue
#to see all breakpoints: "info break"



#AUDIO PLAYBACK MAKEFILE
TARGET=SamplePedal.hex
EXECUTABLE=SamplePedal.elf

#cross compiler:
CC=arm-none-eabi-gcc

#linker:
LD=arm-none-eabi-ld
#LD=arm-none-eabi-gcc

#archive maintaining program:
AR=arm-none-eabi-ar

#program for comiling assembly files:
AS=arm-none-eabi-as

#objcopy is used to convert between object files
#this doesnt seem to be used anywhere???? ---> used at the bottom
#	$(CP) -O ihex $^ $@
CP=arm-none-eabi-objcopy

#displays information from object files
OD=arm-none-eabi-objdump

#this seens to run at the end to convert the .elf file to .hex
BIN=$(CP) -O ihex


#------------------------------------------------------------------------------
# Setup Variables and Includes for firmware compiling/linking
#------------------------------------------------------------------------------

#these are all "#defines" that the ST libraries use as input.
# see https://forum.sparkfun.com/viewtopic.php?t=30848
DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F4XX -DMANGUSTA_DISCOVERY -DUSE_USB_OTG_FS -DHSE_VALUE=8000000 -DMEDIA_IntFLASH

MCU = cortex-m4

#MCFlags info:
#-specs=nosys.specs: specifies no semihosting. see http://www.openstm32.org/Other%2BManuals
#											and http://www.keil.com/support/man/docs/armcc/armcc_pge1358787046598.htm
#-mthumb: Requests that the compiler targets the T32 (THUMB 32 bit) instruction set.
#-mlittle-endian: endian-ness
#-mfpu=fpv4-sp-d16: This flag specifies what floating-point hardware (or emulation) is available on your target architecture
#											more info:https://embeddedartistry.com/blog/2017/10/9/r1q7pksku2q3gww9rpqef0dnskphtc
#-mfloat-abi=hard: used to select which ARM ABI is used. The hard option enables full hardware floating-point support.
#											see the link above for info
#-mthumb-interwork: Generate code that supports calling between the ARM and Thumb instruction sets
#											see https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html

MCFLAGS = -mcpu=$(MCU) -g -specs=nosys.specs -mthumb -mlittle-endian -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb-interwork
STM32_INCLUDES = -I../Utilities/STM32F4-Discovery \
	-I../Libraries/CMSIS/ST/STM32F4xx/Include/ \
	-I../Libraries/CMSIS/Include/ \
	-I../Libraries/STM32F4xx_StdPeriph_Driver/inc/ \
	-I../Libraries/STM32_USB_Device_Library/Class/hid/inc \
	-I../Libraries/STM32_USB_Device_Library/Core/inc/ \
	-I../Libraries/STM32_USB_OTG_Driver/inc/ \
	-I./inc/

#optimization  values
#0s: This option selects optimizations which reduce the size of an executable
#see: http://www.network-theory.co.uk/docs/gccintro/gccintro_49.html
OPTIMIZE       = -Os

CFLAGS	= $(MCFLAGS)  $(OPTIMIZE)  $(DEFS) -I./ -I./ $(STM32_INCLUDES)  -Wl,-T,stm32_flash.ld
AFLAGS	= $(MCFLAGS)
#-mapcs-float use float regs. small increase in code size

STM32_USB_OTG_SRC = ../Libraries/STM32_USB_OTG_Driver/src/usb_dcd_int.c \
	../Libraries/STM32_USB_OTG_Driver/src/usb_core.c \
	../Libraries/STM32_USB_OTG_Driver/src/usb_dcd.c \

STM32_USB_DEVICE_SRC = ../Libraries/STM32_USB_Device_Library/Class/hid/src/usbd_hid_core.c \
	../Libraries/STM32_USB_Device_Library/Core/src/usbd_req.c \
	../Libraries/STM32_USB_Device_Library/Core/src/usbd_core.c \
	../Libraries/STM32_USB_Device_Library/Core/src/usbd_ioreq.c

SRC = src/main.c \
	src/audio_sample.c \
	src/stm32f4xx_it.c \
	src/system_stm32f4xx.c \
	src/waveplayer.c \
	../Utilities/STM32F4-Discovery/stm32f4_discovery.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/misc.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c \
	../Utilities/STM32F4-Discovery/stm32f4_discovery_audio_codec.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c \
	../Utilities/STM32F4-Discovery/stm32f4_discovery_lis302dl.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c \
	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.c \
	#	../Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c \

STARTUP = startup_stm32f4xx.s

OBJDIR = .
OBJ = $(SRC:%.c=$(OBJDIR)/%.o)
OBJ += Startup.o
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# OpenOCD variables for flash/erase/run/debug
#------------------------------------------------------------------------------

OPENOCD_PATH ?= /usr/local/share/openocd
export OPENOCD_BIN = openocd
export OPENOCD_INTERFACE = interface/stlink-v2-1.cfg
export OPENOCD_TARGET = target/stm32f4x_stlink.cfg

#flash:
OPENOCD_FLASH_CMDS = ''
OPENOCD_FLASH_CMDS += -c 'reset halt'
OPENOCD_FLASH_CMDS += -c 'sleep 10'
OPENOCD_FLASH_CMDS += -c 'stm32f2x unlock 0'
#check -- PRJ_FULL needs to be changed. this writes the .hex instead of the .elf
#OPENOCD_FLASH_CMDS += -c 'flash write_image erase $(PRJ_FULL) 0 ihex'
OPENOCD_FLASH_CMDS += -c 'flash write_image erase $(EXECUTABLE) 0 elf'
OPENOCD_FLASH_CMDS += -c shutdown
export OPENOCD_FLASH_CMDS

#erase:
OPENOCD_ERASE_CMDS = ''
OPENOCD_ERASE_CMDS += -c 'sleep 10'
OPENOCD_ERASE_CMDS += -c 'sleep 10'
OPENOCD_ERASE_CMDS += -c 'reset halt'
OPENOCD_ERASE_CMDS += -c 'sleep 10'
OPENOCD_ERASE_CMDS += -c 'sleep 10'
OPENOCD_ERASE_CMDS += -c 'stm32f2x mass_erase 0'
OPENOCD_ERASE_CMDS += -c shutdown
export OPENOCD_ERASE_CMDS

#run:
OPENOCD_RUN_CMDS = ''
OPENOCD_RUN_CMDS += -c 'reset halt'
OPENOCD_RUN_CMDS += -c 'sleep 10'
OPENOCD_RUN_CMDS += -c 'reset run'
OPENOCD_RUN_CMDS += -c 'sleep 10'
OPENOCD_RUN_CMDS += -c shutdown
export OPENOCD_RUN_CMDS

#debug:
#this doesnt make much sense to me...
OPENOCD_DEBUG_CMDS = ''
OPENOCD_DEBUG_CMDS += -c 'halt'
OPENOCD_DEBUG_CMDS += -c 'sleep 10'

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

#for compilation: .hex and .elf file creation:
all: $(TARGET)

#for reference: https://hackaday.com/2016/03/11/embed-with-elliot-march-makefile-madness/
#another helpful link: http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# sooo... TARGET depends on EXECUTABLE. The tab indented next line tells Make how to
# get from the dependency to the target

#CP=arm-none-eabi-objcopy
#TARGET=DIYAudio.hex
#EXECUTABLE=DIYAudio.elf
#"$@" is a shortcut for the item to the left of the ":"
#"$^" is a shortcut for the item to the right of the ":"
# so the command is: arm-none-eabi-objcopy -O ihex DIYAudio.elf DIYAudio.hex
# this abstraction seems pointlessly confusing!!

$(TARGET): $(EXECUTABLE)
	$(CP) -O ihex $^ $@

# EXECUTABLE depends on SRC and STARTUP (the .c files and .s file)
#CC=arm-none-eabi-gcc
#CFLAGS is all the compiler flags and Includes
# the command is: arm-none-eabi-gcc (flags and includes) (source files) -o DIYAudio.elf
$(EXECUTABLE): $(SRC) $(STARTUP)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f $(TARGET) $(EXECUTABLE)

#discussion about flashing/erasing/running
#https://stackoverflow.com/questions/38033130/how-to-use-the-gdb-gnu-debugger-and-openocd-for-microcontroller-debugging-fr

# openocd variables and targets


#------------------------------OpenOCD Commands---------------------------------

flash:
	$(OPENOCD_BIN) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c init $(OPENOCD_FLASH_CMDS)

erase:
	$(OPENOCD_BIN) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c init $(OPENOCD_ERASE_CMDS)

run:
	$(OPENOCD_BIN) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c init $(OPENOCD_RUN_CMDS)

debug:
	$(OPENOCD_BIN) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c init $(OPENOCD_DEBUG_CMDS)
