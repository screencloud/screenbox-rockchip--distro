#!/bin/bash
apt-get install -y udev

if [ $? -ne 0 ]; then
	exit 1
fi
