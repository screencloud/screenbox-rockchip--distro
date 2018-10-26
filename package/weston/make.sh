#!/bin/bash
apt-get install -y weston

if [ $? -ne 0 ]; then
	exit 1
fi
