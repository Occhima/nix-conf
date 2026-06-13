{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.modules.services.podman;

in
{
  options.modules.services.podman = {
    enable = mkEnableOption "User-level podman container management";
  };

  config = mkIf cfg.enable {

    services.podman = {
      enable = true;
      enableTypeChecks = true;
    };

  };
}
