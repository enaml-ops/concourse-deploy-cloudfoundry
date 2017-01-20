#!/bin/bash -e

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath ert-plugin/$PRODUCT_PLUGIN

UAA_LDAP_ENABLED=$(vault read -field=uaa-ldap-enabled $VAULT_HASH_MISC)
ALLOW_APP_SSH_ACCESS=$(vault read -field=allow-app-ssh-access $VAULT_HASH_MISC)
SKIP_HAPROXY=$(vault read -field=skip-haproxy $VAULT_HASH_MISC)

if [[ $UAA_LDAP_ENABLED == "true" ]]; then
  UAA_LDAP_ENABLED_FLAG="--uaa-ldap-enabled=true"
fi

if [[ $ALLOW_APP_SSH_ACCESS == "true" ]]; then
  SSH_FLAG="--allow-app-ssh-access=true"
fi

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
  $SSH_FLAG \
  $HAPROXY_FLAG \
  $UAA_LDAP_ENABLED_FLAG \
  --infer-from-cloud \
  --stemcell-version $STEMCELL_VERSION \
  --vault-active \
  --vault-domain $VAULT_ADDR \
  --vault-hash-host $VAULT_HASH_HOSTVARS \
  --vault-hash-ip $VAULT_HASH_IP \
  --vault-hash-keycert $VAULT_HASH_KEYCERT \
  --vault-hash-misc $VAULT_HASH_MISC \
  --vault-hash-password $VAULT_HASH_PASSWORD \
  --vault-token $VAULT_TOKEN > manifest/deployment.yml

#eof
