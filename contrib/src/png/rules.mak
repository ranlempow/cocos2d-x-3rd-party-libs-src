# PNG
PNG_VERSION ?= 1.6.16
PNG_URL ?= $(SF)/libpng/libpng16/older-releases/$(PNG_VERSION)/libpng-$(PNG_VERSION).tar.xz
$(eval PNG_URL := $(PNG_URL))


$(TARBALLS)/libpng-$(PNG_VERSION).tar.xz:
	$(call download,$(PNG_URL))

.sum-png: libpng-$(PNG_VERSION).tar.xz


png: libpng-$(PNG_VERSION).tar.xz .sum-png
	$(UNPACK)
	$(MOVE)

DEPS_png = zlib $(DEPS_zlib)

.png: png
	$(RECONF)
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) install
	touch $@
