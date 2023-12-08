#!/bin/bash

# Shell script to simulate the run of extended rtx-kg2 image on
# CU HPC Alpine environment within Lima environment which is
# compatible with MacOS Apple Silicon. Created to help decrease time related
# to testing image run and hardware resource requests (where possible).
# see Lima project more details: https://github.com/lima-vm/lima

# presumes an existing installation of lima
limactl start --vm-type=qemu --arch=x86_64 template://ubuntu-lts

# enter the shell of the ubuntu-lts instance
limactl shell ubuntu-lts

# following instructions under https://apptainer.org/docs/admin/main/installation.html
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:apptainer/ppa
sudo apt update
sudo apt install -y apptainer

# test the installation
apptainer exec docker://alpine cat /etc/alpine-release

# show the apptainer build configuration
apptainer buildcfg
