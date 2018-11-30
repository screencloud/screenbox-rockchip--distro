#!/bin/bash

set -e
METHOD=$1
CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	if [ -e $TOP_DIR/build.sh ] && [ ! -e $OUTPUT_DIR/.kernelmodules.done ];then
		export LDFLAGS="--sysroot=$SYSROOT"
		$TOP_DIR/build.sh modules
		touch $OUTPUT_DIR/.kernelmodules.done
	fi

	BT_TTY=ttyS0

	mkdir -p $TARGET_DIR/system/lib/modules
	mkdir -p $TARGET_DIR/system/etc/firmware
	$GCC $TOP_DIR/external/rkwifibt/src/rk_wifi_init.c -o $TARGET_DIR/usr/bin/rk_wifi_init
	$GCC $TOP_DIR/external/rkwifibt/brcm_tools/brcm_patchram_plus1.c -o $TARGET_DIR/usr/bin/brcm_patchram_plus1
	find $TOP_DIR/kernel/drivers/net/wireless/rockchip_wlan/*  -name "*.ko" | xargs -n1 -i cp {} $TARGET_DIR/system/lib/modules/
	install -m 0644 -D $TOP_DIR/external/rkwifibt/firmware/broadcom/all/WIFI_FIRMWARE/* $TARGET_DIR/system/etc/firmware/
	install -m 0644 -D $TOP_DIR/external/rkwifibt/firmware/broadcom/all/BT_FIRMWARE/* $TARGET_DIR/system/etc/firmware/
	install -m 0755 -D $TOP_DIR/external/rkwifibt/S66load_wifi_modules $TARGET_DIR/usr/bin/
	sed -i 's/BT_TTY_DEV/\/dev\/ttyS0/g' $TARGET_DIR/usr/bin/S66load_wifi_modules
	install -m 0644 -D $DISTRO_DIR/package/rkwifibt/wpa_supplicant.conf $TARGET_DIR/etc/wpa_supplicant.conf
	install -m 0644 -D $DISTRO_DIR/package/rkwifibt/dnsmasq.conf $TARGET_DIR/etc/dnsmasq.conf
	install -m 0755 -D $DISTRO_DIR/package/rkwifibt/wifi_start.sh $TARGET_DIR/usr/bin/
	install -m 0644 -D $DISTRO_DIR/package/rkwifibt/wifi-init.service $TARGET_DIR/lib/systemd/system/
else
	systemctl enable wifi-init.service
fi



