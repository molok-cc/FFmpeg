#!/bin/sh

CUDA_INCLUDE=/usr/local/cuda/include
CUDA_LIBRARY_DIR=/usr/local/cuda/lib64

CFLAGS="$CFLAGS -I$CUDA_INCLUDE"
CXXFLAGS="$CXXFLAGS -I$CUDA_INCLUDE"
LDFLAGS="$LDFLAGS -L$CUDA_LIBRARY_DIR"

./configure \
  --enable-gpl --enable-version3 --enable-nonfree \
  --enable-libaom \
  --enable-libass \
  --enable-libdav1d \
  --enable-libfdk-aac \
  --enable-libfontconfig \
  --enable-libfreetype \
  --enable-libfribidi \
  --enable-libopus \
  --enable-librtmp \
  --enable-libshaderc \
  --enable-libsmbclient \
  --enable-libsoxr \
  --enable-libsrt \
  --enable-libssh \
  --enable-libsvtav1 \
  --enable-libtensorflow \
  --enable-libvmaf \
  --enable-libvpx \
  --enable-libwebp \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libxml2 \
  --enable-libzimg \
  --enable-openssl \
  --enable-cuvid \
  --enable-ffnvcodec \
  --enable-libnpp \
  --enable-nvdec \
  --enable-nvenc \
  --cc=$CC \
  --extra-cflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --enable-hardcoded-tables

make -j
sudo make install
