#!/bin/sh

export PATH="/usr/bin:$PATH"

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

if [ -z "$TRIPLET" ]; then
  TRIPLET=x64-windows
fi

# CC=clang-cl
# CXX=clang++-cl

ROOT=$SCRIPTPATH/../..
VENDOR=$ROOT/vendor
PREFIX=$ROOT/build/$TRIPLET
INCDIR=$PREFIX/include
LIBDIR=$PREFIX/lib

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$LIBDIR/pkgconfig:/usr/local/lib/pkgconfig

ECFLAGS="-I$INCDIR"
ELDFLAGS="-LIBPATH:$LIBDIR"

cd $ROOT

configure="
  ./configure \
    --enable-gpl --enable-version3 --enable-nonfree \
    --enable-libdav1d --enable-libfdk-aac --enable-libx264 --enable-libx265 \
    --enable-libmfx \
    --toolchain=msvc \
    --cc=$CC \
    --enable-pic \
    --enable-hardcoded-tables
"

if [[ $TRIPLET == *-static ]]; then
  configure+=" --pkg-config-flags=--static"
  # MSVC_RUNTIME_LIBRARY="MT"
  # ELDFLAGS+=" -NODEFAULTLIB:MSVCRT"
else
  configure+=" --enable-shared"
  # MSVC_RUNTIME_LIBRARY="MD"
fi

if [ -z "$DEBUG" ]; then
  configure+=" --prefix=$PREFIX"
else
  configure+="
    --prefix=$PREFIX/debug
    --enable-debug
    --disable-optimizations
    --disable-stripping
  "
  # MSVC_RUNTIME_LIBRARY+="d"
fi

# ECFLAGS+=" -$MSVC_RUNTIME_LIBRARY"
configure+=" --extra-cflags=\"$ECFLAGS\" --extra-ldflags=\"$ELDFLAGS\""

# echo $configure
# exit 0

eval $configure

# exit 0

make clean
make -j
make install
