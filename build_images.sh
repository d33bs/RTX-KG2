#!/bin/bash

# set env vars
export DOCKER_SINGULARITY_PLATFORM=linux/amd64
export TARGET_DOCKERFILE=./Dockerfile
export TARGET_DOCKER_TAG=rtx-kg2-build
export TARGET_DOCKER_IMAGE_FILE=./image/$TARGET_DOCKER_TAG.tar.gz

# make image dir if it doesn't already exist
mkdir -p ./image

# clear images
rm -f ./image/$TARGET_DOCKER_IMAGE_FILE

# create a buildx builder
docker buildx create --name mybuilder
docker buildx use mybuilder

# build an image as per the platform
docker buildx build --platform $DOCKER_SINGULARITY_PLATFORM -f $TARGET_DOCKERFILE -t $TARGET_DOCKER_TAG . --load
# docker save $TARGET_DOCKER_TAG | gzip > $TARGET_DOCKER_IMAGE_FILE

# #load the docker image to test that the results work (in docker)
# docker load -i $TARGET_DOCKER_IMAGE_FILE
# docker run --platform $DOCKER_SINGULARITY_PLATFORM -it $TARGET_DOCKER_TAG /bin/bash
