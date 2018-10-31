#!/bin/bash
set -e
cd /sdk/external/mpp
cmake .
make
make install
cd -
