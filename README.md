# nvidia-docker-py-faster-rcnn-for-10secs
1.install docker 
-----
refer to https://docs.docker.com/install/linux/docker-ce/ubuntu/ (Docker Docs)

2.install nvidia-docker2 (nvidia-docker is deprecated) 
-----
refer to  https://github.com/NVIDIA/nvidia-docker

3.Pull my images or Build images from provided Dockerfile 
------
`docker pull cklmnh/faster-rcnn:1.0` 

or

`cd PATH OF YOU/nvidia-docker-opencv`

`docker build -t cklmnh/faster-rcnn:1.0 .`

(maybe have SimHash due to unstable Internet,just try several times)

`p.s It will slowly pull images or especially build images, but after pulling or building you can set up your own DL-dev environment
in a few secs.Amazing speed with the help of Nvidia-docker!`

4.Run faster-rcnn in a few secs

`cd  PATH OF YOU/nvidia-docker-opencv/get-model`

`chmod a+x fetch_faster_rcnn_models.sh && ./fetch_faster_rcnn_models.sh`  

(then you will get vgg model and zf model)

then `cd PATH OF YOU/nvidia-docker-opencv/`

`docker run --runtime=nvidia -itd --name  -v PATH OF YOU/nvidia-docker-opencv/faster_rcnn_models:/py-faster-rcnn/data/faster_rcnn_models cklmnh/faster-rcnn:1.0`

`docker exec -it faster-rcnn /bin/bash` (enter into the container)

then you will enter in a new command line 

`cd py-faster-rcnn/tools`

`./demo.py` (use GPU by default, you can use your cpu with `./demo.py --cpu`)

the result is stored in PATH OF YOU/nvidia-docker-opencv/faster_rcnn_models
