#!/bin/bash
apt-get install -y tree

if [ $? -ne 0 ]; then
	exit 1
fi
