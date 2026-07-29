#!/bin/bash

set -e

REPO="discoding/havenjh"
ZIP="havenjh-web.zip"

WORK="/tmp/havenjh-update"
TARGET="/var/www/html"

rm -rf "$WORK"
mkdir -p "$WORK"

cd "$WORK"

echo "Laatste release ophalen..."

URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest \
| grep browser_download_url \
| grep "$ZIP" \
| cut -d '"' -f4)

wget "$URL" -O "$ZIP"

unzip -o "$ZIP"

echo "Nieuwe website plaatsen..."

rm -rf "$TARGET"/*

cp -r web/* "$TARGET"

chown -R www-data:www-data "$TARGET"

echo "Update klaar"
