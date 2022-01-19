#!/bin/sh

export CC=clang CXX=clang++
export CFLAGS="-Ofast"
export CXXFLAGS="$CFLAGS"

check() {
  if [ $? -ne 0 ]; then
    exit
  fi
}

./configure.sh
check
make -j install
check
