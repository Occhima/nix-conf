{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.virtualisation.podman;
in
{
  options.modules.virtualisation.podman = {
    enable = mkEnableOption "Podman container runtime";
    dockerCompat = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Docker compatibility";
    };
  };

  config = mkIf cfg.enable {
    # Ensure it doesn't conflict with Docker when in compat mode
    assertions = [
      {
        assertion =
          !(
            cfg.dockerCompat
            && config.virtualisation.docker.enable
            && !config.modules.virtualisation.docker.usePodman
          );
        message = "Cannot enable both Podman with Docker compatibility and real Docker. Either disable Podman's dockerCompat option or set modules.virtualisation.docker.usePodman = true.";
      }
    ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = cfg.dockerCompat;
      dockerSocket.enable = cfg.dockerCompat;
      defaultNetwork.settings.dns_enabled = true;
      # enableNvidia =
      #   cfg.enableNvidia || builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
        dates = "weekly";
      };
    };

    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];
  };
}
