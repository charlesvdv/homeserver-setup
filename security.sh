#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Firewalls
ufw allow ssh
ufw allow http
ufw allow https
ufw default deny incoming
ufw default allow outgoing
ufw enable
