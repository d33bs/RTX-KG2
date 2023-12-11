#!/bin/bash

# Shell script to test the run of extended rtx-kg2 image on
# GCP VM via interactive session with Docker.
# note: this work expects that data transfer for UMLS and Drugbank data
# have been prepared on HPC Alpine under /projects/$USER/rtx-kg2-data-staging

# setting to exit the script on any failures
set -e

export TARGET_PLATFORM=linux/amd64
export TARGET_CUDBMI_TAG=kg2-cudbmi-set
export RTXKG2_DATA_DIR=/mnt/disks/rtx-kg2-data

# make a log dir
mkdir -p $RTXKG2_DATA_DIR/kg2-build-logs

# change dir to the data dir
cd $RTXKG2_DATA_DIR

# download sif file for singularity
curl -OJL https://github.com/CU-DBMI/RTX-KG2/releases/download/v2023.12.07/kg2-cudbmi-set.tar.gz

# load image into docker
docker import kg2-cudbmi-set.tar.gz

# run the docker image with the mapped volumes as references
docker run -it --platform $TARGET_PLATFORM \
    -v $PWD/kg2-build-logs:/home/ubuntu/kg2-build/logs \
    -v $PWD/data-staging:/home/ubuntu/data-staging \
    $TARGET_CUDBMI_TAG:latest \
    /bin/bash
