{
  config,
  lib,
  inputs,
  ...
}:

with lib;

let
  cfg = config.modules.data.persistence;
in
{
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];
  options.modules.data.persistence = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable persistence configuration for home directories";
    };

    location = mkOption {
      type = types.str;
      default = "persist";
      description = "Subdirectory under $HOME for persisted data";
    };

    directories = mkOption {
      type = types.listOf types.str;
      default = [
        "documents"
        "Dropbox"
        "downloads"
        # "media/pictures"
        # "media/videos"
      ];
      description = "Directories to persist";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.location != "";
        message = "modules.data.persistence.location cannot be empty";
      }
    ];

    home.persistence = {
      "${config.home.homeDirectory}/${cfg.location}" = {
        defaultDirectoryMethod = "symlink";
        directories = cfg.directories;
        allowOther = true;
      };
    };
  };
}
