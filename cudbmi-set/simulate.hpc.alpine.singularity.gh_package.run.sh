#!/bin/bash

# Shell script to simulate the run of extended rtx-kg2 image on
# CU HPC Alpine environment. Created to help decrease time related
# to testing image run and hardware resource requests (where possible).

export TARGET_PLATFORM=linux/amd64
export TARGET_CUDBMI_TAG=kg2-cudbmi-set

# build the docker image as a singularity image
docker run -it \
    -v $PWD/cudbmi-set/kg2-build-logs:/home/ubuntu/kg2-build/logs \
    -v $PWD/cudbmi-set/data-staging:/home/ubuntu/data-staging \
    --platform $TARGET_PLATFORM \
    $TARGET_CUDBMI_TAG:latest \
    /bin/bash
