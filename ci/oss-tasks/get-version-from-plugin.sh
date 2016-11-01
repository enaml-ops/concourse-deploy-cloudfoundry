#!/bin/bash -e

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath omg-product-bundle/$PRODUCT_PLUGIN

PRODUCT_NAME=$(printf ${PRODUCT_PLUGIN%%-*})

omg-cli/omg-linux product-meta $PRODUCT_NAME | \
  awk '/^pivotal-/ {printf $NF}' > $OUTPUT_DIR/product_version

omg-cli/omg-linux product-meta $PRODUCT_NAME | \
  awk '/^stemcell:/ {printf $NF}' > $OUTPUT_DIR/stemcell_version

printf "Pivotal $PRODUCT_NAME version: $(<$OUTPUT_DIR/product_version)\n"
printf "Stemcell version: $(<$OUTPUT_DIR/stemcell_version)\n"

#eof
