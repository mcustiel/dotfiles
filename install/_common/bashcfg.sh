#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"

BASHRC_CONTENTS="$(cat "$BASHRC")"

echo "$BASHRC_CONTENTS" | sed '/MCUSTIEL_CONFIG_STARTS/,/MCUSTIEL_CONFIG_ENDS/d' | sudo tee "$BASHRC" > /dev/null
sudo cat "$TPL_DIR/bashrc.cfg" | sudo tee -a "$BASHRC" > /dev/null

BASH_PROFILE_CONTENTS="$(cat "$BASH_PROFILE")"

echo "$BASH_PROFILE_CONTENTS" | sed '/MCUSTIEL_CONFIG_STARTS/,/MCUSTIEL_CONFIG_ENDS/d' | sudo tee "$BASHRC" > /dev/null
sudo cat "$TPL_DIR/bashrc.cfg" | sudo tee -a "$BASH_PROFILE" > /dev/null

if [ "$MC_TEST" = "true" ] ; then
	cat $BASHRC
	cat $BASH_PROFILE
fi
