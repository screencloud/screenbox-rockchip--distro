#!/bin/bash

set -e
DEPENDENCIES="gstreamer-rockchip weston libqt5widgets5 libatomic1 qtwayland5 libqt5multimedia5"
$SCRIPTS_DIR/build_pkgs.sh $ARCH $SUITE "$DEPENDENCIES"
PKG=video
#QMAKE=/usr/bin/qmake
QMAKE=$TOP_DIR/buildroot/output/rockchip_rk3399/host/bin/qmake
mkdir -p $BUILD_DIR/$PKG
cd $BUILD_DIR/$PKG
$QMAKE $TOP_DIR/app/$PKG
make
mkdir -p $TARGET_DIR/usr/local/$PKG
cp $TOP_DIR/app/$PKG/conf/* $TARGET_DIR/usr/local/$PKG/
mkdir -p $TARGET_DIR/usr/share/applications
install -m 0644 -D $TOP_DIR/app/$PKG/video.desktop $TARGET_DIR/usr/share/applications/
install -m 0755 -D $BUILD_DIR/$PKG/videoPlayer $TARGET_DIR/usr/local/$PKG/videoPlayer
cd -

