#!/usr/bin/env bash

xhost +local:docker

USER_UID=$(id -u)

docker run -d \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`/gnuradio:/home/gnuradio \
    -e DISPLAY=unix$DISPLAY \
    --device /dev/bus/usb \
    --device /dev/snd \
    --volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse \
    --name gnuradio \
    --user root \
    gnuradio

docker exec --user root gnuradio iio_info -s