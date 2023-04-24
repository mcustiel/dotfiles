#!/usr/bin/env bash

set +x
set +e

docker rmi mcustiel-dotfiles

docker build -t mcustiel-dotfiles .

docker run --rm -e MC_TESTING=true -e SSH_AUTH_SOCK=/ssh-agent -v "${SSH_AUTH_SOCK}:/ssh-agent"  mcustiel-dotfiles

