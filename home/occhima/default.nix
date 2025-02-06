{ lib, config, ... }:
with lib;
{
  home = {
    username = mkDefault "occhima";
    homeDirectory = mkDefault "/home/${config.home.username}";
    stateVersion = mkDefault "24.11";
  };

  nix = {
    package = mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      warn-dirty = false;
    };

  };

  # homeModules = {

  # };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
