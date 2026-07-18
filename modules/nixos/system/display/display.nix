# Display stack fact. The wayland/x11 modules import this and publish
# which stack the host runs; features read the fact (via config on NixOS,
# osConfig in Home Manager) to adapt values. Importing both display
# aspects on one host is a configuration error and fails as an option
# conflict.
{
  flake.modules.nixos.display-base =
    { lib, ... }:
    {
      options.modules.system.display.type = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "wayland"
            "x11"
          ]
        );
        default = null;
        description = "The display server stack this host runs (published by the display modules).";
      };
    };
}
