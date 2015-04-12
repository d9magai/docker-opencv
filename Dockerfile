FROM centos
MAINTAINER d9magai

ENV OPENCV_PREFIX /opt/opencv
ENV OPENCV_SRC_DIR $OPENCV_PREFIX/src

ENV OPENCV_ARCHIVE opencv.zip
ENV OPENCV_ARCHIVE_URL https://github.com/Itseez/opencv/archive/3.0.0-beta.zip
ENV OPENCV_CONTRIB_ARCHIVE opencv_contrib.zip
ENV OPENCV_CONTRIB_ARCHIVE_URL https://github.com/Itseez/opencv_contrib/archive/3.0.0-beta.zip

RUN yum update -y && yum install -y \
    unzip \
    make \
    cmake \
    gcc-c++ \
    && yum clean all

RUN mkdir -p $OPENCV_SRC_DIR \
    && cd $OPENCV_SRC_DIR \
    && curl -sL https://github.com/Itseez/opencv/archive/3.0.0-beta.zip -o $OPENCV_ARCHIVE \
    && curl -sL https://github.com/Itseez/opencv_contrib/archive/3.0.0-beta.zip -o $OPENCV_CONTRIB_ARCHIVE \
    && unzip $OPENCV_ARCHIVE \
    && unzip $OPENCV_CONTRIB_ARCHIVE \
    && OPENCV_CONTRIB_PATH=`pwd`"/"`unzip -l $OPENCV_CONTRIB_ARCHIVE | head -5 | tail -1 | awk '{print$4}'`"modules" \
    && cd `unzip -l $OPENCV_ARCHIVE | head -5 | tail -1 | awk '{print$4}'` \
    && cmake -DOPENCV_EXTRA_MODULES_PATH=$OPENCV_CONTRIB_PATH -DCMAKE_INSTALL_PREFIX=$OPENCV_PREFIX . \
    && make \
    && make install \
    && rm -rf $OPENCV_SRC_DIR

RUN echo "$OPENCV_PREFIX/lib" > /etc/ld.so.conf.d/opencv.conf && ldconfig

