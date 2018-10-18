#!/bin/bash

git clone https://github.com/rbrito/usbmount  /sdk/distro/output/build/usbmount
cd /sdk/distro/output/build/usbmount
git reset --hard 9a92e7d622662380f4329e0db17e263509715722
install -m 0755 -D usbmount /usr/share/usbmount/usbmount
install -m 0755 -D 00_create_model_symlink /etc/usbmount/mount.d/00_create_model_symlink
install -m 0755 -D 00_remove_model_symlink /etc/usbmount/umount.d/00_remove_model_symlink
install -m 0644 -D 90-usbmount.rules /lib/udev/rules.d/90-usbmount.rules
install -m 0644 -D usbmount.conf /etc/usbmount/usbmount.conf
install -m 0644 -D usbmount@.service /lib/systemd/system/usbmount@.service

for i in 0 1 2 3 4 5 6 7; do
	mkdir media/usb$i 2> /dev/null || :
done

ln -s media/usb0 udisk
cd -


