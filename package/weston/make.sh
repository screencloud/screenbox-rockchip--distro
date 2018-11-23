#!/bin/bash

set -e
METHOD=$1
export CURRENT_DIR=$(dirname $(realpath "$0"))
if [ x$METHOD = xcross ];then
	if [ ! -d $OUTPUT_DIR/build/weston ] && [ ! -d $OUTPUT_DIR/build/weston/.git ];then
		git clone https://github.com/wayland-project/weston.git $OUTPUT_DIR/build/weston -b 5.0
	fi
	cd $BUILD_DIR/weston
	export LDFLAGS="$LDFLAGS -Wl,-rpath-link,$SYSROOT/lib:$SYSROOT/usr/lib:$TARGET_DIR/lib/$TOOLCHAIN:$TARGET_DIR/usr/lib:$TARGET_DIR/usr/lib/$TOOLCHAIN -L$TARGET_DIR/usr/lib"
	./autogen.sh --target=aarch64-linux-gnu --host=aarch64-linux-gnu --disable-dependency-tracking --disable-static --enable-shared  --disable-headless-compositor --disable-colord --disable-devdocs --disable-setuid-install --enable-dbus --enable-weston-launch --enable-egl --disable-rdp-compositor --disable-fbdev-compositor --enable-drm-compositor WESTON_NATIVE_BACKEND=drm-backend.so --disable-x11-compositor --disable-xwayland --disable-vaapi-recorder --disable-lcms --disable-systemd-login --disable-systemd-notify --enable-junit-xml --disable-demo-clients-install
	make WAYLAND_PROTOCOLS_DATADIR=$TARGET_DIR/usr/share/wayland-protocols
	sudo -E make install
	cd -
fi

