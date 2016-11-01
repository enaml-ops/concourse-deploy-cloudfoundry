#!/bin/bash -e

echo -e "$BOSH_CACERT" > ca.cert

bosh --ca-cert ca.cert -n target $BOSH_TARGET
bosh -n download manifest $BOSH_DEPLOYMENT_NAME $BOSH_DEPLOYMENT_NAME.yml
bosh -n deployment $BOSH_DEPLOYMENT_NAME.yml
bosh -n run errand $BOSH_ERRAND

#eof
