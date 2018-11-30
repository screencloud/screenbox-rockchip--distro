#!/bin/bash

METHOD=$1
if [ x$METHOD = xcross ];then
	exit 0
else
	set -e
	/sdk/distro/scripts/install.sh libgstreamer1.0-dev
	/sdk/distro/scripts/install.sh gstreamer1.0-plugins-base
	/sdk/distro/scripts/install.sh gstreamer1.0-plugins-good
	/sdk/distro/scripts/install.sh gstreamer1.0-plugins-bad
	/sdk/distro/scripts/install.sh gstreamer1.0-plugins-ugly
	/sdk/distro/scripts/install.sh gstreamer1.0-tools
	/sdk/distro/scripts/install.sh libgstreamer-plugins-base1.0-dev
	/sdk/distro/scripts/install.sh libgstreamer-plugins-bad1.0-dev
fi

