#!/bin/sh

echo > .config

cat nss-setup/config-nss.seed |  grep -v CONFIG_PACKAGE_luci >> .config
echo "
CONFIG_TARGET_qualcommax_ipq807x_DEVICE_linksys_mx4300=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_batctl-default=y
CONFIG_PACKAGE_kmod-batman-adv=y
CONFIG_BATMAN_ADV_BATMAN_V=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_MCAST=y
CONFIG_PACKAGE_luci-proto-batman-adv=y
CONFIG_PACKAGE_luci-app-sqm=y
CONFIG_PACKAGE_luci-app-watchcat=y
CONFIG_PACKAGE_collectd-mod-thermal=y
CONFIG_PACKAGE_luci-app-statistics=y
CONFIG_PACKAGE_kmod-nf-conntrack-netlink=y
CONFIG_PACKAGE_luci-app-nlbwmon=y
CONFIG_PACKAGE_px5g-standalone=y
CONFIG_PACKAGE_luci-app-uhttpd=y
CONFIG_PACKAGE_luci-app-advanced-reboot=y
CONFIG_FEED_nss_packages=n" >> .config
make defconfig

if [ "$1" = "full" ]; then
    kmods=$(wget -qO- https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/packages/Packages.manifest | grep "Package: kmod"  | grep -v ath | grep -v kmod-bonding | grep -v vxlan | grep -v kmod-nat46 | cut -d ' ' -f 2)
    for k in $kmods; do grep -q $k=y .config || echo CONFIG_PACKAGE_$k=m >> .config; done
    make defconfig
fi
