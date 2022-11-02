#!/bin/sh

export PATH="/usr/bin:$PATH"

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

if [ -z "$TRIPLET" ]; then
  TRIPLET=x64-windows
fi

# CC=clang-cl
# CXX=clang++-cl

ROOT=`realpath $SCRIPTPATH/../..`
VENDOR=$ROOT/vendor
PREFIX=$ROOT/build/$TRIPLET

if [[ ! -z "$DEBUG" ]]; then
  PREFIX+=/debug
fi

INCDIR=$PREFIX/include
LIBDIR=$PREFIX/lib

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$LIBDIR/pkgconfig:/usr/local/lib/pkgconfig

ECFLAGS="-I$INCDIR"
ELDFLAGS="-LIBPATH:$LIBDIR"

cd $ROOT

configure="
  ./configure --prefix=$PREFIX \
    --enable-gpl --enable-version3 --enable-nonfree \
    --enable-libdav1d --enable-libfdk-aac --enable-libx264 --enable-libx265 \
    --enable-libmfx \
    --toolchain=msvc \
    --enable-pic \
    --enable-hardcoded-tables
"

if [ ! -z "$CC" ]; then
  configure+=" --cc=$CC"
fi

if [ ! -z "$CXX" ]; then
  configure+=" --cxx=$CXX"
fi

if [[ $TRIPLET == *-static ]]; then
  configure+=" --pkg-config-flags=--static"
  # MSVC_RUNTIME_LIBRARY="MT"
  # ELDFLAGS+=" -NODEFAULTLIB:MSVCRT"
else
  configure+=" --enable-shared"
  # MSVC_RUNTIME_LIBRARY="MD"
fi

if [ ! -z "$DEBUG" ]; then
  configure+="
    --enable-debug
    --disable-optimizations
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

mv $LIBDIR/libavdevice.a $LIBDIR/avdevice.lib
mv $LIBDIR/libavfilter.a $LIBDIR/avfilter.lib
mv $LIBDIR/libavformat.a $LIBDIR/avformat.lib
mv $LIBDIR/libavcodec.a $LIBDIR/avcodec.lib
mv $LIBDIR/libpostproc.a $LIBDIR/postproc.lib
mv $LIBDIR/libswresample.a $LIBDIR/swresample.lib
mv $LIBDIR/libswscale.a $LIBDIR/swscale.lib
mv $LIBDIR/libavutil.a $LIBDIR/avutil.lib
