command_exist () {
	type "$1" > /dev/null 2>&1;
}

systemd_unit_exist () {
	systemctl list-units | grep -q $1;
}
