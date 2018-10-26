#!/bin/bash
apt-get install -y g++

if [ $? -ne 0 ]; then
	exit 1
fi
