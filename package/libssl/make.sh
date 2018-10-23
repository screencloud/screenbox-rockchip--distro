#!/bin/bash
apt-get install -y libssl-dev
if [ $? -ne 0 ]; then
	exit 1
fi
