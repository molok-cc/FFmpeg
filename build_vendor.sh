#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

export CMAKE_GENERATOR=Ninja
export CMAKE_BUILD_TYPE=Release

alias cmake="cmake -G$CMAKE_GENERATOR -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE"

check() {
  if [ $? -ne 0 ]; then
    exit
  fi
}

cd $SCRIPTPATH/vendor/aomedia.googlesource.com/aom
mkdir cmake-build
cd cmake-build
cmake ..
ninja install
check

cd $SCRIPTPATH/vendor/gitlab.com/AOMediaCodec/SVT-AV1
mkdir cmake-build
cd cmake-build
cmake ..
ninja install
check

cd $SCRIPTPATH/vendor/github.com/google/shaderc
./utils/git-sync-deps
mkdir cmake-build
cd cmake-build
cmake -DSHADERC_SKIP_TESTS=ON -DSHADERC_SKIP_EXAMPLES=ON \
  -DSHADERC_SKIP_COPYRIGHT_CHECK=ON ..
ninja install
check

cd $SCRIPTPATH/vendor
TF_PKG=libtensorflow-gpu-linux-x86_64-2.7.0.tar.gz
curl -O https://storage.googleapis.com/tensorflow/libtensorflow/$TF_PKG
tar -C /usr/local -xzf $TF_PKG
check

cd $SCRIPTPATH/vendor/github.com/Netflix/vmaf/libvmaf
meson build --buildtype release
ninja -vC build install
check

cd $SCRIPTPATH/vendor/github.com/sekrit-twc/zimg
./autogen.sh
./configure
make -j install
check

cd $SCRIPTPATH/vendor/git.videolan.org/git/ffmpeg/nv-codec-headers
make install
check
