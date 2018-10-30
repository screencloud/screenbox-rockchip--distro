#!/bin/bash
#apt-get install -y glmark2-es2-wayland

if [ ! -d /sdk/distro/output/build/glmark2 ];then
	git clone https://github.com/glmark2/glmark2.git  /sdk/distro/output/build/glmark2
	if [ $? -ne 0 ]; then
		exit 1
	fi
fi

cd /sdk/distro/output/build/glmark2
./waf configure --with-flavors=drm-glesv2,wayland-glesv2 --prefix=/usr
if [ $? -ne 0 ]; then
	exit 1
fi
./waf
if [ $? -ne 0 ]; then
	exit 1
fi
./waf install
if [ $? -ne 0 ]; then
	exit 1
fi
cd -
