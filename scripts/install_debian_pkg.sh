#!/bin/bash

set -e
ARCH=$1
SUITE=$2
MIRROR=$3
PKG=$4
AUTH=$5

log() {
    local format="$1"
    shift
    printf -- "$format\n" "$@" >&2
}

run() {
    log "I: Running command: %s" "$*"
    "$@"
}

if [ x$AUTH == "xinit" ];then
	run $SCRIPTS_DIR/multistrap_build.sh -a $ARCH -b $SCRIPTS_DIR/debconfseed.txt -c $SCRIPTS_DIR/multistrap.conf -d $TARGET_DIR -m $MIRROR -p "$PKG" -s $SUITE
	echo "deb [arch=$ARCH] $MIRROR $SUITE main" > $TARGET_DIR/etc/apt/sources.list.d/multistrap-debian.list
else
	run $SCRIPTS_DIR/multistrap_build.sh -a $ARCH -b $SCRIPTS_DIR/debconfseed.txt -c $SCRIPTS_DIR/multistrap.conf -d $TARGET_DIR -m $MIRROR -p "$PKG" -s $SUITE -u "--no-auth"
fi
$SCRIPTS_DIR/fix_link.sh $TARGET_DIR/usr/lib/$TOOLCHAIN

