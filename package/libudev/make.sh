#!/bin/bash
apt-get install -y libudev-dev

if [ $? -ne 0 ]; then
	exit 1
fi
