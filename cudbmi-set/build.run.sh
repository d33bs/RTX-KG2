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
sudo mkdir -p /home/ubuntu/kg2-build/semmeddb
sudo cp /home/ubuntu/data-staging/semmeddb/* /home/ubuntu/kg2-build/semmeddb
sudo sed -i.bak '54s|.*|# commented out to avoid issues|' /home/ubuntu/RTX-KG2/extract-semmeddb.sh
sudo sed -i.bak '55s|.*|# commented out to avoid issues|' /home/ubuntu/RTX-KG2/extract-semmeddb.sh

# avoid errors with dgidb and rely on pre-prepared data transfer
sudo sed -i.bak '24s|.*|# commented out to avoid issues|' /home/ubuntu/RTX-KG2/extract-dgidb.sh
sudo sed -i.bak '25s|.*|update_date=$(date +"%Y%m%d_%H%M%S")|' /home/ubuntu/RTX-KG2/extract-dgidb.sh
sudo sed -i.bak '26s|.*|# commented out to avoid issues|' /home/ubuntu/RTX-KG2/extract-dgidb.sh
sudo sed -i.bak '28s|.*|# ${curl_get} ${dgidb_url} > /tmp/${dgidb_file}|' /home/ubuntu/RTX-KG2/extract-dgidb.sh
sudo cp /home/ubuntu/data-staging/interactions.tsv /tmp/interactions.tsv

# provide static user context for postgres and drugcentral work (avoid sudo context challenges)
sudo sed -i.bak '48 s|psql -U|sudo -u ubuntu psql -U|' /home/ubuntu/RTX-KG2/extract-drugcentral.sh
# change the path of psql output to avoid root/ubuntu permission issues (and downstream permission change issues)
sudo sed -i.bak '27s|.*|sudo chown root:ubuntu ${drugcentral_dir} \&\& sudo chmod 775 ${drugcentral_dir}|' /home/ubuntu/RTX-KG2/extract-drugcentral.sh

# run the build in alltest mode
# sudo bash -x /home/ubuntu/kg2-code/build-kg2-snakemake.sh alltest

# run the build in test mode (which depends on the alltest run above)
# sudo bash -x /home/ubuntu/kg2-code/build-kg2-snakemake.sh test

# full run of the build after the alltest and test runs
sudo bash -x /home/ubuntu/kg2-code/build-kg2-snakemake.sh all -F
