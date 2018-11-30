#!/bin/bash

set -e
METHOD=$1
export CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	if [ ! -d $BUILD_DIR/glmark2 ];then
		git clone https://github.com/glmark2/glmark2.git  $BUILD_DIR/glmark2
	fi

	cd $BUILD_DIR/glmark2
	echo "cflag:$CFLAGS, cxxflag:$CXXFLAGS "
	./waf configure --with-flavors=drm-glesv2,wayland-glesv2 --prefix=/usr
	./waf
	./waf install
	cd -
else
	echo " "
	#apt-get install -y glmark2-es2-wayland
fi
