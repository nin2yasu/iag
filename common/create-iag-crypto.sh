#!/bin/bash

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

pushd ${RUNDIR}
openssl req -newkey rsa -nodes -config iag_cert_config -x509 -out iag.cert.pem -days 730
cat iag.cert.pem iag.key.pem > secret_files/iag.certkey.pem
rm iag.key.pem
rm iag.cert.pem
popd
