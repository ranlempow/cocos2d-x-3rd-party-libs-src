# PHYSFS
PHYSFS_VERSION ?= 3.0.0
PHYSFS_URL ?= https://icculus.org/physfs/downloads/physfs-$(PHYSFS_VERSION).tar.bz2
$(eval PHYSFS_URL := $(PHYSFS_URL))

$(TARBALLS)/physfs-$(PHYSFS_VERSION).tar.bz2:
	$(call download,$(PHYSFS_URL))

.sum-physfs: physfs-$(PHYSFS_VERSION).tar.bz2

physfs: physfs-$(PHYSFS_VERSION).tar.bz2 .sum-physfs
	$(UNPACK)
	$(MOVE)

.physfs: physfs toolchain.cmake
	cd $< && $(HOSTVARS_PIC) $(CMAKE) \
		-DPHYSFS_BUILD_SHARED=OFF \
		-DOTHER_LDFLAGS="$(shell echo ${LDADD} | sed -e 's/\s/;/g')"
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
