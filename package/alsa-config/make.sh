#!/bin/bash

install -D -m 0644 -D /sdk/external/alsa-config/cards/* /usr/share/alsa/cards/
if [ $? -ne 0 ]; then
	exit 1
fi
