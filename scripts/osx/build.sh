#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
if [ -z "$TRIPLET" ]; then
  TRIPLET=x64-osx
fi
ROOT=`realpath $SCRIPTPATH/../..`
PREFIX=$ROOT/build/$TRIPLET

CFLAGS="-fvisibility=hidden"

cd $ROOT
./configure --prefix=$PREFIX \
  --enable-gpl --enable-version3 --enable-nonfree \
  --extra-cflags="$CFLAGS" \
  --enable-pic \
  --enable-hardcoded-tables

make -j
make install
