#!/bin/bash

# used for testing Docker or Apptainer/Singularity images for kg2

# setting to exit the script on any failures
set -e

# cd to the home dir for ubuntu user
cd /home/ubuntu

# run the build script, continuing even if there are errors
sudo bash -x /home/ubuntu/RTX-KG2/setup-kg2-build.sh || true

# make the logs subdir so we may analyze the logs
mkdir -p /home/ubuntu/kg2-build/logs

# copy the logs from the build dir to the log sub dir
cp /home/ubuntu/kg2-build/*.log /home/ubuntu/kg2-build/logs
