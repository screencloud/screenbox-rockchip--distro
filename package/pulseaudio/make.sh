#!/bin/bash
apt-get install -y pulseaudio
if [ $? -ne 0 ]; then
	exit 1
fi