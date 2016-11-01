#!/bin/bash -e

curl -SsL -u "$CONCOURSE_USER:$CONCOURSE_PASS" "$CONCOURSE_URL/api/v1/cli?arch=amd64&platform=linux" > fly
chmod +x fly

./fly -t here login -c "$CONCOURSE_URL" -u "$CONCOURSE_USER" -p "$CONCOURSE_PASS"
./fly -t here get-pipeline -p $PIPELINE_NAME > $PIPELINE_NAME.yml

sed -i.original "

  /^resources:$/,/^resource_types:$/ {

    /^- name: $PRODUCT$/,/product_version:/ {
      s,\(product_version:\).*,\1 $(<versions/product_version),
    }

    /^- name: stemcells$/,/product_version:/ {
      s,\(product_version:\).*,\1 \"$(<versions/stemcell_version)\",
    }

  }

  s,\(STEMCELL_VERSION:\).*,\1 \"$(<versions/stemcell_version)\",

" $PIPELINE_NAME.yml

./fly -t here set-pipeline -n -p $PIPELINE_NAME -c $PIPELINE_NAME.yml

#eof
