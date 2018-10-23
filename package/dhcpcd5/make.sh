#!/bin/bash
apt-get install -y dhcpcd5

if [ $? -ne 0 ]; then
	exit 1
fi
