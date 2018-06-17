# aklomp/base64

BASE64_VERSION ?= 0.3.0
BASE64_URL ?= $(GITHUB)/aklomp/base64/archive/v$(BASE64_VERSION).tar.gz
$(eval BASE64_URL := $(BASE64_URL))

$(TARBALLS)/v$(BASE64_VERSION).tar.gz:
	$(call download,$(BASE64_URL))

.sum-base64: v$(BASE64_VERSION).tar.gz

base64: v$(BASE64_VERSION).tar.gz .sum-base64
	$(UNPACK)
	mv base64-$(BASE64_VERSION) base64 && touch base64

.base64: base64
	cd $< && $(HOSTVARS_PIC) $(MAKE)
	touch $@