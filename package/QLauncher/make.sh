#!/bin/bash

set -e
PKG=QLauncher
QMAKE=/usr/bin/qmake
mkdir -p $BUILD_DIR/$PKG
cd $BUILD_DIR/$PKG
$QMAKE $TOP_DIR/app/$PKG
make
mkdir -p $TARGET_DIR/usr/local/$PKG
cp $TOP_DIR/app/QLauncher/resources/images/* $TARGET_DIR/usr/local/QLauncher/
install -m 0755 -D $BUILD_DIR/$PKG/$PKG $TARGET_DIR/usr/local/$PKG/$PKG
install -m 0755 -D $PACKAGE_DIR/$PKG/S50launcher $TARGET_DIR/etc/init.d/S50launcher
cd -

