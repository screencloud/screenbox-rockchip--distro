#!/bin/bash

pkg_name=android-tools-adbd
installed=`dpkg -s $pkg_name  | grep Status`
if [ "$installed" == "Status: install ok installed" ];then
	echo "$pkg_name already installed"
else
        apt-get install -y $pkg_name
        if [ $? -ne 0 ]; then
                exit 1
        fi
fi

CONFIG_FILE=/usr/bin/.usb_config

if [ ! -e $CONFIG_FILE ];then
        touch $CONFIG_FILE
fi

test ! `grep usb_adb_en $CONFIG_FILE` && echo usb_adb_en >> $CONFIG_FILE
exit 0
