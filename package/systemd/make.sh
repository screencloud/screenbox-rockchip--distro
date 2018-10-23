#!/bin/bash
apt-get install -y systemd
if [ $? -ne 0 ]; then
	exit 1
fi
if [ -f /lib/systemd/system/serial-getty@.service ]; then
	sed -i '/ExecStart/c\\nExecStart=-/sbin/agetty --a root --keep-baud 115200,38400,9600 %I $TERM' /lib/systemd/system/serial-getty@.service
fi

if [ $? -ne 0 ]; then
	exit 1
fi
