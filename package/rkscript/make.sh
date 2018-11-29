#!/bin/bash

set -e
METHOD=$1
if [ x$METHOD = xcross ];then
	
	install -m 0755 -D $TOP_DIR/buildroot/package/rockchip/rkscript/*.sh $TARGET_DIR/usr/bin/
else
	exit 0
fi
