# home/profiles/software-engineering.nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    ghc
    cabal-install
    stack
    ocaml
    elixir
    # Add more functional programming tools as desired
  ];
}
