#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

set -e

function fail {
	echo "Error: $1"
	if [ -n "${2:-""}" ]; then
		exit "$2"
	fi
	exit 1
}

if [ ! "$(command -v 'git')" ]; then
	fail "Git not installed. Please install before running this command"
fi

if [ -d /tmp/dotfiles ] ; then
	rm -rf /tmp/dotfiles
fi

[ -z ${MC_TESTING:-} ] && MC_TESTING="false"
[ -s ${MC_BRANCH:-} ] && MC_BRANCH=""

if [ "$MC_TESTING" = "false" ]; then
	SSH_CFG="$HOME/.ssh"
	[ -d "$SSH_CFG" ] || mkdir "$SSH_CFG"
	chmod 0700 "$SSH_CFG"
	ssh-keyscan github.com > "$SSH_CFG/known_hosts"
	chmod 0600 "$SSH_CFG/known_hosts"

	echo "Cloning repository..."
	git clone git@github.com:mcustiel/dotfiles.git /tmp/dotfiles
	if [ "${MC_BRANCH}" != "" ]; then
		cd /tmp/dotfiles
		git checkout "${MC_BRANCH}"
		cd -
	fi
	ls /tmp/dotfiles
	echo "Repository cloned successfully"
else
	cp -vr "$SCRIPT_DIR/" /tmp/dotfiles
	ls -Flash $SCRIPT_DIR
	ls -Flash /tmp/dotfiles
	ls -Flash /tmp/dotfiles/.config
fi
source "/tmp/dotfiles/startup/msgfunctions"

infomsg "Starting installation..."

"/tmp/dotfiles/install/$(uname -s).sh"

rm -rf /tmp/dotfiles

successmsg "Installation completed successfully!"
