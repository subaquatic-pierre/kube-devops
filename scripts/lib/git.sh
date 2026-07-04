#!/usr/bin/env bash

git_commit() {
	version="$1"
	env="$2"
	echo "[INFO]: Running git commit for version $version to $env"
	maybe git add .
	maybe git commit -m "deployed version $version to $env"
}
