#!/bin/bash

set -e
ARCH=$1
SUITE=$2
MIRROR=$3
PKGS=$4
log() {
    local format="$1"
    shift
    printf -- "$format\n" "$@" >&2
}

run() {
    log "I: Running command: %s" "$*"
    "$@"
}

for p in $PKGS;do
	$SCRIPTS_DIR/build_pkg.sh $ARCH $SUITE $MIRROR $p
done
