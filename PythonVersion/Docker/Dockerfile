FROM alpine:latest
RUN apk add bash
RUN apk add wget
RUN apk add tar
RUN apk add curl
RUN apk add gcc
RUN apk add nano
RUN apk add build-base
RUN apk add linux-headers
RUN apk add musl-dev
RUN apk add make
RUN apk add autoconf
RUN apk add zlib
RUN apk add zlib-dev
RUN apk add g++
RUN apk add git
RUN apk add openssl
RUN apk add openssl-dev
RUN apk add sqlite-dev
RUN apk add libffi
RUN apk add libffi-dev
# RUN apk add libxml2-dev
# RUN apk add libxslt-dev
WORKDIR /home
ARG PYTHON_VERSION="3.8.5"
ARG PYTHON_VERSION_MAJOR="3.8"
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
RUN tar -xf Python-$PYTHON_VERSION.tgz
WORKDIR /home/Python-$PYTHON_VERSION
RUN ./configure --enable-optimizations --prefix=/opt/python-$PYTHON_VERSION
# RUN make -j 8
# RUN make -j 8 install
RUN make
RUN make install
RUN /opt/python-$PYTHON_VERSION/bin/pip$PYTHON_VERSION_MAJOR install pip -U
RUN /opt/python-$PYTHON_VERSION/bin/pip$PYTHON_VERSION_MAJOR install setuptools -U
RUN /opt/python-$PYTHON_VERSION/bin/pip$PYTHON_VERSION_MAJOR install wheel
RUN ln -s /opt/python-$PYTHON_VERSION/bin/python$PYTHON_VERSION_MAJOR /usr/local/bin/python
RUN ln -s /opt/python-$PYTHON_VERSION/bin/python$PYTHON_VERSION_MAJOR /usr/local/bin/python3
WORKDIR /home
RUN git clone https://github.com/numpy/numpy.git
WORKDIR /home/numpy
RUN
# bdist_wheel
# https://github.com/numpy/numpy/blob/main/INSTALL.rst.txt#ubuntu-debian
# https://github.com/raspi-chromecast-box/Alpine-Linux-lxml-whl-4.5.0/blob/master/Alpine-lxml-Build-whl-Notes.md
# https://numpy.org/doc/stable/user/building.html
# https://github.com/numpy/numpy/blob/main/setup.py
python setup.py build -j 4 install --prefix $HOME/.local
wget https://github.com/lxml/lxml/archive/lxml-4.5.0.tar.gz
tar -xf lxml-4.5.0.tar.gz
cd lxml-lxml-4.5.0

