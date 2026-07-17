{ ... }:
{
  occhima.networkmanager.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.modules) mkForce;
      inherit (lib.lists) optionals;
      # ponytail: check xserver instead of old display.type selector
      isGui = config.services.xserver.enable or false;
    in
    {
      options.modules.network.networkmanager = {
      };

      config = {
        environment.systemPackages = optionals isGui [
          pkgs.networkmanagerapplet
        ];

        networking.networkmanager = {
          enable = true;
          plugins = mkForce (optionals isGui [ pkgs.networkmanager-openvpn ]);
          dns = "systemd-resolved";
          unmanaged = [
            "interface-name:tailscale*"
            "interface-name:br-*"
            "interface-name:rndis*"
            "interface-name:docker*"
            "interface-name:virbr*"
            "interface-name:vboxnet*"
            "interface-name:waydroid*"
            "type:bridge"
          ];
          wifi = {
            backend = "wpa_supplicant";
            powersave = false;
            scanRandMacAddress = true;
          };
          ethernet.macAddress = "random";
        };
      };
    };
}
