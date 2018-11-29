#!/bin/bash

set -e
METHOD=$1
export CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	cd $TOP_DIR/external/libdrm
	./autogen.sh --target=aarch64-linux-gnu --host=aarch64-linux-gnu --disable-dependency-tracking --disable-static --enable-shared  --disable-cairo-tests --disable-manpages --disable-intel --disable-radeon --disable-amdgpu --disable-nouveau --disable-vmwgfx --disable-omap-experimental-api --disable-etnaviv-experimental-api --disable-exynos-experimental-api --disable-freedreno --disable-tegra-experimental-api --disable-vc4 --enable-rockchip-experimental-api --enable-udev --disable-valgrind --enable-install-test-programs
	make 
	make install
	cd -
fi
