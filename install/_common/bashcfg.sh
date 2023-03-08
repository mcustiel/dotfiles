#!/usr/bin/env bash

ROOT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")"

source "$ROOT_DIR/startup/msgfunctions"

infomsg "Configuring bash"

TPL_DIR="$ROOT_DIR/_templates"
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"

if [ -e $BASHRC ] ; then
	cp "$BASHRC" "$BASHRC.mc.bkp"
	sed -i '/MCUSTIEL_CONFIG_STARTS/,/MCUSTIEL_CONFIG_ENDS/d' "$BASHRC"
fi

if [ -e $BASH_PROFILE ] ; then
	cp "$BASH_PROFILE" "$BASH_PROFILE.mc.bkp"
	sed -i '/MCUSTIEL_CONFIG_STARTS/,/MCUSTIEL_CONFIG_ENDS/d' "$BASH_PROFILE"
fi

sed -i '/NVM_DIR/d' "$BASHRC"

cat "$TPL_DIR/bashrc.cfg" >> "$BASHRC"
cat "$TPL_DIR/bash_profile.cfg" >> "$BASH_PROFILE"

if [ "$MC_TESTING" = "true" ] ; then
	cat $BASHRC
	cat $BASH_PROFILE
	ls -Flash /root
fi

successmsg "Done! ${MC_CHECK}"
