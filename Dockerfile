FROM ghcr.io/molok-cc/ffmpeg:dev
WORKDIR /root/ffmpeg
RUN ./build.sh

FROM nvidia/cuda:11.7.0-runtime-ubuntu22.04
ENV TZ=Etc/UTC
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libass9 libdav1d5 libfdk-aac2 libopus0 \
  librtmp1 libsmbclient libsoxr0 libsrt1.4-openssl \
  libvpx7 libwebp7 libwebpmux3 libx264-163 libx265-199 \
  libxml2 \
  && rm -rf /var/lib/apt/lists/*
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
COPY --from=0 \
  /usr/local/lib/x86_64-linux-gnu/libvmaf.so.1 \
  /usr/local/lib/libzimg.so.2 \
  /usr/local/lib/libtensorflow.so.2 \
  /usr/local/lib/libtensorflow_framework.so.2 \
  /usr/local/lib/libSvtAv1Enc.so.1 \
  /usr/local/lib/
COPY --from=0 \
  /root/ffmpeg/ffmpeg \
  /root/ffmpeg/ffprobe \
  /usr/local/bin/
LABEL org.opencontainers.image.source=https://github.com/molok-cc/FFmpeg
