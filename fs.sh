#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# List fs with storage info: `lsblk`
# Get uuid: `sudo blkid`

. ./utils.sh

if [ ! -d "/storage" ]; then
	mkdir -p /mnt/{data0,data1,data2,par0}
	mkdir -p /storage

	echo "
UUID=94e5c719-d70f-4ad8-99fd-c295a4fce10e /mnt/data0 ext4 defaults 0 0 # sdb1
UUID=6340cbf1-3cd0-40c0-b6cb-7301ef4aabf9 /mnt/data1 ext4 defaults 0 0 # sdd1
UUID=0952645c-e058-48b1-b5df-9cf1dc03537d /mnt/data2 ext4 defaults 0 0 # sde1
UUID=6d24a801-7fcf-47e0-88e2-62de3dc3900e /mnt/par0 ext4 defaults 0 0  # sdc1

/mnt/data* /storage fuse.mergerfs direct_io,defaults,allow_other,minfreespace=50G,fsname=mergerfs 0 0
	" >> /etc/fstab

	mount -a
fi

echo ""

if [ ! -d "/etc/snapraid.conf" ]; then
	echo "
parity /mnt/par0/snapraid.parity
content /mnt/data0/snapraid.content
content /mnt/data1/snapraid.content
content /mnt/data2/snapraid.content
data d0 /mnt/data0
data d1 /mnt/data1
data d2 /mnt/data2
	" > /etc/snapraid.conf
fi

if ! systemd_unit_exist "snapraid.timer"; then
	echo "
[Unit]
Description=snapraid sync

[Service]
ExecStart=/bin/sh -c 'snapraid sync'
	" > /etc/systemd/system/snapraid.service

	echo "
[Unit]
Description=snapraid sync timer

[Timer]
OnBootSec=5min
OnUnitActiveSec=4h
Unit=snapraid.service

[Install]
WantedBy=timers.target
	" > /etc/systemd/system/snapraid.timer

	systemctl enable snapraid.timer
fi
