#!/bin/bash
apt-get install -y alsa-utils
if [ $? -ne 0 ]; then
	exit 1
fi
