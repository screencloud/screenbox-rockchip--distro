#!/bin/bash
apt-get install -y pkg-config

if [ $? -ne 0 ]; then
	exit 1
fi
