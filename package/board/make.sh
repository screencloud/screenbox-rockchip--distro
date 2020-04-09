#!/bin/bash

set -e

source $OUTPUT_DIR/.config

if [ x$BR2_PACKAGE_BOARD_RK3328_EVB == xy ];then
	install -m 0755 -D $PACKAGE_DIR/board/S49hdmi_init $TARGET_DIR/etc/init.d
fi
