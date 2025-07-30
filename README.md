# luci-app-ddnstox

## SDK 说明

GitHub Action 工作流默认使用 `openwrt-24.10` SDK 作为 opkg 包管理器产出物。

在 openwrt-22.03 或更旧的 OpenWrt LuCI 版本上安装会存在 `luci-lua-runtime` 依赖不足问题，
如需对其进行兼容处理可以更换为 `openwrt-22.03` SDK 进行编译。


```diff
--- a/.github/workflows/release-build.yml
+++ b/.github/workflows/release-build.yml
@@ -17,7 +17,7 @@ jobs:
           - arm_cortex-a9
           - x86_64
         sdk:
-          - openwrt-24.10
+          - openwrt-22.03
           - SNAPSHOT
 
     steps:
--- a/install_ddnstox.sh
+++ b/install_ddnstox.sh
@@ -27,7 +27,7 @@ if [ -x "/usr/bin/apk" ]; then
 elif command -v opkg >/dev/null 2>&1; then
     PKG_MANAGER="opkg"
     PKG_OPT="install --force-downgrade"
-    SDK="openwrt-24.10"
+    SDK="openwrt-22.03"
 else
     msg_red "No supported package manager found."
     exit 1

```