#!/usr/bin/env bash
# Common helpers for deploy scripts. Safe to source multiple times.

: "${TOP_PID:=$$}"

die() {
	local msg="${1:-"Unknown error"}"
	echo "[ERROR] $msg" >&2
	if [ -n "${USAGE:-}" ]; then echo "$USAGE" >&2; fi
	if [ -n "${TOP_PID:-}" ] && kill -0 "$TOP_PID" 2>/dev/null; then
		kill -s TERM "$TOP_PID"
	else
		exit 1
	fi
}

pushd_quiet() {
	local d="$1"
	echo
	echo "Changing working directory to ./$d..."
	pushd "$d" &>/dev/null || die "Failed to enter $d."
}

popd_quiet() {
	popd &>/dev/null || die "Failed to return to previous directory."
}

# ---- DRY-RUN helpers ----
is_dry_run() {
	case "${DRY_RUN:-0}" in
	1 | true | TRUE | on | ON | yes | YES) return 0 ;;
	*) return 1 ;;
	esac
}

maybe() { # usage: maybe <cmd> [args...]
	if is_dry_run; then
		echo "[DRY-RUN] $*"
	else
		"$@"
	fi
}

now_ts() {
	# ISO-8601 with timezone offset, e.g. 2025-09-17T14:03:11+04:00
	date -Iseconds
}
