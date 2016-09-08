#!/bin/bash -e

if [[ -z $PRODUCT ]] ; then
  printf "ERROR: \$PRODUCT not defined\n"
  exit 1
fi

if [[ -z $OUTPUT_DIR ]] ; then
  printf "ERROR: \$OUTPUT_DIR not defined\n"
  exit 1
fi

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type cloudconfig \
  -pluginpath omg-cli/$CLOUD_CONFIG_PLUGIN

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath omg-cli-product-bundle/$PRODUCT_PLUGIN

PRODUCT_NAME=$(printf $PRODUCT_PLUGIN | cut -d- -f1)

omg-cli/omg-linux product-meta $PRODUCT_NAME | \
  grep ^pivotal-$PRODUCT | awk '{print $NF}' > $OUTPUT_DIR/version

printf "Version $(<$OUTPUT_DIR/version)\n"

#eof
