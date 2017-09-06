#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

main() {
	source ./utils.sh
	source ./install.sh
	source ./fs.sh
	source ./setup.sh
	source ./security.sh
	source ./services.sh
}

main
