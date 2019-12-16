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

if [ -f ${RUNDIR}/docker/docker.properties ];then
  . ${RUNDIR}/docker/docker.properties
else
  echo "Couldn't find ${RUNDIR}/docker/docker.properties"
  exit 1 #Fail
fi

if [ -d ${RUNDIR}/configs/${1}/src/ ];then
  cp -R ${RUNDIR}/configs/${1}/src ${RUNDIR}/docker/${1}.mount
else
  echo "Couldn't find directory ${RUNDIR}/configs/${1}/src/"
  exit 1 #Fail
fi

if [ ! -f "$RUNDIR/common/certkey.pem" ]
then
        echo "Keys not generated yet; calling creation script..."
        $RUNDIR/common/create-cert.sh
fi

docker run -d --name iag-${1} \
  -v ${RUNDIR}/docker/${1}.mount:/var/iag/config \
  -v ${RUNDIR}/common/certkey.pem:/var/iag/config/crypto/front-end-cert-key \
  -e CI_TENANT_HOST=${CI_TENANT_HOST} \
  -e OIDC_CLIENT_ID=${OIDC_CLIENT_ID} \
  -e OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET} \
  -p ${2}:8443 \
  ibmcom/ibm-application-gateway:19.12
