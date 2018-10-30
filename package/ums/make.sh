#!/bin/bash
CONFIG_FILE=/usr/bin/.usb_config

if [ ! -e $CONFIG_FILE ];then
	touch $CONFIG_FILE
fi

test ! `grep usb_ums_en $CONFIG_FILE` && echo usb_ums_en >> $CONFIG_FILE
exit 0
