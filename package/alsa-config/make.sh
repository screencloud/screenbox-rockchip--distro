#!/bin/bash

set -e
METHOD=$1
CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	
	install -m 0644 -D $TOP_DIR/external/alsa-config/cards/* $TARGET_DIR/usr/share/alsa/cards/
else
	exit 0
fi
