#!/bin/bash
apt-get install -y iw
if [ $? -ne 0 ]; then
	exit 1
fi
