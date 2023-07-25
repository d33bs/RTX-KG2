#!/usr/bin/env bash
# setup-kg2.sh:  setup the environment for building the KG2 knowledge graph for the RTX biomedical reasoning system
# Copyright 2019 Stephen A. Ramsey <stephen.ramsey@oregonstate.edu>

# Options:
# ./setup-kg2-build.sh test       Generates a logfile `setup-kg2-build-test.log` instead of `setup-kg2-build.log`
# ./setup-kg2-build.sh travisci   Accommodate Travis CI's special runtime environment
set -x

set -o nounset -o pipefail -o errexit

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo Usage: "$0 [travisci|test]" 
    exit 2
fi

# Usage: setup-kg2-build.sh [travisci|test]

build_flag=${1:-""}

## setup the shell variables for various directories
config_dir=`dirname "$0"`
if [[ "${build_flag}" == "travisci" ]]
then
    sed -i "\@CODE_DIR=~/kg2-code@cCODE_DIR=/home/travis/build/RTXteam/RTX-KG2" ${config_dir}/master-config.shinc
fi
# source ${config_dir}/master-config.shinc

if [[ "${build_flag}" != "test" ]]
then
    test_str=""
else
    test_str="-test"
fi

# mysql_user=ubuntu
# mysql_password=1337
if [[ "${build_flag}" != "travisci" ]]
then
    psql_user=ubuntu
fi

mkdir -p ${BUILD_DIR}
setup_log_file=${BUILD_DIR}/setup-kg2-build${test_str}.log

echo "================= starting setup-kg2.sh ================="
date

echo `hostname`

## sym-link into RTX-KG2/
if [ ! -L ${CODE_DIR} ]; then
    if [[ "${build_flag}" != "travisci" ]]
    then
        ln -sf ~/RTX-KG2 ${CODE_DIR}
    fi
fi

# adding these to the dockerfile configuration
# ## install the Linux distro packages that we need (python3-minimal is for docker installations)
# sudo apt-get update

# ## handle weird tzdata install (this makes UTC the timezone)
# sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

# # install various other packages used by the build system
# #  - curl is generally used for HTTP downloads
# #  - wget is used by the neo4j installation script (some special "--no-check-certificate" mode)
# sudo apt-get install -y \
#      default-jre \
#      awscli \
#      zip \
#      curl \
#      wget \
#      flex \
#      bison \
#      libxml2-dev \
#      gtk-doc-tools \
#      libtool \
#      automake \
#      git \
#      libssl-dev

# added mysql sections to dockerfile configuration
# sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_password}"
# sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_password}"

# sudo apt-get install -y mysql-server \
#      mysql-client \
#      libmysqlclient-dev \
#      python3-mysqldb

# sudo service mysql start

# if [[ "${build_flag}" != "travisci" ]]
# then
#     ## this is for convenience when I am remote working
#     sudo apt-get install -y emacs
# fi

# we want python3.7 (also need python3.7-dev or else pip cannot install the python package "mysqlclient")
if [[ "${build_flag}" != "travisci" ]]
then
    # ported from setup-python37-with-pip3-in-ubuntu.shinc for simplification
    # this [portion of the] shell script is meant to be run with "source" assuming that you have already sourced "master.shinc"
    # - installs python3.7 in either Ubuntu 18.04 or 20.04, along with pip3, and creates a python3.7 virtualenv
    #   in the directory identified by the environment variable VENV_DIR (which must already exist before this
    #   script is executed)

    # added to dockerfile configuration
    # sudo apt-get update
    # sudo apt-get install -y software-properties-common
    # sudo -E add-apt-repository -y ppa:deadsnakes/ppa
    # sudo apt-get install -y python3.7 python3.7-dev python3.7-venv

    # some shenanigans required in order to install pip into python3.7 (not into python3.6!)
    curl -s https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    apt-get download python3-distutils
    if [ -f python3-distutils_3.6.9-1~18.04_all.deb ]
    then
    python3_distutils_filename=python3-distutils_3.6.9-1~18.04_all.deb
    else
        if [ -f python3-distutils_3.8.10-0ubuntu1~20.04_all.deb ]
        then
    python3_distutils_filename=python3-distutils_3.8.10-0ubuntu1~20.04_all.deb
        else
            >&2 echo "Unrecognized python3 distutils .deb package filename; this is a bug in setup-python37-with-pip3-in-ubuntu.shinc"
            exit 1
        fi
    fi
    mv ${python3_distutils_filename} /tmp
    sudo dpkg-deb -x /tmp/${python3_distutils_filename} /
    sudo -H python3.7 /tmp/get-pip.py 2>&1 | grep -v "WARNING: Running pip as the 'root' user"

    ## create a virtualenv for building KG2
    python3.7 -m venv ${VENV_DIR}

    ## Install python3 packages that we will need (Note: we are not using pymongo
    ## directly, but installing it silences a runtime warning from ontobio):
    ## (maybe we should eventually move this to a requirements.txt file?)
    # added: 
    # - setuptools update
    # - build to enable pyproject.toml installations from dependencies (notably, pydanatic-core)
    # - setuptools-rust for cryptography pkg dependency build
    # upgrade setuptools for installations
    # installation for cryptography dep.
    ${VENV_DIR}/bin/pip3 uninstall --yes setuptools 
    ${VENV_DIR}/bin/pip3 install setuptools-rust pip setuptools -U
    ${VENV_DIR}/bin/pip3 install "cryptography>=2.0"
    # installation for cffi
    ${VENV_DIR}/bin/pip3 install cffi

    ${VENV_DIR}/bin/pip3 install wheel build


    # backout from setuptools-rust for setuptools and other dep installations
    ${VENV_DIR}/bin/pip3 uninstall --yes setuptools
    ${VENV_DIR}/bin/pip3 install setuptools
    

    # clone and install pydantic-core, dependency of other pkgs
    git clone --branch v2.3.0 --depth 1 --single-branch https://github.com/pydantic/pydantic-core $BUILD_DIR/pydantic-core
    cd $BUILD_DIR/pydantic-core
    # creates a wheel from pypoject.toml (py3.7 is incompatible with pyproject.toml)
    ${VENV_DIR}/bin/python3 -m build
    # install from the wheel
    ${VENV_DIR}/bin/pip3 install dist/pydantic_core-2.3.0-cp37-cp37m-linux_x86_64.whl
    # return to the prior directory
    cd -
    ${VENV_DIR}/bin/pip3 install -r ${CODE_DIR}/requirements-kg2-build.txt
else
    pip install -r ${CODE_DIR}/requirements-kg2-build.txt
fi


## install ROBOT (software: ROBOT is an OBO Tool) by downloading the jar file
## distribution and cURLing the startup script (note github uses URL redirection
## so we need the "-L" command-line option, and cURL doesn't like JAR files by
## default so we need the "application/zip")
${curl_get} -H "Accept: application/zip" https://github.com/RTXteam/robot/releases/download/v1.3.0/robot.jar > ${BUILD_DIR}/robot.jar 
curl -s https://raw.githubusercontent.com/RTXteam/robot/v1.3.0/bin/robot > ${BUILD_DIR}/robot
chmod +x ${BUILD_DIR}/robot

## setup owltools
${curl_get} ${BUILD_DIR} https://github.com/RTXteam/owltools/releases/download/v0.3.0/owltools > ${BUILD_DIR}/owltools
chmod +x ${BUILD_DIR}/owltools



# commenting out the below to avoid AWS work
# if [[ "${build_flag}" != "travisci" ]]
# then
#     ## setup AWS CLI
#     if ! ${s3_cp_cmd} s3://${s3_bucket}/test-file-do-not-delete /tmp/; then
#         aws configure
#     else
#         rm -f /tmp/test-file-do-not-delete
#     fi
# fi

RAPTOR_NAME=raptor2-2.0.15
# setup raptor (used by the "checkOutputSyntax.sh" script in the umls2rdf package)
${curl_get} -o ${BUILD_DIR}/${RAPTOR_NAME}.tar.gz http://download.librdf.org/source/${RAPTOR_NAME}.tar.gz
rm -r -f ${BUILD_DIR}/${RAPTOR_NAME}
tar xzf ${BUILD_DIR}/${RAPTOR_NAME}.tar.gz -C ${BUILD_DIR} 
cd ${BUILD_DIR}/${RAPTOR_NAME}
./autogen.sh --prefix=/usr/local
make
make check
sudo make install
sudo ldconfig

# added to dockerfile
# if [[ "${build_flag}" != "travisci" ]]
# then
#     # setup MySQL
#     MYSQL_PWD=${mysql_password} mysql -u root -e "CREATE USER IF NOT EXISTS '${mysql_user}'@'localhost' IDENTIFIED BY '${mysql_password}'"
#     MYSQL_PWD=${mysql_password} mysql -u root -e "GRANT ALL PRIVILEGES ON *.* to '${mysql_user}'@'localhost'"
#
#     cat >${mysql_conf} <<EOF
# [client]
# user = ${mysql_user}
# password = ${mysql_password}
# host = localhost
# EOF
# ## set mysql server variable to allow loading data from a local file
# mysql --defaults-extra-file=${mysql_conf} \
#       -e "set global local_infile=1"
# ## setup PostGreSQL
# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# sudo apt-get update
# sudo apt-get -y install postgresql
#     sudo -u postgres psql -c "DO \$do\$ BEGIN IF NOT EXISTS ( SELECT FROM pg_catalog.pg_roles WHERE rolname = '${psql_user}' ) THEN CREATE ROLE ${psql_user} LOGIN PASSWORD null; END IF; END \$do\$;"
#     sudo -u postgres psql -c "ALTER USER ${psql_user} WITH password null"
# fi

if [[ "${build_flag}" == "travisci" ]]
then
    export PATH=$PATH:${BUILD_DIR}
fi

date

echo "================= script finished ================="

# commenting out the below to avoid AWS work
# if [[ "${build_flag}" != "travisci" ]]
# then
#     ${s3_cp_cmd} ${setup_log_file} s3://${s3_bucket_versioned}/
# fi
