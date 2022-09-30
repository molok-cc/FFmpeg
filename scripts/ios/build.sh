#!/bin/sh

realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
if [ -z "$TRIPLET" ]; then
  TRIPLET=arm64-ios
fi
ROOT=`realpath $SCRIPTPATH/../..`
PREFIX=$ROOT/build/$TRIPLET

SDK_NAME=iphoneos
ARCH=arm64

CC="xcrun -sdk $SDK_NAME clang"
CFLAGS="-I$PREFIX/include -fvisibility=hidden"
LDFLAGS="-L$PREFIX/lib"

cd $ROOT
./configure --prefix=$PREFIX \
  --enable-gpl --enable-version3 --enable-nonfree \
  --enable-small --disable-runtime-cpudetect \
  --enable-cross-compile \
  --arch=$ARCH \
  --target-os=darwin \
  --cc="$CC" \
  --extra-cflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --enable-pic

cat ffbuild/config.log

make -j
make install
