# GLFM
GLFM_VERSION ?= 0.8.1
GLFM_URL ?= $(GITHUB)/brackeen/glfm/archive/$(GLFM_VERSION).tar.gz
$(eval GLFM_URL := $(GLFM_URL))

$(TARBALLS)/$(GLFM_VERSION).tar.gz:
	$(call download,$(GLFM_URL))

.sum-glfm: $(GLFM_VERSION).tar.gz

glfm: $(GLFM_VERSION).tar.gz .sum-glfm
	$(UNPACK)
	mv glfm-$(GLFM_VERSION) $(GLFM_VERSION) 
	$(APPLY) $(SRC)/glfm/support_c99_0.8.1.patch
	$(APPLY) $(SRC)/glfm/make_install_0.8.1.patch
	$(APPLY) $(SRC)/glfm/no-android-runtime.patch
	$(MOVE)

.glfm: glfm toolchain.cmake
	cd $< && $(HOSTVARS_PIC) $(CMAKE)
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
