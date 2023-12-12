#!/bin/bash

# used for building Docker and Apptainer/Singularity images for use
# with RTX-KG2 on the University of Colorado's Alpine HPC

# setting to exit the script on any failures
set -e

# set env vars for use below
export TARGET_VERSION="2023.12.07"
export TARGET_PLATFORM=linux/amd64
export TARGET_KG2_DOCKERFILE=./Dockerfile
export TARGET_KG2_TAG=kg2
export TARGET_CUDBMI_DOCKERFILE=./cudbmi-set/Dockerfile.build-extended
export TARGET_CUDBMI_TAG=kg2-cudbmi-set
export TARGET_DOCKER_IMAGE_FILENAME=$TARGET_CUDBMI_TAG.tar.gz
export TARGET_SINGULARITY_IMAGE_FILENAME=$TARGET_CUDBMI_TAG.sif
export TARGET_DOCKER_IMAGE_FILEPATH=./image/$TARGET_DOCKER_IMAGE_FILENAME

# make image dir if it doesn't already exist
mkdir -p ./image

# clear images
rm -f ./image/*

# build kg2 image as per the platform
docker build --platform $TARGET_PLATFORM \
    -f $TARGET_KG2_DOCKERFILE \
    -t $TARGET_KG2_TAG:latest \
    .

# using the kg2 image above,
# build extended kg2 image with decoupled additions
docker build \
    --build-arg IMAGE_REF="kg2" \
    --platform $TARGET_PLATFORM \
    -f $TARGET_CUDBMI_DOCKERFILE \
    -t $TARGET_CUDBMI_TAG:latest \
    .

# save the built docker image to tar.gz format
docker save $TARGET_CUDBMI_TAG | gzip > ./image/$TARGET_DOCKER_IMAGE_FILENAME

# build the docker image as a singularity image
docker run --platform $TARGET_PLATFORM \
    --volume $PWD/image:/image \
    --workdir /image \
    --privileged \
    quay.io/singularity/singularity:v4.0.1 \
    build $TARGET_SINGULARITY_IMAGE_FILENAME docker-archive://$TARGET_DOCKER_IMAGE_FILENAME
