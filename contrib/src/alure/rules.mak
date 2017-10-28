# ALURE
ALURE_VERSION ?= 1.2
ALURE_URL ?= http://kcat.strangesoft.net/alure-releases/alure-$(ALURE_VERSION).tar.gz
$(eval ALURE_URL := $(ALURE_URL))

$(TARBALLS)/alure-$(ALURE_VERSION).tar.gz:
	$(call download,$(ALURE_URL))

.sum-alure: alure-$(ALURE_VERSION).tar.gz

alure: alure-$(ALURE_VERSION).tar.gz .sum-alure
	$(UNPACK)
	$(APPLY) $(SRC)/alure/no-stdcpp.patch
	$(APPLY) $(SRC)/alure/fix_extra_libs.patch
	$(APPLY) $(SRC)/alure/example_program_install_as_target.patch
	$(MOVE)

space := $()

DEPS_alure += openal $(DEPS_openal)
DEPS_alure += flac $(DEPS_flac)
DEPS_alure += vorbis $(DEPS_vorbis)

ifdef HAVE_ANDROID
ALURE_LDADD += OpenSLES
endif

.alure: alure toolchain.cmake
	cd $< && $(HOSTVARS_PIC) CXXFLAGS="$(CXXFLAGS) -Wno-deprecated-declarations" $(CMAKE) \
		-DDYNLOAD=OFF -DBUILD_SHARED=OFF \
		-DEXTRA_LIBS="$(shell echo "${LDADD} ${ALURE_LDADD}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | sed -e 's/\s/;/g')"
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
