https://github.com/48723247842/RedisCirclularList

https://blog.tensorflow.org/2021/05/next-generation-pose-detection-with-movenet-and-tensorflowjs.html

https://tfhub.dev/google/movenet/singlepose/lightning/3
https://tfhub.dev/google/movenet/singlepose/thunder/3

https://includehealth.com/

```bash
sudo apt-get install python3-dev python3-venv python3-numpy -y
python3 -v venv venv
sudo apt-get install python3-numpy
```

https://www.piwheels.org/simple/numpy/
https://www.piwheels.org/simple/numpy/numpy-1.20.0-cp37-cp37m-linux_armv7l.whl#sha256=bd08254aac78b363b14acac456038ce6438bad848e02b275837930115e41ea21


https://stackoverflow.com/a/63410157
source venv/bin/activate
pip install wheel==0.34.1
python -c "import wheel.pep425tags as w; print(w.get_supported(archive_root=''))" | sed -zE 's/\),/),\n/g'

#### https://stackoverflow.com/a/40492425
#### https://www.piwheels.org/project/opencv-python/
#### https://github.com/EdjeElectronics/TensorFlow-Object-Detection-on-the-Raspberry-Pi/issues/18
sudo apt-get install build-essential cmake git pkg-config \
libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk-3-dev \
libtbb2 libtbb-dev libdc1394-22-dev libjpeg62 libopenjp2-7 libilmbase-dev \
libilmbase24 libatlas-base-dev libgstreamer1.0-dev \
gfortran openexr libopenexr-dev libilmbase-dev \
python3-dev python3-numpy python3-scipy -y

screen
pyenv install 3.7.3
<!-- pyenv virtualenv 3.7.3 motion-alarm-venv
echo "3.7.3/envs/motion-alarm-venv" > .python-version -->
virtualenv -p /home/morphs/.pyenv/versions/3.7.3/bin/python3.7 venv
pip install numpy-1.20.3-cp37-cp37m-linux_armv7l.whl
<!-- pip install opencv_python-4.5.1.48-cp37-cp37m-linux_armv7l.whl -->
pip install opencv-python --no-cache-dir
pip install requests imutils redis



### https://www.instructables.com/Build-Docker-Image-for-Raspberry-Pi/
### https://www.docker.com/blog/multi-arch-images/