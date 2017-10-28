# ogg
OGG_VERSION ?= 1.3.2
OGG_URL ?= http://downloads.xiph.org/releases/ogg/libogg-$(OGG_VERSION).tar.gz
$(eval OGG_URL := $(OGG_URL))

$(TARBALLS)/libogg-$(OGG_VERSION).tar.gz:
	$(call download,$(OGG_URL))

.sum-ogg: libogg-$(OGG_VERSION).tar.gz

ogg: libogg-$(OGG_VERSION).tar.gz .sum-ogg
	$(UNPACK)
	$(MOVE)

.ogg: ogg
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) V=1 install
	touch $@
