#!/bin/bash

# used for running RTX-KG2 builds via Docker or Apptainer/Singularity images
# note: runs build.test.sh to help prepare the work.

# setting to exit the script on any failures
set -e

# cd to the home dir for ubuntu user
cd /home/ubuntu

# run the build.test.sh script to prepare things
sudo bash -x /home/ubuntu/RTX-KG2/cudbmi-set/build.test.sh

# prepare a place for the umls data to land
sudo mkdir -p /home/ubuntu/kg2-build/umls

# prepare the umls data locally for use (sidestepping historical s3 dependencies)
sudo cp /home/ubuntu/data-staging/umls-2023AA-metathesaurus-full.zip \
    /home/ubuntu/kg2-build/umls

# remove umls dir deletion line within extract-umls.sh
sudo sed -i.bak '34s/.*/# removed line to avoid local umls dir usage /' /home/ubuntu/RTX-KG2/extract-umls.sh

# set name for drugbank dataset based on newly downloaded data
sudo sed -i.bak '24s/.*/xml_filename=drugbank_all_full_database.xml.zip/' /home/ubuntu/RTX-KG2/extract-drugbank.sh

# set unzip instead of gz uncompress for drugbank
sudo sed -i.bak '27s#.*#unzip -p /home/ubuntu/data-staging/${xml_filename} | sudo tee ${output_file} > /dev/null #' /home/ubuntu/RTX-KG2/extract-drugbank.sh

# prepare the semmeddb tar.gz file from source table files to remain compatible with extract-semmeddb.sh
sudo tar -czvf \
    /home/ubuntu/kg2-build/semmeddb/semmedVER43_2023_R_WHOLEDB.tar.gz \
    /home/ubuntu/data-staging/semmedVER43_2023_R_*

# avoid errors with dgidb and rely on pre-prepared data transfer
sudo sed -i.bak '28s|.*|# ${curl_get} ${dgidb_url} > /tmp/${dgidb_file}|' /home/ubuntu/RTX-KG2/extract-dgidb.sh
sudo cp /home/ubuntu/data-staging/interactions.tsv /tmp/interactions.tsv

# provide static user context for postgres and drugcentral work (avoid sudo context challenges)
sudo sed -i.bak '48 s|psql -U|sudo -u ubuntu psql -U|' /home/ubuntu/RTX-KG2/extract-drugcentral.sh

# run the build in alltest mode
sudo bash -x /home/ubuntu/kg2-code/build-kg2-snakemake.sh alltest

# run the build in test mode (which depends on the alltest run above)
sudo bash -x /home/ubuntu/kg2-code/build-kg2-snakemake.sh test

# full run of the build afte rthe alltest and test runs
sudo bash -x /home/ubuntu/kg2-code/build-kg2-snakemake.sh all -F
