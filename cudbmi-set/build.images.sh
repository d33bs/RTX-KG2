#!/bin/bash

# used for building Docker and Apptainer/Singularity images for use
# with RTX-KG2 on the University of Colorado's Alpine HPC

# setting to exit the script on any failures
set -e

# set env vars for use below
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

# create a buildx builder
# Check if the builder with the specified name already exists
if ! docker buildx inspect mybuilder >/dev/null 2>&1; then
    # Builder does not exist, create it
    # note: requires additional driver-opt and buildkitd-flags to avoid
    # local network issues "ERROR: failed to solve: granting entitlement network.host..."
    # referenced: https://github.com/docker/buildx/issues/835#issuecomment-966496802
    docker buildx create \
    --use \
    --name mybuilder \
    --driver-opt network=host \
    --buildkitd-flags '--allow-insecure-entitlement network.host'
fi
docker buildx use mybuilder

# build kg2 image as per the platform
docker buildx build --platform $TARGET_PLATFORM \
    -f $TARGET_KG2_DOCKERFILE \
    -t $TARGET_KG2_TAG:latest \
    . \
    --load

# run a registry to host the image for use with buildx build
# which is unable to properly reference local images otherwise
# referenced: https://github.com/docker/buildx/issues/301#issuecomment-755164475
if ! [[ $(docker ps -a --filter "name=registry" --format '{{.Names}}') == "registry" ]]; then
    # run a registry
    docker run -d --name registry --network=host registry:2
fi

# tag and push the image above to the registry
docker tag kg2:latest localhost:5000/kg2:latest
docker push localhost:5000/kg2:latest

# build extended kg2 image with decoupled additions
# note: we make minor modifications to force the build to ref the local registry
# for using the locally built image above
docker buildx build --network=host \
    --build-arg LOCAL_REGISTRY="localhost:5000" \
    --platform $TARGET_PLATFORM \
    -f $TARGET_CUDBMI_DOCKERFILE \
    -t $TARGET_CUDBMI_TAG:latest \
    . \
    --load

# docker buildx build --platform $DOCKER_SINGULARITY_PLATFORM -t $TARGET_TAG . --load
docker save $TARGET_CUDBMI_TAG | gzip > $TARGET_DOCKER_IMAGE_FILEPATH

# load the docker image
docker load -i $TARGET_DOCKER_IMAGE_FILEPATH

# run the docker image with the contents of the build.test.sh script
BUILD_TEST_SH_FILE="/home/ubuntu/RTX-KG2/cudbmi-set/build.test.sh"
docker run \
    -v $PWD/cudbmi-set/kg2-build-logs:/home/ubuntu/kg2-build/logs \
    --platform $TARGET_PLATFORM \
    $TARGET_CUDBMI_TAG \
    /bin/bash \
    -c "chmod +x $BUILD_TEST_SH_FILE && $BUILD_TEST_SH_FILE"

# seek success text in specific log file
# note: if we fail here we exit and do not proceed to build the singularity image
if grep -q "======= script finished ======" "/home/ubuntu/kg2-build-logs/setup-kg2-build.log"; then
    echo "setup-kg2-build.sh finished successfully."
else
    echo "Error: setup-kg2-build.sh did not finish successfully."
    exit 1
fi

# build the docker image as a singularity image
# docker run --platform $TARGET_PLATFORM \
#     --volume $PWD/image:/image \
#     --workdir /image \
#     --privileged \
#     quay.io/singularity/singularity:v4.0.1 \
#     build $TARGET_SINGULARITY_IMAGE_FILENAME docker-archive://$TARGET_DOCKER_IMAGE_FILENAME
