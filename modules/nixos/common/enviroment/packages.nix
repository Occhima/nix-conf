{ self', ... }:
let
  inherit (self'.packages) install-tools;
in
{
  programs = {
    git.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages = [
    install-tools
  ];
}
