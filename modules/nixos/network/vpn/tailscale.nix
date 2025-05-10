# NOTE: Yet another module stolen from isabelroses dotfiles ...
# https://github.com/isabelroses/dotfiles/blob/b097aa7c6d028f65d997e26d4b94e5175e07b0f2/modules/nixos/networking/tailscale.nix#L23
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkDefault
    mkOption
    mkEnableOption
    optionals
    ;
  inherit (lib.types) listOf str;

  inherit (config.services) tailscale;

  cfg = config.modules.network.vpn.tailscale;
in
{
  options.modules.network.vpn.tailscale = {
    enable = mkEnableOption "Tailscale VPN";

    defaultFlags = mkOption {
      type = listOf str;
      default = [ "--ssh" ];
      description = ''
        A list of command-line flags that will be passed to the Tailscale daemon on startup
        using the {option}`config.services.tailscale.extraUpFlags`.
        If `isServer` is set to true, the server-specific values will be appended to the list
        defined in this option.
      '';
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ];

    networking.firewall = {
      trustedInterfaces = [ "${tailscale.interfaceName}" ];
      checkReversePath = "loose";
      allowedUDPPorts = [ tailscale.port ];
    };

    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = mkDefault "server";
      extraUpFlags = cfg.defaultFlags ++ optionals cfg.enable [ "--advertise-exit-node" ];
    };

  };
}
