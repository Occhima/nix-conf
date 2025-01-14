{ ... }:

{

  imports = [
    ./devshell.nix
    ./treefmt.nix
    ./pre-commit.nix
    ./just.nix
    ./actions.nix
    ./nix-unit.nix
  ];

}
