#!/bin/bash
set -euo pipefail
if ${DEBUG:-false}; then set -x; fi
# functions #####################################

usage() {
	cat <<EOF
USAGE: 
	$0 <config string> [<value to set>]
	$0 clear <config string>

Modifies input stream of .config file.

Written by Kamil Cukrowski. Jointly under MIT License and Beerware License.
EOF
}

config_set() { sed    -e '/^[# ]\?'"$1"'[ =]/s/.*/'"$2"'/'; }
config_get() { sed -n -e '/^[# ]\?'"$1"'[ =]/p'; }

runtests() {
	local config
	config="# CONFIG_VAR12 is not set
CONFIG_VAR=dont touch
CONFIG_VAR1=0
CONFIG_VAR2=1
# CONFIG_VAR3 is not set"
	tests=(
		"cat"
		"$0 CONFIG_VAR1"
		"$0 clear CONFIG_VAR1"
		"$0 clear CONFIG_VAR2"
		"$0 clear CONFIG_VAR3"
		"$0 CONFIG_VAR2"
		"$0 CONFIG_VAR1 10"
		"$0 ULUMULU"
	)
	for test in "${tests[@]}"; do
		echo "+ $test <<<\"\$config\""
		$test <<<"$config"
	done
}


# main #########################################

if [ $# -lt 1 -o $# -gt 2 ]; then usage; exit 1; fi

case "$1" in
test)
	runtests
	;;
clear)
	config_set "$2" "# $2 is not set"
	;;
*)
	if [ $# -eq 2 ]; then
		config_set "$1" "$1=$2"
	else
		config_get "$1"
	fi
	;;
esac

