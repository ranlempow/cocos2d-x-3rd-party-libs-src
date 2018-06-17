# ARCHIVE

ARCHIVE_VERSION ?= 3.3.2
ARCHIVE_URL ?= https://www.libarchive.org/downloads/libarchive-$(ARCHIVE_VERSION).tar.gz
$(eval ARCHIVE_URL := $(ARCHIVE_URL))

$(TARBALLS)/libarchive-$(ARCHIVE_VERSION).tar.gz:
	$(call download,$(ARCHIVE_URL))

.sum-archive: libarchive-$(ARCHIVE_VERSION).tar.gz

ifdef HAVE_CROSS_COMPILE
ARCHIVE_CONFIG_VARS=CHOST=$(HOST)
endif

archive: libarchive-$(ARCHIVE_VERSION).tar.gz .sum-archive
	$(UNPACK)
	mv $(UNPACK_DIR)/contrib/android/include/android_lf.h $(UNPACK_DIR)/libarchive
	$(APPLY) $(SRC)/archive/andriod_19.patch
	$(MOVE)

DEPS_archive += zlib $(DEPS_zlib)
DEPS_archive += openssl $(DEPS_openssl)

.archive: archive .zlib .openssl
	cd $< && $(HOSTVARS) ./Configure $(HOSTCONF) --disable-largefile --disable-bsdtar --disable-bsdcat --disable-bsdcpio
	cd $< && $(MAKE) V=1 install
	touch $@
