# justfile
# Simple tasks to manage your NixOS + Home Manager setup

HOST := "lattes"
HOME_USER := "me"


switch:
  sudo nixos-rebuild switch --flake .

rebuild:
    scripts/rebuild.sh





check:
  nix flake check

flake-update:
  nix flake update

update: flake-update switch
