FROM ubuntu:18.04
MAINTAINER Stephen Ramsey (stephen.ramsey@oregonstate.edu)

# need to add user "ubuntu" and give sudo privilege:
RUN useradd ubuntu -m -s /bin/bash

# need to install git and sudo
RUN apt-get update
RUN apt-get install -y git sudo screen

# give sudo privilege to user ubuntu:
RUN usermod -aG sudo ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu
RUN touch /home/ubuntu/.sudo_as_admin_successful
RUN chown ubuntu.ubuntu /home/ubuntu/.sudo_as_admin_successful

# switch to user ubuntu
USER ubuntu

# following steps from documentation under build procedure #1.
# Reference: README.md##build-option-1-build-kg2-in-parallel-directly-on-an-ubuntu-system
# (1) Install the `git` and `screen` packages
# Added screen to earlier installations in this file.
# (2) change to the home directory for user `ubuntu`:
WORKDIR /home/ubuntu
# (3) Clone the RTX software from GitHub:
# Defering to use local copy of source to keep builds in alignment
# with current branch or fork code.
COPY . /home/ubuntu/RTX-KG2
# (4) Setup the KG2 build system: 
# Note: bash with the -x flag uses xtrace
RUN bash -x RTX-KG2/setup-kg2-build.sh
