#!/bin/bash

DEBIAN_CDN=http://cdn.debian.net/debian
UBUNTU_CDN=
DEFAULT_MIRROR=http://ftp.cn.debian.org/debian
NETSELECT_APT_DEB=netselect-apt_0.3.ds1-28_all.deb
NETSELECT_APT_URL=http://ftp.cn.debian.org/debian/pool/main/n/netselect/$NETSELECT_APT_DEB
NETSELECT_DEB=netselect_0.3.ds1-28+b1_amd64.deb
NETSELECT_URL=http://ftp.cn.debian.org/debian/pool/main/n/netselect/$NETSELECT_DEB
OS=$1
ARCH=$2
CDN=$3

usage() {
        echo "Usage: $0: distro arch" >&2
}

netselect_chkinstall()
{
	if [ -z `which netselect` ];then
		wget -P /tmp $NETSELECT_URL
		sudo dpkg -i /tmp/$NETSELECT_DEB
	fi
}

netselect_apt_chkinstall()
{
	if [ -z `which netselect-apt` ];then
		wget -P /tmp $NETSELECT_APT_URL
		sudo dpkg -i /tmp/$NETSELECT_APT_DEB
	fi
}

main()
{
	if [ $OS == debian ];then
		if [ x$CDN == xcdn ];then
			MIRROR=$DEBIAN_CDN
		else
			netselect_chkinstall
			netselect_apt_chkinstall
			MIRROR=`sudo netselect-apt -o /tmp/.sources.list -t 20 -a $ARCH 2>&1 |grep -A 1 "fastest valid for HTTP" | tail -1 | cut -d ' ' -f 9`
			sudo rm -f /tmp/.sources.list
		fi
	elif [ $OS == ubuntu ];then
		if [ x$CDN == xcdn ];then
			MIRROR=$UBUNTU_CDN
		else
			netselect_chkinstall
			MIRROR=`sudo netselect -s 1 $(wget -qO - mirrors.ubuntu.com/mirrors.txt) | cut -d ' ' -f 5`
		fi
	else
		usage
	fi
	echo "$MIRROR"
}

main "$@"
