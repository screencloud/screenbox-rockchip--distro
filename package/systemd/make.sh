#!/bin/bash
apt-get install -y systemd
if [ $? -ne 0 ]; then
	exit 1
fi

install -m 0644 /sdk/distro/package/systemd/serial-getty@.service /lib/systemd/system/serial-getty@.service
