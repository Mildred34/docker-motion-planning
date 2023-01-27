# Resume
In summary, this little, project installed a container to build a pybullet
application with OMPL.

# Requirements
* Having docker installed on your host machine
* Having an ssh key on your host machine (if you wan to use git)

# Files
* Dockerfile
* docker-compose.yml
* install.sh
* README.md

# Installation
1. Launch install.sh script

# Warning
Removing a container will make you loss all its content.
Be sure before making a `docker container prune -f` or `docker container rm <container_id>`
You can add a volume to your Dockerfile file or docker-compose.yml file to save your container workspace in local on your host.

# Use your nivida cards to launch your Docker
Asumming you have the nvidia drivers and [nvidia-docker-plugin](https://github.com/NVIDIA/nvidia-docker/wiki) installed on your machine.

```
docker run --rm -it --runtime=nvidia --privileged --net=host --ipc=host \
-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
-v $HOME/.Xauthority:/home/$(id -un)/.Xauthority -e XAUTHORITY=/home/$(id -un)/.Xauthority \
-v $HOME/.ssh:/root/.ssh \
-v $HOME/catkin_ws:/home/$(id -un)/catkin_ws
-e DOCKER_USER_NAME=$(id -un) \
-e DOCKER_USER_ID=$(id -u) \
-e DOCKER_USER_GROUP_NAME=$(id -gn) \
-e DOCKER_USER_GROUP_ID=$(id -g) \
-e ROS_IP=127.0.0.1 \
_image_name
```

# Docker tips
* Check containers running and stopped
```
docker container ls -a
```
* Restart a container and access to the CLI
```
docker container start <container_id>
docker attach <container_id>
```
* Remove all image with specified pattern
```
docker images -a | grep "none" | awk '{print $3}' | xargs docker rmi -f
```
* Remove all images, containers, volumes unused
```
docker container prune -f
docker image prune -f
docker volume prune -f
```
* To allow X11 connection to your docker
```
xhost +local:root
```

# Trouble shooting
* g++ and gcc version

On recent computer, your hardware will not be compatible with the gcc version used by the image.
You can change install an updated version and make it default by:
```
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install gcc-8 g++-8
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-8
update-alternatives --config gcc
```
