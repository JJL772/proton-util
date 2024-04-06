#!/usr/bin/env bash
set -e

function get_steam_dirs {
	echo $(cat ~/.steam/steam/steamapps/libraryfolders.vdf | grep "\"path\"" | sed -E "s/^\s+\"path\"\s+\"(.*)\"\$/\\1/")
}

function find_proton {
	for d in `get_steam_dirs`; do
		DIR="$d/steamapps/common/$1"
		if stat "$DIR" > /dev/null; then
			echo "$DIR"
			return 0
		fi
	done
	return 1
}

VER="- Experimental"
VT=$(echo $(basename "${BASH_SOURCE[0]}") | sed -E "s/proton([0-9]+\.?[0-9]?).*/\\1/")
case $VT in
	[0-9]*)
		if echo "$VT" | grep -Eo "\." > /dev/null; then
			VER="$VT"
		else
			VER="$VT.0"
		fi
		;;
	*)
		VER="- Experimental"
		;;
esac

PROTON="Proton $VER"
PREFIX=`find_proton "$PROTON"`

echo "Running $PROTON"

export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam"
export STEAM_COMPAT_DATA_PATH="$HOME/.proton/prefix-$VER"
mkdir -p "$STEAM_COMPAT_DATA_PATH"

python3 "$PREFIX/proton" run "$@"
