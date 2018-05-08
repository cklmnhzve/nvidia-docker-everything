FROM cklmnh/opencv3.4-cuda9-python2.7:1.0
LABEL maintainer "cklmnhzve@163.com"

ENV CUDNN_VERSION 7.1.2.21
ENV PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    CUDAHOME=/usr/local/cuda-9.0
COPY ./OpenBLAS /opt/OpenBLAS
COPY ./1/cudnn.hpp /1/cudnn.hpp
COPY ./1/cudnn/* /1/cudnn/
COPY ./1/src/* /1/src/
COPY ./Makefile.config /
RUN rm -rf /var/lib/apt/lists/* && apt-get update && apt-get install -y python-numpy vim libgflags-dev \
    libgoogle-glog-dev liblmdb-dev python-tk libprotobuf-dev libleveldb-dev \
    libsnappy-dev libopencv-dev libhdf5-serial-dev git \ 
    protobuf-compiler libopenblas-dev libjpeg62 libfreeimage-dev pkgconf \
    python-dev --no-install-recommends libboost-all-dev \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    libnccl-dev=$NCCL_VERSION-1+cuda9.0 \
    libcudnn7=$CUDNN_VERSION-1+cuda9.0 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0 \
    && git clone --recursive https://github.com/rbgirshick/py-faster-rcnn.git \
    && mv Makefile.config py-faster-rcnn/caffe-fast-rcnn \
    && mv /1/cudnn.hpp /py-faster-rcnn/caffe-fast-rcnn/include/caffe/util/cudnn.hpp \
    && mv /1/cudnn/* /py-faster-rcnn/caffe-fast-rcnn/include/caffe/layers/ \
    && mv /1/src/* /py-faster-rcnn/caffe-fast-rcnn/src/caffe/layers/ \
    && cd /py-faster-rcnn/caffe-fast-rcnn/python && pip install -r requirements.txt && pip install easydict \
    && cd /py-faster-rcnn/caffe-fast-rcnn \
    && sed -i 's/LIBRARIES += glog gflags protobuf boost_system boost_filesystem m hdf5_hl hdf5/LIBRARIES += glog gflags protobuf boost_system boost_filesystem m hdf5_serial_hl hdf5_serial/' Makefile \
    && cd /usr/lib/x86_64-linux-gnu && ln -s libhdf5_serial.so.8.0.2 libhdf5.so && ln -s libhdf5_serial_hl.so.8.0.2 libhdf5_hl.so \
    && cd /py-faster-rcnn/lib && make \
    && cd /py-faster-rcnn/caffe-fast-rcnn && make -j8 && make pycaffe
ENV PYTHONPATH=/home/py-faster-rcnn/caffe-fast-rcnn/python:$PYTHONPATH
COPY ./demo.py /py-faster-rcnn/tools
# Define default command.
CMD ["python"]
