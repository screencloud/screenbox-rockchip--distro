#!/bin/bash

set -e
cd /sdk/external/libdrm
aclocal
./autogen.sh --disable-intel --disable-radeon --disable-amdgpu --disable-nouveau --disable-vmwgfx --disable-freedreno --disable-vc4 --enable-rockchip-experimental-api --enable-install-test-programs

#./configure --disable-intel --disable-radeon --disable-amdgpu --disable-nouveau --disable-vmwgfx --disable-freedreno --disable-vc4 --enable-rockchip-experimental-api --enable-install-test-programs
make
make install
