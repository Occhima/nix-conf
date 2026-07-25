# docker-engine: the real Docker daemon. No host currently imports this —
# workstations use podman-host's Docker compatibility instead.
{
  flake.modules.nixos.docker-engine = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
        dates = "weekly";
      };
    };

    environment.systemPackages = with pkgs; [
      docker-client
      docker-compose
    ];
  };
}
