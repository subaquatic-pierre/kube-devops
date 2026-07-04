#!/usr/bin/env bash
# Loads all *.sh modules in this directory (except itself), once.

# Guard against double-loading in the same shell
if [ -n "${__LIB_INDEX_SH_SOURCED:-}" ]; then
	return 0 2>/dev/null || exit 0
fi
readonly __LIB_INDEX_SH_SOURCED=1

# Resolve this folder even when sourced from elsewhere
# (BASH_SOURCE works in bash; fallback to $0 if needed)
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Load every module in deterministic order
# (skip index.sh itself)
while IFS= read -r -d '' mod; do
	case "$(basename "$mod")" in
	index.sh) continue ;;
	esac
	# shellcheck source=/dev/null
	. "$mod"
done < <(find "$_LIB_DIR" -maxdepth 1 -type f -name '*.sh' -print0 | sort -z)
