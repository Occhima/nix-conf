{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.modules.data.persistence;
in
{
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
        #".ssh"
        #"Dropbox"
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

  };
}
