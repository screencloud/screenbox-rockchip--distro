#!/bin/bash
apt-get install -y wpasupplicant
if [ $? -ne 0 ]; then
	exit 1
fi
