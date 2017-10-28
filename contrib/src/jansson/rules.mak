# jansson
JANSSON_VERSION ?= 2.10
JANSSON_URL ?= https://github.com/akheron/jansson/archive/v$(JANSSON_VERSION).tar.gz
$(eval JANSSON_URL := $(JANSSON_URL))

$(TARBALLS)/v$(JANSSON_VERSION).tar.gz:
	$(call download,$(JANSSON_URL))

.sum-jansson: v$(JANSSON_VERSION).tar.gz

jansson: v$(JANSSON_VERSION).tar.gz .sum-jansson
	$(UNPACK)
	mv jansson-$(JANSSON_VERSION) jansson && touch jansson

.jansson: jansson
	$(RECONF)
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) V=1 install
	touch $@
