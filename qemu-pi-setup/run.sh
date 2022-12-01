#!/bin/sh

QEMU=qemu-system-aarch64

get_qemu_version() {
	"$QEMU" --version | perl -ne 'print $1 if /version (\S+)/'
}

check_version_at_least() {
	V="$( (echo "$1" ; get_qemu_version) | sort -V | head -1 )"
	test "$V" = "$1"
	return $?
}

cd "$HOME"

# Target root with kernel and dtbs
ROOTFS=rootfs
# Target downloaded zip
TARGET=raspios_lite_armhf_latest.zip
# Port to forward ssh to
SSHPORT=50022
# Enable or disable GPIO management
ENABLEQTEST=true
#ENABLEQTEST=false
QTESTSOCKET="/tmp/tmp-gpio.sock"

IMGNAME="$(7z l "$TARGET" | awk '/  raspios/{print $NF}')"
echo "[ ] root image: $IMGNAME"

BOOTPARAMS=""
# Console and system prints
#BOOTPARAMS="$BOOTPARAMS kgdboc=ttyAMA0,115200"
BOOTPARAMS="$BOOTPARAMS console=ttyAMA0,115200"
BOOTPARAMS="$BOOTPARAMS earlyprintk"
BOOTPARAMS="$BOOTPARAMS loglevel=8"
# Root and fs
BOOTPARAMS="$BOOTPARAMS rw"
BOOTPARAMS="$BOOTPARAMS root=/dev/mmcblk0p2"
BOOTPARAMS="$BOOTPARAMS rootwait"
BOOTPARAMS="$BOOTPARAMS rootfstype=ext4"
#BOOTPARAMS="$BOOTPARAMS init=/bin/sh"

NETPARAMS=""

# From qemu 5.1.0 usb-net was implemented
if check_version_at_least "5.1.0"; then
	NETPARAMS="$NETPARAMS -device usb-net,netdev=net0"
	NETPARAMS="$NETPARAMS -netdev user,id=net0,hostfwd=tcp:127.0.0.1:$SSHPORT-:22"
fi

QTESTPARAMS=""
if $ENABLEQTEST; then
	QTESTPARAMS="$QTESTPARAMS -qtest unix:$QTESTSOCKET"
fi

LOGPARAMS=""
if $LOGPARAMS; then
	LOGPARAMS="$LOGPARAMS -D /tmp/qemu.log"
	LOGPARAMS="$LOGPARAMS -d guest_errors"
fi

SERIAL=""
SERIAL="$SERIAL -curses"
SERIAL="$SERIAL -serial stdio"
SERIAL="$SERIAL -monitor unix:/tmp/monitor.sock"

"$QEMU"                                                   \
	-curses                                           \
	$SERIAL                                           \
	-M       raspi3b                                  \
	-dtb     "$ROOTFS/bcm2710-rpi-3-b-plus.dtb"       \
	-kernel  "$ROOTFS/kernel8.img"                    \
	-append  "$BOOTPARAMS"                            \
	-drive   "file=$IMGNAME,if=sd,format=raw,index=0" \
	$NETPARAMS                                        \
	$QTESTPARAMS                                      \
	$LOGPARAMS                                        \
	;
