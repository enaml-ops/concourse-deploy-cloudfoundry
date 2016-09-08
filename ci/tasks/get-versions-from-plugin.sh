#!/bin/bash -e

if [[ -z $PRODUCT ]] ; then
  printf "ERROR: \$PRODUCT not defined"
  exit 1
fi

if [[ -z $OUTPUT_DIR ]] ; then
  printf "ERROR: \$OUTPUT_DIR not defined"
  exit 1
fi

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type cloudconfig \
  -pluginpath omg-cli/$CLOUD_CONFIG_PLUGIN

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath omg-cli-product-bundle/$PRODUCT_PLUGIN

omg-cli/omg-linux product-meta $PRODUCT_PLUGIN | \
  grep ^pivotal-$PRODUCT | awk '{print $3}' > $OUTPUT_DIR/version

#eof
