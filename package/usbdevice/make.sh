#!/bin/bash

install -m 755 -D /sdk/buildroot/package/rockchip/usbdevice/S50usbdevice /usr/bin/
install -m 644 -D /sdk/distro/package/usbdevice/usbdevice.service /lib/systemd/system/
systemctl enable usbdevice.service
install -m 644 -D /sdk/buildroot/package/rockchip/usbdevice/61-usbdevice.rules /lib/udev/rules.d/
install -m 755 -D /sdk/buildroot/package/rockchip/usbdevice/usbdevice /usr/bin/
