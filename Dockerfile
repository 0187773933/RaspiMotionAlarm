#FROM ubuntu:latest
FROM debian:stable-slim
RUN apt-get update -y
RUN apt-get install gcc -y
RUN apt-get install nano -y
RUN apt-get install tar -y
RUN apt-get install bash -y
RUN apt-get install sudo -y
RUN apt-get install openssl -y
RUN apt-get install git -y
RUN apt-get install make -y
RUN apt-get install cmake -y
RUN apt-get install gfortran -y
RUN apt-get install pkg-config -y
RUN apt-get install wget -y
RUN apt-get install curl -y
RUN apt-get install unzip -y
RUN apt-get install net-tools -y
RUN apt-get install iproute2 -y
RUN apt-get install iputils-ping -y
# Programming Languages , Python Comes Pre-Packaged Now
# RUN apt-get install golang-go -y
# Apparently, gocv.io requires go 1.11.6
# and 11JUN2021 , apt-get installs
# we installed a specific version of go somewhere in a docker
RUN apt-get install python-pip -y
RUN apt-get install python3-pip -y
RUN apt-get install python3-venv -y
RUN apt-get install build-essential -y
RUN apt-get install python3-dev -y
RUN apt-get install python3-setuptools -y
RUN apt-get install python3-smbus -y
RUN apt-get install python3-numpy -y
RUN apt-get install python3-scipy -y
RUN apt-get install libncursesw5-dev -y
RUN apt-get install libgdbm-dev -y
RUN apt-get install libc6-dev -y
RUN apt-get install zlib1g-dev -y
RUN apt-get install libsqlite3-dev -y
RUN apt-get install tk-dev -y
RUN apt-get install libssl-dev -y
RUN apt-get install openssl -y
RUN apt-get install libffi-dev -y

# OpenCV Stuff
RUN apt-get install libsm6 -y
RUN apt-get install libxrender1 -y
RUN apt-get install libfontconfig1 -y
RUN apt-get install libopencv-dev -y
RUN apt-get install python3-opencv -y
RUN apt-get install yasm -y
RUN apt-get install ffmpeg -y
RUN apt-get install libswscale-dev -y
RUN apt-get install libtbb2 -y
RUN apt-get install libtbb-dev -y
RUN apt-get install libjpeg-dev -y
RUN apt-get install libpng-dev -y
RUN apt-get install libtiff-dev -y
RUN apt-get install libavformat-dev -y
RUN apt-get install libpq-dev -y
RUN apt-get install libxvidcore-dev -y
RUN apt-get install libx264-dev -y
RUN apt-get install libavcodec-dev -y
RUN apt-get install libv4l-dev -y
RUN apt-get install libgtk-3-dev -y
RUN apt-get install libdc1394-22-dev -y
RUN apt-get install libjpeg62 -y
RUN apt-get install libopenjp2-7 -y
RUN apt-get install libilmbase-dev -y
# RUN apt-get install libilmbase24 -y
RUN apt-get install libatlas-base-dev -y
RUN apt-get install libgstreamer1.0-dev -y
RUN apt-get install openexr -y
RUN apt-get install libopenexr-dev -y

ENV TZ="US/Eastern"
ARG USERNAME="morphs"
ARG PASSWORD="asdfasdf"
RUN useradd -m $USERNAME -p $PASSWORD -s "/bin/bash"
RUN mkdir -p /home/$USERNAME
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME
RUN usermod -aG sudo $USERNAME
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME
COPY ./PythonVersion /home/$USERNAME/PythonVersion
COPY ./GoVersion /home/$USERNAME/GoVersion
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/PythonVersion
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/GoVersion
RUN python3 -m pip install requests
RUN python3 -m pip install imutils
RUN python3 -m pip install redis

# Build OpenCV for GoVersion
RUN mkdir -p /home/$USERNAME/opencv/
WORKDIR /home/$USERNAME/opencv/
ENV OPENCV_VERSION="4.5.0"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
RUN unzip ${OPENCV_VERSION}.zip
WORKDIR /home/$USERNAME/opencv/opencv-$OPENCV_VERSION
RUN mkdir -p /home/$USERNAME/opencv/opencv-$OPENCV_VERSION/cmake_binary
WORKDIR /home/$USERNAME/opencv/opencv-$OPENCV_VERSION/cmake_binary
RUN cmake \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D PYTHON_EXECUTABLE=$(which python3) \
-D WITH_CUDA=OFF \
-D CMAKE_BUILD_TYPE=RELEASE \
-D BUILD_PYTHON_SUPPORT=ON \
-D CMAKE_INSTALL_PREFIX=/usr \
-D INSTALL_C_EXAMPLES=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D BUILD_PYTHON_SUPPORT=ON \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
-D WITH_TBB=ON \
-D WITH_PTHREADS_PF=ON \
-D WITH_OPENNI=OFF \
-D WITH_OPENNI2=ON \
-D WITH_EIGEN=ON \
-D BUILD_DOCS=ON \
-D BUILD_TESTS=ON \
-D BUILD_PERF_TESTS=ON \
-D BUILD_EXAMPLES=ON \
-D WITH_OPENCL=$OPENCL_ENABLED \
-D USE_GStreamer=ON \
-D WITH_GDAL=ON \
-D WITH_CSTRIPES=ON \
-D ENABLE_FAST_MATH=1 \
-D WITH_OPENGL=ON \
-D WITH_QT=OFF \
-D WITH_IPP=OFF \
-D WITH_FFMPEG=ON \
-D WITH_PROTOBUF=ON \
-D BUILD_PROTOBUF=ON \
-D CMAKE_SHARED_LINKER_FLAGS=-Wl,-Bsymbolic \
-D WITH_V4L=ON ..
# -D WITH_NGRAPH=ON \
#make -j $(nproc) && \
RUN make
RUN sudo make install
RUN sudo ldconfig
RUN sudo chown $USERNAME:video /dev/video0
# # RUN rm /${OPENCV_VERSION}.zip
# # RUN rm -r /opencv-${OPENCV_VERSION}

# ENV DISPLAY=:10.0
# # ENTRYPOINT [ "/usr/bin/python3" , "/home/$USERNAME/main.py" ]
ENTRYPOINT [ "/bin/bash" ]