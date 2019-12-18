#!/bin/bash

if [ $# -ne 2 ];then
  echo "Usage: ${0} <config dir> <publish_host:port>"
  exit 1
fi

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR/..\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ]; then
  echo "Failed to get local path"
  exit 1  # fail
fi

if [ -f ${RUNDIR}/common/config.properties ];then
  . ${RUNDIR}/common/config.properties
else
  echo "Couldn't find ${RUNDIR}/common/config.properties"
  exit 1 #Fail
fi

if [ ! -d ${RUNDIR}/docker/mounts ];then
  mkdir ${RUNDIR}/docker/mounts
fi

if [ -d ${RUNDIR}/docker/mounts/${1}.mount ];then
  rm -rf ${RUNDIR}/docker/mounts/${1}.mount
fi

if [ -d ${RUNDIR}/configs/${1}/src/ ];then
  cp -R ${RUNDIR}/configs/${1}/src ${RUNDIR}/docker/mounts/${1}.mount
else
  echo "Couldn't find directory ${RUNDIR}/configs/${1}/src/"
  exit 1 #Fail
fi

if [ ! -f "$RUNDIR/common/secret_files/iag.certkey.pem" ]
then
        echo "Keys not generated yet; calling creation script..."
        $RUNDIR/common/create-iag-crypto.sh
fi

docker rm -f iag-${1} > /dev/null 2>&1

docker run -d --name iag-${1} \
  -v ${RUNDIR}/docker/mounts/${1}.mount:/var/iag/config \
  -v ${RUNDIR}/common/secret_files:/var/iag/config/secret_files \
  -v ${RUNDIR}/common/env_files:/var/iag/config/env_files \
  --env-file=${RUNDIR}/common/config.properties \
  -p ${2}:8443 \
  ibmcom/ibm-application-gateway:19.12
if [ $? -eq 0 ];then
  echo "Logs for container... Ctrl-c will not terminate container."
  docker logs -f iag-${1}
fi
