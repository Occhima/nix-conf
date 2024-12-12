# justfile
# Simple tasks to manage your NixOS + Home Manager setup

HOST := "my-host"
HOME_USER := "alice"

default:
  @echo "Available commands: update, switch, flake-update, home-switch, data-science-shell, htb-shell, software-engineering-shell"

switch:
  sudo nixos-rebuild switch --flake .

flake-update:
  nix flake update

update: flake-update switch

home-switch:
  nix run .#hm-${HOME_USER} && ./result/activate

data-science-shell:
  nix develop .#data-science

htb-shell:
  nix develop .#htb

software-engineering-shell:
  nix develop .#software-engineering
