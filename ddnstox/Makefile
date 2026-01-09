#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk
PKG_ARCH_DDNSTO:=$(ARCH)
PKG_NAME:=ddnsto
PKG_VERSION:=4.0.1
PKG_RELEASE=1

PKG_SOURCE:=$(PKG_NAME)-binary-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://fw.koolcenter.com/binary/ddnsto/beta/
PKG_HASH:=605bce67109e402711fb6689e79f090a472f371084c2b3b8111526fee8adb767

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-binary-$(PKG_VERSION)

PKG_LICENSE:=
PKG_LICENSE_FILE:=
PKG_MAINTAINER:=sbwml <admin@cooluc.com>

include $(INCLUDE_DIR)/package.mk

define Package/ddnsto
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DDNSTO
  URL:=https://web.ddnsto.com
  DEPENDS:=@(arm||aarch64||x86_64) +ca-bundle
endef

define Package/$(PKG_NAME)/description
  DDNSTO is a stable, fast, and user-friendly intranet penetration tool.
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/ddnsto
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	[ -f /etc/uci-defaults/ddnsto ] && /etc/uci-defaults/ddnsto && rm -f /etc/uci-defaults/ddnsto
	exit 0
fi
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/config $(1)/etc/init.d $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ddnsto.$(PKG_ARCH_DDNSTO) $(1)/usr/sbin/ddnstod
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ddwebdav.$(PKG_ARCH_DDNSTO) $(1)/usr/sbin/ddwebdav
	$(INSTALL_CONF) ./files/ddnsto.config $(1)/etc/config/ddnsto
	$(INSTALL_BIN) ./files/ddnsto.init $(1)/etc/init.d/ddnsto
	$(INSTALL_BIN) ./files/ddnsto.uci-default $(1)/etc/uci-defaults/ddnsto
	$(LN) /usr/sbin/ddnstod $(1)/usr/sbin/ddnsto
endef
