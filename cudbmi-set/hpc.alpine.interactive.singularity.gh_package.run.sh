#!/bin/bash

# Shell script to run extended rtx-kg2 image on
# CU HPC Alpine environment.

# request interactive session
sinteractive --partition=amem --time=2-10:00:00 --mem=320G --qos=long

# load Singularity module
module load singularity

# set a project dir which has 250GB of space
export SINGULARITY_TMPDIR=/projects/$USER
export KG2_LOCAL_BUILD_DIR=$SINGULARITY_TMPDIR/kg2-build

# create a kg2-build dir for the data to land
mkdir -p $KG2_LOCAL_BUILD_DIR

# Pull the Docker image using Singularity
singularity pull \
    --tmpdir $SINGULARITY_TMPDIR \
    docker://docker.pkg.github.com/cu-dbmi/rtx-kg2/kg2-cudbmi-set:latest

# Run the Singularity container
singularity shell \
    --bind $KG2_LOCAL_BUILD_DIR:/home/ubuntu/kg2-build \
    kg2-cudbmi-set_latest.sif
