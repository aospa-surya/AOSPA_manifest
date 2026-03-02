#!/bin/bash

set -e

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'

TAG="$1"
MANIFEST_XML="system.xml"
TMP_MANIFEST=".clo_system_tmp.xml"
MANIFEST_URL="https://git.codelinaro.org/clo/la/la/system/manifest/-/raw/$TAG/$TAG.xml"

if [ -z "$TAG" ]; then
    echo -e "Usage: ./system-allinone.sh <LA.QSSI.*>"
    exit 1
fi

if [[ $TAG != LA.QSSI* ]]; then
    echo -e "${red}Only QSSI tags supported!$end"
    exit 1
fi

if ! wget -q --spider "$MANIFEST_URL"; then
    echo -e "${red}Invalid tag: $TAG$end"
    exit 1
fi

echo -e "${blu}Downloading CLO system manifest $TAG...$end"
curl -Ls "$MANIFEST_URL" -o "$TMP_MANIFEST"

echo -e "${blu}Replacing system.xml with CLO manifest...$end"
cp "$TMP_MANIFEST" "$MANIFEST_XML"

rm -f "$TMP_MANIFEST"

git add system.xml
echo -e "${grn}system.xml updated and staged. Commit manually when ready.$end"