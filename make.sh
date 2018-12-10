#!/bin/bash

DISTRO_DIR=$(dirname $(realpath "$0"))
TOP_DIR=$DISTRO_DIR/..

source $TOP_DIR/device/rockchip/.BoardConfig.mk
source $DISTRO_DIR/envsetup.sh

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
	fi
}

target_clean()
{
	system=$1
	for pkg in $(cat $DISTRO_DIR/configs/build.config)
	do
		if [ x$pkg != x`grep $pkg $DISTRO_CONFIG` ];then
			sudo chroot $system apt-get remove -y $pkg
		fi
	done

	sudo chroot $system apt-get autoclean -y
	sudo chroot $system apt-get clean -y
	sudo chroot $system apt-get autoremove -y
	sudo rm -rf $system/usr/share/locale/*
	sudo rm -rf $system/usr/share/man/*
	sudo rm -rf $system/usr/share/doc/*
	sudo rm -rf $system/usr/include/*
	sudo rm -rf $system/var/log/*
	sudo rm -rf $system/var/lib/apt/lists/*
	sudo rm -rf $system/var/cache/*
	echo "remove unused dri..."
	if [ $DISTRO_ARCH = arm64 ];then
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/msm_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/nouveau_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/nouveau_drv_video.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/nouveau_vieux_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/r200_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/r300_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/r600_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/r600_drv_video.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/radeon_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/radeonsi_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/radeonsi_drv_video.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/tegra_dri.so
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/dri/vc4_dri.so
	elif [ $DISTRO_ARCH = arm ];then
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/msm_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/nouveau_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/nouveau_drv_video.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/nouveau_vieux_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/r200_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/r300_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/r600_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/r600_drv_video.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/radeon_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/radeonsi_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/radeonsi_drv_video.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/tegra_dri.so
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/dri/vc4_dri.so
	fi
	echo "remove vdpau..."
	if [ $DISTRO_ARCH = arm64 ];then
		sudo rm -rf $system/usr/lib/aarch64-linux-gnu/vdpau
	elif [ $DISTRO_ARCH = arm ];then
		sudo rm -rf $system/usr/lib/arm-linux-gnueabihf/vdpau
	fi
	sudo rm -rf $system/sdk
}

build_rootfs()
{
	echo "packing rootfs image..."
	sudo rm -rf $ROOTFS_DIR
	sudo cp -ar $TARGET_DIR $ROOTFS_DIR
	target_clean $ROOTFS_DIR
	if [ $RK_ROOTFS_TYPE = ext4 ];then
		pack_ext4 $ROOTFS_DIR $ROOTFS_EXT4
	elif [ $RK_ROOTFS_TYPE = squashfs ];then
		pack_squashfs $ROOTFS_DIR $ROOTFS_SQUASHFS
	fi
}

build_package()
{
	echo "build package: $1"
	package=$1
	if [ -x $PACKAGE_DIR/$package/make.sh ];then
		echo "execute $PACKAGE_DIR/$package/make.sh"
		sudo  -E $PACKAGE_DIR/$package/make.sh cross
		if [ $? -ne 0 ]; then
			echo "cross build package $package failed"
			exit 1
		fi
		sudo mount -o rw,bind $TOP_DIR $MOUNT_DIR
		sudo chroot $TARGET_DIR bash /sdk/distro/package/$package/make.sh
		if [ $? -ne 0 ]; then
			echo "build package $package failed"
			sudo umount $MOUNT_DIR
			exit 1
		fi
		sudo umount $MOUNT_DIR
		sudo scripts/fix_link.sh $TARGET_DIR/usr/lib/$TOOLCHAIN
	fi
}

build_packages()
{
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

arch_init()
{
	DISTRO_ARCH=$RK_ARCH
	if [ -z $DISTRO_ARCH ];then
		DISTRO_ARCH=arm64
	fi
	if [ $DISTRO_ARCH == arm ] || [ $DISTRO_ARCH == arm64 ];then
		QEMU_ARCH=$DISTRO_ARCH
		if [ $DISTRO_ARCH == arm64 ];then
			QEMU_ARCH=aarch64
		fi
	else
		echo "$DISTRO_ARCH is not a valid arch. we only support arm and arm64"
	fi
}

build_single_package()
{
	arch_init
	build_package $1
}

build_all()
{
	mkdir -p $OUTPUT_DIR $BUILD_DIR $TARGET_DIR $IMAGE_DIR $MOUNT_DIR
	arch_init
	DISTRO_MIRROR=`$DISTRO_DIR/scripts/get_mirror.sh $DISTRO_OS $DISTRO_ARCH`
	defconfig_init
	config_init
	build_minibase
	sourcelist_init
	build_packages
	build_rootfs
}

main()
{
	if [ x$1 == xrootfs ];then
		arch_init
		build_rootfs
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
