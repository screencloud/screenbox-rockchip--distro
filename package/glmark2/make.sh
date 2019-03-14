#!/bin/bash

set -e
DEPENDENCIES="libdrm libpng-dev libjpeg-dev libudev-dev libmali"
$SCRIPTS_DIR/build_pkgs.sh $ARCH $SUITE $MIRROR "$DEPENDENCIES"
COMMIT=9a03892d0ef250b0eb5c87792dbfbd48e23d15bb
PKG=glmark2-$COMMIT
if [ ! -e $DOWNLOAD_DIR/$PKG.tar.gz ];then
	wget -O $DOWNLOAD_DIR/$PKG.tar.gz https://github.com/glmark2/glmark2/archive/$COMMIT/$PKG.tar.gz
fi

if [ ! -d $BUILD_DIR/$PKG ];then
	tar -xzf $DOWNLOAD_DIR/$PKG.tar.gz -C $BUILD_DIR
fi
source $OUTPUT_DIR/.config
cd $BUILD_DIR/$PKG
if [ x$BR2_PACKAGE_LIBDRM = xy ] && [ x$BR2_PACKAGE_WESTON = xy ];then
	./waf configure --with-flavors=drm-glesv2,wayland-glesv2 --prefix=/usr
elif [ x$BR2_PACKAGE_LIBDRM = xy ];then
	./waf configure --with-flavors=drm-glesv2 --prefix=/usr
elif [ x$BR2_PACKAGE_WESTON = xy ];then
	./waf configure --with-flavors=wayland-glesv2 --prefix=/usr
fi
./waf
./waf install
cd -
