#!/bin/bash
cp /sdk/buildroot/package/rockchip/partinit/61-partition-init.rules /lib/udev/rules.d/
chmod 755 /lib/udev/rules.d/61-partition-init.rules
cp /sdk/buildroot/package/rockchip/partinit/61-sd-cards-auto-mount.rules /lib/udev/rules.d/
chmod 755 /lib/udev/rules.d/61-sd-cards-auto-mount.rules

echo -e "/dev/block/by-name/misc\t\t/misc\t\t\temmc\t\tdefaults\t\t0\t0" >> /etc/fstab
echo -e "/dev/block/by-name/oem\t\t/oem\t\t\t$$RK_OEM_FS_TYPE\t\tdefaults\t\t0\t2" >> /etc/fstab
echo -e "/dev/block/by-name/userdata\t/userdata\t\t$$RK_USERDATA_FS_TYPE\t\tdefaults\t\t0\t2" >> /etc/fstab

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

if [ ! -L udisk ];then
	ln -fs media/usb udisk
fi

if [ ! -L sdcard ];then
	ln -fs mnt/sdcard sdcard
fi
