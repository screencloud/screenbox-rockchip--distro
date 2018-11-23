#!/bin/bash

METHOD=$1
if [ x$METHOD = xcross ];then
	exit 0
else
	set -e
	source /sdk/device/rockchip/.BoardConfig.mk
	install -m 0644 /sdk/buildroot/package/rockchip/partinit/61-partition-init.rules /lib/udev/rules.d/
	install -m 0644 /sdk/buildroot/package/rockchip/partinit/61-sd-cards-auto-mount.rules /lib/udev/rules.d/
	install -m 0755 /sdk/buildroot/package/rockchip/partinit/S21mountall.sh /usr/bin/
	install -m 0644 /sdk/distro/package/partinit/mount-all.service /lib/systemd/system/
	systemctl enable mount-all.service
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
fi
