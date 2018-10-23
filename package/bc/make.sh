#!/bin/bash
apt-get install -y bc
if [ $? -ne 0 ]; then
	exit 1
fi
