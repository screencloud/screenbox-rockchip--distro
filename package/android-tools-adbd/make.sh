#!/bin/bash
pkg_name=android-tools-adbd
installed=`dpkg -l | grep $pkg_name`
if [ -z "$installed" ];then
	apt-get install -y $pkg_name
	if [ $? -ne 0 ]; then
		exit 1
	fi
else
	echo "$pkg_name already installed"
fi

CONFIG_FILE=/usr/bin/.usb_config

if [ ! -e $CONFIG_FILE ];then
        touch $CONFIG_FILE
fi

test ! `grep usb_adb_en $CONFIG_FILE` && echo usb_adb_en >> $CONFIG_FILE
exit 0
