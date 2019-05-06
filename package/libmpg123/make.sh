#!/bin/bash

set -e
DEPENDENCIES=libmpg123-dev
$SCRIPTS_DIR/build_pkgs.sh $ARCH $SUITE "$DEPENDENCIES"
MPG123_TO_OUT123_GZ=$TARGET_DIR/usr/share/doc/libmpg123-dev/examples/mpg123_to_out123.c.gz
MPG123_TO_OUT123_C=$TARGET_DIR/usr/share/doc/libmpg123-dev/examples/mpg123_to_out123.c
MPG123_TO_WAV_C=$TARGET_DIR/usr/share/doc/libmpg123-dev/examples/mpg123_to_wav.c
MPGLIB=$TARGET_DIR/usr/share/doc/libmpg123-dev/examples/mpglib.c
if [ -e $MPG123_TO_OUT123_GZ ];then
	gzip -dkf $MPG123_TO_OUT123_GZ
fi

if [ -e $MPG123_TO_OUT123_C ];then
	cp $MPG123_TO_OUT123_C $MPG123_TO_WAV_C
fi

$GCC $MPG123_TO_WAV_C --sysroot=$TARGET_DIR -lmpg123 -lout123 -lm -ldl -I$TARGET_DIR/usr/include -I$TARGET_DIR/usr/include/$TOOLCHAIN -o $TARGET_DIR/usr/bin/mpg123_to_wav

$GCC $MPGLIB --sysroot=$TARGET_DIR -lmpg123 -lm -ldl -I$TARGET_DIR/usr/include -I$TARGET_DIR/usr/include/$TOOLCHAIN -o $TARGET_DIR/usr/bin/mpglib
