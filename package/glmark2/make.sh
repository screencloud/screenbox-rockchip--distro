#!/bin/bash

set -e
COMMIT=9b1070fe9c5cf908f323909d3c8cbed08022abe8
PKG=glmark2-$COMMIT
if [ ! -d $BUILD_DIR/$PKG ];then
	wget -O $DOWNLOAD_DIR/$PKG.tar.gz https://github.com/glmark2/glmark2/archive/$COMMIT/$PKG.tar.gz
fi

if [ ! -d $BUILD_DIR/$PKG ];then
	tar -xzf $DOWNLOAD_DIR/$PKG.tar.gz -C $BUILD_DIR
fi

cd $BUILD_DIR/$PKG
./waf configure --with-flavors=drm-glesv2,wayland-glesv2 --prefix=/usr
./waf
./waf install
cd -
