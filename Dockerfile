FROM centos
MAINTAINER d9magai

ENV OPENCV_PREFIX /opt/opencv
ENV OPENCV_SRC_DIR $OPENCV_PREFIX/src
ENV OPENCV_VERSION 3.0.0
ENV OPENCV_BASENAME opencv-$OPENCV_VERSION
ENV OPENCV_ARCHIVE $OPENCV_BASENAME.tar.gz
ENV OPENCV_ARCHIVE_URL https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.tar.gz

RUN yum update -y && yum install -y \
    tar \
    make \
    cmake \
    gcc-c++ \
    && yum clean all

RUN mkdir -p $OPENCV_SRC_DIR \
    && cd $OPENCV_SRC_DIR \
    && curl -o $OPENCV_ARCHIVE -L $OPENCV_ARCHIVE_URL \
    && tar xvf $OPENCV_ARCHIVE \
    && cd $OPENCV_BASENAME \
    && cmake -DCMAKE_INSTALL_PREFIX=$OPENCV_PREFIX . \
    && make \
    && make install \
    && rm -rf $OPENCV_SRC_DIR

RUN echo "$OPENCV_PREFIX/lib" > /etc/ld.so.conf.d/opencv.conf && ldconfig

