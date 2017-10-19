# GLM
GLM_VERSION ?= 0.9.8.5
GLM_URL ?= $(GITHUB)/g-truc/glm/releases/download/$(GLM_VERSION)/glm-$(GLM_VERSION).zip
$(eval GLM_URL := $(GLM_URL))

$(TARBALLS)/glm-$(GLM_VERSION).zip:
	$(call download,$(GLM_URL))

.sum-glm: glm-$(GLM_VERSION).zip

glm: glm-$(GLM_VERSION).zip .sum-glm
	$(UNPACK)

.glm: glm toolchain.cmake
	cd $< && $(HOSTVARS) $(CMAKE)
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
