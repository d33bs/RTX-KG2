#!/bin/bash

# used for running RTX-KG2 builds via Docker or Apptainer/Singularity images
# note: runs build.test.sh to help prepare the work.

# setting to exit the script on any failures
set -e

# cd to the home dir for ubuntu user
cd /home/ubuntu

# run the build.test.sh script to prepare things
source /home/ubuntu/RTX-KG2/cudbmi-set/build.test.sh

# prepare a place for the umls data to land
sudo mkdir -p /home/ubuntu/kg2-build/umls

# prepare the umls data locally for use (sidestepping historical s3 dependencies)
sudo cp /home/ubuntu/data-staging/umls-2023AA-metathesaurus-full.zip \
    /home/ubuntu/kg2-build/umls

# remove umls dir deletion line within extract-umls.sh
sudo sed -i.bak '34s/.*/# removed line to avoid local umls dir usage /' /home/ubuntu/RTX-KG2/extract-umls.sh

# run the build in test mode
sudo bash -x /home/ubuntu/kg2-code/build-kg2-snakemake.sh alltest
