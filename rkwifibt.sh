#!/bin/bash

SCRIPT_ROOT=$(dirname $(readlink -f "$0"))
source $SCRIPT_ROOT/../device/rockchip/.BoardConfig.mk
TARGET_ARCH=$RK_ARCH

if [ -e $SCRIPT_ROOT/overlay-wifi ]; then
    rm -rf $SCRIPT_ROOT/overlay-wifi
fi

mkdir $SCRIPT_ROOT/overlay-wifi

if [ $TARGET_ARCH == "arm64" ]; then
    CROSS_COMPILE=$SCRIPT_ROOT/../prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
else
    CROSS_COMPILE=$SCRIPT_ROOT/../prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- 
fi

${CROSS_COMPILE}gcc -o $SCRIPT_ROOT/../external/rkwifibt/src/rk_wifi_init $SCRIPT_ROOT/../external/rkwifibt/src/rk_wifi_init.c

mkdir -p $SCRIPT_ROOT/overlay-wifi/system/lib/modules/
make -C $SCRIPT_ROOT/../kernel ARCH=$TARGET_ARCH $RK_KERNEL_DEFCONFIG
make -C $SCRIPT_ROOT/../kernel ARCH=$TARGET_ARCH  modules -j4
find $SCRIPT_ROOT/../kernel/drivers/net/wireless/rockchip_wlan/*  -name "*.ko" | \
xargs -n1 -i cp {} $SCRIPT_ROOT/overlay-wifi/system/lib/modules/

mkdir -p $SCRIPT_ROOT/overlay-wifi/system/etc/firmware
install -D -m 0644 $SCRIPT_ROOT/../external/rkwifibt/firmware/broadcom/all/* $SCRIPT_ROOT/overlay-wifi/system/etc/firmware
install -D -m 0755 $SCRIPT_ROOT/../external/rkwifibt/src/rk_wifi_init $SCRIPT_ROOT/overlay-wifi/usr/bin/rk_wifi_init

mkdir -p $SCRIPT_ROOT/overlay-wifi/lib/systemd/system/
cat>$SCRIPT_ROOT/overlay-wifi/lib/systemd/system/rk_wifi_init.service<<EOF
[Unit]
Description=rk_wifi_init
Before=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/rk_wifi_init

[Install]
WantedBy=multi-user.target
EOF
