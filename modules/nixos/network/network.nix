{
  flake.modules.nixos.network =
    {
      lib,
      config,
      ...
    }:
    let
      inherit (lib.modules) mkDefault;
    in
    {
      config = {
        environment.etc.hosts.mode = "0644";
        networking = {
          hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

          usePredictableInterfaceNames = mkDefault true;

          nameservers = [
            "1.1.1.1"
            "1.0.0.1"
            "9.9.9.9"
          ];

          enableIPv6 = true;
        };

        services.resolved.enable = true;

        systemd = {
          network.wait-online.enable = false;

          services = {
            systemd-networkd.stopIfChanged = false;
            systemd-resolved.stopIfChanged = false;
          };
        };
      };
    };
}
