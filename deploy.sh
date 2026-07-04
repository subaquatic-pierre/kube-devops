#!/bin/bash
set -euo pipefail

# load lib (run from repo root)
. "./scripts/lib/index.sh"

# --- HARD-CODED REMOTE HOSTS ---
STAGING_HOST="staging-host"
PRODUCTION_HOST_1="web-1"
PRODUCTION_HOST_2="web-2"

parse_args() {
	DRY_RUN=0

	# Step 1: Loop through arguments to find and handle flags.
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-n | --dry-run)
			DRY_RUN=1
			shift # Move past the processed flag
			;;
		-h | --help | help)
			print_help
			exit 0
			;;
		-*)
			# Handles any unknown flags that start with a hyphen
			die "Unknown flag: $1"
			;;
		*)
			# Not a flag, so break the loop to handle positional arguments
			break
			;;
		esac
	done

	# Step 2: Assign the remaining arguments to positional variables.
	NEW_VERSION="${1:-}"
	shift || true
	ENV_NAME="${1:-}"
	shift || true

	# Step 3: Run the validation checks as before.
	[ -z "${NEW_VERSION:-}" ] && die "Version tag not specified."
	[ -z "${ENV_NAME:-}" ] && die "Environment not specified."
	case "$ENV_NAME" in local | staging | production) ;; *) die "Invalid env '$ENV_NAME'. Allowed: local|staging|production." ;; esac

	# Optional: Check for any extra, unknown arguments
	if [ -n "${1:-}" ]; then
		die "Unknown argument: $1"
	fi
}

run() {
	parse_args "$@"

	# Load old version if present (ok if first run)
	if [ -f .version ]; then
		. .version
		OLD_VERSION="${CURRENT_VERSION:-0.0.0}"
	else
		OLD_VERSION="0.0.0"
	fi

	echo "Old Version: $OLD_VERSION"
	echo "New Version: $NEW_VERSION"
	echo "Environment: $ENV_NAME"
	echo "DRY_RUN=${DRY_RUN}"

	# If not production, we also bump kubernetes deploy.yaml (staging/local use k8s)
	UPDATE_KUBE="true"
	[ "$ENV_NAME" = "production" ] && UPDATE_KUBE="false"

	# Update env files and (optionally) deploy.yaml; also writes rich .version snapshot
	update_envs "$OLD_VERSION" "$NEW_VERSION" "$ENV_NAME" "$UPDATE_KUBE"

	if [ "$ENV_NAME" = "local" ]; then
		echo "==> Local build selected"
		build_all_images "$NEW_VERSION" "$ENV_NAME"
		exec_kube "local"
		echo "Local deploy complete."
	fi

	if [ "$ENV_NAME" = "staging" ]; then
		echo "==> Staging build selected"
		build_all_images "$NEW_VERSION" "$ENV_NAME"
		push_all_images "$NEW_VERSION"
		exec_kube "$STAGING_HOST"
		echo "Staging deploy complete."
	fi

	if [ "$ENV_NAME" = "production" ]; then
		echo "==> Prod build selected"
		build_all_images "$NEW_VERSION" "$ENV_NAME"
		push_all_images "$NEW_VERSION"

		# Roll services on each prod host
		systemd_update_remote_host "$PRODUCTION_HOST_1" "$NEW_VERSION"
		systemd_update_remote_host "$PRODUCTION_HOST_2" "$NEW_VERSION"
		echo "Production deploy complete."
	fi

	git_commit "$NEW_VERSION" "$ENV_NAME"

	echo "Deployment complete"

}

run "$@"
