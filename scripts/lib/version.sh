#!/usr/bin/env bash
# Version & env update utilities

_git_branch() { git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"; }
_git_sha() { git rev-parse --short HEAD 2>/dev/null || echo "unknown"; }
_user_name() { id -un 2>/dev/null || whoami 2>/dev/null || echo "unknown"; }

_write_version_file() {
	local new_version="$1" env="$2"
	local ts user branch sha
	ts="$(now_ts)"
	user="$(_user_name)"
	branch="$(_git_branch)"
	sha="$(_git_sha)"

	echo "Writing .version with:"
	echo "  CURRENT_VERSION=$new_version"
	echo "  LAST_DEPLOY_ENV=$env"
	echo "  LAST_DEPLOY_AT=$ts"
	echo "  LAST_DEPLOY_USER=$user"
	echo "  GIT_BRANCH=$branch"
	echo "  GIT_COMMIT_SHA=$sha"

	if is_dry_run; then
		echo "[DRY-RUN] > .version (not writing)"
	else
		cat >.version <<EOF
CURRENT_VERSION=$new_version
LAST_DEPLOY_ENV=$env
LAST_DEPLOY_AT=$ts
LAST_DEPLOY_USER=$user
GIT_BRANCH=$branch
GIT_COMMIT_SHA=$sha
EOF
	fi
}

update_envs() {
	echo "$@"
	local old_version="$1" new_version="$2" env="$3" update_kube="${4:-false}"

	[ -z "$new_version" ] && die "Usage: update_envs <old_version> <new_version> <env> [update_kube:true|false]"

	# Update kube deploy.yaml tag if requested (non-prod)
	if [ "$update_kube" = "true" ]; then
		if [ -f kubernetes/deploy.yaml ]; then
			echo "Updating kubernetes/deploy.yaml image tags: :$old_version -> :$new_version ..."
			maybe sed -E -i "s/:[0-9]+\.[0-9]+\.[0-9]+/:${new_version}/g" kubernetes/deploy.yaml
		else
			echo "[WARN] kubernetes/deploy.yaml not found; skipping."
		fi
	fi

	# Finally, (try to) write .version snapshot
	_write_version_file "$new_version" "$env"
}
