{
  config,
  lib,
  # inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  # inherit (inputs) haumea;
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
