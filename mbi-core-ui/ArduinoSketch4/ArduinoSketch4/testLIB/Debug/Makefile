################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL := cmd.exe
RM := rm -rf

USER_OBJS :=

LIBS := 
PROJ := 

O_SRCS := 
C_SRCS := 
S_SRCS := 
S_UPPER_SRCS := 
OBJ_SRCS := 
ASM_SRCS := 
PREPROCESSING_SRCS := 
OBJS := 
OBJS_AS_ARGS := 
C_DEPS := 
C_DEPS_AS_ARGS := 
EXECUTABLES := 
OUTPUT_FILE_PATH :=
OUTPUT_FILE_PATH_AS_ARGS :=
AVR_APP_PATH :=$$$AVR_APP_PATH$$$
QUOTE := "
ADDITIONAL_DEPENDENCIES:=
OUTPUT_FILE_DEP:=
LIB_DEP:=
LINKER_SCRIPT_DEP:=

# Every subdirectory with source files must be described here
SUBDIRS := 


# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS +=  \
../Sketch.cpp


PREPROCESSING_SRCS += 


ASM_SRCS += 


OBJS +=  \
Sketch.o

OBJS_AS_ARGS +=  \
Sketch.o

C_DEPS +=  \
Sketch.d

C_DEPS_AS_ARGS +=  \
Sketch.d

OUTPUT_FILE_PATH +=testLIB.elf

OUTPUT_FILE_PATH_AS_ARGS +=testLIB.elf

ADDITIONAL_DEPENDENCIES:=

OUTPUT_FILE_DEP:= ./makedep.mk

LIB_DEP+=  \
C:/Users/Vitor/Documents/Atmel\ Studio/7.0/ArduinoSketch4/ArduinoSketch4/ArduinoCore/Debug/libArduinoCore.a \
C:/Users/Vitor/Documents/Atmel\ Studio/7.0/ArduinoSketch4/ArduinoSketch4/ArduinoCore/Debug/libArduinoCore.a

LINKER_SCRIPT_DEP+= 


# AVR32/GNU C Compiler
./Sketch.o: .././Sketch.cpp
	@echo Building file: $<
	@echo Invoking: AVR8/GNU C Compiler : 5.4.0
	$(QUOTE)C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-g++.exe$(QUOTE) -funsigned-char -funsigned-bitfields -DDEBUG -DF_CPU=16000000L -DARDUINO=10803 -DARDUINO_AVR_MEGA2560 -DARDUINO_ARCH_AVR -DUSB_VID=0x2341 -DUSB_PID=0x0010 -DUSB_MANUFACTURER="\"Arduino LLC\""  -I"..\\..\ArduinoCore\include\core" -I"..\\..\ArduinoCore\include\__vm" -I"..\\..\ArduinoCore\include\libraries\adafruit_gfx_library" -I"..\\..\ArduinoCore\include\libraries\adafruit_ssd1306-master" -I"..\\..\ArduinoCore\include\libraries\arduino-ad5933-master" -I"..\\..\ArduinoCore\include\libraries\ds3231" -I"..\\..\ArduinoCore\include\libraries\EEPROM" -I"..\\..\ArduinoCore\include\libraries\red_beryl" -I"..\\..\ArduinoCore\include\libraries\red_crystal" -I"..\\..\ArduinoCore\include\libraries\red_fang" -I"..\\..\ArduinoCore\include\libraries\red_quartz" -I"..\\..\ArduinoCore\include\libraries\SPI" -I"..\\..\ArduinoCore\include\libraries\Wire" -I"..\\..\ArduinoCore\include\libraries\adafruit_gfx_library\Fonts" -I"..\\..\ArduinoCore\include\libraries\Wire\utility" -I"..\\..\ArduinoCore\include\variants\mega" -I"C:\Program Files (x86)\Atmel\Studio\7.0\Packs\Atmel\ATmega_DFP\1.2.272\include"  -Os -fno-threadsafe-statics -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -mrelax -g2 -w -mmcu=atmega2560 -B "C:\Program Files (x86)\Atmel\Studio\7.0\Packs\Atmel\ATmega_DFP\1.2.272\gcc\dev\atmega2560" -c -std=gnu++11 -MD -MP -MF "$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)"   -o "$@" "$<" 
	@echo Finished building: $<
	




# AVR32/GNU Preprocessing Assembler



# AVR32/GNU Assembler




ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: $(OUTPUT_FILE_PATH) $(ADDITIONAL_DEPENDENCIES)

$(OUTPUT_FILE_PATH): $(OBJS) $(USER_OBJS) $(OUTPUT_FILE_DEP) $(LIB_DEP) $(LINKER_SCRIPT_DEP)
	@echo Building target: $@
	@echo Invoking: AVR8/GNU Linker : 5.4.0
	$(QUOTE)C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-g++.exe$(QUOTE) -o$(OUTPUT_FILE_PATH_AS_ARGS) $(OBJS_AS_ARGS) $(USER_OBJS) $(LIBS) -Wl,-Map="testLIB.map" -Wl,--start-group -Wl,-lArduinoCore -Wl,-lm -Wl,-lArduinoCore  -Wl,--end-group -Wl,-L"C:\Program Files (x86)\Arduino\lib" -Wl,-L"C:\Users\Vitor\Documents\Atmel Studio\7.0\ArduinoSketch4\ArduinoSketch4\ArduinoCore\Debug"  -Wl,--gc-sections -mrelax -mmcu=atmega2560 -B "C:\Program Files (x86)\Atmel\Studio\7.0\Packs\Atmel\ATmega_DFP\1.2.272\gcc\dev\atmega2560" -Os  
	@echo Finished building target: $@
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objcopy.exe" -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures  "testLIB.elf" "testLIB.hex"
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objcopy.exe" -j .eeprom  --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0  --no-change-warnings -O ihex "testLIB.elf" "testLIB.eep" || exit 0
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objdump.exe" -h -S "testLIB.elf" > "testLIB.lss"
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objcopy.exe" -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures "testLIB.elf" "testLIB.srec"
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-size.exe" "testLIB.elf"
	
	





# Other Targets
clean:
	-$(RM) $(OBJS_AS_ARGS) $(EXECUTABLES)  
	-$(RM) $(C_DEPS_AS_ARGS)   
	rm -rf "testLIB.elf" "testLIB.a" "testLIB.hex" "testLIB.lss" "testLIB.eep" "testLIB.map" "testLIB.srec" "testLIB.usersignatures"
	