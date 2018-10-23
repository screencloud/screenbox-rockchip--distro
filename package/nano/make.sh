#!/bin/bash
apt-get install -y nano
if [ $? -ne 0 ]; then
	exit 1
fi
