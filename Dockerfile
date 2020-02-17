FROM ubuntu:18.04

ARG OPENCV_VERSION=2.4.13.6
ARG WORKSPACE=/root/workspace
ARG NTHREADS=4


RUN mkdir -p $WORKSPACE

RUN apt-get update
RUN apt-get -y install wget cmake


# install OpenCV

WORKDIR $WORKSPACE

RUN apt-get -y install clang libgtk2.0-dev pkg-config

RUN wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz \
    && tar xvf $OPENCV_VERSION.tar.gz \
    && cd opencv-$OPENCV_VERSION/ \
    && mkdir -p release \
    && cd release \
    && cmake .. \
    && make -j$NTHREADS \
    && make install \
    && cd ../../ \
    && rm $OPENCV_VERSION.tar.gz \
    && rm -r opencv-$OPENCV_VERSION


WORKDIR $WORKSPACE

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y libeigen3-dev freeglut3-dev libglew-dev

# Pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git && \
    cd Pangolin && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# install ORB-SLAM
RUN git clone https://github.com/IshitaTakeshi/ORB_SLAM2.git \
    && cd ORB_SLAM2/ \
    && git checkout refactor \
    && ./build.sh

WORKDIR $WORKSPACE/ORB_SLAM2
