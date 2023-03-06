#!/bin/bash

export MC_DOTFILES_PATH="$HOME/.mcustiel"
CURDIR="$MC_DOTFILES_PATH/startup"

source "$CURDIR/msgfunctions"
source "$CURDIR/exports"
source "$CURDIR/functions"
source "$CURDIR/aliases"
source "$CURDIR/path"
source "$CURDIR/tools"

successmsg "Startup successful. $CHECK"
