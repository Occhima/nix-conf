#!/usr/bin/env bash
# Run a NixOS VM for the specified host.
# The VM variant of every disko host swaps to the face2face disko layout.
# Usage: run-vm <hostname>

HOST=${1:?Usage: run-vm <hostname>  (one of the flake's nixosConfigurations)}

# Build and run the VM
nix build ".#nixosConfigurations.$HOST.config.system.build.vmWithDisko" -o result
./result/bin/disko-vm
