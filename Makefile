############################################################################
# apps/external/mbedtls/Makefile
#
#   Copyright 2018 Sony Video & Sound Products Inc.
#   Author: Masayuki Ishikawa <Masayuki.Ishikawa@jp.sony.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name NuttX nor the names of its contributors may be
#    used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
############################################################################

-include $(TOPDIR)/.config
-include $(TOPDIR)/Make.defs
include $(APPDIR)/Make.defs

CFLAGS	+= -I ./include -D__unix__ -DNUTTX

ASRCS	=
CSRCS	=

ifeq ($(CONFIG_EXTERNAL_MBEDTLS),y)
CSRCS += library/aes.c
CSRCS += library/aesni.c
CSRCS += library/arc4.c
CSRCS += library/asn1parse.c
CSRCS += library/asn1write.c
CSRCS += library/base64.c
CSRCS += library/bignum.c
CSRCS += library/blowfish.c
CSRCS += library/camellia.c
CSRCS += library/ccm.c
CSRCS += library/certs.c
CSRCS += library/cipher.c
CSRCS += library/cipher_wrap.c
CSRCS += library/cmac.c
CSRCS += library/ctr_drbg.c
CSRCS += library/debug.c
CSRCS += library/des.c
CSRCS += library/dhm.c
CSRCS += library/ecdh.c
CSRCS += library/ecdsa.c
CSRCS += library/ecjpake.c
CSRCS += library/ecp.c
CSRCS += library/ecp_curves.c
CSRCS += library/entropy.c
CSRCS += library/entropy_poll.c
CSRCS += library/error.c
CSRCS += library/gcm.c
CSRCS += library/havege.c
CSRCS += library/hmac_drbg.c
CSRCS += library/md2.c
CSRCS += library/md4.c
CSRCS += library/md5.c
CSRCS += library/md.c
CSRCS += library/md_wrap.c
CSRCS += library/memory_buffer_alloc.c
CSRCS += library/net_sockets.c
CSRCS += library/oid.c
CSRCS += library/padlock.c
CSRCS += library/pem.c
CSRCS += library/pk.c
CSRCS += library/pkcs11.c
CSRCS += library/pkcs12.c
CSRCS += library/pkcs5.c
CSRCS += library/pkparse.c
CSRCS += library/pk_wrap.c
CSRCS += library/pkwrite.c
CSRCS += library/platform.c
CSRCS += library/platform_util.c
CSRCS += library/ripemd160.c
CSRCS += library/rsa.c
CSRCS += library/rsa_internal.c
CSRCS += library/sha1.c
CSRCS += library/sha256.c
CSRCS += library/sha512.c
CSRCS += library/ssl_cache.c
CSRCS += library/ssl_ciphersuites.c
CSRCS += library/ssl_cli.c
CSRCS += library/ssl_cookie.c
CSRCS += library/ssl_srv.c
CSRCS += library/ssl_ticket.c
CSRCS += library/ssl_tls.c
CSRCS += library/threading.c
CSRCS += library/timing.c
CSRCS += library/version.c
CSRCS += library/version_features.c
CSRCS += library/x509.c
CSRCS += library/x509_create.c
CSRCS += library/x509_crl.c
CSRCS += library/x509_crt.c
CSRCS += library/x509_csr.c
CSRCS += library/x509write_crt.c
CSRCS += library/x509write_csr.c
CSRCS += library/xtea.c
endif

AOBJS = $(ASRCS:.S=$(OBJEXT))
COBJS = $(CSRCS:.c=$(OBJEXT))

SRCS  = $(ASRCS) $(CSRCS)
OBJS  = $(AOBJS) $(COBJS)

ifeq ($(CONFIG_WINDOWS_NATIVE),y)
  BIN = $(TOPDIR)\staging\libmbedtls$(LIBEXT)
else
ifeq ($(WINTOOL),y)
  BIN = $(TOPDIR)\\staging\\libmbedtls$(LIBEXT)
else
  BIN = $(TOPDIR)/staging/libmbedtls$(LIBEXT)
endif
endif

ROOTDEPPATH = --dep-path .

# Common build

VPATH =

all: .built
.PHONY: context depend clean distclean preconfig
.PRECIOUS: $(TOPDIR)/staging/libmbedtls$(LIBEXT)

$(AOBJS): %$(OBJEXT): %.S
	$(call ASSEMBLE, $<, $@)

$(COBJS): %$(OBJEXT): %.c
	$(call COMPILE, $<, $@)

.built: $(OBJS)
	$(call ARCHIVE, $(BIN), $(OBJS))
	$(Q) touch .built

install:

context:

.depend: Makefile $(SRCS)
	$(Q) $(MKDEP) $(ROOTDEPPATH) "$(CC)" -- $(CFLAGS) -- $(SRCS) >Make.dep
	$(Q) touch $@

depend: .depend

clean:
	$(call DELFILE, .built)
	$(call CLEAN)

distclean: clean
	$(call DELFILE, Make.dep)
	$(call DELFILE, .depend)

preconfig:

-include Make.dep
