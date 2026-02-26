#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 修改默认IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
# 修改默认主机名
sed -i 's/LEDE/H29K/g' package/base-files/files/bin/config_generate
sed -i 's/LEDE/H29K/g' package/base-files/luci2/bin/config_generate

# 修改 WiFi 名称（SSID）从 LEDE → H29K
sed -i 's/set wireless.default_radio${devidx}.ssid=LEDE/set wireless.default_radio${devidx}.ssid=H29K/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改加密方式 (none → psk2)
sed -i 's/set wireless.default_radio${devidx}.encryption=none/set wireless.default_radio${devidx}.encryption=psk2/' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 在加密行后新增密码行 (确保格式对齐)
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a \\t\tset wireless.default_radio${devidx}.key=11235813' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 替换时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
if ! grep -q "zonename=" package/base-files/files/bin/config_generate; then
    sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
else
    sed -i "s/zonename='.*'/zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
fi

# 替换ntp服务器
sed -i 's/0.openwrt.pool.ntp.org/ntp.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/1.openwrt.pool.ntp.org/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/2.openwrt.pool.ntp.org/ntp.ntsc.ac.cn/g' package/base-files/files/bin/config_generate
sed -i 's/3.openwrt.pool.ntp.org/cn.ntp.org.cn/g' package/base-files/files/bin/config_generate

# 默认 shell 为 bash
sed -i 's/\/bin\/ash/\/bin\/bash/g' package/base-files/files/etc/passwd

## samba设置
# enable multi-channel

# sed -i '/workgroup/a \\n\t## enable multi-channel' feeds/packages/net/samba4/files/smb.conf.template
# sed -i '/enable multi-channel/a \\tserver multi channel support = yes' feeds/packages/net/samba4/files/smb.conf.template

# default config
# sed -i 's/#aio read size = 0/aio read size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
# sed -i 's/#aio write size = 0/aio write size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
# sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template
# sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' feeds/packages/net/samba4/files/smb.conf.template
# sed -i 's/#create mask/create mask/g' feeds/packages/net/samba4/files/smb.conf.template
# sed -i 's/#directory mask/directory mask/g' feeds/packages/net/samba4/files/smb.conf.template
# sed -i 's/0666/0644/g;s/0744/0755/g;s/0777/0755/g' feeds/luci/applications/luci-app-samba4/htdocs/luci-static/resources/view/samba4.js
# sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/samba.config
# sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/smb.conf.template

# 最大连接数修改为65535
sed -i '$a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 显示增加编译时间
# if [ "${REPO_BRANCH#*-}" = "23.05" ]; then
#    sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION=\"LEDE R$(TZ=UTC-8 date +'%y.%-m.%-d') (By @aaaol build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"/g"  package/base-files/files/etc/openwrt_release
#    echo -e "\e[41m当前写入的编译时间:\e[0m \e[33m$(grep 'DISTRIB_DESCRIPTION' package/base-files/files/etc/openwrt_release)\e[0m"
# else
#    sed -i "s/DISTRIB_DESCRIPTION=.*/DISTRIB_DESCRIPTION=\"LEDE By @aaaol\"/g"  package/base-files/files/etc/openwrt_release
#    sed -i "s/OPENWRT_RELEASE=.*/OPENWRT_RELEASE=\"LEDE R$(TZ=UTC-8 date +'%y.%-m.%-d') (By @aaaol build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"/g"  package/base-files/files/usr/lib/os-release
#    echo -e "\e[41m当前写入的编译时间:\e[0m \e[33m$(grep 'OPENWRT_RELEASE' package/base-files/files/usr/lib/os-release)\e[0m"
# fi

sed -i "s|DISTRIB_DESCRIPTION=.*|DISTRIB_DESCRIPTION=\"LEDE R$(TZ=UTC-8 date +'%y.%m.%d') (By @aaaol build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"|g" package/base-files/files/etc/openwrt_release
sed -i "s|OPENWRT_RELEASE=.*|OPENWRT_RELEASE=\"LEDE R$(TZ=UTC-8 date +'%y.%m.%d') (By @aaaol build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"|g" package/base-files/files/usr/lib/os-release


# 固件更新地址
sed -i '/CPU usage/a\                <tr><td width="33\%"><\%:Compile update\%></td><td><a target="_blank" href="https://github.com/aaaol/OpenWrt/releases">👇查看</a></td></tr>' package/lean/autocore/files/arm/index.htm
sed -i '/CPU usage/a\                <tr><td width="33%\"><%:Compile update%></td><td><a target="_blank" href="https://github.com/aaaol/OpenWrt/releases">👇查看</a></td></tr>' package/lean/autocore/files/arm/index.htm

echo "========================="
echo " DIY2 配置完成……"
