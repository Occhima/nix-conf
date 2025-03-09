{
  inputs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.home;
in
{
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];

  options.modules.home = {
    enable = mkEnableOption "home-manager module to define home stuff";
    username = mkOption {
      type = types.str;
      default = "occhima";
      description = "The user to configure home-manager for";
    };
  };

  config = mkIf cfg.enable {

    home = {

      username = cfg.username;
      homeDirectory = "/home/${cfg.username}";
      stateVersion = "23.11";
      preferXdgDirectories = true;
      # sessionVariables = {

      # }
      persistence = {
        "${config.home.homeDirectory}/persist" = {
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
