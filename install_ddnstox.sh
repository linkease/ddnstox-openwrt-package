#!/bin/sh

BASE_URL="https://down.cooluc.com/bin/ddnstox"

# Define color codes and output functions
RED='\033[1;31m'
GREEN='\033[1;32m'
RESET='\033[0m'

msg_red()   { printf "${RED}%b${RESET}\n" "$*"; }
msg_green() { printf "${GREEN}%b${RESET}\n" "$*"; }

msg_green "\nInstall luci-app-ddnstox"
msg_green "LuCI support for DDNSTOX\n"

# Check if running on OpenWrt
if [ ! -f /etc/openwrt_release ]; then
    msg_red "Unknown OpenWrt Version."
    exit 1
fi

# Detect package manager and set SDK version
if [ -x "/usr/bin/apk" ]; then
    PKG_MANAGER="apk"
    PKG_OPT="add --allow-untrusted"
    SDK="SNAPSHOT"
elif command -v opkg >/dev/null 2>&1; then
    PKG_MANAGER="opkg"
    PKG_OPT="install --force-downgrade"
    SDK="openwrt-22.03"
else
    msg_red "No supported package manager found."
    exit 1
fi

# Create temporary directory and set up cleanup on exit
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# Check if the current platform is supported
msg_green "Checking platform..."

DEVICES_ARCH="$(ldd --version 2>&1 | head -1 | awk -F'[()]' '{print $2}')"

SUPPORTED_ARCH="
aarch64
arm
x86_64
"
FOUND=0
for arch in $SUPPORTED_ARCH; do
    if [ "$DEVICES_ARCH" = "$arch" ]; then
        FOUND=1
        [ "$arch" = "arm" ] && PKG_ARCH="arm_cortex-a9"
        [ "$arch" = "aarch64" ] && PKG_ARCH="aarch64_generic"
        [ "$arch" = "x86_64" ] && PKG_ARCH="x86_64"
        break
    fi
done

if [ "$FOUND" -ne 1 ]; then
    msg_red "Error! The current \"$DEVICES_ARCH\" platform is not supported."
    exit 1
fi

# Download the corresponding package archive
PKG_FILE="$SDK-$PKG_ARCH.tar.gz"
PKG_URL="$BASE_URL/$PKG_FILE"

msg_green "Downloading $PKG_URL ..."
if ! curl --connect-timeout 5 -m 300 -kLo "$TEMP_DIR/$PKG_FILE" "$PKG_URL"; then
    msg_red "Download $PKG_FILE failed."
    exit 1
fi

# Stop ddnstox service
if [ -x "/etc/init.d/ddnstox" ]; then
    /etc/init.d/ddnstox stop || true
fi

# Extract and install packages
msg_green "\nInstalling Packages ..."
tar -zxf "$TEMP_DIR/$PKG_FILE" -C "$TEMP_DIR/"
for pkg in "$TEMP_DIR"/packages_ci/ddnstox*.* \
           "$TEMP_DIR"/packages_ci/luci-app-ddnstox*.* \
           "$TEMP_DIR"/packages_ci/luci-i18n-ddnstox-zh-cn*.*; do
    [ -f "$pkg" ] && $PKG_MANAGER $PKG_OPT $pkg
done

# Clean up temporary files and finish
rm -rf /tmp/luci-*

# Start ddnstox service
if [ -x "/etc/init.d/ddnstox" ]; then
    /etc/init.d/ddnstox start || true
fi

if [ -x "/usr/bin/ddnstox" ] && [ -f "/usr/lib/lua/luci/model/cbi/ddnstox.lua" ]; then
    msg_green "$(cat <<-'EOF'
  ____  ____  _   _ ____ _____ ___
  |  _ \|  _ \| \ | / ___|_   _/ _ \
  | | | | | | |  \| \___ \ | || | | |
  | |_| | |_| | |\  |___) || || |_| |
  |____/|____/|_| \_|____/ |_| \___/   ....is now installed!


  感谢使用 DDNSTOX，请登录 https://web.ddnsto.com 获取 Token 使用插件。
EOF
)"
else
    cat <<-'EOF'

    [40;37;1m█████████████████████████████████████[0m
    [40;37;1m█████████████████████████████████████[0m
    [40;37;1m████ ▄▄▄▄▄ █▀█▀█ █▄▀▀ ▄▄▀█ ▄▄▄▄▄ ████[0m
    [40;37;1m████ █   █ █▀▀▀█ ▀█▀ ▀▄█▀█ █   █ ████[0m
    [40;37;1m████ █▄▄▄█ █▀ ██▀▀ ▀▀▀ ▄ █ █▄▄▄█ ████[0m
    [40;37;1m████▄▄▄▄▄▄▄█▄▀ ▀ █ █▄█▄█▄█▄▄▄▄▄▄▄████[0m
    [40;37;1m████ ▄   ▀▄  ▄▀██▄▄▄▀ ▀▀  ▀▄▀▄█▄▀████[0m
    [40;37;1m████▄ █▄█ ▄▀▀█▄▄ █▄▄▀▄█▀▀▀ ▄█▀█▀█████[0m
    [40;37;1m████▀▄ ▀▀ ▄▄ ▄▄ ▀▄▀▄▀ ▀ ██▀▀▀▄▄█▀████[0m
    [40;37;1m█████▀█▀ ▀▄█▀▀██ █▀▄▄██▀▀█▀█▀▄▄▀█████[0m
    [40;37;1m████▀█▀▀  ▄▀▄ ▄▄▀ ▀█▀   ▀▀▀ ▀▄ █▀████[0m
    [40;37;1m████ ██▄█▀▄ ▄▄ █ ██▄ ▄██▄██ ██▄▀█████[0m
    [40;37;1m████▄███▄█▄█  ▄█▀▄▀██ ▀▄ ▄▄▄ ▀   ████[0m
    [40;37;1m████ ▄▄▄▄▄ █▄▄█▀▄▄█ ▀▄▄  █▄█ ▄▄██████[0m
    [40;37;1m████ █   █ █ ▀ ▀▄▄▀▄▀▄▀█▄▄▄▄▄▀ ▀ ████[0m
    [40;37;1m████ █▄▄▄█ █ █▀█▀▄█ ▄▄▀▀    ▄ ▄ █████[0m
    [40;37;1m████▄▄▄▄▄▄▄█▄█▄██▄███▄█▄███▄▄▄▄██████[0m
    [40;37;1m█████████████████████████████████████[0m
    [40;37;1m█████████████████████████████████████[0m
EOF

    msg_red "\n\n  安装失败，请检查网络连接或平台架构是否受支持。"
	msg_green "  如果问题持续，请使用微信扫码联系官方客服获取帮助。\n"
fi
