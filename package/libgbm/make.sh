#!/bin/bash

PACKAGE=libgbm-dev
METHOD=$1
if [ x$METHOD = xcross ];then
	exit 0
else
	/sdk/distro/scripts/install.sh $PACKAGE
	source /sdk/device/rockchip/.BoardConfig.mk
	source /sdk/distro/scripts/env_chroot.sh
	sed -i '9c Version: 17' /usr/lib/$TOOLCHAIN/pkgconfig/gbm.pc
fi

