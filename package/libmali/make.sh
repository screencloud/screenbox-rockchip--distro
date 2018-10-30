#!/bin/bash

source /sdk/device/rockchip/.BoardConfig.mk

rm_so()
{
	rm -f /usr/lib/aarch64-linux-gnu/libmali*
	rm -f /usr/lib/aarch64-linux-gnu/libMali*
	rm -f /usr/lib/aarch64-linux-gnu/libEGL.so*
	rm -f /usr/lib/aarch64-linux-gnu/libgbm.so*
	rm -f /usr/lib/aarch64-linux-gnu/libGLESv1_CM.so*
	rm -f /usr/lib/aarch64-linux-gnu/libGLESv2.so*
	rm -f /usr/lib/aarch64-linux-gnu/libMaliOpenCL.so
	rm -f /usr/lib/aarch64-linux-gnu/libOpenCL.so
	rm -f /usr/lib/aarch64-linux-gnu/libwayland-egl.so*

	rm -f /usr/lib/arm-linux-gnueabihf/libmali*
	rm -f /usr/lib/arm-linux-gnueabihf/libMali*
	rm -f /usr/lib/arm-linux-gnueabihf/libEGL.so*
	rm -f /usr/lib/arm-linux-gnueabihf/libgbm.so*
	rm -f /usr/lib/arm-linux-gnueabihf/libGLESv1_CM.so*
	rm -f /usr/lib/arm-linux-gnueabihf/libGLESv2.so*
	rm -f /usr/lib/arm-linux-gnueabihf/libMaliOpenCL.so
	rm -f /usr/lib/arm-linux-gnueabihf/libOpenCL.so
	rm -f /usr/lib/arm-linux-gnueabihf/libwayland-egl.so*
}

link_opengl()
{
	ln -s libmali.so libMali.so
	ln -s libmali.so libEGL.so
	ln -s libmali.so libEGL.so.1
	ln -s libmali.so libgbm.so
	ln -s libmali.so libgbm.so.1
	ln -s libmali.so libGLESv1_CM.so
	ln -s libmali.so libGLESv1_CM.so.1
	ln -s libmali.so libGLESv2.so
	ln -s libmali.so libGLESv2.so.2
	ln -s libmali.so libwayland-egl.so
	ln -s libmali.so libwayland-egl.so.1
}
link_opencl()
{
	ln -s libmali.so libMaliOpenCL.so
	ln -s libmali.so libOpenCL.so
}


if [ $RK_TARGET_PRODUCT == rk3399 ];then
	rm_so
	install -m 0644 -D /sdk/external/libmali/lib/aarch64-linux-gnu/libmali-midgard-t86x-r14p0-wayland.so /usr/lib/aarch64-linux-gnu/
	cd /usr/lib/aarch64-linux-gnu/
	ln -s libmali-midgard-t86x-r14p0-wayland.so libmali.so
	link_opengl
	link_opencl
	cd -
elif [ $RK_TARGET_PRODUCT == rk3288 ];then
	rm_so
	install -m 0644 -D /sdk/external/libmali/lib/arm-linux-gnueabihf/libmali-midgard-t76x-r14p0-r0p0-wayland.so /usr/lib/arm-linux-gnueabihf/
	install -m 0644 -D /sdk/external/libmali/lib/arm-linux-gnueabihf/libmali-midgard-t76x-r14p0-r1p0-wayland.so /usr/lib/arm-linux-gnueabihf/
	install -m 0755 -D /sdk/external/libmali/overlay/S10libmali_rk3288 /usr/bin/S10libmali
	cd /usr/lib/arm-linux-gnueabihf
	link_opengl
	link_opencl
	cd -
elif [ $RK_TARGET_PRODUCT == rk3328 ];then
	rm_so
	install -m 0644 -D /sdk/external/libmali/lib/aarch64-linux-gnu/libmali-utgard-450-r7p0-r0p0-wayland.so /usr/lib/aarch64-linux-gnu/
	cd /usr/lib/aarch64-linux-gnu/
	ln -s libmali-utgard-450-r7p0-r0p0-wayland.so libmali.so
	link_opengl
	link_opencl
	cd -
elif [ $RK_TARGET_PRODUCT == px3se ];then
	rm_so
	install -m 0644 -D /sdk/external/libmali/lib/arm-linux-gnueabihf/libmali-utgard-400-r7p0-r3p0-wayland.so /usr/lib/arm-linux-gnueabihf/
	install -m 0755 -D /sdk/external/libmali/overlay/S10libmali_px3se /usr/bin/S10libmali
	install -m 0755 -D /sdk/external/libmali/overlay/px3seBase /usr/sbin/
	cd /usr/lib/arm-linux-gnueabihf
	ln -s libmali-utgard-400-r7p0-r3p0-wayland.so libmali.so
	link_opengl
	cd -
elif [ $RK_TARGET_PRODUCT == rk3128 ];then
	rm_so
	install -m 0644 -D /sdk/external/libmali/lib/arm-linux-gnueabihf/libmali-utgard-400-r7p0-r1p1-wayland.so /usr/lib/arm-linux-gnueabihf/
	cd /usr/lib/arm-linux-gnueabihf
	ln -s libmali-utgard-400-r7p0-r1p1-wayland.so
	link_opengl
	cd -
elif [ $RK_TARGET_PRODUCT == rk3326 ] || [ $RK_TARGET_PRODUCT == px30 ];then
	if [ $RK_ARCH == arm64 ];then
		rm_so
		install -m 0644 -D /sdk/external/libmali/lib/aarch64-linux-gnu/libmali-bifrost-g31-rxp0-wayland-gbm.so /usr/lib/aarch64-linux-gnu/
		cd /usr/lib/aarch64-linux-gnu/
		ln -s libmali-bifrost-g31-rxp0-wayland-gbm.so libmali.so
		link_opengl
		link_opencl
		cd -
	elif [ $RK_ARCH == arm ];then
		rm_so
		install -m 0644 -D /sdk/external/libmali/lib/arm-linux-gnueabihf/libmali-bifrost-g31-rxp0-wayland-gbm.so /usr/lib/arm-linux-gnueabihf/
		cd /usr/lib/arm-linux-gnueabihf/
		ln -s libmali-bifrost-g31-rxp0-wayland-gbm.so libmali.so
		link_opengl
		link_opencl
		cd -
	fi
fi
