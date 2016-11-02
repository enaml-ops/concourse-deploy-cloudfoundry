export VAULT_ADDR=http://1.0.0.4:8200
export VAULT_TOKEN=12345678989
export VAULT_CRED_HASH=secret/my-hash
export VAULT_NET_HASH=secret/my-hash
./vault write ${VAULT_CRED_HASH} bosh-cacert=@rootCA.pem bosh-client-secret=@director.pwd bosh-pass=@director.pwd @deployment-props.json
./vault write ${VAULT_NET_HASH} @deployment-net.json
