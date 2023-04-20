#!/usr/bin/env bash

ROOT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")"

source "$ROOT_DIR/startup/msgfunctions"

infomsg "Configuring nvn/node/npm/yarn/typescript"

if [ "$(command -v nvm)" = "" ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ "$(command -v node)" = "" ]; then
	nvm install node
fi

npm install -g yarn npx npm

echo "$PATH" | grep -q 'yarn' || export PATH="$PATH:$HOME/.yarn/bin"

yarn global add typescript eslint neovim tsx gulp

successmsg "Done! ${MC_CHECK}"
