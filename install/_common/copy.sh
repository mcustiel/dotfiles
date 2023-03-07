#!/usr/bin/env bash

ROOT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")"

source "$ROOT_DIR/startup/msgfunctions"

infomsg "Installing config files and scripts..."

CONFIG_DIR="$HOME/.mcustiel"

if [ ! -d "$CONFIG_DIR" ] ; then
	mkdir "$CONFIG_DIR"
fi

cp -vr "$ROOT_DIR/startup" "$CONFIG_DIR/"
cp -vr "$ROOT_DIR/global_scripts" "$CONFIG_DIR/"
cp -vr "$ROOT_DIR/config" "$CONFIG_DIR/"

if [ ! -d "$HOME/.config" ]; then
	mkdir "$HOME/.config"
fi
cp -vr "$ROOT_DIR/.config" "$HOME/"

chmod +x "$CONFIG_DIR/global_scripts/"*

successmsg "Done! ${MC_CHECK}"
