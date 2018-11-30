#!/bin/bash

set -e
METHOD=$1
export CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	cd $TOP_DIR/external/gstreamer-rockchip
	./autogen.sh --prefix=/usr --libdir=/usr/lib/$TOOLCHAIN --host=aarch64-linux-gnu --disable-valgrind --disable-examples --disable-rkximage
	make 
	make install
	cd -
fi
