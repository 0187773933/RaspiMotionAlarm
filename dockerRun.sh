#!/bin/bash
# https://linuxize.com/post/how-to-install-opencv-on-ubuntu-18-04/
# https://spltech.co.uk/how-to-access-the-raspberry-pi-camera-inside-docker-and-opencv/
# sudo docker rm motion-alarm -f || echo ""
sudo docker build -t motion-alarm .
sudo docker run -it \
-v ${PWD}/PythonVersion/built_wheels:/home/morphs/built_wheels \
-v /tmp/.X11-unix:/tmp/.X11-unix \
--device "/dev/video0:/dev/video0" \
motion-alarm
# https://askubuntu.com/a/1324570
#  --privileged
#--device "/dev/vchiq:/dev/vchiq" \