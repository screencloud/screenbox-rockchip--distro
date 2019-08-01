#!/bin/bash

set -e
PKG=settings
DEPENDENCIES="weston libqt5widgets5 libatomic1 qtwayland5 libqt5bluetooth5 libqt5sql5"
$SCRIPTS_DIR/build_pkgs.sh $ARCH $SUITE "$DEPENDENCIES"
#QMAKE=/usr/bin/qmake
QMAKE=$TOP_DIR/buildroot/output/$RK_CFG_BUILDROOT/host/bin/qmake
mkdir -p $BUILD_DIR/$PKG
cd $BUILD_DIR/$PKG
$QMAKE $TOP_DIR/app/$PKG
make -j$RK_JOBS
mkdir -p $TARGET_DIR/usr/share/icon
cp $TOP_DIR/app/$PKG/conf/icon_setting.png $TARGET_DIR/usr/share/icon/
mkdir -p $TARGET_DIR/usr/share/applications
install -m 0644 -D $TOP_DIR/app/$PKG/setting.desktop $TARGET_DIR/usr/share/applications/
install -m 0755 -D $BUILD_DIR/$PKG/settings $TARGET_DIR/usr/bin/settings
install -m 0755 -D $DISTRO_DIR/package/$PKG/S30dbus $TARGET_DIR/etc/init.d/S30dbus
ln -sf /sbin/wpa_supplicant $TARGET_DIR/usr/sbin/wpa_supplicant
cd -

