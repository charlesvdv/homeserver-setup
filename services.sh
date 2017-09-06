#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Launch docker compose services
echo "Launching docker services..."
pushd docker
docker-compose up --remove-orphans -d
popd
