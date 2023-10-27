#!/bin/bash

# used for testing Docker or Apptainer/Singularity images for kg2

# setting to exit the script on any failures
set -e

# switch user to ubuntu and run commands
su - ubuntu <<'EOF'
    # cd to the home dir for ubuntu user
    cd /home/ubuntu

    # run the build script
    bash -x /home/ubuntu/RTX-KG2/setup-kg2-build.sh
EOF

# seek success text in specific log file
if grep -q "======= script finished ======" "/home/ubuntu/kg2-build/setup-kg2-build.log"; then
    echo "setup-kg2-build.sh finished successfully."
else
    echo "Error: setup-kg2-build.sh did not finish successfully."
    exit 1
fi

