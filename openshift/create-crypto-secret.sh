#!/bin/bash

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

if [ ! -f "$RUNDIR/../common/certkey.pem" ]
then
        echo "Keys not generated yet; calling creation script..."
        $RUNDIR/../common/create-cert.sh
fi

echo "Deleting iag-crypto Secret (if it exists)"
oc delete secret iag-crypto > /dev/null 2>&1
echo "Creating new iag-crypto Secret"
oc create secret generic iag-crypto --from-file=front-end-cert-key=${RUNDIR}/../common/certkey.pem
