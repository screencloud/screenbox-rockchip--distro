#!/bin/bash
apt-get install -y android-tools-adbd
if [ -x /usr/bin/adb ];then
	touch /.adb.en
fi
