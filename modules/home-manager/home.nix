{
  inputs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home-manager;
in
{
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];

  options.modules.home-manager = {
    enable = mkEnableOption "home-manager module";
    username = mkOption {
      type = types.str;
      default = "occhima";
      description = "The user to configure home-manager for";
    };
  };

  config = mkIf cfg.enable {
    programs.home-manager.enable = true;

    home = {
      stateVersion = "23.11"; # This needs to be at the top level
      username = cfg.username; # Use cfg.username directly
      homeDirectory = "/home/${cfg.username}";

      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          defaultDirectoryMethod = "symlink";
          directories = [
            "Documents"
            "Dropbox"
            "Downloads"
            "Pictures"
            "Videos"
            ".local/bin"
            ".ssh"
            ".local/share/nix" # trusted settings and repl history
          ];
          allowOther = true;
        };
      };

    };

    xdg = {
      enable = true;
      configHome = "${config.home.homeDirectory}/.config"; # Use $HOME instead of trying to reference config
      dataHome = "${config.home.homeDirectory}/.local/share";
      cacheHome = "${config.home.homeDirectory}/.cache";
    };

  };
}
