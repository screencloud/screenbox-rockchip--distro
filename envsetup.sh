#!/bin/bash -x

export DISTRO_DIR=$(dirname $(realpath "$0"))
export TOP_DIR=$(realpath $DISTRO_DIR/..)
export OUTPUT_DIR=$DISTRO_DIR/output
export TARGET_DIR=$OUTPUT_DIR/target
export BUILD_DIR=$OUTPUT_DIR/build
export IMAGE_DIR=$OUTPUT_DIR/images
export ROOTFS_DIR=$OUTPUT_DIR/rootfs
export CONFIGS_DIR=$DISTRO_DIR/configs
export PACKAGE_DIR=$DISTRO_DIR/package
export DOWNLOAD_DIR=$DISTRO_DIR/download
export MOUNT_DIR=$TARGET_DIR/sdk

if [ $RK_ARCH == arm64 ];then
	export TOOLCHAIN_DIR=$TOP_DIR/prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu
	export TOOLCHAIN=aarch64-linux-gnu
elif [ $RK_ARCH == arm ];then
	export TOOLCHAIN_DIR=$TOP_DIR/prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf
	export TOOLCHAIN=arm-linux-gnueabihf
fi
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
export AR="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-ar"
export AS="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-as"
export LD="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-ld"
export NM="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-nm"
export CC="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-gcc"
export GCC="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-gcc"
export CPP="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-cpp"
export CXX="$TOOLCHAIN_DIR/bin/$TOOLCHAIN-g++"
export SYSROOT="$TARGET_DIR"
export STAGING_DIR="$TARGET_DIR"
export PKG_CONFIG="/usr/bin/pkg-config"
export PKG_CONFIG_PATH="$TARGET_DIR/usr/lib/$TOOLCHAIN/pkgconfig:$TARGET_DIR/usr/share/pkgconfig"
export PKG_CONFIG_LIBDIR="$TARGET_DIR/usr/lib/$TOOLCHAIN/pkgconfig:$TARGET_DIR/usr/share/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$TARGET_DIR"
export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1
export DESTDIR="$TARGET_DIR"
export CFLAGS="-I$TARGET_DIR/usr/include -I$TARGET_DIR/usr/include/$TOOLCHAIN"
export LDFLAGS="--sysroot=$SYSROOT"
