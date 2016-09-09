#!/bin/bash -e

for TILE in $PRODUCT_DIR/*.pivotal; do
  unzip -d $OUTPUT_DIR $TILE
done

#eof
