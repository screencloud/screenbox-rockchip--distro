#!/bin/bash
apt-get install -y net-tools
if [ $? -ne 0 ]; then
	exit 1
fi
