#!/bin/bash

METHOD=$1
if [ x$METHOD = xcross ];then
	set -e
	install -m 755 -D $TOP_DIR/buildroot/package/rockchip/usbdevice/S50usbdevice $TARGET_DIR/usr/bin/
	install -m 644 -D $DISTRO_DIR/package/usbdevice/usbdevice.service $TARGET_DIR/lib/systemd/system/
	install -m 644 -D $TOP_DIR/buildroot/package/rockchip/usbdevice/61-usbdevice.rules $TARGET_DIR/lib/udev/rules.d/
	install -m 755 -D $TOP_DIR/buildroot/package/rockchip/usbdevice/usbdevice $TARGET_DIR/usr/bin/
else
	systemctl enable usbdevice.service
fi
