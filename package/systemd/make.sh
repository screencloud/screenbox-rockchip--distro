#!/bin/bash

PACKAGE=systemd
METHOD=$1
if [ x$METHOD = xcross ];then
	exit 0
else
	set -e
	/sdk/distro/scripts/install.sh $PACKAGE
	install -m 0644 /sdk/distro/package/systemd/serial-getty@.service /lib/systemd/system/serial-getty@.service
fi

