#!/bin/bash -e

curl -SsL -u "$CONCOURSE_USER:$CONCOURSE_PASS" "$CONCOURSE_URL/api/v1/cli?arch=amd64&platform=linux" > fly
chmod +x fly

./fly -t here login -c "$CONCOURSE_URL" -u "$CONCOURSE_USER" -p "$CONCOURSE_PASS"
./fly -t here get-pipeline -p $PIPELINE_NAME > $PIPELINE_NAME.yml
./fly -t here set-pipeline -p $PIPELINE_NAME -c $PIPELINE_NAME.yml \
  -v elastic-runtime-version=$(<versions/product_version) \
  -v stemcell-version=$(<versions/stemcell_version) <<EOF
y
EOF

#eof
