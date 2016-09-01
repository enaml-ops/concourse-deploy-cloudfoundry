#!/bin/bash -e

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type cloudconfig \
  -pluginpath omg-cli/$CLOUD_CONFIG_PLUGIN

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath omg-cli-product-bundle/$PRODUCT_PLUGIN

omg-cli/omg-linux deploy-product \
  $PRODUCT_PLUGIN
  --infer-from-cloud \
  --print-manifest \
  --vault-active \
  --vault-domain $VAULT_DOMAIN \
  --vault-hash-host $VAULT_HASH_HOST \
  --vault-hash-ip $VAULT_HASH_IP \
  --vault-hash-keycert $VAULT_HASH_KEYCERT \
  --vault-hash-password $VAULT_HASH_PASSWORD \
  --vault-token $VAULT_TOKEN > manifest/deployment.yml

#eof
