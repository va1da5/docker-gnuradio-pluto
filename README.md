# Docker for GNU Radio Companion with ADALM-PLUTO SDR

## Introduction

This Docker image will help you to quickly dive into RF world with ADALM-PLUTO SDR without worrying about Linux complexity. It is going to download, compile and install the latest version of available drivers. Everything required will be in the Docker image, so you don't need to worry about adding unnecessary stuff to your beloved Linux system.

## Installation

Please ensure that you have the following installed in your Linux system:
* GIT
* Docker

Use the following commands to create Docker image for GNU Radio Companion.

```bash
git clone git@github.com:va1da5/docker-gnuradio-pluto.git
cd docker-gnuradio-pluto
docker build -t gnuradio .

```

## Usage

There are two common ways to communicate with ADALM-PLUTO: via USB or network connection. The repository contains two run scripts for this matter:

* run-over-network.sh
* run-over-usb.sh

```bash
# Start container with network support
./run-over-network.sh
```

When attached to a host computer ADALM-PLUTO disguises itself as a network interface. The default IP address of the PlutoSDR is 192.168.2.1. This is later used in GNU Radio when defining the device URI `ip:192.168.2.1`.

```bash
# Start container with USB support
./run-over-usb.sh
```

Another way to connect to the PlutoSDR is over USB. This option has a bit better data throughput ([Performance Metrics](https://wiki.analog.com/university/tools/pluto/devs/performance)). The USB ID changes each time when the PlutoSDR is attached to a host machine. In order to find the ID you need to attach to the container and execute the following command. Moreover, root privileges are required (`--user root`) when accessing PlutoSDR over USB.

```bash
> docker exec -it gnuradio bash
root@thinkpad:~# iio_info -s
Library version: 0.15 (git tag: ea597c4)
Compiled with backends: local xml ip usb
Available contexts:
	0: 0xx6:bxxx (Analog Devices Inc. PlutoSDR (ADALM-PLUTO)), serial=1044xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx [usb:2.4.5]
```
In this case device URI would be `usb:2.4.5`.

PlutoSDR USB ID will be presented when starting the container using `run-over-usb.sh` script.

