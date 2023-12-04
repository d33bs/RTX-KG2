#!/bin/bash

# Shell script to simulate the run of extended rtx-kg2 image on
# CU HPC Alpine environment. Created to help decrease time related
# to testing image run and hardware resource requests (where possible).

# build the docker image as a singularity image
docker run -it --platform $TARGET_PLATFORM \
    --volume $PWD/image:/image \
    --workdir /image \
    --privileged \
    quay.io/singularity/singularity:v4.0.1
