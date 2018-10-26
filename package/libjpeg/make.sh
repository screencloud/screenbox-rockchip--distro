#!/bin/bash
apt-get install -y libjpeg-dev

if [ $? -ne 0 ]; then
	exit 1
fi
