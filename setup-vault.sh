export VAULT_ADDR=http://1.0.0.4:8200
export VAULT_HASH=secret/my-hash
./vault write ${VAULT_HASH} bosh-cacert=@rootCA.pem bosh-client-secret=@director.pwd bosh-pass=@director.pwd @deployment-props.json
