#!/bin/bash -e

if [[ -z $PRODUCT ]]; then
  printf "ERROR: \$PRODUCT not defined\n"
  exit 1
fi

if [[ -z $PIVNET_API_TOKEN ]]; then
  printf "ERROR: \$PIVNET_API_TOKEN not defined\n"
  exit 1
fi

if [[ -z $OUTPUT_DIR ]]; then
  printf "ERROR: \$OUTPUT_DIR not defined\n"
  exit 1
fi

# If "latest" or specific version is specified, use it.  Otherwise,
# read the version from the omg product plugin.
if [[ $VERSION == "from-omg-plugin" ]] ; then
  VERSION=$(<versions/version)
fi

# Determine latest version
if [[ $VERSION == "latest" ]]; then
  PIVNET_REL_VERSION=$(curl -s https://network.pivotal.io/api/v2/products/$PRODUCT/releases | \
    jq '[.releases[].version]' | \
    grep '[0-9].[0-9].[0-9]' | \
    awk -F\" '{print $2}' | sort -r | head -1)
else
  PIVNET_REL_VERSION=$VERSION
fi

# Get the release id for the version
CMD="curl -s https://network.pivotal.io/api/v2/products/$PRODUCT/releases | jq ' .releases[] | select(.version == \"$PIVNET_REL_VERSION\") | .id'"
RELEASE_ID=$(eval $CMD)

# Accept EULA
CMD="curl -s https://network.pivotal.io/api/v2/products/$PRODUCT/releases | jq ' .releases[] | select(.version == \"$PIVNET_REL_VERSION\") | ._links.eula_acceptance.href '"
EULA=$(eval $CMD | tr -d '"')
curl -s -H "Authorization: Token $PIVNET_API_TOKEN" -X POST $EULA

# Determine product name if a stemcell
if [[ $PRODUCT == "stemcells" ]]; then
  if [[ -z $STEMCELL_CPI ]]; then
    printf "ERROR: \$STEMCELL_CPI not defined"
    exit 1
  fi
  CMD="curl -s https://network.pivotal.io/api/v2/products/$PRODUCT/releases/$RELEASE_ID/product_files | jq ' .product_files[] | .name' | grep -i $STEMCELL_CPI "
  PRODUCT_NAME=$(eval $CMD | tr -d '"')
fi

# Get download link & checksum
CMD="curl -s https://network.pivotal.io/api/v2/products/$PRODUCT/releases/$RELEASE_ID/product_files | jq ' .product_files[] | select(.name == \"$PRODUCT_NAME\") | ._links.download.href'"
PIVNET_LINK=$(eval $CMD | tr -d '"')

CMD="curl -s -X GET https://network.pivotal.io/api/v2/products/$PRODUCT/releases/$RELEASE_ID/product_files | jq ' .product_files[] | select(.name == \"$PRODUCT_NAME\") | ._links.self.href'"
PIVNET_SELF=$(eval $CMD | tr -d '"')

MD5_HASH=$(curl -s $PIVNET_SELF | jq ' .product_file.md5' | tr -d '"')

# Download
echo "Downloading $PRODUCT $PIVNET_REL_VERSION version from $PIVNET_LINK with md5=$MD5_HASH..."
wget -O $OUTPUT_DIR/$PRODUCT-$PIVNET_REL_VERSION.pivotal --post-data="" --header="Authorization: Token $PIVNET_API_TOKEN" $PIVNET_LINK

# Get MD5 hash of the downloaded file
MD5_HASH_DL=$(openssl md5 $OUTPUT_DIR/$PRODUCT-$PIVNET_REL_VERSION.pivotal | awk -F "= " '{print$2}')

# Test if MD5 hash matches, if true; then unzip
if [[ $MD5_HASH_DL != $MD5_HASH ]]; then
  printf "ERROR: MD5 hash does not match for $PRODUCT-$PIVNET_REL_VERSION.pivotal\n"
  exit 1
else
  printf "MD5 matches for $PRODUCT-$PIVNET_REL_VERSION.pivotal\n"
fi

# Extract the bosh release to $OUTPUT_DIR/releases
unzip -d $OUTPUT_DIR $PRODUCT-$PIVNET_REL_VERSION.pivotal

#eof
