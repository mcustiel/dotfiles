#!/usr/bin/env bash

yarn global add vscode-langservers-extracted

yarn global add \
	@microsoft/compose-language-service \
	dockerfile-language-server-nodejs \
	typescript-language-server \
	vscode-css-languageservice \
	vscode-html-languageservice \
	vscode-json-languageservice \
	vscode-markdown-languageservice \
	yaml-language-server

yarn global updgrade
