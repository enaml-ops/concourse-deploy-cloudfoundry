#!/bin/bash -e

# Create or rotate certificates and passwords/preshared keys
# in the $VAULT_HASH_KEYCERT and $VAULT_HASH_PASSWORD vault
# hashes.  $SYSTEM_DOMAIN is required for certificate generation.

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath omg-product-bundle/$PRODUCT_PLUGIN

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
  $HAPROXY_FLAG \
  --infer-from-cloud \
  --system-domain $SYSTEM_DOMAIN \
  --vault-active \
  --vault-domain $VAULT_ADDR \
  --vault-hash-host $VAULT_HASH_HOSTVARS \
  --vault-hash-ip $VAULT_HASH_IP \
  --vault-hash-keycert $VAULT_HASH_KEYCERT \
  --vault-hash-misc $VAULT_HASH_MISC \
  --vault-hash-password $VAULT_HASH_PASSWORD \
  --vault-rotate \
  --vault-token $VAULT_TOKEN > throw-away-manifest.yml

#eof
