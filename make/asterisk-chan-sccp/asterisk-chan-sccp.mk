$(call PKG_INIT_BIN, 4681)
$(PKG)_NAME_NO_HYPHEN:=$(subst -,,$(pkg))
$(PKG)_SOURCE:=$($(PKG)_NAME_NO_HYPHEN)-$($(PKG)_VERSION).tar.xz
$(PKG)_SITE:=svn@https://svn.code.sf.net/p/chan-sccp-b/code/trunk

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/$($(PKG)_NAME_NO_HYPHEN)-$($(PKG)_VERSION)

$(PKG)_BINARY := $($(PKG)_DIR)/src/.libs/chan_sccp.so
$(PKG)_BINARY_TARGET := $($(PKG)_DEST_DIR)$(ASTERISK_MODULES_DIR)/chan_sccp.so

$(PKG)_CONFIG := $($(PKG)_DIR)/conf/sccp.conf
$(PKG)_CONFIG_TARGET := $($(PKG)_DEST_DIR)$(ASTERISK_CONFIG_DIR)/sccp.conf

$(PKG)_BUILD_PREREQ += autoreconf

$(PKG)_DEPENDS_ON := asterisk

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_ASTERISK_LOWMEMORY

$(PKG)_CONFIGURE_PRE_CMDS += autoreconf -f -i;
# add EXTRA_(C|LD)FLAGS
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;

$(PKG)_CONFIGURE_ENV += SCCP_REVISION=$(ASTERISK_CHAN_SCCP_VERSION)

$(PKG)_CONFIGURE_OPTIONS += --with-asterisk=$(ASTERISK_INSTALL_DIR_ABSOLUTE)/usr
$(PKG)_CONFIGURE_OPTIONS += --sysconfdir=/mod/etc

$(PKG)_EXTRA_CFLAGS += $(if $(FREETZ_PACKAGE_ASTERISK_LOWMEMORY),-DLOW_MEMORY)

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(ASTERISK_CHAN_SCCP_DIR) \
		EXTRA_CFLAGS="$(ASTERISK_CHAN_SCCP_EXTRA_CFLAGS)"

$($(PKG)_CONFIG): $($(PKG)_DIR)/.configured
	touch $@

$($(PKG)_BINARY_TARGET): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_CONFIG_TARGET): $($(PKG)_CONFIG)
	$(INSTALL_FILE)

$(pkg):

$(pkg)-precompiled: $($(PKG)_BINARY_TARGET) #$($(PKG)_CONFIG_TARGET)

$(pkg)-clean:
	-$(SUBMAKE) -C $(ASTERISK_CHAN_SCCP_DIR) clean

$(pkg)-uninstall:
	$(RM) $(ASTERISK_CHAN_SCCP_BINARY_TARGET) $(ASTERISK_CHAN_SCCP_CONFIG_TARGET)

$(PKG_FINISH)
