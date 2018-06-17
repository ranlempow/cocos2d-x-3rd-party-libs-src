# cmocka
CMOCKA_VERSION ?= 1.1.1
CMOCKA_URL ?= https://cmocka.org/files/1.1/cmocka-$(CMOCKA_VERSION).tar.xz
$(eval CMOCKA_URL := $(CMOCKA_URL))

$(TARBALLS)/cmocka-$(CMOCKA_VERSION).tar.xz:
	$(call download,$(CMOCKA_URL))

.sum-cmocka: cmocka-$(CMOCKA_VERSION).tar.xz

cmocka: cmocka-$(CMOCKA_VERSION).tar.xz .sum-cmocka
	$(UNPACK)
	$(MOVE)
    
CMOCKA_CMAKE := $(CMAKE_EXEC) .. -DCMAKE_INSTALL_PREFIX=$(PREFIX)
ifdef HAVE_CROSS_COMPILE
CMOCKA_CMAKE := $(CMOCKA_CMAKE) -DCMAKE_TOOLCHAIN_FILE=$(abspath toolchain.cmake)
endif

#-DCMAKE_SYSTEM_NAME=Android
.cmocka: cmocka toolchain.cmake
	mkdir -p $</build
	cd $</build && $(HOSTVARS_PIC) $(CMOCKA_CMAKE)
	cd $</build && $(MAKE) VERBOSE=1 install
	touch $@
