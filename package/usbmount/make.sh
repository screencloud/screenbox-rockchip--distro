#!/bin/bash

pkg_name=usbmount
installed=`dpkg -s $pkg_name  | grep Status`
if [ "$installed" == "Status: install ok installed" ];then
	echo "$pkg_name already installed"
else
        apt-get install -y $pkg_name
        if [ $? -ne 0 ]; then
                exit 1
        fi
fi

install -m 0644 /sdk/distro/package/usbmount/usbmount.conf /etc/usbmount/usbmount.conf
ln -sf media/usb udisk


