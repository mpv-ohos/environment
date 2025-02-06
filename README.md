## Setup environment
### Install docker
Go to [Docker official docs](https://docs.docker.com/engine/install/) and follow steps to install Docker Engine.
### Build image
Pull this repo to local and set it on a suitable location, go to the directory where you put this repo, run command:
```shell
sudo docker build -t ohos_build_env ./
```
You can check local images by running:
```shell
sudo docker image ls
```
### Run image
After running this command, docker will create a new container to run the image:
```shell
sudo docker run -v -it ohos_build_env /bin/bash
```
### Exit container
If you want to quit the container but make it still running tasks at background, press Ctrl + P + Q. \
If you want to exit the container and don't want it running at background, enter `exit` in container tty directly.
### Check running containers
```shell
sudo docker container ls
```
### Re-open the container
You can get container id follow the *Check running container* step.
```shell
sudo docker attach CONTAINER_ID
```
### Delete the container
```shell
sudo docker container rm CONTAINER_ID
```
### Delete the image
```shell
sudo docker image rm ohos_build_env
```
