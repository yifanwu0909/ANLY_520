#!/bin/bash
# set -x -e
#
# (C) Copyright 2017 Simson L. Garfinkel, Marck Vaisman
# Creative Commons Attribution-ShareAlike 4.0 license
# https://creativecommons.org/licenses/by-sa/4.0/
#
# bootstrap script for S3 clusters
# Log output to /var/log/bootstrap-actions/
# This script runs as the hadoop user


echo Cluster Customization started at `date`

# Install Linux "yum" packages we want
sudo yum install -y libjpeg-devel

export SPARK_HOME=/usr/lib/spark
export PYSPARK_DRIVER_PYTHON=ipython
# export PYSPARK_DRIVER_PYTHON_OPTS='notebook'
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib:$SPARK_HOME/python/lib/py4j-src.zip

sudo pip install ipython==5.4 jupyter matplotlib pandas findspark scikit-learn

# Additions to .bashrc
# Remember --- Amazon default .bashrc does not have an EOL, so we need to start with a blank line
echo "" >> /home/hadoop/.bashrc
cat  >> /home/hadoop/.bashrc << EOF
## ANLY 502 Additions START
export HADOOP_HOME=/usr/lib/hadoop
export PUBLIC_IP=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
export INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
export AWS_DEFAULT_REGION=$(curl --retry 5 --silent --connect-timeout 2 http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
export AWS_INSTANCE_ID=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
export AWS_AVAILABILITY_ZONE=$(curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone)
export JAVA_HOME=/etc/alternatives/jre
export SPARK_HOME=/usr/lib/spark
# export PYSPARK_DRIVER_PYTHON=ipython
# export PYSPARK_DRIVER_PYTHON_OPTS='notebook'
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib:$SPARK_HOME/python/lib/py4j-src.zip
export PYTHONHASHSEED=42
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --no-browser --port=8888 --ip=0.0.0.0 --NotebookApp.token=''"
# alias ipyspark="export PYSPARK_DRIVER_PYTHON=python3;pyspark"

## ANLY 502 Additions END
EOF

source /home/hadoop/.bashrc

# Start screen session and detach
screen -dm bash -c "PYSPARK_DRIVER_PYTHON=jupyter pyspark"

echo Cluster Customization completed at `date`

echo "


-------------- POST STARTUP SCRIPT COMPLETE ---------------
ipython and Jupyter (running Python 2) are configured.
To access Jupyter notebook, logoff with the exit command
and log back on using agent and port forwarding:
ssh -A -L8888:localhost:8888 hadoop@...
and then open a web browser and go to http://localhost:8888
-----------------------------------------------------------


"

