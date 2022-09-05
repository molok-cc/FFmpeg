#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

TRIPLET=$1
DEBUG=$2

if [ -z "$TRIPLET" ]; then
  TRIPLET=x64-windows
fi

# CC=clang-cl
# CXX=clang++-cl

cd ${SCRIPTPATH}/../..

configure="
  ./configure \
    --enable-gpl --enable-version3 --enable-nonfree \
    --arch=x86_64 \
    --target-os=win64 --toolchain=msvc \
    --cc=$CC \
    --cxx=$CXX \
    --enable-pic \
    --enable-hardcoded-tables
"

if [[ $TRIPLET != *-static ]]; then
  configure+=" --enable-shared"  
fi

if [ -z "$DEBUG" ]; then
  configure+=" --prefix=$SCRIPTPATH/../../build/${TRIPLET}"
else
  configure+="
    --prefix=$SCRIPTPATH/../../build/${TRIPLET}/debug
    --enable-debug
    --disable-optimizations
    --disable-stripping
  "
fi

# echo $configure
# exit 0

eval $configure

make clean
make -j
make install
