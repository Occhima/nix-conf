{
  config,
  lib,
  pkgs,
  inputs,
  osConfig ? { },
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) attrByPath;

  cfg = config.modules.desktop.apps.flatpak;
  flatpakEnabledInNixOS = attrByPath [
    "services"
    "flatpak"
    "enable"
  ] false osConfig;
in
{
  imports = [ inputs.flatpaks.homeManagerModules.nix-flatpak ];

  options.modules.desktop.apps.flatpak = {
    enable = mkEnableOption "flatpak";
    packages = mkOption {
      type = types.listOf (types.either types.str (types.attrsOf types.anything));
      default = [
      ];
      description = "List of Flatpak packages to install";
    };
  };

  config = mkIf (cfg.enable && flatpakEnabledInNixOS && pkgs.stdenv.hostPlatform.isLinux) {
    warnings = lib.optional (
      !flatpakEnabledInNixOS
    ) "Flatpak is not enabled in  NixOS configuration. Enable services.flatpak in your NixOS config.";

    services.flatpak = {
      packages = cfg.packages;
      uninstallUnmanaged = false;
      uninstallUnused = true;
      update.auto.enable = false;
      update.onActivation = false;
    };
  };
}
