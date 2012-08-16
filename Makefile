APP=mempodroid
 
NDK_DIR := /media/__ubuntu_11.10_/home/li3939108/android-ndk-r8b
NDK_HOST := linux-x86
SDKTOOL := /media/ext4_34GB_Lct1/home/li3939108/Documents/android-sdk-linux/tools
 
TOOLCHAIN_PREFIX := $(NDK_DIR)/toolchains/arm-linux-androideabi-4.6/prebuilt/$(NDK_HOST)/bin/arm-linux-androideabi-
CC := $(TOOLCHAIN_PREFIX)gcc
CPP := $(TOOLCHAIN_PREFIX)g++
LD := $(CC)
 
COMMON_FLAGS := -mandroid -ffunction-sections -fdata-sections -Os -g \
 --sysroot=$(NDK_DIR)/platforms/android-14/arch-arm \
 -fPIC \
 -fvisibility=hidden \
 -D__NEW__
 
CFLAGS := $(COMMON_FLAGS)
 
CFLAGS += -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ -DANDROID -DSK_RELEASE -DNDEBUG
 
CFLAGS += -UDEBUG -march=armv5te -mtune=xscale -msoft-float -mthumb-interwork -fpic -ffunction-sections -funwind-tables -fstack-protector -fmessage-length=0 -Bdynamic
 
CPPFLAGS := $(COMMON_FLAGS) \
 -fno-rtti -fno-exceptions \
 -fvisibility-inlines-hidden 
 
LDFLAGS += --sysroot=$(NDK_DIR)/platforms/android-14/arch-arm 
LDFLAGS +=  -Bdynamic -Wl,-dynamic-linker,/system/bin/linker -Wl,--gc-sections -Wl,-z,nocopyreloc   
LDFLAGS += -L$(NDK_DIR)/toolchains/arm-linux-androideabi-4.6/prebuilt/$(NDK_HOST)/lib/gcc/arm-linux-androideabi/4.6.x-google
LDFLAGS += -L$(NDK_DIR)/toolchains/arm-linux-androideabi-4.6/prebuilt/$(NDK_HOST)/lib/gcc
LDFLAGS += -L$(NDK_DIR)/toolchains/arm-linux-androideabi-4.6/prebuilt/$(NDK_HOST)/arm-linux-androideabi/lib
LDFLAGS += -lc -llog -lgcc \
  -z $(NDK_DIR)/platforms/android-14/arch-arm/usr/lib/crtbegin_dynamic.o $(NDK_DIR)/platforms/android-14/arch-arm/usr/lib/crtend_android.o 
 
OBJS += $(APP).o 
 
all:    $(APP) 
 
$(APP):    $(OBJS) 
	$(LD) $(LDFLAGS) -o $@ $^ 
 
%.o:    %.c 
	$(CC) -c $(CFLAGS) $< -o $@ 
 
%.o:    %.cpp 
	$(CPP) -c $(CFLAGS) $(CPPFLAGS) $< -o $@ 
 
install: $(APP) 
	$(SDKTOOL)/adb push $(APP) /data/local/bin/$(APP) 
	$(SDKTOOL)/adb shell chmod 755 /data/local/bin/$(APP) 
 
run: 
	$(SDKTOOL)/adb shell /data/local/bin/$(APP) 
 
clean: 
	@rm -f $(APP).o $(APP)
