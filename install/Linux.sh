#!/usr/bin/env bash

if [ "$MC_TESTING" = "true" ]; then
	PREFIX=""
else
	PREFIX="sudo"
fi

$PREFIX apt-get install -y fd-find ripgrep curl wget

$PREFIX snap install --beta nvim --classic

# Copy config directories
SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

source "$SCRIPT_DIR/../startup/msgfunctions"

infomsg "Starting installation in LINUX system"

"$SCRIPT_DIR/_common/copy.sh"

# Install bash-it
"$SCRIPT_DIR/_common/bashit.sh"

# Install nvm, node, yarn, typescript, etc
"$SCRIPT_DIR/_common/node.sh"

# Install language servers for LSP
"$SCRIPT_DIR/_common/lsp-lang-servers.sh"

# Write config to .bashrc
"$SCRIPT_DIR/_common/bashcfg.sh"

successmsg "Installation in linux system successful"
