{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.virtualisation.docker;
in
{
  options.modules.virtualisation.docker = {
    enable = mkEnableOption "Docker container runtime";
    usePodman = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use podman for docker compatibility";
    };
  };

  config = mkIf cfg.enable {
    # Use podman as docker implementation if configured
    modules.virtualisation.podman = mkIf cfg.usePodman {
      enable = true;
      dockerCompat = true;
    };

    # Use actual docker if podman is not used
    virtualisation.docker = mkIf (!cfg.usePodman) {
      enable = true;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
        dates = "weekly";
      };
    };

    # Add docker CLI
    environment.systemPackages = with pkgs; [
      docker-client
      docker-compose
    ];
  };
}
