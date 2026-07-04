#!/bin/bash

# Default SSH options
SSH_OPTS=(-o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8)

# Run the systemd image-bump on a remote host for one service
# Usage: _systemd_remote_update_one <host> <service> <new_tag> [sudo_cmd]
_systemd_remote_update_one() {
	local host="$1" svc="$2" new_tag="$3"
	echo "INFO: running remote service update for ${svc}.service on HOST: ${host}"

	maybe ssh "${SSH_OPTS[@]}" "$host" bash -s -- "$svc" "$new_tag" <<'REMOTE'
set -euo pipefail

svc="$1"
new_tag="$2"

env_file="/etc/default/${svc}"
if [ ! -f "$env_file" ]; then
  echo "WARN: ${env_file} not found, skipping" >&2
  exit 0
fi

echo "INFO: making backup ${env_file}.bak"
sudo cp -a "$env_file" "${env_file}.bak"

# First IMAGE= line (if any)
line="$(grep -m1 -E '^IMAGE=' "$env_file" || true)"

if [ -z "$line" ]; then
  echo "WARN: No IMAGE= in ${env_file}; skipping"
else
  image="${line#IMAGE=}"
  if [[ "$image" == *:* ]]; then
    repo="${image%:*}"
    new_image="${repo}:${new_tag}"
  else
    new_image="${image}:${new_tag}"
  fi

  if [ "$image" = "$new_image" ]; then
    echo "INFO: ${env_file} already at ${new_image}"
  else
    echo "UPDATE: ${env_file}  IMAGE=$image -> IMAGE=$new_image"
    # Write to tmp as root, then move into place
    sudo awk -v newimg="IMAGE=${new_image}" '
      BEGIN { done=0 }
      {
        if (!done && $0 ~ /^IMAGE=/) { print newimg; done=1 }
        else { print }
      }
    ' "$env_file" | sudo tee "${env_file}.tmp" > /dev/null
    sudo mv "${env_file}.tmp" "$env_file"
  fi
fi

sudo systemctl daemon-reload
sudo systemctl restart "${svc}.service"
sudo systemctl --no-pager --full status "${svc}.service" -n 0 || true
echo "INFO: service reloaded ${svc}.service"
REMOTE
}

# Usage: systemd_update_host <host> <new_tag>
systemd_update_remote_host() {
	local host="$1" new_tag="$2"
	for svc in api www; do
		_systemd_remote_update_one "$host" "$svc" "$new_tag"
	done
}
