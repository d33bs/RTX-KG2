#!/bin/bash

# used for testing Docker or Apptainer/Singularity images for kg2

# setting to exit the script on any failures
set -e

# switch user to ubuntu and run commands
su - ubuntu

# cd to the home dir for ubuntu user
cd /home/ubuntu

# run the build script
bash -x /home/ubuntu/RTX-KG2/setup-kg2-build.sh

mkdir /home/ubuntu/kg2-build/logs

cp /home/ubuntu/kg2-build/*.log /home/ubuntu/kg2-build/logs

