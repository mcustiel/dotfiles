#!/usr/bin/env bash

set -x

# Copy config directories
SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

source "$SCRIPT_DIR/../startup/msgfunctions"

infomsg "Starting installation in LINUX system"

"$SCRIPT_DIR/_common/copy.sh"

# Install bash-it
"$SCRIPT_DIR/_common/bashit.sh"

# Write config to .bashrc
"$SCRIPT_DIR/_common/bashcfg.sh"

successmsg "Installation in linux system successful"
