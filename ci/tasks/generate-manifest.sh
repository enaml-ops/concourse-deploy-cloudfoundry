#!/bin/bash -e

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath ert-plugin/$PRODUCT_PLUGIN

if [[ $SKIP_HAPROXY == "false" ]]; then
  HAPROXY_FLAG="--skip-haproxy=false"
fi

omg-cli/omg-linux deploy-product \
  --bosh-url $(vault read -field=bosh-url $VAULT_HASH_MISC) \
  --bosh-port $(vault read -field=bosh-port $VAULT_HASH_MISC) \
  --bosh-user $(vault read -field=bosh-user $VAULT_HASH_MISC) \
  --bosh-pass $(vault read -field=bosh-pass $VAULT_HASH_MISC) \
  --print-manifest \
  --ssl-ignore \
  $PRODUCT_PLUGIN \
  --cf-mysql-release-version $(<cf-mysql-release/version) \
  --cf-release-version $(<cf-release/version) \
  --cflinuxfs2-release-version $(<cflinuxfs2-release/version) \
  --diego-release-version $(<diego-release/version) \
  --etcd-release-version $(<etcd-release/version) \
  --garden-release-version $(<garden-release/version) \
  $HAPROXY_FLAG \
  --infer-from-cloud \
  --stemcell-version $(<stemcells/version) \
  --vault-active \
  --vault-domain $VAULT_ADDR \
  --vault-hash-host $VAULT_HASH_HOSTVARS \
  --vault-hash-ip $VAULT_HASH_IP \
  --vault-hash-keycert $VAULT_HASH_KEYCERT \
  --vault-hash-password $VAULT_HASH_PASSWORD \
  --vault-token $VAULT_TOKEN > manifest/deployment.yml

#eof
