#!/bin/bash

install -m 755 /sdk/buildroot/package/rockchip/usbdevice/S50usbdevice /etc/init.d/
install -m 644 /sdk/buildroot/package/rockchip/usbdevice/61-usbdevice.rules /lib/udev/rules.d/
install -m 755 /sdk/buildroot/package/rockchip/usbdevice/usbdevice /usr/bin/
