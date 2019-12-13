#!/bin/bash

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

pushd ${RUNDIR}
openssl req -newkey rsa -nodes -config cert_config -x509 -out cert.pem -days 730
cat cert.pem key.pem > certkey.pem
echo -n B64::
cat certkey.pem | base64
popd
