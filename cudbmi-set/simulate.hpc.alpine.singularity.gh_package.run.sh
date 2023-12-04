#!/bin/bash

# Shell script to simulate the run of extended rtx-kg2 image on
# CU HPC Alpine environment. Created to help decrease time related
# to testing image run and hardware resource requests (where possible).

export TARGET_PLATFORM=linux/amd64

# build the docker image as a singularity image
docker run -it --platform $TARGET_PLATFORM \
    --volume $PWD:/rtx-kg2 \
    --workdir /image \
    --privileged \
    quay.io/singularity/singularity:v4.0.1 \
    shell \
    --bind /rtx-kg2/cudbmi-set/kg2-build:/home/ubuntu/kg2-build \
    /rtx-kg2/image/kg2-cudbmi-set_latest.sif
