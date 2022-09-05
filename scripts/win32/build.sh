#!/bin/sh

export PATH="/usr/bin:$PATH"

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

DEBUG=$1

if [ -z "$TRIPLET" ]; then
  TRIPLET=x64-windows
fi

# CC=clang-cl
# CXX=clang++-cl

ROOT=$SCRIPTPATH/../..
VENDOR=$ROOT/vendor

ECFLAGS=-I"$VENDOR/git.videolan.org/git/ffmpeg/nv-codec-headers/include"

cd $ROOT

configure="
  ./configure \
    --enable-gpl --enable-version3 --enable-nonfree --disable-doc \
    --enable-ffnvcodec \
    --arch=x86_64 \
    --target-os=win64 --toolchain=msvc \
    --cc=$CC \
    --cxx=$CXX \
    --extra-cflags=$ECFLAGS \
    --extra-cxxflags=$ECFLAGS \
    --enable-pic \
    --enable-hardcoded-tables
"

if [[ $TRIPLET == *-static ]]; then
  configure+=" --pkg-config-flags=--static"
else
  configure+=" --enable-shared"  
fi

if [ -z "$DEBUG" ]; then
  configure+=" --prefix=$SCRIPTPATH/../../build/$TRIPLET"
else
  configure+="
    --prefix=$SCRIPTPATH/../../build/$TRIPLET/debug
    --enable-debug
    --disable-optimizations
    --disable-stripping
  "
fi

# echo $configure
# exit 0

eval $configure

# exit 0

make clean
make -j
make install
