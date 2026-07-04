#!/usr/bin/env bash

# Map env -> required Dockerfile
dockerfile_for_env() {
	case "$1" in
	local) echo "Dockerfile.dev" ;;
	staging) echo "Dockerfile.staging" ;;
	production) echo "Dockerfile.prod" ;;
	*) die "Unknown env '$1' for Dockerfile mapping (expected: local|staging|production)" ;;
	esac
}

# Ensure the required Dockerfile exists; otherwise fail
ensure_dockerfile() {
	local df="$1"
	if [ ! -f "$df" ]; then
		echo "[ERROR] Required Dockerfile not found: $df" >&2
		echo "         CWD: $(pwd)" >&2
		echo "         Available Dockerfile* here:" >&2
		ls -1 Dockerfile* 2>/dev/null || true
		die "Missing Dockerfile: $df"
	fi
}

docker_build() {
	local repo="$1" env="$2"
	[ -z "$repo" ] && die "Repo required for docker build"
	[ -z "$env" ] && die "Env required for docker build"

	local df
	df="$(dockerfile_for_env "$env")"
	ensure_dockerfile "$df"

	echo "Building image: $repo using $df"
	maybe docker build -f "$df" . -t "$repo"
}

docker_push() {
	local repo="$1"
	[ -z "$repo" ] && die "Repo required for docker push"
	maybe docker --config ~/.docker/user push "$repo"
}

build_all_images() {
	local version="$1" env="$2"
	[ -z "$version" ] && die "Version tag not specified."
	[ -z "$env" ] && die "Env tag not specified."

	local user="user"
	local api="$user/api:$version"
	local frontend="$user/frontend:$version"

	pushd_quiet "api"
	docker_build "$api" "$env"
	popd_quiet
	pushd_quiet "www"
	docker_build "$frontend" "$env"
	popd_quiet
}

push_all_images() {
	local version="$1"
	[ -z "$version" ] && die "Version tag not specified."
	local user="user"
	maybe docker_push "$user/api:$version"
	maybe docker_push "$user/frontend:$version"
}
