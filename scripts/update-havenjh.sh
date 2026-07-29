#!/bin/bash

set -e

echo "======================================"
echo " HavenJH Update"
echo "======================================"

cd /tmp

echo "Download nieuwste versie..."
wget -O havenjh-web.zip https://github.com/discoding/havenjh/releases/latest/download/havenjh-web.zip

echo "Uitpakken..."
rm -rf web
unzip -oq havenjh-web.zip

echo "Bestanden installeren..."
sudo rm -rf /var/www/html/*
sudo cp -r web/* /var/www/html/

echo "Nginx herstarten..."
sudo systemctl restart nginx

echo ""
echo "✅ HavenJH update klaar"
