#!/bin/bash
apt-get install -y glmark2
if [ $? -ne 0 ]; then
	exit 1
fi
