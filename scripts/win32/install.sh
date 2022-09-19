#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
ROOT=$SCRIPTPATH/../..
VENDOR=$ROOT/vendor
PREFIX=$ROOT/build/$TRIPLET

if [[ -z "$DEBUG" ]]; then
  CONFIG=Release
else
  PREFIX+=/debug
  CONFIG=Debug
fi

LIBDIR=$PREFIX/lib

if [[ $TRIPLET == *-static ]]; then
  BUILD_SHARED_LIBS="OFF"
  CMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>"
else
  BUILD_SHARED_LIBS="ON"
  CMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>DLL"
fi

rm /usr/bin/link.exe

cd $VENDOR/code.videolan.org/videolan/dav1d
mkdir build && cd build
configure="meson .. --prefix=$PREFIX -Denable_tests=false -Denable_tools=false"
if [[ $TRIPLET == *-static ]]; then
  configure+=" --default-library=static -Db_vscrt=static_from_buildtype"
fi
if [[ -z "$DEBUG" ]]; then
  configure+=" -Dbuildtype=release"
else
  configure+=" -Dbuildtype=debug"
fi
eval $configure
meson compile
meson install
mv $PREFIX/lib/libdav1d.a $PREFIX/lib/dav1d.lib

cd $VENDOR/github.com/FFmpeg/nv-codec-headers
make install
mv /usr/local/include/ffnvcodec $PREFIX/include/

cd $VENDOR/github.com/GPUOpen-LibrariesAndSDKs/AMF
cp -r amf/public/include $PREFIX/include/AMF

cd $VENDOR/github.com/Intel-Media-SDK/MediaSDK
cd api/mfx_dispatch/windows
sed -i 's/10.0.17134.0/10.0.22621.0/' libmfx_vs2015.vcxproj
MSBuild.exe libmfx_vs2015.vcxproj -p:PlatformToolset=v143 -p:Configuration=$CONFIG
cd ../../..
cp -r api/include /usr/local/include/mfx
mkdir -p $LIBDIR
mv ../build/win_x64/$CONFIG/lib/libmfx_vs2015.lib $LIBDIR/libmfx.lib

cd $VENDOR/github.com/mstorsjo/fdk-aac
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=$CONFIG -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS \
  -DCMAKE_MSVC_RUNTIME_LIBRARY=$CMAKE_MSVC_RUNTIME_LIBRARY \
  -DCMAKE_INSTALL_PREFIX=$PREFIX
cmake --build . --config $CONFIG
cmake --install . --config $CONFIG

cd $VENDOR/code.videolan.org/videolan/x264
configure="CC=cl ./configure --prefix=$PREFIX --disable-cli --enable-pic"
if [[ $TRIPLET == *-static ]]; then
  configure+=" --enable-static"
else
  configure+=" --enable-shared"
fi
if [[ ! -z "$DEBUG" ]]; then
  configure+=" --enable-debug"
fi
eval $configure
make clean
make -j
make install

cd $VENDOR/bitbucket.org/multicoreware/x265_git
cd source
git fetch --tags
sed -i 's/C_FLAGS_RELEASE/& CMAKE_CXX_FLAGS_DEBUG CMAKE_C_FLAGS_DEBUG/' CMakeLists.txt
mkdir build
cd build
if [[ $TRIPLET == *-static ]]; then
  STATIC_LINK_CRT="ON"
else
  STATIC_LINK_CRT="OFF"
fi
cmake .. -DCMAKE_BUILD_TYPE=$CONFIG -DSTATIC_LINK_CRT=$STATIC_LINK_CRT \
  -DENABLE_SHARED=$BUILD_SHARED_LIBS \
  -DCMAKE_MSVC_RUNTIME_LIBRARY=$CMAKE_MSVC_RUNTIME_LIBRARY \
  -DCMAKE_INSTALL_PREFIX=$PREFIX -DENABLE_CLI=OFF
cmake --build . --config $CONFIG
cmake --install . --config $CONFIG
if [[ $TRIPLET == *-static ]]; then
  mv $LIBDIR/x265-static.lib $LIBDIR/libx265.lib
else
  mv $LIBDIR/x265-shared.lib $LIBDIR/libx265.lib
fi
