#!/bin/bash
# This is to create an alpine image for the sole purpose of
# "pre-building" numpy , etc as wheels for a perticular raspi-wheel-tag
# so , I think , if you run this docker thing on a device you are trying to target , it should
# build a wheel for it.
# somehow do this in qemu / docker? virtual arch ,
# where python3 cp38 linux_armv7l numpy whl ?
#
name="alpine-py-wheel-builder"
sudo docker rm $name -f || echo ""
sudo docker build -t $name .
sudo docker run -it \
-v ${PWD}/built_wheels:/home/morphs/built_wheels \
$name
# sudo docker run -dit \
# --name lxml-build \
# -v /home/morphs/DOCKER_VOLUME/:/home \
# alpine:latest