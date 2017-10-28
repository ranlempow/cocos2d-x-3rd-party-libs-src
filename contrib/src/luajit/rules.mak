# luajit

LUAJIT_VERSION ?= 2.1.0-beta3
LUAJIT_URL ?= http://luajit.org/download/LuaJIT-$(LUAJIT_VERSION).tar.gz
$(eval LUAJIT_URL := $(LUAJIT_URL))

$(TARBALLS)/LuaJIT-$(LUAJIT_VERSION).tar.gz:
	$(call download,$(LUAJIT_URL))

.sum-luajit: LuaJIT-$(LUAJIT_VERSION).tar.gz

luajit: LuaJIT-$(LUAJIT_VERSION).tar.gz .sum-luajit
	$(UNPACK)
	$(APPLY) $(SRC)/luajit/mingw.patch
ifeq ($(LUAJIT_VERSION),2.0.1)
	$(APPLY) $(SRC)/luajit/v2.0.1_hotfix1.patch
endif

ifeq ($(LUAJIT_VERSION),2.1.0-beta2)
	$(APPLY) $(SRC)/luajit/luajit-v2.1.0-beta2.patch
endif
	$(MOVE)

ifdef HAVE_IOS
ifeq ($(MY_TARGET_ARCH),armv7)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),armv7s)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),arm64)
LUAJIT_HOST_CC="gcc -m64 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),i386)
LUAJIT_HOST_CC="gcc -m32 $(OPTIM)"
endif

LUAJIT_TARGET_FLAGS="-isysroot $(IOS_SDK) -Qunused-arguments $(EXTRA_CFLAGS) $(EXTRA_LDFLAGS) $(ENABLE_BITCODE)"
LUAJIT_CROSS_HOST=$(xcrun cc)
endif #endof HAVE_IOS

ifdef HAVE_ANDROID

LUAJIT_GCC_M32=gcc
LUAJIT_GCC_M64=gcc

ifdef GCC_M32
LUAJIT_GCC_M32=$(GCC_M32)/gcc
endif

ifdef GCC_M64
LUAJIT_GCC_M64=$(GCC_M64)/gcc
endif

ifeq ($(MY_TARGET_ARCH),armeabi)
LUAJIT_HOST_CC="$(LUAJIT_GCC_M32) -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),armeabi-v7a)
LUAJIT_HOST_CC="$(LUAJIT_GCC_M32) -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),arm64-v8a)
LUAJIT_HOST_CC="$(LUAJIT_GCC_M64) -m64 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),x86)
LUAJIT_HOST_CC="$(LUAJIT_GCC_M32) -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),x86_64)
LUAJIT_HOST_CC="$(LUAJIT_GCC_M64) -m64 $(OPTIM) -DLUAJIT_ENABLE_GC64"
endif

ifeq ($(MY_TARGET_ARCH),mips)
LUAJIT_HOST_CC="$(LUAJIT_GCC_M32) -m32 $(OPTIM)"
endif

ifeq ($(MY_TARGET_ARCH),mips64)
LUAJIT_HOST_CC="$(LUAJIT_GCC_M64) -m64 $(OPTIM)"
endif



NDKF=--sysroot=$(ANDROID_NDK)/platforms/$(ANDROID_API)/arch-$(PLATFORM_SHORT_ARCH)
LUAJIT_TARGET_FLAGS="${NDKF} ${EXTRA_CFLAGS} ${EXTRA_LDFLAGS}"
LUAJIT_CROSS_HOST=$(HOST)-
endif

.luajit: luajit
ifdef HAVE_ANDROID
	cd $< && $(MAKE) -j8 BUILDMODE=static \
		HOST_CC=$(LUAJIT_HOST_CC) CROSS=$(LUAJIT_CROSS_HOST) TARGET_SYS=Linux \
		TARGET_CFLAGS=$(LUAJIT_TARGET_FLAGS) \
		TARGET_LDFLAGS=$(LUAJIT_TARGET_FLAGS)
endif

ifdef HAVE_MACOSX
	cd $< && CFLAGS="-DLUAJIT_ENABLE_GC64" LD_FLAGS="" $(MAKE) -j8
endif

ifndef HAVE_ANDROID

ifdef HAVE_LINUX

ifeq ($(MY_TARGET_ARCH),x86_64)
	cd $< && $(HOSTVARS_PIC) $(MAKE) -j8 HOST_CC="$(CC)" HOST_CFLAGS="$(CFLAGS)"
else
	cd $< && $(HOSTVARS_PIC) $(MAKE) -j8 HOST_CC="$(CC) -m32" HOST_CFLAGS="$(CFLAGS)"
endif

endif #ifdef HAVE_LINUX

endif #ifndef HAVE_ANDROID

ifdef HAVE_IOS

ifeq ($(MY_TARGET_ARCH),x86_64)
	cd $< && CFLAGS="-DLUAJIT_ENABLE_GC64" LD_FLAGS="" $(MAKE) -j8
else
	cd $< && $(MAKE) -j8 HOST_CC=$(LUAJIT_HOST_CC) CROSS=$(LUAJIT_CROSS_HOST) TARGET_SYS=iOS  TARGET_FLAGS=$(LUAJIT_TARGET_FLAGS)
endif

endif
ifdef HAVE_WIN32
	cd $< && $(HOSTVARS) mingw32-make install PREFIX=$(PREFIX) BUILDMODE=static
else
	cd $< && $(MAKE) install PREFIX=$(PREFIX)
endif
	touch $@
