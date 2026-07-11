# Explicit host context for shared Home Manager modules.
#
# When Home Manager runs inside NixOS the defaults below are derived from
# the real `osConfig`; the standalone evaluation has no `osConfig` and sets
# these options explicitly instead (see modules/flake/home-manager.nix).
# Shared modules must consume `config.modules.hostContext` rather than
# reaching into arbitrary `osConfig` paths.
{
  config,
  lib,
  osConfig ? { },
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.modules.hostContext = {
    wayland = mkOption {
      type = types.bool;
      default = (osConfig.modules.system.display.type or "") == "wayland";
      description = "Whether the host session runs on Wayland.";
    };

    monitors = mkOption {
      type = types.attrs;
      default = osConfig.modules.hardware.monitors or { };
      description = ''
        Monitor layout, same shape as the NixOS option
        `modules.hardware.monitors` (`primaryMonitorName` and `displays`).
      '';
    };

    steam = mkOption {
      type = types.bool;
      default = osConfig.modules.services.steam.enable or false;
      description = "Whether the host has Steam enabled.";
    };

    yubikey = mkOption {
      type = types.bool;
      default = osConfig.modules.hardware.yubikey.enable or false;
      description = "Whether the host has YubiKey support enabled.";
    };

    defaultShell = mkOption {
      type = types.str;
      default = lib.getName (osConfig.users.users.${config.home.username}.shell or "");
      description = "Name of the login shell the host assigns to this user.";
    };
  };
}
