{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.podman;
in
{
  options.modules.services.podman = {
    enable = mkEnableOption "User-level podman container management and services";
  };

  config = mkIf cfg.enable {
    services = {
      podman = {
        enable = true;
        enableTypeChecks = true;
        # think about another alternative for this, it seemd to cluttered
        # containers = haumea.lib.load {
        #   src = ./containers;
        #   inputs = {
        #     inherit config lib;
        #   };
        # };
      };

    };
  };
}
