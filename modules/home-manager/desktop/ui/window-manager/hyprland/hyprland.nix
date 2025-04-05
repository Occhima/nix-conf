{
  config,
  lib,
  inputs,
  pkgs,
  osConfig ? { },
  ...
}:

let
  inherit (lib.attrsets) attrByPath;
  cfg = config.modules.desktop.ui;
  hyprInputs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  enabledHyprlandThroughNixos = attrByPath [
    "modules"
    "system"
    "display"
    "enableHyprlandEssential"
  ] false osConfig;

  hyprPackage = if enabledHyprlandThroughNixos then null else hyprInputs.hyprland;
  hyprPortalPackage =
    if enabledHyprlandThroughNixos then null else hyprInputs.xdg-desktop-portal-hyprland;

in
{

  imports = [ inputs.hyprland.homeManagerModules.default ];
  config = lib.mkIf (cfg.windowManager == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = hyprPackage;
      portalPackage = hyprPortalPackage;

      systemd = {
        enable = false;
        variables = [ "--all" ];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
    };
  };
}
