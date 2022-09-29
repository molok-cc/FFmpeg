#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
if [ -z "$TRIPLET" ]; then
  TRIPLET=arm64-android
fi
ROOT=`realpath $SCRIPTPATH/../..`
PREFIX=$ROOT/build/$TRIPLET

HOST_TAG=linux-x86_64
ARCH=aarch64
TARGET=$ARCH-linux-android33

CC=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST_TAG/bin/$TARGET-clang
CXX=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST_TAG/bin/$TARGET-clang++

cd $ROOT
./configure --prefix=$PREFIX \
  --enable-gpl --enable-version3 --enable-nonfree \
  --enable-cross-compile \
  --arch=$ARCH \
  --target-os=android \
  --cc=$CC \
  --cxx=$CXX \
  --extra-cflags="-I$PREFIX/include -fvisibility=hidden" \
  --extra-ldflags="-L$PREFIX/lib" \
  --enable-pic

make -j
make install
