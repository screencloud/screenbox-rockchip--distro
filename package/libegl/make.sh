#!/bin/bash
apt-get install -y libegl1-mesa-dev

if [ $? -ne 0 ]; then
	exit 1
fi
