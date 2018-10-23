#!/bin/bash

BT_TTY=ttyS0

mkdir -p /system/lib/modules
mkdir -p /system/etc/firmware
gcc /sdk/external/rkwifibt/src/rk_wifi_init.c -o /usr/bin/rk_wifi_init
if [ $? -ne 0 ]; then
	exit 1
fi
gcc /sdk/external/rkwifibt/brcm_tools/brcm_patchram_plus1.c -o /usr/bin/brcm_patchram_plus1
if [ $? -ne 0 ]; then
	exit 1
fi
#source /sdk/device/rockchip/.BoardConfig.mk
#make -C /sdk/kernel ARCH=$RK_ARCH CROSS_COMPILE=/usr/bin/aarch64-linux-gnu- $RK_KERNEL_DEFCONFIG
#make -C /sdk/kernel ARCH=$RK_ARCH CROSS_COMPILE=/usr/bin/aarch64-linux-gnu- modules -j4
find /sdk/kernel/drivers/net/wireless/rockchip_wlan/*  -name "*.ko" | xargs -n1 -i cp {} /system/lib/modules/
if [ $? -ne 0 ]; then
	exit 1
fi
install -m 0644 -D /sdk/external/rkwifibt/firmware/broadcom/all/WIFI_FIRMWARE/* /system/etc/firmware/
install -m 0644 -D /sdk/external/rkwifibt/firmware/broadcom/all/BT_FIRMWARE/* /system/etc/firmware/
install -m 0755 -D /sdk/external/rkwifibt/S66load_wifi_modules /etc/init.d/
install -m 0644 -D /sdk/distro/package/rkwifibt/wpa_supplicant.conf /etc/wpa_supplicant.conf
install -m 0644 -D /sdk/distro/package/rkwifibt/dnsmasq.conf /etc/dnsmasq.conf
install -m 0755 -D /sdk/distro/package/rkwifibt/wifi_start.sh /usr/bin/
sed -i 's/BT_TTY_DEV/\/dev\/ttyS0/g' /etc/init.d/S66load_wifi_modules

if [ $? -ne 0 ]; then
	exit 1
fi
