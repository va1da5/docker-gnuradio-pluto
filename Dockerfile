FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt upgrade -yf \
    && apt install -y software-properties-common --no-install-recommends \
    && add-apt-repository -y ppa:myriadrf/gnuradio \
    && add-apt-repository -y ppa:myriadrf/drivers \
    && apt-get update \
    && apt install -y gnuradio gnuradio-dev xterm git --no-install-recommends \
    && apt install -y libxml2 libxml2-dev \
        bison flex cmake libaio-dev \
        libboost-all-dev swig \
    && apt-get -yf install libcdk5-dev libusb-1.0-0-dev \
        libserialport-dev libavahi-client-dev doxygen \
        graphviz --no-install-recommends \
    && echo "xterm_executable=/usr/bin/xterm" >> /etc/gnuradio/conf.d/grc.conf \
    && apt install -y pulseaudio-utils --no-install-recommends

COPY pulse-client.conf /etc/pulse/client.conf

WORKDIR /tmp

RUN git clone https://github.com/analogdevicesinc/libiio.git \
    && cd libiio \
    && cmake ./ \
    && make all \
    && make install \
    && cd .. && rm -rf libiio

RUN git clone https://github.com/analogdevicesinc/libad9361-iio.git \ 
    && cd libad9361-iio \
    && cmake ./ \
    && make && make install \
    && cd .. && rm -rf libad9361-iio

RUN git clone https://github.com/analogdevicesinc/gr-iio.git \
    && cd gr-iio \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr . \
    && make && make install \
    && cd .. && ldconfig && rm -rf gr-iio

RUN apt remove -y cmake git \
        software-properties-common \
    && apt-get -y clean && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

ENV UNAME gnuradio

RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio

USER $UNAME

ENV HOME /home/${UNAME}

WORKDIR /home/${UNAME}

ENTRYPOINT [ "gnuradio-companion" ]