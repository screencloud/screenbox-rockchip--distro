#!/bin/bash

set -e
if [ ! -d $BUILD_DIR/glmark2 ];then
	git clone https://github.com/glmark2/glmark2.git  $BUILD_DIR/glmark2
fi

cd $BUILD_DIR/glmark2
echo "cflag:$CFLAGS, cxxflag:$CXXFLAGS LDFLAGS=$LDFLAGS"
./waf configure --with-flavors=drm-glesv2,wayland-glesv2 --prefix=/usr
./waf
./waf install
cd -
