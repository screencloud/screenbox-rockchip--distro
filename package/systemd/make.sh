#!/bin/bash
apt-get install -y systemd
if [ -f /lib/systemd/system/serial-getty@.service ]; then
	sed -i '/ExecStart/c\\nExecStart=-/sbin/agetty --a root --keep-baud 115200,38400,9600 %I $TERM' /lib/systemd/system/serial-getty@.service
fi
