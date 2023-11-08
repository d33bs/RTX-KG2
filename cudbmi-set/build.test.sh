#!/bin/bash

# used for testing Docker or Apptainer/Singularity images for kg2

# setting to exit the script on any failures
set -e

# cd to the home dir for ubuntu user
cd /home/ubuntu

# insert fixes into line 102 of /home/ubuntu/RTX-KG2/setup-kg2-build.sh 
# for correcting python build requirements
sudo sed -i.bak \
    '102r /home/ubuntu/RTX-KG2/cudbmi-set/python-pydantic-core-workarounds.sh' \
    /home/ubuntu/RTX-KG2/setup-kg2-build.sh

# replace faulty postgres apt link in setup file (http vs https)
# see: https://www.postgresql.org/download/linux/ubuntu/
sed -i 's|http://apt.postgresql.org/pub/repos/apt|https://apt.postgresql.org/pub/repos/apt|g' \
    /home/ubuntu/RTX-KG2/setup-kg2-build.sh

# prepend python dependencies for amending potential challenges
(cat /home/ubuntu/RTX-KG2/cudbmi-set/requirements-build-append.txt \
    && cat /home/ubuntu/RTX-KG2/requirements-kg2-build.txt) > temp.txt \
    && sudo mv temp.txt /home/ubuntu/RTX-KG2/requirements-kg2-build.txt

# run the build script, continuing even if there are errors
sudo bash -x /home/ubuntu/RTX-KG2/setup-kg2-build.sh || true

# make the logs subdir so we may analyze the logs
mkdir -p /home/ubuntu/kg2-build/logs

# copy the logs from the build dir to the log sub dir
cp /home/ubuntu/kg2-build/*.log /home/ubuntu/kg2-build/logs
