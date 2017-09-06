#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

. ./config.sh

echo "Setup..."
echo "	- docker"
# Allow docker to run without sudo.
sudo groupadd docker -f
usermod -aG docker charles

# auto-start docker on boot.
systemctl enable docker

echo "	- ddclient"
echo "
protocol=dyndns2
use=if, if=eno1
server=ovh.com
login=charlesvdv.be-charles
password='${DYNDNS_PASSWD}'
ssl=yes
.charlesvdv.be,cloud.charlesvdv.be
" > /etc/ddclient.conf
systemctl enable ddclient

echo "	- docker services"
echo "
POSTGRES_PASSWORD="${DB_PASSWD}"
POSTGRES_DB=nextcloud
POSTGRES_USER=nextcloud
" > ./docker/db.env

echo "	- automatic update"
dpkg-reconfigure -plow unattended-upgrades

echo ""
