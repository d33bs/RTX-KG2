#!/bin/bash

# set env vars
export DOCKER_SINGULARITY_PLATFORM=linux/amd64
export TARGET_DOCKERFILE=./Dockerfile
export TARGET_TAG=rtx-kg2-build
export TARGET_DOCKER_IMAGE_FILENAME=$TARGET_TAG.tar.gz
export TARGET_SINGULARITY_IMAGE_FILENAME=$TARGET_TAG.sif
export TARGET_DOCKER_IMAGE_FILEPATH=./image/$TARGET_DOCKER_IMAGE_FILENAME

# make image dir if it doesn't already exist
mkdir -p ./image

# clear images
rm -f ./image/*

# create a buildx builder
docker buildx create --name mybuilder
docker buildx use mybuilder

# build an image as per the platform
docker buildx build --platform $DOCKER_SINGULARITY_PLATFORM -f $TARGET_DOCKERFILE -t $TARGET_TAG . --load
# docker buildx build --platform $DOCKER_SINGULARITY_PLATFORM -t $TARGET_TAG . --load
docker save $TARGET_TAG | gzip > $TARGET_DOCKER_IMAGE_FILEPATH

# #load the docker image to test that the results work (in docker)
# docker load -i $TARGET_DOCKER_IMAGE_FILEPATH
# docker run --platform $DOCKER_SINGULARITY_PLATFORM -it $TARGET_TAG /bin/bash

# build the docker image as a singularity image
# docker build --platform $DOCKER_SINGULARITY_PLATFORM -f docker/Dockerfile.2.build-singularity-image -t singularity-builder .
# docker run --platform $DOCKER_SINGULARITY_PLATFORM -v $PWD/image:/image -it --privileged singularity-builder 
# docker run --platform $DOCKER_SINGULARITY_PLATFORM \
#     --volume $PWD/image:/image \
#     --workdir /image \
#     --privileged \
#     quay.io/singularity/singularity:v3.10.4 \
#     build $TARGET_SINGULARITY_IMAGE_FILENAME docker-archive://$TARGET_DOCKER_IMAGE_FILENAME
