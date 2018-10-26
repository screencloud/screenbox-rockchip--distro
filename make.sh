#!/bin/bash

DISTRO_DIR=$(dirname $(realpath "$0"))
TOP_DIR=$DISTRO_DIR/..
OUTPUT_DIR=$DISTRO_DIR/output
BUILD_DIR=$OUTPUT_DIR/build
TARGET_DIR=$OUTPUT_DIR/target
IMAGE_DIR=$OUTPUT_DIR/images
FIRMWARE_DIR=$OUTPUT_DIR/firmware
CONFIGS_DIR=$DISTRO_DIR/configs
PACKAGE_DIR=$DISTRO_DIR/package
DOWNLOAD_DIR=$DISTRO_DIR/download
MOUNT_DIR=$TARGET_DIR/sdk
MIRROR_FILE=$OUTPUT_DIR/.mirror
ARCH_FILE=$OUTPUT_DIR/.arch
DEFCONFIG_FILE=$OUTPUT_DIR/.defconfig
DISTRO_CONFIG=$OUTPUT_DIR/.config
ROOTFS_DEBUG_EXT4=$IMAGE_DIR/rootfs.debug.ext4
ROOTFS_DEBUG_SQUASHFS=$IMAGE_DIR/rootfs.debug.squashfs
ROOTFS_EXT4=$IMAGE_DIR/rootfs.ext4
ROOTFS_SQUASHFS=$IMAGE_DIR/rootfs.squashfs
DISTRO_DEFCONFIG=$1
BUILD_PACKAGE=$1
DISTRO_ARCH=$2
QEMU_ARCH=aarch64
DEFAULT_MIRROR=http://ftp.cn.debian.org/debian
NETSELECT_APT_DEB=netselect-apt_0.3.ds1-28_all.deb
NETSELECT_APT_URL=http://ftp.cn.debian.org/debian/pool/main/n/netselect/$NETSELECT_APT_DEB
NETSELECT_DEB=netselect_0.3.ds1-28+b1_amd64.deb
NETSELECT_URL=http://ftp.cn.debian.org/debian/pool/main/n/netselect/$NETSELECT_DEB
DISTRO_MIRROR=$DEFAULT_MIRROR
DISTRO_VERSION=buster
DISTRO_OS=debian

if [ $DISTRO_VERSION==buster ];then
	DISTRO_OS=debian
elif [ $DISTRO_VERSION==bionic ];then
	DISTRO_OS=ubuntu
fi

log() {
    local format="$1"
    shift
    printf -- "$format\n" "$@" >&2
}

die() {
    local format="$1"
    shift
    log "E: $format" "$@"
    exit 1
}

run() {
    log "I: Running command: %s" "$*"
    "$@"
}

clean()
{
	sudo rm -rf $OUTPUT_DIR
}

pack_squashfs()
{
	SRC=$1
	DST=$2
	mksquashfs $SRC $DST -noappend -comp gzip
}

pack_ext4()
{
	SRC=$1
	DST=$2
	if [ -x $DISTRO_DIR/../device/rockchip/common/mke2img.sh ];then
		sudo $DISTRO_DIR/../device/rockchip/common/mke2img.sh $SRC $DST
	else
		SIZE=`du -sk --apparent-size $SRC | cut --fields=1`
		inode_counti=`find $SRC | wc -l`
		inode_counti=$[inode_counti+512]
		EXTRA_SIZE=$[inode_counti*4]
		SIZE=$[SIZE+EXTRA_SIZE]
		genext2fs -b $SIZE -N $inode_counti -d $SRC $DST
		tune2fs -C 1 $DST
		resize2fs -M $DST
		e2fsck -fy $DST
	fi
}

target_clean()
{
	system=$1
	sudo chroot $system apt-get clean
	sudo chroot $system apt-get autoclean
	sudo chroot $system apt-get autoremove
	sudo rm -rf $system/usr/share/locale/*
	sudo rm -rf $system/usr/share/man/*
	sudo rm -rf $system/usr/share/doc/*
	sudo rm -rf $system/var/log/*
	sudo rm -rf $system/var/lib/apt/lists/*
	sudo rm -rf $system/var/cache/*
	sudo rm -rf $system/sdk
}

build_firmware()
{
	sudo rm -rf $FIRMWARE_DIR
	sudo cp -ar $TARGET_DIR $FIRMWARE_DIR
	target_clean $FIRMWARE_DIR
	pack_ext4 $FIRMWARE_DIR $ROOTFS_DEBUG_EXT4
	pack_ext4 $FIRMWARE_DIR $ROOTFS_EXT4
	pack_squashfs $FIRMWARE_DIR $ROOTFS_DEBUG_SQUASHFS
	pack_squashfs $FIRMWARE_DIR $ROOTFS_SQUASHFS

}

build_package()
{
	echo "build package: $1"
	package=$1
	if [ -x $PACKAGE_DIR/$package/make.sh ];then
		sudo mount -o rw,bind $TOP_DIR $MOUNT_DIR
		echo "execute $PACKAGE_DIR/$package/make.sh"
		sudo chroot $TARGET_DIR bash /sdk/distro/package/$package/make.sh
		if [ $? -ne 0 ]; then
			echo "build package $package failed"
			sudo umount $MOUNT_DIR
			exit 1
		fi
		sudo umount $MOUNT_DIR
	fi
}

build_packages()
{
	if [ -e $TOP_DIR/build.sh ] && [ ! -e $OUTPUT_DIR/.kernelmodules.done ];then
		$TOP_DIR/build.sh modules
		touch $OUTPUT_DIR/.kernelmodules.done
	fi

	if [ ! -e $OUTPUT_DIR/.buildtool.done ] && [ $DISTRO_DIR/configs/build.config ];then
		for pkg in $(cat $DISTRO_DIR/configs/build.config)
		do
			build_package $pkg
			touch $OUTPUT_DIR/.buildtool.done
		done
	fi


	if [ -e $DISTRO_CONFIG ];then
		for line in $(cat $DISTRO_CONFIG)
		do
			build_package $line
		done
	fi
}

make_sourcelist()
{
	echo "deb $DISTRO_MIRROR $DISTRO_VERSION main" > $BUILD_DIR/sourcelist/sources.list
	echo "deb $DISTRO_MIRROR sid main" >> $BUILD_DIR/sourcelist/sources.list
	chmod 644 $BUILD_DIR/sourcelist/sources.list
	sudo chown root:root $BUILD_DIR/sourcelist/sources.list
}

sourcelist_init()
{
	if [ ! -d $BUILD_DIR/sourcelist ];then
		mkdir $BUILD_DIR/sourcelist
	fi

	if [ ! -e $BUILD_DIR/sourcelist/sources.list ];then
		echo "make source list"
		make_sourcelist
	fi

	diff $BUILD_DIR/sourcelist/sources.list $TARGET_DIR/etc/apt/sources.list
	if [ $? -eq 1 ] || [ ! -e $OUTPUT_DIR/.sourcelist.done ];then
		sudo cp $BUILD_DIR/sourcelist/sources.list $TARGET_DIR/etc/apt/sources.list
		echo "update package lists for target system"
		sudo chroot $TARGET_DIR apt-get update
		if [ $? -eq 0 ]; then
			touch $OUTPUT_DIR/.sourcelist.done
		fi
	fi


}

build_minibase()
{
	which debootstrap >/dev/null 2>/dev/null || die "debootstrap isn't found in \$PATH, is debootstrap package installed?"

	if ! which "qemu-$QEMU_ARCH-static" >/dev/null 2>&1; then
		die "Sorry, couldn't find binary %s" "qemu-$QEMU_ARCH-static"
	fi
	
	if [ -e $OUTPUT_DIR/.stage1.done ];then
		echo "minibase stage1 already done. so skip it. please delete $OUTPUT_DIR/.stage1.done if you want to rebuild it"
	else
		sudo debootstrap --variant minbase --arch "$DISTRO_ARCH" --foreign $DISTRO_VERSION $TARGET_DIR $DISTRO_MIRROR
		if [ $? -eq 0 ]; then
			touch $OUTPUT_DIR/.stage1.done
		else
			exit 1
		fi
	fi
	
	sudo cp $(which "qemu-$QEMU_ARCH-static") $TARGET_DIR/usr/bin/

	if [ -e $OUTPUT_DIR/.stage2.done ];then
		echo "minibase stage2 already done. so skip it. please delete $OUTPUT_DIR/.stage2.done if you want to rebuild it"
	else
		sudo chroot $TARGET_DIR /debootstrap/debootstrap --second-stage
		if [ $? -eq 0 ]; then
			touch $OUTPUT_DIR/.stage2.done
		else
			exit 1
		fi
	fi

}

config_init()
{
	if [ $DISTRO_DEFCONFIG ] && [ -e $CONFIGS_DIR/$DISTRO_DEFCONFIG ];then
		if [ -e $DISTRO_CONFIG ];then
			rm $DISTRO_CONFIG
		fi
		for line in $(cat $CONFIGS_DIR/$DISTRO_DEFCONFIG)
		do
			if [ $line ] && [ -e $CONFIGS_DIR/$line ];then
				cat $CONFIGS_DIR/$line >> $DISTRO_CONFIG
			fi
		done
	else
		echo "$DISTRO_DEFCONFIG is not a valid defconfig, please use defconfig in $CONFIGS_DIR/"
	fi
}

defconfig_init()
{
	if [ -z $DISTRO_DEFCONFIG ];then
		if [ -e $DEFCONFIG_FILE ];then
			DISTRO_DEFCONFIG=`cat $DEFCONFIG_FILE`
			return
		else
			DISTRO_DEFCONFIG=default_defconfig
			echo "$DISTRO_DEFCONFIG" > $DEFCONFIG_FILE
		fi
	else
		echo "$DISTRO_DEFCONFIG" > $DEFCONFIG_FILE
	fi
}

netselect_chkinstall()
{
	if [ -z `which netselect` ];then
		wget -P $DOWNLOAD_DIR $NETSELECT_URL
		sudo dpkg -i $DOWNLOAD_DIR/$NETSELECT_DEB
	fi
}

netselect_apt_chkinstall()
{
	if [ -z `which netselect-apt` ];then
		wget -P $DOWNLOAD_DIR $NETSELECT_APT_URL
		sudo dpkg -i $DOWNLOAD_DIR/$NETSELECT_APT_DEB
	fi
}

ubuntu_mirror_init()
{
	netselect_chkinstall
	DISTRO_MIRROR=`sudo netselect -s 1 $(wget -qO - mirrors.ubuntu.com/mirrors.txt) | cut -d ' ' -f 5`
}

debian_mirror_init()
{
	netselect_chkinstall
	netselect_apt_chkinstall
	DISTRO_MIRROR=`sudo netselect-apt -o $OUTPUT_DIR/.sources.list -t 20 -a $DISTRO_ARCH 2>&1 |grep -A 1 "fastest valid for HTTP" | tail -1 | cut -d ' ' -f 9`
	sudo rm $OUTPUT_DIR/.sources.list
}

mirror_init()
{
	if [ -e $MIRROR_FILE ];then
		DISTRO_MIRROR=`cat $MIRROR_FILE`
	else
		echo "looking for the fastest mirror for $DISTRO_OS"
		if [ $DISTRO_OS == debian ];then
			debian_mirror_init
		elif [ $DISTRO_OS == ubuntu ];then
			ubuntu_mirror_init
		fi

		if [ $? -eq 0 ]; then
			echo "$DISTRO_MIRROR" > $MIRROR_FILE
		else
			exit 1
		fi
	fi
}

arch_init()
{
	if [ -z $DISTRO_ARCH ];then
		if [ -e $ARCH_FILE ];then
			DISTRO_ARCH=`cat $ARCH_FILE`
			return
		else
			DISTRO_ARCH=arm64
		fi
	fi
	if [ $DISTRO_ARCH == arm ] || [ $DISTRO_ARCH == arm64 ];then
		echo "$DISTRO_ARCH" > $ARCH_FILE
		QEMU_ARCH=$DISTRO_ARCH
		if [ $DISTRO_ARCH == arm64 ];then
			QEMU_ARCH=aarch64
		fi
	else
		echo "$DISTRO_ARCH is not a valid arch. we only support arm and arm64"
	fi
}

dir_init()
{
	if [ ! -d $OUTPUT_DIR ];then
		mkdir $OUTPUT_DIR
	fi

	if [ ! -d $BUILD_DIR ];then
		mkdir $BUILD_DIR
	fi

	if [ ! -d $TARGET_DIR ];then
		mkdir $TARGET_DIR
	fi

	if [ ! -d $IMAGE_DIR ];then
		mkdir $IMAGE_DIR
	fi

	if [ ! -d $MOUNT_DIR ];then
		mkdir $MOUNT_DIR
	fi
}

build_single_package()
{
	arch_init
	build_package $1
}

build_all()
{
	dir_init
	arch_init
	mirror_init
	defconfig_init
	config_init
	build_minibase
	sourcelist_init
	build_packages
	build_firmware
}

main()
{
	if [ x$1 == xfirmware ];then
		build_firmware
		exit 0
	elif [ -x $PACKAGE_DIR/$1/make.sh ];then
		build_single_package $1
		exit 0
	else
		build_all
		exit 0
	fi
}

main "$@"
