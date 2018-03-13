FROM ubuntu
MAINTAINER d9magai

ENV OPENCV_VERSION 3.4.1
ENV OPENCV_ARCHIVE_URL https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz

RUN deps='\
         gcc \
         g++ \
         make \
         cmake \
         pkg-config \
         python3.5-dev \
         curl \
         ca-certificates \
         ' \
    && set -x \
    && apt update -qq \
    && apt install -y -qq $deps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sL bootstrap.pypa.io/get-pip.py | python3.5 \
    && pip3 install numpy

RUN curl -sL $OPENCV_ARCHIVE_URL | tar xz -C /tmp \
    && mkdir -p /tmp/opencv-${OPENCV_VERSION}/build \
    && cd /tmp/opencv-${OPENCV_VERSION}/build \
    && cmake .. \
       -DBUILD_DOCS=OFF \
       -DBUILD_EXAMPLES=OFF \
       -DBUILD_TESTS=OFF \
       -DBUILD_PERF_TESTS=OFF \
       -DBUILD_WITH_DEBUG_INFO=OFF \
    && make -s \
    && make -s install \
    && rm -rf /tmp/opencv-${OPENCV_VERSION}

