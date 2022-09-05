#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
ROOT=$SCRIPTPATH/../..
VENDOR=$ROOT/vendor

cd $VENDOR/github.com/FFmpeg/nv-codec-headers
make install

cd $VENDOR/github.com/GPUOpen-LibrariesAndSDKs/AMF
cp -r amf/public/include /usr/local/include/AMF

cd $VENDOR/github.com/Intel-Media-SDK/MediaSDK
cd api/mfx_dispatch/windows
sed -i 's/10.0.17134.0/10.0.22621.0/' libmfx_vs2015.vcxproj
msbuild libmfx_vs2015.vcxproj /p:PlatformToolset=v143 /p:Configuration=Release
cd ../../..
cp -r api/include /usr/local/include/mfx
cp ../build/win_x64/Release/lib/libmfx_vs2015.lib /usr/local/lib/libmfx.lib
