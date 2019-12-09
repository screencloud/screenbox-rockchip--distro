#!/bin/bash

ARCH=$1
SUITE=$2
PACKAGES="$3"
AUTH=$4
set -e
export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C
export PATH=$PATH:/usr/sbin:/sbin
export QEMU_LD_PREFIX="`readlink -m "$TARGET_DIR"`"
export PROOT_NO_SECCOMP=1
if [ $ARCH == arm64 ];then
        QEMU_ARCH=aarch64
elif [ $ARCH == arm ];then
        QEMU_ARCH=arm
else
        echo "$ARCH is not a valid arch. we only support arm and arm64! set to arm64"
        QEMU_ARCH=aarch64
fi
QEMU=qemu-$QEMU_ARCH-static
CHROOTQEMUCMD="proot -q $QEMU -v -1 -0 -b /dev -b /sys -b /proc -r"
CHROOTCMD="proot -v -1 -0 -r"

if [ ! -e $OUTPUT_DIR/.mirror ];then
	export MIRROR=`$SCRIPTS_DIR/get_mirror.sh $SUITE $ARCH default`
#	export MIRROR=`$SCRIPTS_DIR/get_mirror.sh $SUITE $ARCH`
	echo $MIRROR > $OUTPUT_DIR/.mirror
else
	export MIRROR=`cat $OUTPUT_DIR/.mirror`
fi
ROOTDIR=$TARGET_DIR
MULTISTRAPCONF=`tempfile -d /tmp -p multistrap`
echo -n > "$MULTISTRAPCONF"
while read line; do
        eval echo $line >> "$MULTISTRAPCONF"
done < $SCRIPTS_DIR/multistrap.conf

if [ x$AUTH == "xinit" ];then
	proot -0 multistrap -f "$MULTISTRAPCONF"
	echo "deb [arch=$ARCH] $MIRROR $SUITE main" > $TARGET_DIR/etc/apt/sources.list.d/multistrap-debian.list
else
	proot -0 multistrap --no-auth -f "$MULTISTRAPCONF"
fi

cp $SCRIPTS_DIR/debconfseed.txt $TARGET_DIR/tmp/
$CHROOTQEMUCMD $TARGET_DIR debconf-set-selections /tmp/debconfseed.txt

for script in $TARGET_DIR/var/lib/dpkg/info/*.preinst; do
        [ "$script" = "$TARGET_DIR/var/lib/dpkg/info/vpnc.preinst" ] && continue
        DPKG_MAINTSCRIPT_NAME=preinst \
        DPKG_MAINTSCRIPT_PACKAGE="`basename $script .preinst`" \
        $CHROOTQEMUCMD $TARGET_DIR ${script##$TARGET_DIR} install
done

$CHROOTQEMUCMD $TARGET_DIR /usr/bin/dpkg --configure -a
$SCRIPTS_DIR/fix_link.sh $TARGET_DIR/usr/lib/$TOOLCHAIN

