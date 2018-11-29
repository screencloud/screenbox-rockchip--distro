#!/bin/bash

set -e
METHOD=$1
export CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	cd $TOP_DIR/external/mpp
	cmake -DRKPLATFORM=ON -DHAVE_DRM=ON .
	make 
	make install
	cd -
fi
