#!/bin/bash
apt-get install -y vim
if [ $? -ne 0 ]; then
	exit 1
fi
