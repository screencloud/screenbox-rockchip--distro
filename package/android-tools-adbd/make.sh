#!/bin/bash
apt-get install -y android-tools-adbd
if [ $? -ne 0 ]; then
	exit 1
fi

CONFIG_FILE=/usr/bin/.usb_config

if [ ! -e $CONFIG_FILE ];then
        touch $CONFIG_FILE
fi

test ! `grep usb_adb_en $CONFIG_FILE` && echo usb_adb_en >> $CONFIG_FILE
