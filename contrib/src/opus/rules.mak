# opus
OPUS_VERSION ?= 1.2.1
OPUS_URL ?= https://archive.mozilla.org/pub/opus/opus-$(OPUS_VERSION).tar.gz
$(eval OPUS_URL := $(OPUS_URL))

$(TARBALLS)/opus-$(OPUS_VERSION).tar.gz:
	$(call download,$(OPUS_URL))

.sum-opus: opus-$(OPUS_VERSION).tar.gz

opus: opus-$(OPUS_VERSION).tar.gz .sum-opus
	$(UNPACK)
	$(MOVE)

.opus: opus
	$(RECONF)
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF)
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
