# voribs
VORBIS_VERSION ?= 1.3.5
VORBIS_URL ?= http://downloads.xiph.org/releases/vorbis/libvorbis-$(VORBIS_VERSION).tar.gz
$(eval VORBIS_URL := $(VORBIS_URL))

$(TARBALLS)/libvorbis-$(VORBIS_VERSION).tar.gz:
	$(call download,$(VORBIS_URL))

.sum-vorbis: libvorbis-$(VORBIS_VERSION).tar.gz

vorbis: libvorbis-$(VORBIS_VERSION).tar.gz .sum-vorbis
	$(UNPACK)
	$(MOVE)

DEPS_vorbis = ogg $(DEPS_ogg)

.vorbis: vorbis .ogg
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) V=1 install
	touch $@
