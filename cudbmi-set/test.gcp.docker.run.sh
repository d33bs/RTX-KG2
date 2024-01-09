#!/bin/bash

# Shell script to test the run of extended rtx-kg2 image on
# GCP VM via interactive session with Docker.
# note: this work expects that data transfer for UMLS and Drugbank data
# have been prepared on HPC Alpine under /projects/$USER/rtx-kg2-data-staging

# note: presumes the docker daemon has access to large file storage via --data-root
# option usage pointed to VM mount with large storage.

# setting to exit the script on any failures
set -e

export TARGET_PLATFORM=linux/amd64
export TARGET_CUDBMI_TAG=kg2-cudbmi-set
export RTXKG2_DATA_DIR=/mnt/disks/rtx-kg2-data

# make a log dir
mkdir -p $RTXKG2_DATA_DIR/kg2-build-logs
mkdir -p $RTXKG2_DATA_DIR/kg2-build
mkdir -p $RTXKG2_DATA_DIR/docker-data-root

# change dir to the data dir
cd $RTXKG2_DATA_DIR

# clear previous work to avoid collisions
sudo rm -rf $RTXKG2_DATA_DIR/kg2-build-logs/*
sudo rm -rf $RTXKG2_DATA_DIR/kg2-build/*

# clean up docker system for storage space
docker system prune -f

# run the docker image with the mapped volumes as references
cd $RTXKG2_DATA_DIR
docker run -it --platform $TARGET_PLATFORM \
    -v $PWD/kg2-build-logs:/home/ubuntu/kg2-build/logs \
    -v $PWD/data-staging:/home/ubuntu/data-staging \
    -v $PWD/kg2-build:/home/ubuntu/kg2-build \
    $TARGET_CUDBMI_TAG:latest \
    /bin/bash

# run the following script from within the interactive session:
# /home/ubuntu/RTX-KG2/cudbmi-set/build.run.sh

# log into running container from another session
# docker container list
# docker exec -it <container_id_or_name> /bin/bash
