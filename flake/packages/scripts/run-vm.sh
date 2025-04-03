#!/usr/bin/env bash
# Run a NixOS VM for the specified host
# Usage: run-vm [hostname]

HOST=${1:-face2face}

# Build and run the VM
nix build ".#nixosConfigurations.$HOST.config.system.build.vmWithDisko" -o result
./result/bin/disko-vm
