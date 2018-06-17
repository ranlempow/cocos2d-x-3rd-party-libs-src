# ALURE2

ALURE2_GITURL := http://repo.or.cz/alure.git

$(TARBALLS)/alure2-git.tar.xz:
	$(call download_git,$(ALURE_GITURL),master,2cb361e)

.sum-alure2: alure2-git.tar.xz
	$(warning $@ not implemented)
	touch $@


alure2: alure2-git.tar.xz .sum-alure2
	$(UNPACK)
	$(MOVE)

DEPS_alure2 = openal $(DEPS_openal)
DEPS_alure2 = opus $(DEPS_opus)
DEPS_alure2 = physfs $(DEPS_physfs)
DEPS_alure2 = flac $(DEPS_flac)


.alure2: alure2 toolchain.cmake .openal .opus .physfs .flac 
ifdef HAVE_WIN32
	cd $< && $(HOSTVARS) $(CMAKE)
else
	cd $< && $(HOSTVARS_PIC) $(CMAKE)
endif
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
