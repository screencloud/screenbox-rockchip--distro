#!/bin/bash

set -e
METHOD=$1
export CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	cd $TOP_DIR/external/mpp
	cmake -DRKPLATFORM=ON -DHAVE_DRM=ON -DCMAKE_INSTALL_LIBDIR=/usr/lib/$TOOLCHAIN -DCMAKE_INSTALL_PREFIX=/usr .
	make 
	make install
	cd -
fi
