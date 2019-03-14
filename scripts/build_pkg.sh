#!/bin/bash

set -e
ARCH=$1
SUITE=$2
MIRROR=$3
PKG=$4

log() {
    local format="$1"
    shift
    printf -- "$format\n" "$@" >&2
}

run() {
    log "I: Running command: %s" "$*"
    "$@"
}


mkdir -p $BUILD_DIR/$PKG
if [ -e $BUILD_DIR/$PKG/.timestamp ];then
	if [ -z `find $BUILD_DIR/$PKG -newer $BUILD_DIR/$PKG/.timestamp` ];then
		echo "$PKG has been built before, skiped"
		exit 0
	fi
fi

if [ -x $PACKAGE_DIR/$PKG/make.sh ];then
	echo "building package $PKG"
	run $PACKAGE_DIR/$PKG/make.sh
	echo "build $PKG done!!!"
else
	echo "installing package $PKG"
	$SCRIPTS_DIR/install_pkg.sh $RK_ARCH $SUITE $MIRROR $PKG
	echo "install $PKG done!!!"
fi

touch $BUILD_DIR/$PKG/.timestamp

