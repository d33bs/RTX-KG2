FROM ubuntu:18.04
MAINTAINER Stephen Ramsey (stephen.ramsey@oregonstate.edu)

# set environment vars from .sh and .shinc files
ENV mysql_user=ubuntu
ENV mysql_password=1337
ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_ROOT_PASSWORD=${mysql_password}

# need to add user "ubuntu" and give sudo privilege:
RUN useradd ubuntu -m -s /bin/bash

# pre-installs
RUN apt-get update
RUN apt-get install -y wget software-properties-common

## setup PostGreSQL
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# added for python compat with venv work 
RUN add-apt-repository -y ppa:deadsnakes/ppa

# reupdate
RUN apt-get update
# handle weird tzdata install (this makes UTC the timezone)
RUN apt-get install -y \
    tzdata \
    git \
    sudo \
    screen \
    default-jre \
    awscli \
    zip \
    curl \
    flex \
    bison \
    libxml2-dev \
    gtk-doc-tools \
    libtool \
    automake \
    libssl-dev \
    emacs \
    python3.7 \
    python3.7-dev \
    python3.7-venv \
    mysql-server \
    mysql-client \
    libmysqlclient-dev \
    python3-mysqldb \
    postgresql

# give sudo privilege to user ubuntu:
RUN usermod -aG sudo ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu
RUN touch /home/ubuntu/.sudo_as_admin_successful
RUN chown ubuntu.ubuntu /home/ubuntu/.sudo_as_admin_successful

# switch to user ubuntu
USER ubuntu

# set environment vars from .sh and .shinc files
ENV mysql_user=ubuntu
ENV mysql_password=1337
ENV psql_user=ubuntu
ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_ROOT_PASSWORD=${mysql_password}
ENV BUILD_DIR=/home/ubuntu/kg2-build
ENV VENV_DIR=/home/ubuntu/kg2-venv
ENV CODE_DIR=/home/ubuntu/kg2-code
ENV umls_dir=${BUILD_DIR}/umls
ENV umls_dest_dir=${umls_dir}/META
ENV s3_region=us-west-2
ENV s3_bucket=rtx-kg2
ENV s3_bucket_public=rtx-kg2-public
ENV s3_bucket_versioned=rtx-kg2-versioned
ENV s3_cp_cmd="aws s3 cp --no-progress --region ${s3_region}"
ENV mysql_conf=/home/ubuntu/RTX-KG2/mysql-config.conf
ENV curl_get="curl -s -L -f"
ENV curies_to_categories_file=${CODE_DIR}/curies-to-categories.yaml
ENV curies_to_urls_file=${CODE_DIR}/curies-to-urls-map.yaml
ENV predicate_mapping_file=${CODE_DIR}/predicate-remap.yaml
ENV infores_mapping_file=${CODE_DIR}/kg2-provided-by-curie-to-infores-curie.yaml
ENV ont_load_inventory_file=${CODE_DIR}/ont-load-inventory${test_suffix}.yaml
ENV umls2rdf_config_master=${CODE_DIR}/umls2rdf-umls.conf
ENV rtx_config_file=RTXConfiguration-config.json
ENV biolink_model_version=3.1.2

# following steps from documentation under build procedure #1.
# Reference: README.md##build-option-1-build-kg2-in-parallel-directly-on-an-ubuntu-system
# (1) Install the `git` and `screen` packages
# Added screen to earlier installations in this file.
# (2) change to the home directory for user `ubuntu`:
WORKDIR /home/ubuntu

RUN mkdir -p ${BUILD_DIR}

# (3) Clone the RTX software from GitHub:
# Defering to use local copy of source to keep builds in alignment
# with current branch or fork code.
COPY . /home/ubuntu/RTX-KG2

RUN sudo chmod +x /home/ubuntu/RTX-KG2/wait-for-mysql.sh

# mysql configuration block
# set mysql server variable to allow loading data from a local file

# start mysql and run configurations
RUN sudo service mysql start && \
    sudo mysql -u root -e "CREATE USER IF NOT EXISTS '${mysql_user}'@'localhost' IDENTIFIED BY '${mysql_password}';" && \
    sudo mysql -u root --password="${mysql_password}" -e "GRANT ALL PRIVILEGES ON *.* to '${mysql_user}'@'localhost';" && \
    sudo mysql --defaults-extra-file=${mysql_conf} -e "set global local_infile=1"

# start postgres and run configuration
RUN sudo service postgresql start && \
    sudo -u postgres psql -c "DO \$do\$ BEGIN IF NOT EXISTS ( SELECT FROM pg_catalog.pg_roles WHERE rolname = '${psql_user}' ) THEN CREATE ROLE ${psql_user} LOGIN PASSWORD null; END IF; END \$do\$;" && \
    sudo -u postgres psql -c "ALTER USER ${psql_user} WITH password null"

# (4) Setup the KG2 build system: 
# Note: bash with the -x flag uses xtrace
RUN bash /home/ubuntu/RTX-KG2/setup-kg2-build.sh

