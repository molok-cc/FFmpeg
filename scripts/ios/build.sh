#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
if [ -z "$TRIPLET" ]; then
  TRIPLET=arm64-ios
fi
ROOT=`realpath $SCRIPTPATH/../..`
PREFIX=$ROOT/build/$TRIPLET
LIBDIR=$PREFIX/lib

SDK_NAME=iphoneos
ARCH=arm64

CC="xcrun -sdk $SDK_NAME clang"
CFLAGS="-arch $ARCH -I$PREFIX/include -fvisibility=hidden"
LDFLAGS="-arch $ARCH -L$LIBDIR"

mkdir -p $LIBDIR

cd $ROOT
./configure --prefix=$PREFIX \
  --enable-gpl --enable-version3 --enable-nonfree \
  --enable-small --disable-runtime-cpudetect \
  --disable-audiotoolbox \
  --arch=$ARCH \
  --enable-cross-compile \
  --target-os=darwin \
  --cc="$CC" \
  --extra-cflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --enable-pic

cat ffbuild/config.log

# make -j
# make install
