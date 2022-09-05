#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
ROOT=$SCRIPTPATH/../..
VENDOR=$ROOT/vendor

cd $VENDOR/github.com/FFmpeg/nv-codec-headers
make install

cd $VENDOR/github.com/GPUOpen-LibrariesAndSDKs/AMF
cp -r amf/public/include /usr/local/include/AMF
