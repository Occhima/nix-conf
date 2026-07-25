{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.wayland.windowManager.hyprland;
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        # Hyprland 0.55 introduced the new configuration format. Keep this as
        # a default so a host can opt back into hyprlang with one assignment.
        configType = lib.mkDefault (
          if lib.versionAtLeast pkgs.hyprland.version "0.55" then "lua" else "hyprlang"
        );

        settings = hyprlandLib.mkConfig cfg.configType {
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
        };
      };
    };
}
