#!/bin/bash
set -e
cd /sdk/external/mpp
cmake -DRKPLATFORM=ON -DHAVE_DRM=ON .
make
make install
cd -
