#!/bin/bash

pkg_name=libmad0-dev
installed=`dpkg -s $pkg_name  | grep Status`
if [ "$installed" == "Status: install ok installed" ];then
	echo "$pkg_name already installed"
else
        apt-get install -y $pkg_name
        if [ $? -ne 0 ]; then
                exit 1
        fi
fi

MINIMAD_GZ=/usr/share/doc/libmad0-dev/examples/minimad.c.gz
if [ -e $MINIMAD_GZ ];then
	gzip -d $MINIMAD_GZ
fi

gcc /usr/share/doc/libmad0-dev/examples/minimad.c -lmad -o /usr/bin/minimad

if [ $? -ne 0 ]; then
	exit 1
fi
