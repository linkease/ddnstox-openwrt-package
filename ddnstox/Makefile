#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ddnstox
PKG_VERSION:=4.0.0
PKG_RELEASE=1

PKG_SOURCE:=ddnsto-custom-binary-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://fw0.koolcenter.com/binary/ddnsto/op_custom
PKG_HASH:=fb15d35677ab2e30f25d8eb8e8380daaf40d72b178d39751510ac0d39d60d027

PKG_BUILD_DIR:=$(BUILD_DIR)/ddnsto-custom-binary-$(PKG_VERSION)

PKG_LICENSE:=
PKG_LICENSE_FILE:=
PKG_MAINTAINER:=sbwml <admin@cooluc.com>

include $(INCLUDE_DIR)/package.mk

define Package/ddnstox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DDNSTOX
  URL:=https://web.ddnsto.com
  DEPENDS:=@(arm||aarch64||x86_64) +ca-bundle
endef

define Package/ddnstox/description
  DDNSTO is a stable, fast, and user-friendly intranet penetration tool.
endef

define Package/ddnstox/conffiles
/etc/config/ddnstox
endef

define Build/Compile
endef

define Package/ddnstox/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/config $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ddnstox.init $(1)/etc/init.d/ddnstox
	$(INSTALL_CONF) ./files/ddnstox.config $(1)/etc/config/ddnstox
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ddnstox-custom.$(ARCH) $(1)/usr/bin/ddnstox
endef

$(eval $(call BuildPackage,ddnstox))
