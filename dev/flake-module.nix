{ ... }:

{

  imports = [
    ./treefmt.nix
    # ./deploy.nix
    ./pre-commit.nix
    ./actions.nix
    ./nix-unit.nix
    ./devshell.nix
    ./just.nix
  ];

}
