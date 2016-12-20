#!/bin/bash -e

for TILE in $PRODUCT_DIR/*.pivotal; do
  unzip -d $OUTPUT_DIR $TILE
done

echo "we dont want the consul release"
rm -fr ${OUTPUT_DIR}/releases/consul*

#eof
