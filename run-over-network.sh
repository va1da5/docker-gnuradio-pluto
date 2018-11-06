#!/usr/bin/env bash

xhost +local:docker

USER_UID=$(id -u)

docker run -d \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`/gnuradio:/home/gnuradio \
    -e DISPLAY=unix$DISPLAY \
    --network=host \
    --device /dev/snd \
    --volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse \
    --name gnuradio \
    gnuradio