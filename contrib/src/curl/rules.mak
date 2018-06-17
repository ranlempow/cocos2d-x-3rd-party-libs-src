# curl

CURL_VERSION ?= 7.52.1
CURL_URL ?= http://curl.haxx.se/download/curl-$(CURL_VERSION).tar.gz
$(eval CURL_URL := $(CURL_URL))

$(TARBALLS)/curl-$(CURL_VERSION).tar.gz:
	$(call download,$(CURL_URL))

.sum-curl: curl-$(CURL_VERSION).tar.gz

curl: curl-$(CURL_VERSION).tar.gz .sum-curl
	$(UNPACK)
	$(UPDATE_AUTOCONFIG)
	$(MOVE)

DEPS_curl += zlib $(DEPS_zlib)
DEPS_curl += openssl $(DEPS_openssl)

configure_option+= \
--disable-ntlm-wb \
--disable-ftp \
--enable-ldap \
--disable-ldaps \
--disable-dict \
--disable-telnet \
--disable-tftp \
--disable-pop3 \
--disable-imap \
--disable-smb \
--disable-smtp \
--disable-gopher \
--without-libssh2 \
--without-libidn \
--without-nghttp2

ifdef HAVE_LINUX
configure_option+=--without-librtmp
endif

ifdef HAVE_TVOS
configure_option+=--disable-ntlm-wb
endif

EXTRA_CURL_LIBS=
ifdef HAVE_WIN32
EXTRA_CURL_LIBS=LIBS=-lcrypt32
endif

.curl: curl .zlib .openssl
	$(RECONF)
	cd $< && $(HOSTVARS_PIC) $(EXTRA_CURL_LIBS) ./configure $(HOSTCONF) \
		--with-ssl=$(PREFIX) \
		--with-zlib=$(PREFIX)/lib \
		--enable-ipv6 \
		--disable-ldap \
		$(configure_option)

	cd $< && $(MAKE) install
	touch $@
