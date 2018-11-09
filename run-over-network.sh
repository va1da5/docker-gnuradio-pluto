#!/usr/bin/env bash

xhost +local:docker

USER_UID=$(id -u)

CONTAINER_EXIST=`docker ps -a --format "{{.Image}}" | grep gnuradio`

if [ $CONTAINER_EXIST ]; then
    docker start gnuradio
else
    docker run --rm -d \
        --volume /tmp/.X11-unix:/tmp/.X11-unix \
        --volume `pwd`/gnuradio:/home/gnuradio \
        -e DISPLAY=unix$DISPLAY \
        --network=host \
        --device /dev/snd \
        --device /dev/dri \
        --volume /run/user/${USER_UID}/pulse:/run/user/1000/pulse \
        --name gnuradio \
        gnuradio
fi