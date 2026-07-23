#!/usr/bin/env bash
# Run a NixOS VM for the specified host.
# The VM variant of every disko host swaps to the face2face disko layout.
# Usage: run-vm <hostname>
set -euo pipefail

HOST=${1:?Usage: run-vm <hostname> (one of the flake nixosConfigurations)}

# The requested host must exist as a NixOS configuration.
if ! nix eval --raw ".#nixosConfigurations" --apply 'configs: builtins.toString (builtins.hasAttr "'"$HOST"'" configs)' | grep -q true; then
  echo "error: unknown host '$HOST' (not in nixosConfigurations)" >&2
  exit 1
fi

# The host must provide the vmWithDisko variant.
if ! nix eval --raw ".#nixosConfigurations.$HOST.config.system.build" --apply 'build: builtins.toString (build ? vmWithDisko)' | grep -q true; then
  echo "error: host '$HOST' has no system.build.vmWithDisko" >&2
  exit 1
fi

# Build into an explicitly managed result link, never clobbering ./result.
RESULT_LINK=$(mktemp -u "${TMPDIR:-/tmp}/run-vm-$HOST-XXXXXX")
trap 'rm -f "$RESULT_LINK"' EXIT

nix build ".#nixosConfigurations.$HOST.config.system.build.vmWithDisko" -o "$RESULT_LINK"
"$RESULT_LINK/bin/disko-vm"
