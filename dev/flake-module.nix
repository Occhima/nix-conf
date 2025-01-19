{ ... }:

{

  imports = [
    # ./just.nix

    ./treefmt.nix
    ./pre-commit.nix
    ./actions.nix
    ./nix-unit.nix
    ./devshell.nix
  ];

}
