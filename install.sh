#~/usr/bin/env bash

function fail() {
	echo "Error: $1"
	if [ -n "${2-out}" ]; then
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

git clone git@github.com:mcustiel/dotfiles.git /tmp/dotfiles

"/tmp/dotfiles/install/$(uname -s).sh"
