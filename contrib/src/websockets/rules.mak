# websockets

WEBSOCKETS_GITURL := https://github.com/warmcat/libwebsockets

$(TARBALLS)/libwebsockets-git.tar.xz:
	$(call download_git,$(WEBSOCKETS_GITURL),master,7355750)

.sum-websockets: libwebsockets-git.tar.xz
	$(warning $@ not implemented)
	touch $@

websockets: libwebsockets-git.tar.xz .sum-websockets
	$(UNPACK)
	$(APPLY) $(SRC)/websockets/remove-werror.patch
	$(MOVE)

ifdef HAVE_TIZEN
EX_ECFLAGS = -fPIC
endif


DEPS_websockets += zlib $(DEPS_zlib)
DEPS_websockets += openssl $(DEPS_openssl)

ifdef HAVE_TVOS
	make_option=-DLWS_WITHOUT_DAEMONIZE=1
endif

ifdef HAVE_WIN32
	make_option +=-DLWS_OPENSSL_LIBRARIES=$(PREFIX)/lib/libopenssl.a
	make_option +=-DLWS_OPENSSL_INCLUDE_DIRS=$(PREFIX)/include
endif

.websockets: websockets .zlib .openssl toolchain.cmake
	cd $< && $(HOSTVARS) CFLAGS="$(CFLAGS) $(EX_ECFLAGS)" $(CMAKE) -DLWS_WITH_SSL=1 -DLWS_WITHOUT_SERVER=1 -DLWS_WITH_SHARED=0 -DLWS_WITHOUT_TEST_SERVER=1 -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=1 -DLWS_WITHOUT_TEST_PING=1 -DLWS_WITHOUT_TEST_ECHO=1 -DLWS_WITHOUT_TEST_FRAGGLE=1 -DLWS_IPV6=1 $(make_option)
	cd $< && $(MAKE) VERBOSE=1 install
	touch $@
