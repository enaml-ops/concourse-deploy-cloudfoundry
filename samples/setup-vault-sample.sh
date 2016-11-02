export VAULT_ADDR=http://1.0.0.4:8200
export VAULT_TOKEN=12345678989
export VAULT_HASH=secret/cf-nonprod-props
echo "requires files (rootCA.pem, director.pwd, deployment-props.json)"
vault write ${VAULT_HASH} \
  bosh-cacert=@rootCA.pem \
  bosh-client-secret=@director.pwd \
  bosh-pass=@director.pwd @deployment-props.json

vault read ${VAULT_HASH} 
