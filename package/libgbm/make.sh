#!/bin/bash
apt-get install -y libgbm-dev

if [ $? -ne 0 ]; then
	exit 1
fi
