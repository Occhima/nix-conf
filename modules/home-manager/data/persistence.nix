{ ... }:
{
  config.occhima.persistence.homeManager = (
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) mkOption types;
      cfg = config.modules.data.persistence;
    in
    {
      options.modules.data.persistence = {
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

      config = {
        assertions = [
          {
            assertion = cfg.location != "";
            message = "modules.data.persistence.location cannot be empty";
          }
        ];
      };
    }
  );
}
