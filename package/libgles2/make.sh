#!/bin/bash
apt-get install -y libgles2-mesa-dev

if [ $? -ne 0 ]; then
	exit 1
fi
