#!/bin/sh

cat nss-setup/config-nss.seed |  grep -v luci- > .config
echo  CONFIG_FEED_nss_packages=n >> .config
echo  CONFIG_PACKAGE_batctl-default=y >> .config
echo  CONFIG_PACKAGE_kmod-batman-adv=y >> .config
echo  CONFIG_PACKAGE_luci-proto-batman-adv=y >> .config
echo  CONFIG_PACKAGE_kmod-nf-conntrack-netlink=y >> .config
echo  CONFIG_PACKAGE_luci-app-nlbwmon=y >> .config
echo  CONFIG_PACKAGE_collectd-mod-thermal=y >> .config
echo  CONFIG_PACKAGE_luci-app-statistics=y >> .config
echo  CONFIG_PACKAGE_luci-app-sqm=y >> .config
echo  CONFIG_PACKAGE_px5g-standalone=y >> .config
echo  CONFIG_PACKAGE_luci-app-uhttpd=y >> .config
echo  CONFIG_PACKAGE_luci-app-advanced-reboot=y >> .config
echo  CONFIG_PACKAGE_block-mount=y >> .config
make defconfig


if [ "$1" = "full" ]; then
    kmods=$(wget -qO- https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/packages/Packages.manifest | grep "Package: kmod"  | grep -v ath | cut -d ' ' -f 2)
    for k in $kmods; do grep -q $k=y .config || echo CONFIG_PACKAGE_$k=m >> .config; done
    make defconfig
fi

