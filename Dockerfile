FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt upgrade -yf \
    && apt install -y software-properties-common\
    && add-apt-repository -y ppa:myriadrf/gnuradio \
    && add-apt-repository -y ppa:myriadrf/drivers \
    && apt-get update \
    && apt install -y bison \
        build-essential \
        cmake \
        doxygen \
        flex cmake libaio-dev \
        git \
        graphviz \
        libasound2-dev \
        libavahi-client-dev \
        libboost-all-dev \
        libboost-all-dev swig \
        libcdk5-dev \
        libfftw3-3 \
        libfftw3-dev \
        libgsl-dev \
        liblog4cpp5-dev \
        libqwt5-qt4 \
        libqwt-dev \
        libserialport-dev \
        libusb-1.0-0 \
        libusb-1.0-0-dev \
        libusb-1.0-0-dev \
        libxml2 \
        libxml2-dev \
        libzmq3-dev \
        pkg-config \
        python-cairo-dev \
        python-cheetah \
        python-dev \
        python-gtk2 \
        python-lxml \
        python-mako \
        python-numpy \
        python-qt4 \
        python-qwt5-qt4 \
        python-zmq \
        swig \
    && apt install -y gnuradio gnuradio-dev xterm git libvolk1-bin --no-install-recommends \
    && echo "xterm_executable=/usr/bin/xterm" >> /etc/gnuradio/conf.d/grc.conf

WORKDIR /opt

RUN git clone https://github.com/analogdevicesinc/libiio.git \
    && cd libiio \
    && cmake ./ \
    && make all \
    && make install \
    && cd ..

RUN git clone https://github.com/analogdevicesinc/libad9361-iio.git \ 
    && cd libad9361-iio \
    && cmake ./ \
    && make && make install \
    && cd ..

RUN git clone https://github.com/analogdevicesinc/gr-iio.git \
    && cd gr-iio \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr . \
    && make && make install \
    && cd .. \
    && ldconfig


RUN apt install -y pulseaudio-utils pulseaudio --no-install-recommends

COPY pulse-client.conf /etc/pulse/client.conf

RUN sed -i "s/enable-shm = yes/enable-shm = no/" /etc/pulse/daemon.conf

RUN apt-get -y clean && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

ENV UNAME gnuradio

RUN export UNAME=$UNAME UID=1000 GID=1000 \
    && mkdir -p "/home/${UNAME}" \
    && echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd \
    && echo "${UNAME}:x:${UID}:" >> /etc/group \
    && mkdir -p /etc/sudoers.d \
    && echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} \
    && chmod 0440 /etc/sudoers.d/${UNAME} \
    && chown ${UID}:${GID} -R /home/${UNAME} \
    && usermod -a -G audio,root ${UNAME} 

USER $UNAME

ENV HOME /home/${UNAME}

WORKDIR $HOME

RUN volk_profile

ENTRYPOINT [ "gnuradio-companion" ]