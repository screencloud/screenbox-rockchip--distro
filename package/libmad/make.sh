#!/bin/bash

PACKAGE=libmad0-dev
METHOD=$1
if [ x$METHOD = xcross ];then
	exit 0
else
	set -e
	/sdk/distro/scripts/install.sh $PACKAGE

	MINIMAD_GZ=/usr/share/doc/libmad0-dev/examples/minimad.c.gz
	if [ -e $MINIMAD_GZ ];then
		gzip -d $MINIMAD_GZ
	fi

	gcc /usr/share/doc/libmad0-dev/examples/minimad.c -lmad -o /usr/bin/minimad
fi

