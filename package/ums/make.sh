#!/bin/bash


METHOD=$1
if [ x$METHOD = xcross ];then
	CONFIG_FILE=$TARGET_DIR/usr/bin/.usb_config

	if [ ! -e $CONFIG_FILE ];then
		touch $CONFIG_FILE
	fi

	if [ ! `grep usb_ums_en $CONFIG_FILE` ];then
		echo usb_ums_en >> $CONFIG_FILE
	fi

fi

