#!/bin/bash

# Shell script to simulate the run of extended rtx-kg2 image on
# CU HPC Alpine environment within Lima environment which is
# compatible with MacOS Apple Silicon. Created to help decrease time related
# to testing image run and hardware resource requests (where possible).
# see Lima project more details: https://github.com/lima-vm/lima

# presumes an existing installation of lima
# note: we explicitly call x86_64 arch to avoid arm-based implementation on Apple Silicon
# note: we use the ubuntu-lts template to use a non-latest version of ubuntu which is
# (hopefully!) compatible with apptainer distributions.
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

# cd to the image dir within local RTX-KG2 repository with pre-built images
cd image || exit

# run the image through lima ubuntu LTS apptainer
apptainer shell --containall --cleanenv --fakeroot --writable-tmpfs kg2-cudbmi-set.sif

# run the build.run.sh script from /home/ubuntu within the container
/home/ubuntu/RTX-KG2/cudbmi-set/build.run.sh
