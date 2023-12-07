#!/bin/bash

# Shell script to test the run of extended rtx-kg2 image on
# CU Alpine HPC via interactive session with Singularity.

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

# change dir to user project dir which provides greater storage space
cd /projects/$USER




