#!/bin/bash
apt-get install -y libmad0-dev

if [ $? -ne 0 ]; then
	exit 1
fi

MINIMAD_GZ=/usr/share/doc/libmad0-dev/examples/minimad.c.gz
if [ -e $MINIMAD_GZ ];then
	gzip -d $MINIMAD_GZ
fi

gcc /usr/share/doc/libmad0-dev/examples/minimad.c -lmad -o /usr/bin/minimad

if [ $? -ne 0 ]; then
	exit 1
fi
