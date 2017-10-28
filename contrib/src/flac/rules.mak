# FLAC
FLAC_VERSION ?= 1.3.2
FLAC_URL ?= https://ftp.osuosl.org/pub/xiph/releases/flac/flac-$(FLAC_VERSION).tar.xz
$(eval FLAC_URL := $(FLAC_URL))

$(TARBALLS)/flac-$(FLAC_VERSION).tar.xz:
	$(call download,$(FLAC_URL))

.sum-flac: flac-$(FLAC_VERSION).tar.xz

flac: flac-$(FLAC_VERSION).tar.xz .sum-flac
	$(UNPACK)
	$(APPLY) $(SRC)/flac/option_FLAC_LDADD.patch
	$(MOVE)

DEPS_flac = ogg $(DEPS_ogg)

.flac: flac .ogg
	$(RECONF)
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF) FLAC_LDADD="$(LDADD)"
	cd $< && $(MAKE) V=1 install
	touch $@
