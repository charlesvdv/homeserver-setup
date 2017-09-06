#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

. ./utils.sh

# APT pkg install.
echo "Installing base package"
echo ""
DEBIAN_FRONTEND="noninteractive" apt-get install -y $(cat packages.txt | grep -vE "^\s*#" | tr "\n" " ")
echo ""

# $1 is the app name
# $2 is the function to execute when the install need to happen.
install () {
	if ! command_exist $1; then
		echo "Installing $1...";
		echo "";

		pushd /tmp
		$($2);
		popd
	else
		echo "$1 is already installed.";
	fi

	echo "";
}

docker_install () {
	curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
	# Check if key is correct.
	# apt-key fingerprint 0EBFCD88

	add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/debian \
		$(lsb_release -cs) stable"

	apt update && apt install docker-ce

	if docker run hello-world > /dev/null; then
		echo "docker is installed correctly.";
	else
		echo "docker is not installed.";
	fi
}

docker_compose_install () {
	pip3 install docker-compose
}

snapraid_install () {
	git clone https://github.com/IronicBadger/docker-snapraid.git
	cd docker-snapraid/
	chmod +x build.sh
	./build.sh
	cd build
	dpkg -i snapraid*.deb
}

install "docker" docker_install
install "docker-compose" docker_compose_install
install "snapraid" snapraid_install
