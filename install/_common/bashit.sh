#!/usr/bin/env bash

ROOT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")"

source "$ROOT_DIR/startup/msgfunctions"

infomsg "Configuring bash-it"

git clone --depth=1 https://github.com/Bash-it/bash-it.git "$HOME/.bash_it"
"$HOME/.bash_it/install.sh"

source "$HOME/.bash_it/bash_it.sh"

bash-it enable alias docker
bash-it enable alias docker-compose
bash-it enable alias general
bash-it enable alias git
bash-it enable alias yarn

bash-it enable completion aliases
bash-it enable completion bash-it
bash-it enable completion docker
bash-it enable completion docker-compose
bash-it enable completion git
bash-it enable completion system
bash-it enable completion nvm

bash-it enable plugin base
bash-it enable plugin docker-compose
bash-it enable plugin docker
bash-it enable plugin git
bash-it enable plugin nvm

sed -i '/BASH_IT_THEME/d' "$HOME/.bashrc"

successmsg "Done! ${MC_CHECK}"
