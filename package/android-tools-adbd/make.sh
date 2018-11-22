#!/bin/bash

PACKAGE=android-tools-adbd
METHOD=$1
if [ x$METHOD = xcross ];then
	exit 0
else
	set -e
	/sdk/distro/scripts/install.sh $PACKAGE
	CONFIG_FILE=/usr/bin/.usb_config

	if [ ! -e $CONFIG_FILE ];then
		touch $CONFIG_FILE
	fi
	
	if [ ! `grep usb_adb_en $CONFIG_FILE` ];then
		echo usb_adb_en >> $CONFIG_FILE
	fi
fi

