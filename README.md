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


https://github.com/duo-labs/webauthn


mkdir gobuild && cd gobuild && wget https://golang.org/dl/go1.16.5.linux-armv6l.tar.gz && \
tar -xf go1.16.5.linux-armv6l.tar.gz && cd ..

go run main.go
sudo nano +2009 ~/go/pkg/mod/gocv.io/x/gocv\@v0.25.0/core.go
https://github.com/mattn/go-sqlite3/commit/09259a5557fed04432cc35a10dd3b300ebc119e9




sudo docker exec -it 0d6efb14a349 bash



wget https://storage.googleapis.com/tfhub-lite-models/google/lite-model/movenet/singlepose/lightning/3.tflite
model_bytes , _ := ioutil.ReadFile( "/home/morphs/GoVersion/3.tflite"  )
//net := gocv.ReadNet( "/home/morphs/GoVersion/saved_model.pb" , "" )
net , _ := gocv.ReadNetFromTensorflowBytes( model_bytes )
if net.Empty() {
        fmt.Printf("Error reading network model : %v\n", "file")
        return
}
defer net.Close()

https://github.com/hybridgroup/gocv/blob/9d5242045ea703b26a3b7295ba5e2a627a44dbd2/core.cpp#L830
terminate called after throwing an instance of 'cv::Exception'
  what():  OpenCV(4.5.0) /home/morphs/opencv/opencv-4.5.0/modules/dnn/src/tensorflow/tf_io.cpp:48:
    error: (-2:Unspecified error) FAILED: ReadProtoFromBinaryBuffer(data, len, param).
        Failed to parse GraphDef buffer in function 'ReadTFNetParamsFromBinaryBufferOrDie'
nano +48 /home/morphs/opencv/opencv-4.5.0/modules/dnn/src/tensorflow/tf_io.cpp


https://github.com/opencv/opencv/blob/master/modules/dnn/src/caffe/caffe_io.cpp

nano +1150 /home/morphs/opencv/opencv-4.5.0/modules/dnn/src/caffe/caffe_io.cpp
nano +1112 /home/morphs/opencv/opencv-4.5.0/modules/dnn/src/caffe/caffe_io.cpp


https://github.com/tensorflow/tensorflow/issues/1890#issuecomment-209471861


https://docs.opencv.org/master/
https://docs.opencv.org/master/db/d05/tutorial_config_reference.html


https://awesomeopensource.com/project/DrewNF/Build-Deep-Learning-Env-with-Tensorflow-Python-OpenCV?categorypage=18

https://docs.opencv.org/master/dc/db4/tf_segm_tutorial_dnn_conversion.html

python

https://gist.github.com/kleysonr/63401193c6ead95c7c2fd2101f878362
https://www.datamachines.io/blog/toward-a-containerized-nvidia-cuda-tensorflow-and-opencv


https://gist.github.com/n3wtron/4624820


```bash
sudo apt-get install -y gcc nano tar bash sudo openssl git make cmake gfortran pkg-config wget curl unzip net-tools iproute2 iputils-ping python3-pip python3-venv build-essential python3-dev python3-setuptools python3-smbus python3-numpy python3-scipy libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev libssl-dev openssl libffi-dev libsm6 libxrender1 libfontconfig1 libopencv-dev python3-opencv yasm ffmpeg libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libavformat-dev libpq-dev libxvidcore-dev libx264-dev libavcodec-dev libv4l-dev libgtk-3-dev libdc1394-22-dev libjpeg62 libopenjp2-7 libilmbase-dev libatlas-base-dev libgstreamer1.0-dev openexr libopenexr-dev


sudo dd if=/dev/zero of=/swapfile bs=64M count=16
sudo mkswap /swapfile
sudo chmod 600 /swapfile
sudo swapon /swapfile

cmake \
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
-D WITH_OPENCL=oFF \
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

n=$(nproc) && ((c=$n-1)) && make -j $c
sudo make install
sudo ldconfig
sudo chown morphs:video /dev/video0
sudo swapoff /swapfile
sudo rm /swapfile
```