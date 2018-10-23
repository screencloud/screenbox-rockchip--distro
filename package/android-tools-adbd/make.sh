#!/bin/bash
apt-get install -y android-tools-adbd
if [ $? -ne 0 ]; then
	exit 1
fi

if [ -x /usr/bin/adb ];then
	touch /.adb.en
fi

