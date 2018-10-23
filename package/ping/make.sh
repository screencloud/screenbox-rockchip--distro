#!/bin/bash
apt-get install -y inetutils-ping

if [ $? -ne 0 ]; then
	exit 1
fi
