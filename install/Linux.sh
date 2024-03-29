#!/usr/bin/env bash

if [ "$(command -v apt)" != "" ]; then
	if [ "$MC_TESTING" = "true" ]; then
		PREFIX=""
	else
		PREFIX="sudo"
	fi

	$PREFIX apt-get install -y fd-find ripgrep curl wget
fi

# Copy config directories
SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
CONFIG_DIR="$HOME/.mcustiel"

source "$SCRIPT_DIR/../startup/msgfunctions"

infomsg "Starting installation in LINUX system"

"$SCRIPT_DIR/_common/creates.sh"

"$SCRIPT_DIR/_common/copy.sh"

# Install bash-it
source "$SCRIPT_DIR/_common/bashit.sh"

# Install nvm, node, yarn, typescript, etc
source "$SCRIPT_DIR/_common/node.sh"

# Install language servers for LSP
"$SCRIPT_DIR/_common/lsp-lang-servers.sh"

# Write config to .bashrc
"$SCRIPT_DIR/_common/bashcfg.sh"

#Install neovim
curl -Lo "$CONFIG_DIR/global_scripts/nvim" https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x "$CONFIG_DIR/global_scripts/nvim"

importantmsg "Open a new bash session to let the new config to take place"

successmsg "Installation in linux system successful"
