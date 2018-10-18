#!/bin/bash

source /sdk/device/rockchip/.BoardConfig.mk
install -m 644 /sdk/buildroot/package/rockchip/partinit/61-partition-init.rules /lib/udev/rules.d/
install -m 644  /sdk/buildroot/package/rockchip/partinit/61-sd-cards-auto-mount.rules /lib/udev/rules.d/

# echo -e "/dev/block/by-name/misc\t\t/misc\t\t\temmc\t\tdefaults\t\t0\t0" >> /etc/fstab
echo -e "/dev/disk/by-partlabel/oem\t/oem\t\t$RK_OEM_FS_TYPE\tdefaults\t0\t2" > /etc/fstab
echo -e "/dev/disk/by-partlabel/userdata\t/userdata\t$RK_USERDATA_FS_TYPE\tdefaults\t0\t2" >> /etc/fstab

if [ ! -d oem ];then
	mkdir oem
fi

if [ ! -d userdata ];then
	mkdir userdata
fi

if [ ! -d mnt/sdcard ];then
	mkdir mnt/sdcard
fi

if [ ! -L data ];then
	ln -fs userdata data
fi

if [ ! -L sdcard ];then
	ln -fs mnt/sdcard sdcard
fi
