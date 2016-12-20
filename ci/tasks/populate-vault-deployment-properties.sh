#!/bin/bash -e

# initializes values for vault from a given deployment-props.json file
#
#

echo "${VAULT_PROPERTIES_JSON}" > deployment-props.json
echo "${BOSH_CACERT}" > rootCA.pem

echo "requires files (rootCA.pem, director.pwd, deployment-props.json)"
vault write ${VAULT_HASH_MISC} \
  bosh-cacert=@rootCA.pem \
  bosh-client-secret="${BOSH_CLIENT_SECRET}" \
  bosh-pass="${BOSH_CLIENT_SECRET}" @deployment-props.json

vault read ${VAULT_HASH_MISC}


#eof
