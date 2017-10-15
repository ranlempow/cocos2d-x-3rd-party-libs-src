# OPENAL
OPENAL_VERSION := 1.17.2
OPENAL_URL := http://kcat.strangesoft.net/openal-releases/openal-soft-$(OPENAL_VERSION).tar.bz2


$(TARBALLS)/openal-soft-$(OPENAL_VERSION).tar.bz2:
	$(call download,$(OPENAL_URL))

.sum-openal: openal-soft-$(OPENAL_VERSION).tar.bz2

openal: openal-soft-$(OPENAL_VERSION).tar.bz2 .sum-openal
	$(UNPACK)
	$(MOVE)

.openal: openal toolchain.cmake
	cd $< && $(HOSTVARS) $(CMAKE) -DLIBTYPE=STATIC
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
