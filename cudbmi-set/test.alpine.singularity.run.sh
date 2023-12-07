#!/bin/bash

# Shell script to test the run of extended rtx-kg2 image on
# CU Alpine HPC via interactive session with Singularity.
# note: this work expects that data transfer for UMLS and Drugbank data
# have been prepared on HPC Alpine under /projects/$USER/rtx-kg2-data-staging

# setting to exit the script on any failures
set -e

# load interactive Slurm session with increased memory
# note: if you exit the session you must re-login to Alpine
# in order to begin again due to `screen` errors from slurm.
sinteractive --mem=32G

# display the job related to the sinteractive session
squeue -u $USER

# load singularity 3.7.4 (or latest available)
module load singularity/3.7.4

# set our singularity cache to the projects dir
export SINGULARITY_CACHEDIR=/projects/$USER

# create a testing dir with associated log dir
mkdir -p /projects/$USER/rtx-kg2-testing/kg2-build-logs

# change dir to user project dir which provides greater storage space
cd /projects/$USER/rtx-kg2-testing

# download sif file for singularity
curl -OJL https://github.com/CU-DBMI/RTX-KG2/releases/download/v2023.12.07/kg2-cudbmi-set.sif

# enter into singularity shell from the image with bound local dirs for data access
# singularity shell \
#     --bind /projects/$USER/rtx-kg2-testing/kg2-build-logs:/home/ubuntu/kg2-build/logs \
#     --bind /projects/$USER/rtx-kg2-data-staging:/home/ubuntu/data-staging \
#     kg2-cudbmi-set.sif

