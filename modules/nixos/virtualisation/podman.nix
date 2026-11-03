{
  flake.modules.nixos.podman-host = { pkgs, ... }: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
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
