#!/bin/bash

set -e

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'

TAG="$1"

VENDOR_XML="vendor.xml"
TMP_VENDOR=".clo_vendor_tmp.xml"
VENDOR_URL="https://git.codelinaro.org/clo/la/la/vendor/manifest/-/raw/$TAG/$TAG.xml"

if [ -z "$TAG" ]; then
    echo -e "Usage: ./update-vendor.sh <LA.VENDOR.*>"
    exit 1
fi

if [[ $TAG != LA.VENDOR* ]]; then
    echo -e "${red}Only VENDOR tags supported (LA.VENDOR.*)$end"
    exit 1
fi

if ! wget -q --spider "$VENDOR_URL"; then
    echo -e "${red}Invalid VENDOR tag: $TAG$end"
    exit 1
fi

echo -e "${blu}Downloading CLO vendor manifest $TAG...$end"
curl -Ls "$VENDOR_URL" -o "$TMP_VENDOR"

echo -e "${blu}Replacing vendor.xml...$end"
cp "$TMP_VENDOR" "$VENDOR_XML"
rm -f "$TMP_VENDOR"

git add "$VENDOR_XML"
echo -e "${grn}vendor.xml updated & staged. Commit manually when ready.$end"