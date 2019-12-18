#!/bin/bash

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

pushd ${RUNDIR}/demoapp
openssl req -newkey rsa -nodes -config ../demoapp_cert_config -x509 -out demoapp.cert.pem -days 730
popd
cp ${RUNDIR}/demoapp/demoapp.cert.pem ${RUNDIR}/env_files
