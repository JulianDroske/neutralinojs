#!/bin/sh

cd "$(dirname $0)"

ARCH=$1
# Trigger x64 build by default
if [ "$ARCH" = "" ]; then
    ARCH="x64"
fi

NEU_BIN="./bin/neutralino-linux_$ARCH"

if [ -e $NEU_BIN ]; then
    rm $NEU_BIN
fi

echo "Packing resources.neu..."

./scripts/make_res_neu.sh

NEU_FILE='bin/resources.neu'

# compile res
if [ ! -f "$NEU_FILE" ]; then
	echo "please build $NEU_FILE first"
	exit 1
fi

if ! ld -r -b binary -o "${NEU_FILE}.o" "$NEU_FILE" ;then
	echo "cannot compile resource file."
	exit 1
fi

echo "Compiling Neutralinojs $ARCH..."

g++ -DNEU_STATIC "${NEU_FILE}.o" \
	resources.cpp \
	helpers.cpp \
	main.cpp \
	server/router.cpp \
	server/neuserver.cpp \
	settings.cpp \
	extensions_loader.cpp \
	chrome.cpp \
	auth/authbasic.cpp \
	auth/permission.cpp \
	lib/tinyprocess/process.cpp \
	lib/tinyprocess/process_unix.cpp \
	lib/easylogging/easylogging++.cc \
	lib/platformfolders/platform_folders.cpp \
	lib/clip/clip.cpp \
	lib/clip/image.cpp \
	lib/clip/clip_x11.cpp \
	api/filesystem/filesystem.cpp \
	api/os/os.cpp \
	api/computer/computer.cpp \
	api/debug/debug.cpp \
	api/storage/storage.cpp \
	api/app/app.cpp \
	api/window/window.cpp \
	api/events/events.cpp \
	api/extensions/extensions.cpp \
	api/clipboard/clipboard.cpp \
	-pthread \
	-std=c++17 \
	-DELPP_NO_DEFAULT_LOG_FILE=1 \
	-DHAVE_XCB_XLIB_H \
	-DASIO_STANDALONE \
	-DWEBVIEW_GTK=1 \
	-DTRAY_APPINDICATOR=1 \
	`pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0 glib-2.0 ayatana-appindicator3-0.1 xcb x11` \
	-o $NEU_BIN \
	-no-pie \
	-Os \
	-I . \
	-I lib/asio/include \
	-I lib \
	-L lib

if [ -e $NEU_BIN ]; then
    echo "OK: Neutralino binary is compiled into $NEU_BIN"
else
    echo "ERR: Neutralino binary is not compiled"
    exit 1
fi
