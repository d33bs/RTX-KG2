#!/bin/bash

# used for running the preparatory scripts within the context
# of a running container.

# cd to the home dir for ubuntu user
cd /home/ubuntu

# run the build script
bash -x RTX-KG2/setup-kg2-build.sh
